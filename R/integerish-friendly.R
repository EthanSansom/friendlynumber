integerish_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
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
    out[negatives] <- paste0(negative, inf) # Only `Inf` can be -ve at this point
    return(out)
  }

  remaining_numbers <- abs(numbers[needs_englishifying])
  if (all(remaining_numbers < 1000)) {
    out[needs_englishifying] <- after_format(
      english_hundreds(remaining_numbers),
      and = and,
      hyphenate = hyphenate
    )
    out[negatives] <- paste0(negative, out[negatives])
    return(out)
  }

  out[needs_englishifying] <- english_naturals(remaining_numbers, and = and, hyphenate = hyphenate)
  out[negatives] <- paste0(negative, out[negatives])
  out
}

integerish_friendly_safe <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
  ) {
  integerish_friendly(
    check_is_whole(numbers),
    zero = check_is_string(zero),
    na = check_is_string(na),
    nan = check_is_string(nan),
    inf = check_is_string(inf),
    negative = check_is_string(negative),
    and = check_is_bool(and),
    hyphenate = check_is_bool(hyphenate)
  )
}
