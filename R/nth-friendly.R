nth_friendly <- function(
    numbers,
    zero = "zeroth",
    na = "missingth",
    nan = "not a numberth",
    inf = "infinitieth",
    negative = "negative ",
    bigmark = TRUE
  ) {

  out <- character(length(numbers))

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

  needs_englishifying <- !(infinites | missings | zeros)
  if (!any(needs_englishifying)) {
    out[negatives] <- paste0(negative, inf)
    return(out)
  }

  # Special rules for word endings:
  # *     -> *th
  # 1     -> 1st (but not 11 -> 11st)
  # 2     -> 2nd (but not 12 -> 12nd)
  # 3     -> 3rd
  out[needs_englishifying] <- format_whole(abs(numbers[needs_englishifying]), bigmark = if (bigmark) "," else "")
  out[needs_englishifying] <- sub("(?<!1)3th$", "3rd",
                                  sub("(?<!1)2th$", "2nd",
                                      sub("(?<!1)1th$", "1st",
                                          paste0(out[needs_englishifying], "th"), perl = TRUE), perl = TRUE), perl = TRUE)

  out[negatives] <- paste0(negative, out[negatives])
  trimws(out)
}

nth_friendly_safe <- function(
    numbers,
    zero = "zeroth",
    na = "missingth",
    nan = "not a numberth",
    inf = "infinitieth",
    negative = "negative ",
    bigmark = TRUE
) {
  numbers <- check_is_whole(numbers)
  zero <- check_is_string(zero)
  na <- check_is_string(na)
  nan <- check_is_string(nan)
  inf <- check_is_string(inf)
  negative <- check_is_string(negative)
  bigmark <- check_is_bool(bigmark)

  nth_friendly(
    numbers = numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    bigmark = bigmark
  )
}
