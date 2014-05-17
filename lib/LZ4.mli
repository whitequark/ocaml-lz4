(** LZ4 compression algorithm *)

exception Input_too_large
exception Corrupted

(** [compress_bound sz] returns the maximum size of the LZ4 output
    for [sz] bytes of input, or raises [Input_too_large] if [sz > 0x7E000000].
    Raises [Invalid_argument "LZ4.compress_bound"] if [sz] is negative. *)
val compress_bound : int -> int

module type S = sig
  type storage

  (** [compress input] returns LZ4-compressed [input] or raises [Input_too_large]
      if [input] is longer than [0x7E000000] bytes. *)
  val compress   : storage -> storage

  (** [decompress ~length input] returns LZ4-decompressed [input] or raises [Corrupted]
      if [input] does not constitute a valid LZ4-compressed stream which uncompresses
      into [length] bytes or less.
      Raises [Invalid_argument "LZ4.decompress"] if [length] is negative. *)
  val decompress : length:int -> storage -> storage
end

module Bytes    : S with type storage = Bytes.t
module Bigbytes : S with type storage = (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout)
                                        Bigarray.Array1.t
