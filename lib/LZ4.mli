(** LZ4 compression algorithm *)

exception Input_too_large
exception Corrupted

(** [compress_bound sz] returns the maximum size of the LZ4 output
    for [sz] bytes of input. It raises [Input_too_large] if [sz > 0x7E000000] or if the
    result would be larger than [Pervasives.max_int] (the latter is only possible, if [Sys.word_size = 32]).
    Raises [Invalid_argument "LZ4.compress_bound"] if [sz] is negative. *)
val compress_bound : int -> int

module type S = sig
  type storage

  (** [compress input] returns LZ4-compressed [input] or raises [Input_too_large]
      if [input] is longer than [0x7E000000] bytes. *)
  val compress : storage -> storage

  (** [compress_buff input buf ofs len] writes LZ4-compressed [input]
      into [buf] starting at offset [ofs] and up to [len] bytes.
      Returns the number of bytes actually written in [buf]
      or raises [Input_too_large]
      if [input] is longer than [0x7E000000] bytes
      or compress_bound of input is larger than [len]. *)
  val compress_buff : storage -> storage -> offset:int -> length:int -> int

  (** [decompress ~length input] returns LZ4-decompressed [input] or raises [Corrupted]
      if [input] does not constitute a valid LZ4-compressed stream which uncompresses
      into [length] bytes or less.
      Raises [Invalid_argument "LZ4.decompress"] if [length] is negative. *)
  val decompress : length:int -> storage -> storage
end

module Bytes    : S with type storage = Bytes.t
module Bigbytes : S with type storage = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout)
                                        Bigarray.Array1.t
