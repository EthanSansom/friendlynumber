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
    out[negatives] <- paste(negative, inf)
    return(out)
  }

  remaining_numbers <- abs(numbers[needs_englishifying])
  if (all(remaining_numbers < 1000)) {
    out[needs_englishifying] <- english_hundreds(remaining_numbers)
    out[needs_englishifying & negatives] <- paste(negative, out[needs_englishifying & negatives])
    return(out)
  }

  out[needs_englishifying] <- english_naturals(
    numbers = remaining_numbers,
    prefixes = character(length(remaining_numbers))
  )
  out[needs_englishifying & negatives] <- paste(negative, out[needs_englishifying & negatives])

  out <- trimws(out)
  if (and) out <- and(out)
  if (!hyphenate) out <- unhypenate(out)
  out
}

and <- function(english_numbers) {
  last_number <- sub(".*\\s", "", english_numbers)
  needs_an_and <- last_number %in% nums$hundreds[1:99 + 1]

  english_numbers[needs_an_and] <- sub(
    pattern = "^(.*) (\\S+)$",
    replacement =  "\\1 and \\2",
    x = english_numbers[needs_an_and]
  )
  english_numbers
}

unhypenate <- function(english_numbers) {
  sub("-", " ", english_numbers)
}
