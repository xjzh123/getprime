# Package

version       = "0.1.0"
author        = "xjzh123"
description   = "Generate random prime numbers, and do prime number tests. Note: don't support prime numbers larger than approximately 3037000499 (sqrt(int.high))."
license       = "MIT"
srcDir        = "src"


# Dependencies

requires "nim >= 1.0.0"

# Tasks

task benchmark, "Run the benchmark":
  exec "nim c -r benchmark/benchmark"
