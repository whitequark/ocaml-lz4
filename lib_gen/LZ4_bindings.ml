open Ctypes

module C(F: Cstubs.FOREIGN) = struct
  let compressBound = F.foreign "LZ4_compressBound" (int @-> returning int)
  let b_compress    = F.foreign "LZ4_compress_limitedOutput"
                                (ocaml_bytes @-> ocaml_bytes @-> int @-> int @-> returning int)
  let ba_compress   = F.foreign "LZ4_compress_limitedOutput"
                                (ptr char @-> ptr char @-> int @-> int @-> returning int)
  let b_decompress  = F.foreign "LZ4_decompress_safe"
                                (ocaml_bytes @-> ocaml_bytes @-> int @-> int @-> returning int)
  let ba_decompress = F.foreign "LZ4_decompress_safe"
                                (ptr char @-> ptr char @-> int @-> int @-> returning int)
end
