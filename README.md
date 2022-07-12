# OCaml LZ4 bindings [![build](https://github.com/whitequark/ocaml-lz4/actions/workflows/main.yml/badge.svg)](https://github.com/whitequark/ocaml-lz4/actions/workflows/main.yml)

This package contains bindings for [LZ4][], a very fast lossless compression
algorithm.

  [lz4]: https://code.google.com/p/lz4/

Installation
------------

The bindings are available via [OPAM](https://opam.ocaml.org):

    $ opam install lz4

Alternatively, you can do it manually:

    $ opam install dune ctypes
    $ make all install

Usage
-----

The bindings are contained in findlib package `lz4`.

To roundtrip some data:

``` ocaml
let data         = "wild wild fox" in
let compressed   = LZ4.Bytes.compress (Bytes.of_string data) in
let decompressed = LZ4.Bytes.decompress ~length:(String.length data) compressed in
Printf.printf "%S\n" (Bytes.to_string decompressed) (* => "wild wild fox" *)
```

Documentation
-------------

The API documentation is available at [GitHub pages](http://whitequark.github.io/ocaml-lz4/).

License
-------

[3-clause BSD](LICENSE.txt) (same as LZ4).
