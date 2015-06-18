open Ctypes

module C = LZ4_bindings.C(LZ4_generated)

exception Input_too_large
exception Corrupted

let compress_bound sz =
  if sz < 0 then invalid_arg "LZ4.compress_bound";
  if Sys.word_size = 32 then (
    if  sz > 1_069_547_504 then
      raise Input_too_large;
  )
  else if sz > 0x7E000000 then
    raise Input_too_large;
  C.compressBound sz

module type S = sig
  type storage

  val compress_into : storage -> storage -> int
  val compress : storage -> storage
  val decompress_into : storage -> storage -> int
  val decompress : length:int -> storage -> storage
end

module Bytes = struct
  type storage = Bytes.t

  let compress_into input output =
    let length = C.b_compress (ocaml_bytes_start input) (ocaml_bytes_start output)
                              (Bytes.length input) (Bytes.length output) in
    if length = 0 && Bytes.length input <> 0 then
      raise Input_too_large
    else
      length

  let compress input =
    let length  = compress_bound (Bytes.length input) in
    let output  = Bytes.create length in
    let length' = compress_into input output in
    if length' <> length then
      Bytes.sub output 0 length'
    else
      output

  let decompress_into input output =
    let length = C.b_decompress (ocaml_bytes_start input) (ocaml_bytes_start output)
                                (Bytes.length input) (Bytes.length output) in
    if length < 0 then
      raise Corrupted
    else
      length

  let decompress ~length input =
    if length < 0 then invalid_arg "LZ4.decompress";
    let output  = Bytes.create length in
    let length' = decompress_into input output in
    if length' <> length then
      Bytes.sub output 0 length'
    else
      output
end

module Bigbytes = struct
  type storage = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout)
                 Bigarray.Array1.t

  open Bigarray

  let compress_into input output =
    let length = C.ba_compress (bigarray_start array1 input) (bigarray_start array1 output)
                               (Array1.dim input) (Array1.dim output) in
    if length = 0 && Array1.dim input <> 0 then
      raise Input_too_large
    else
      length

  let compress input =
    let length  = compress_bound (Array1.dim input) in
    let output  = Array1.create char c_layout length in
    let length' = compress_into input output in
    if length' <> length then
      Array1.sub output 0 length'
    else
      output

  let decompress_into input output =
    let length = C.ba_decompress (bigarray_start array1 input) (bigarray_start array1 output)
                                 (Array1.dim input) (Array1.dim output) in
    if length < 0 then
      raise Corrupted
    else
      length

  let decompress ~length input =
    if length < 0 then invalid_arg "LZ4.decompress";
    let output  = Array1.create char c_layout length in
    let length' = decompress_into input output in
    if length' <> length then
      Array1.sub output 0 length'
    else
      output
end
