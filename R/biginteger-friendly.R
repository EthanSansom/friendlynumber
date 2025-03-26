biginteger_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number", # Vestigial, since <bignum_biginteger> is never NaN
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
) {
  # It looks like `integerish_friendly()` "just works" for <bignum_biginteger>,
  # but we'll have to see if there are any edge cases that require differentiation
  integerish_friendly(
    numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    and = and,
    hyphenate = hyphenate
  )
}
