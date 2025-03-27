ntimes_friendly <- function(
    numbers,
    one = "once",
    two = "twice",
    three = "three times",
    zero = "no times",
    na = "an unknown number of times",
    nan = "an undefined number of times",
    inf = "infinite times",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
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

  remaining_numbers <- abs(numbers[needs_englishifying])

  ones <- remaining_numbers == 1
  twos <- remaining_numbers == 2
  threes <- remaining_numbers == 3
  four_plus <- !(ones | twos | threes)

  # `ones`, `twos`, `threes` are within the set of `needs_englishifying` numbers
  out[needs_englishifying][ones] <- one
  out[needs_englishifying][twos] <- two
  out[needs_englishifying][threes] <- three

  needs_englishifying[needs_englishifying][!four_plus] <- FALSE
  remaining_numbers <- remaining_numbers[four_plus]

  if (all(remaining_numbers < 1000)) {
    out[needs_englishifying] <- paste(after_format(
      english_hundreds(remaining_numbers),
      and = and,
      hyphenate = hyphenate
    ), "times")
    out[negatives] <- paste0(negative, out[negatives])
    return(out)
  }

  out[needs_englishifying] <- paste(english_naturals(
    remaining_numbers,
    and = and,
    hyphenate = hyphenate
  ), "times")

  out[negatives] <- paste0(negative, out[negatives])
  out
}

ntimes_friendly_safe <- function(
    numbers,
    one = "once",
    two = "twice",
    three = "three times",
    zero = "no times",
    na = "an unknown number of times",
    nan = "an undefined number of times",
    inf = "infinite times",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
) {
  numbers <- check_is_whole(numbers)
  one <- check_is_string(one)
  two <- check_is_string(two)
  three <- check_is_string(three)
  zero <- check_is_string(zero)
  na <- check_is_string(na)
  nan <- check_is_string(nan)
  inf <- check_is_string(inf)
  negative <- check_is_string(negative)
  and <- check_is_bool(and)
  hyphenate <- check_is_bool(hyphenate)

  ntimes_friendly(
    numbers = numbers,
    one = one,
    two = two,
    three = three,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    and = and,
    hyphenate = hyphenate
  )
}
