open OUnit2

let test_compress_bound ctxt =
  assert_equal ~printer:string_of_int 273 (LZ4.compress_bound 256);
  assert_equal ~printer:string_of_int 1_073_741_823 (* max_int at 32-bit *)
    (LZ4.compress_bound 1_069_547_504);
  assert_raises LZ4.Input_too_large (fun () ->
    if Sys.word_size = 32 then LZ4.compress_bound 1_069_547_505
    else LZ4.compress_bound 0x7E000001);
  assert_raises (Invalid_argument "LZ4.compress_bound") (fun () ->
    LZ4.compress_bound (-1))

let input  = "wild wild fox wild wild fox"
let output = "\x51\x77\x69\x6c\x64\x20\x05\x00\x32\x66\x6f\x78\x09\x00\
              \x80\x77\x69\x6c\x64\x20\x66\x6f\x78"
let printer = Printf.sprintf "%S"

let test_compress_bytes ctxt =
  let output' = LZ4.Bytes.compress (Bytes.of_string input) in
  assert_equal ~printer output (Bytes.to_string output')

let test_decompress_bytes ctxt =
  let input'  = LZ4.Bytes.decompress ~length:(String.length input) (Bytes.of_string output) in
  assert_equal ~printer input (Bytes.to_string input');
  assert_raises LZ4.Corrupted (fun () ->
    LZ4.Bytes.decompress ~length:4 (Bytes.of_string output));
  assert_raises LZ4.Corrupted (fun () ->
    LZ4.Bytes.decompress ~length:10 (Bytes.of_string "foo"));
  assert_raises (Invalid_argument "LZ4.decompress") (fun () ->
    LZ4.Bytes.decompress ~length:(-1) (Bytes.of_string "foo"))

let to_bigbytes s =
  let len = String.length s in
  let t = Bigarray.(Array1.create char c_layout len) in
  for i = 0 to len - 1 do t.{i} <- s.[i] done;
  t

let of_bigbytes ba =
  let len = Bigarray.Array1.dim ba in
  let b = Bytes.create len in
  for i = 0 to len - 1 do Bytes.set b i ba.{i} done;
  Bytes.to_string b

let test_compress_bigbytes ctxt =
  let output' = LZ4.Bigbytes.compress (to_bigbytes input) in
  assert_equal ~printer output (of_bigbytes output')

let test_decompress_bigbytes ctxt =
  let input'  = LZ4.Bigbytes.decompress ~length:(String.length input) (to_bigbytes output) in
  assert_equal ~printer input (of_bigbytes input');
  assert_raises LZ4.Corrupted (fun () ->
    LZ4.Bigbytes.decompress ~length:4 (to_bigbytes output));
  assert_raises LZ4.Corrupted (fun () ->
    LZ4.Bigbytes.decompress ~length:10 (to_bigbytes "foo"));
  assert_raises (Invalid_argument "LZ4.decompress") (fun () ->
    LZ4.Bigbytes.decompress ~length:(-1) (to_bigbytes "foo"))

let suite = "Test LZ4" >::: [
    "test_compress_bound"       >:: test_compress_bound;
    "test_compress_bytes"       >:: test_compress_bytes;
    "test_decompress_bytes"     >:: test_decompress_bytes;
    "test_compress_bigbytes"    >:: test_compress_bigbytes;
    "test_decompress_bigbytes"  >:: test_decompress_bigbytes;
  ]

let _ = run_test_tt_main suite
