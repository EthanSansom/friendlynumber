# TODO: Rename -> integerish_friendly
integer_friendly <- function(
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
    out[negatives] <- paste(negative, inf) # Only `Inf` can be -ve at this point
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
