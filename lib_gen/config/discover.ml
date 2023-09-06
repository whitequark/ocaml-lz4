let () =
  let module C = Configurator.V1 in
  let open C.Pkg_config in
  let run_opt default = function | None -> default | Some x -> x in
  let bind_opt m f = match m with | None -> None | Some x -> f x in (* monad *)
  C.main ~name:"lz4" (fun c ->
    let conf = run_opt {libs = ["-llz4"]; cflags = []} (* fallback => hope for the best *)
                       (bind_opt (C.Pkg_config.get c) (C.Pkg_config.query ~package:"liblz4"))
    in
    C.Flags.write_sexp "c_flags.sexp" conf.cflags;
    C.Flags.write_sexp "c_library_flags.sexp" conf.libs)
