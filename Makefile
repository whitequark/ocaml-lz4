
all:
	@dune build @install

install: all
	@dune install

clean:
	@dune clean

doc:
	@dune build @doc

test:
	@dune runtest
