# TODO: I think this should expect positive integerish numbers, (e.g. 0, 1, 2, ...),
# as should all of the `n*_friendly` functions.

nth_friendly <- function(
    numbers,
    zero = "zeroth",
    na = "missingth",
    nan = "not a numberth",
    inf = "infinityth",
    negative = "negative",
    bigmark = TRUE
  ) {

  # TODO: Maybe needs something for <biginteger>
  out <- paste0(format_whole(numbers, bigmark = if (bigmark) "," else ""), "th")

  infinites <- is.infinite(numbers)
  missings <- is.na(numbers)
  zeros <- !missings & numbers == 0
  negatives <- !missings & numbers < 0
  nans <- is.nan(numbers)
  nas <- !nans & missings

  out[infinites] <- inf
  out[nas] <- na
  out[nans] <- nan
  out[zeros] <- zero
  out[negatives] <- paste(negative, out[negatives])

  needs_englishifying <- !(infinites | missings | zeros)
  if (!any(needs_englishifying)) {
    out[negatives] <- paste(negative, inf)
    return(out)
  }

  # Special rules for word endings:
  # 1     -> 1st (but not 11 -> 11st)
  # 2     -> 2nd
  # 3     -> 3rd
  out[needs_englishifying] <- sub("3th$", "3rd", sub("2th$", "2nd", sub("(?<!1)1th$", "1st", out[needs_englishifying], perl = TRUE)))
  trimws(out)
}
