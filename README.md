OCaml Inotify bindings
======================

This package contains bindings for [LZ4][], a very fast lossless compression
algorithm.

  [lz4]: https://code.google.com/p/lz4/

Installation
------------

The bindings are available via [OPAM](https://opam.ocaml.org):

    $ opam install lz4

Alternatively, you can do it manually:

    $ opam install ctypes
    $ ./configure
    $ make all install

Usage
-----

The bindings are contained in findlib package `lz4`.

Documentation
-------------

The API documentation is available at [GitHub pages](http://whitequark.github.io/ocaml-lz4/).

License
-------

[3-clause BSD](LICENSE.txt) (same as LZ4).
