(** LZ4 compression algorithm *)

exception Input_too_large
exception Corrupted

(** [compress_bound sz] returns the maximum size of the LZ4 output
    for [sz] bytes of input. It raises [Input_too_large] if [sz > 0x7E000000] or if the
    result would be larger than [Pervasives.max_int] (the latter is only possible, if [Sys.word_size = 32]).
    Raises [Invalid_argument "LZ4.compress_bound"] if [sz] is negative. *)
val compress_bound : int -> int

(** Version number of the LZ4 library *)
val version_number : int

module type S = sig
  type storage

  (** [compress_into input output] places LZ4-compressed [input] into [output]
      and returns the length of compressed output or raises [Input_too_large]
      if [input] is longer than [0x7E000000] bytes or [output] is not long
      enough to contain the compressed [input].

      This function does not allocate. *)
  val compress_into   : storage -> storage -> int

  (** [compress input] returns LZ4-compressed [input] or raises [Input_too_large]
      if [input] is longer than [0x7E000000] bytes. *)
  val compress        : storage -> storage

  (** [decompress_into input output] places LZ4-decompressed [input] into [output]
      or raises [Corrupted] if [input] does not constitute a valid LZ4-compressed
      stream which uncompresses into the amount of bytes available in [output] or less.

      This function does not allocate. *)
  val decompress_into : storage -> storage -> int

  (** [decompress ~length input] returns LZ4-decompressed [input] or raises [Corrupted]
      if [input] does not constitute a valid LZ4-compressed stream which uncompresses
      into [length] bytes or less.
      Raises [Invalid_argument "LZ4.decompress"] if [length] is negative. *)
  val decompress      : length:int -> storage -> storage
end

module Bytes    : S with type storage = Bytes.t
module Bigbytes : S with type storage = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout)
                                        Bigarray.Array1.t
