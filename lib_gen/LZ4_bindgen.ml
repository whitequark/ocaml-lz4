open Ctypes

let _ =
  let fmt = Format.formatter_of_out_channel (open_out "lib/LZ4_stubs.c") in
  Format.fprintf fmt "#include <caml/mlvalues.h>@.";
  Format.fprintf fmt "#include <ctypes/cstubs_internals.h>@.";
  Format.fprintf fmt "#include <lz4.h>@.";
  Cstubs.write_c fmt ~prefix:"caml_" (module LZ4_bindings.C);

  let fmt = Format.formatter_of_out_channel (open_out "lib/LZ4_generated.ml") in
  Cstubs.write_ml fmt ~prefix:"caml_" (module LZ4_bindings.C)
