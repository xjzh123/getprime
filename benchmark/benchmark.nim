import std/random

import nimbench

import getprime

randomize()

bench(getPrime):
  var it = getPrime(100000000..1000000000)
  doNotOptimizeAway(it)

runBenchmarks()
