# TODO: Create a `biginteger_friendly()` which generates extra suffixes using
# `nice_illions()` if `english$suffixes` is depleted. Don't bother increasing
# the number of suffixes, since you'll never actually hit that.
#
# This looks like the limit of `integer_friendly()` precision:
# `integer_friendly(1000000000000000 - 1L)` nine hundred ninety-nine trillion... ninety-nine
# `integer_friendly(10000000000000000 - 1L)` ten quadrillion

# TODO: We'll generate more -illions if we've exceeded the alotted amount
biginteger_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative",
    and = FALSE,
    hyphenate = TRUE
) {
  # It looks like `integer_friendly()` "just works" for <bignum_biginteger>, but
  # we'll have to see if there are any edge cases that require differentiation
  integer_friendly(
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
