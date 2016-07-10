// Originally written by Attractive Chaos; distributed under the MIT license (D V.2 code)
// Contributed by leonardo and then modified by Attractive Chaos to remove D 2.0 features

import std.numeric, std.stdio, std.string, std.conv;
import std.experimental.ndslice;
import std.range : iota, lockstep, zip;

alias Matrix = Slice!(2, double*);

Matrix matGen(int n) {
  double coeff = 1.0 / n / n;
  auto matrix = slice!double(n, n);
  foreach (int i; 0 .. n)
    foreach (int j; 0 .. n)
      matrix[i, j] = coeff * (i - j) * (i + j);
  return matrix;
}

Matrix matMul(Matrix a, Matrix b) {
  auto m = a.length, n = a[0].length, p = b[0].length;

  // transpose
  auto c = b.transposed.slice;

  auto x = slice!double(m, p);
  foreach (i; 0 .. a.length)
    foreach (j; 0 .. c.length)
      x[i,j] = dotProduct(a[i].ptr[0..m], c[i].ptr[0..m]);

  return cast(Matrix)x;
}

void main(in string[] args) {
  int n = 100;
  if (args.length > 1) n = (args[1].to!int / 2) * 2;
  auto a = matGen(n);
  auto b = matGen(n);
  auto x = matMul(a, b);
  printf("%.6f\n", x[n / 2][n / 2]);
}
