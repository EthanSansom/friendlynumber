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

biginteger_friendly_safe <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
) {
  # Some paths don't evaluate every one of these arguments, so we need to force
  # the checks here.
  numbers <- check_is_class(numbers, is_biginteger, "bignum_biginteger")
  zero <- check_is_string(zero)
  na <- check_is_string(na)
  nan <- check_is_string(nan)
  inf <- check_is_string(inf)
  negative <- check_is_string(negative)
  and <- check_is_bool(and)
  hyphenate <- check_is_bool(hyphenate)

  integerish_friendly(
    numbers = numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    and = and,
    hyphenate = hyphenate
  )
}
