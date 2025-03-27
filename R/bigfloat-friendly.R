bigfloat_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    decimal = " and ",
    and = FALSE,
    hyphenate = TRUE,
    and_fractional = and,
    hyphenate_fractional = hyphenate,
    english_fractions = NULL
) {
  # It looks like `bigfloat_friendly()` "just works" for <bignum_bigfloat>, but
  # we'll need to see if edge case differences arise.
  numeric_friendly(
    numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    decimal = decimal,
    and = and,
    hyphenate = hyphenate,
    and_fractional = and_fractional,
    hyphenate_fractional = hyphenate_fractional,
    english_fractions = english_fractions
  )
}

bigfloat_friendly_safe <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    decimal = " and ",
    and = FALSE,
    hyphenate = TRUE,
    and_fractional = and,
    hyphenate_fractional = hyphenate,
    english_fractions = NULL
) {
  numbers <- check_is_class(numbers, is_bigfloat, "bignum_bigfloat")
  zero <- check_is_string(zero)
  na <- check_is_string(na)
  nan <- check_is_string(nan)
  inf <- check_is_string(inf)
  negative <- check_is_string(negative)
  decimal <- check_is_string(decimal)
  and <- check_is_bool(and)
  hyphenate <- check_is_bool(hyphenate)
  and_fractional <- check_is_bool(and_fractional)
  hyphenate_fractional <- check_is_bool(hyphenate_fractional)
  english_fractions <- check_is_type(
    english_fractions, is.character, "a character", null_ok = TRUE
  )

  bigfloat_friendly(
    numbers = numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    decimal = decimal,
    and = and,
    hyphenate = hyphenate,
    and_fractional = and_fractional,
    hyphenate_fractional = hyphenate_fractional,
    english_fractions = english_fractions
  )
}
