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

  out <- character(length(numbers))

  infinites <- is.infinite(numbers)
  missings <- is.na(numbers)
  zeros <- !missings & numbers == 0
  negatives <- !missings & numbers < 0

  # `is.na()` is TRUE for NaN
  nans <- is.nan(numbers)
  nas <- !nans & missings

  out[infinites] <- inf
  out[nas] <- na
  out[nans] <- nan
  out[zeros] <- zero

  needs_englishifying <- !(infinites | missings | zeros)
  if (!any(needs_englishifying)) {
    out[negatives] <- paste(negative, inf)
    return(out)
  }

  remaining_numbers <- abs(numbers[needs_englishifying])
  if (all(remaining_numbers < 1000)) {
    out[needs_englishifying] <- english_hundreds(remaining_numbers)
    out[negatives] <- paste(negative, out[negatives])
    return(out)
  }

  out[needs_englishifying] <- english_naturals(remaining_numbers)
  out[negatives] <- paste(negative, out[negatives])

  out <- trimws(out)
  if (and) out <- and(out)
  if (!hyphenate) out <- unhypenate(out)
  out
}
