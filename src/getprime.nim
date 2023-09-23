## Generate random prime numbers, and do prime number tests.
## 
## Note: don't support prime numbers larger than approximately 3037000499 (sqrt(int.high)).

import std/random

const primes = [
  2, 3, 5, 7, 11, 13, 17, 19, 23, 29,
  31, 37, 41, 43, 47, 53, 59, 61, 67, 71,
  73, 79, 83, 89, 97, 101, 103, 107, 109, 113,
  127, 131, 137, 139, 149, 151, 157, 163, 167, 173,
  179, 181, 191, 193, 197, 199, 211, 223, 227, 229,
  233, 239, 241, 251, 257, 263, 269, 271, 277, 281,
  283, 293, 307, 311, 313, 317, 331, 337, 347, 349,
  353, 359, 367, 373, 379, 383, 389, 397, 401, 409,
  419, 421, 431, 433, 439, 443, 449, 457, 461, 463,
  467, 479, 487, 491, 499, 503, 509, 521, 523, 541,
  547, 557, 563, 569, 571, 577, 587, 593, 599, 601,
  607, 613, 617, 619, 631, 641, 643, 647, 653, 659,
  661, 673, 677, 683, 691, 701, 709, 719, 727, 733,
  739, 743, 751, 757, 761, 769, 773, 787, 797, 809,
  811, 821, 823, 827, 829, 839, 853, 857, 859, 863,
  877, 881, 883, 887, 907, 911, 919, 929, 937, 941,
  947, 953, 967, 971, 977, 983, 991, 997
]

func fastPowMod*(n: int, k: int, m: int): int =
  ## Calculates `n ^ k mod m`.
  ##
  ## Note: when `m` is big as 10e9, doesn't support `n` larger than approximately 3037000499 (sqrt(int.high)).
  runnableExamples:
    import std/math
    assert fastPowMod(2, 9, 7) == 2 ^ 9 mod 7
    assert fastPowMod(3, 7, 11) == 3 ^ 7 mod 11

  result = 1
  var k = k
  var n = n mod m
  while k != 0:
    if (k and 1) == 1:
      result = result * n mod m
    k = k div 2
    n = n * n mod m

proc millerRabinTest*(n, tests: int): bool =
  ## Uses Miller Rabin Algorithm to test whether `n` is (probably) a prime number, test for `tests` times.
  ##
  ## Note: doesn't support `n` larger than approximately 3037000499 (sqrt(int.high)).
  runnableExamples:
    assert millerRabinTest(2047, 10) == false
    assert millerRabinTest(2769155087, 10) == false
    assert millerRabinTest(1000000007, 10) == true
    assert millerRabinTest(1000000009, 10) == true

  let (k, q) = block:
    var (k, q) = (0, n - 1)
    while (q and 1) == 0:
      q = q shr 1
      inc k
    (k, q)

  for i in 0 ..< tests:
    var composite = true
    let a = rand(2 .. n-2)

    var r = fastPowMod(a, q, n)
    if r == 1 or r == n - 1:
      composite = false
    else:
      block inner:
        for j in 1..<k:
          r = r * r mod n
          if r == n - 1:
            composite = false
            break inner
    if composite:
      return false

  return true

proc isPrime*(n: int, tests = 30): bool =
  ## Decide whether `n` is a prime number. Use for big numbers.
  ##
  ## Firstly uses a table to check for small prime factors, which is considered faster than using the Miller Rabin test at first.
  ##
  ## Note: doesn't support `n` larger than approximately 3037000499 (sqrt(int.high)), except for the case that `n` can be confirmed as compisite number by checking factors with the table of prime numbers < 1000.
  runnableExamples:
    assert isPrime(2047) == false
    assert isPrime(2769155087) == false
    assert isPrime(1000000007) == true
    assert isPrime(1000000009) == true

  for p in primes:
    if n == p:
      return true
    if n mod p == 0:
      return false
  return millerRabinTest(n, tests)

proc getPrime*(r: Slice[int]): int =
  ## Generate random prime number in range `r`. Use for big enough ranges, like `10e9 .. 10e10`.
  ##
  ## Note: doesn't support numbers larger than approximately 3037000499 (sqrt(int.high)).
  runnableExamples:
    assert isPrime(getPrime(100000..100000000))

  let a = r.a div 6
  let b = r.b div 6

  let offset = sample([1, 5]) # Trick to save time generating random `6n+1` or `6n+5` numbers as any prime numbers > 6 must be `6n+1` or `6n+5`.

  while true:
    let x = rand(a..b) * 6 + offset

    if isPrime(x) and x in r:
      return x
