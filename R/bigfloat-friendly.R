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
  # It looks like `numeric_friendly()` "just works" for <bignum_bigfloat>, but
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
