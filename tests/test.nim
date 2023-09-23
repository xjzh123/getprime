# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest

import std/random
import std/math

import getprime

randomize()

test "fast PowMod":

  check fastPowMod(2, 9, 7) == 2 ^ 9 mod 7
  check fastPowMod(3, 7, 11) == 3 ^ 7 mod 11

test "Miller Rabin Test":

  check millerRabinTest(2047, 10) == false
  check millerRabinTest(2769155087, 10) == false
  check millerRabinTest(1000000007, 10) == true
  check millerRabinTest(1000000009, 10) == true
  check millerRabinTest(3037000499, 10) == false

test "isPrime":

  check isPrime(2047) == false
  check isPrime(2769155087) == false
  check isPrime(1000000007) == true
  check isPrime(1000000009) == true

test "getPrime":

  check isPrime(getPrime(100000..100000000))
