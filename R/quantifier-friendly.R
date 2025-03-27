quantifier_friendly <- function(
    numbers,
    one = "the",
    two = "both",
    zero = "no",
    na = "a missing",
    nan = "an undefined",
    inf = "every",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE,
    bigmark = TRUE,
    max_friendly = 100
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

  # -1 and -2 shouldn't be included, `-1` -> "negative the" doesn't make sense
  ones <- !missings & numbers == 1
  twos <- !missings & numbers == 2
  out[ones] <- one
  out[twos] <- two

  # Numbers above `max_friendly` get non-english names, e.g. `1000` -> "all 1,000"
  numbers <- abs(numbers)
  bigs <- !(missings | infinites) & numbers > max_friendly
  out[bigs] <- format_whole(numbers[bigs], bigmark = if (bigmark) "," else "")

  needs_englishifying <- !(infinites | missings | zeros | ones | twos | bigs)
  if (!any(needs_englishifying)) {
    # Negate before the "all", e.g. `-5` -> "all negative five" not "negative all five"
    out[negatives] <- paste0(negative, out[negatives])
    out[bigs] <- paste("all", out[bigs])
    return(out)
  }

  remaining_numbers <- abs(numbers[needs_englishifying])
  needs_all <- needs_englishifying | bigs

  if (all(remaining_numbers < 1000)) {
    out[needs_englishifying] <- after_format(
      english_hundreds(remaining_numbers),
      and = and,
      hyphenate = hyphenate
    )
    out[negatives] <- paste0(negative, out[negatives])
    out[needs_all] <- paste("all", out[needs_all])
    return(out)
  }

  out[needs_englishifying] <- english_naturals(
    remaining_numbers,
    and = and,
    hyphenate = hyphenate
  )
  out[negatives] <- paste0(negative, out[negatives])
  out[needs_all] <- paste("all", out[needs_all])
  out
}

quantifier_friendly_safe <- function(
    numbers,
    one = "the",
    two = "both",
    zero = "no",
    na = "a missing",
    nan = "an undefined",
    inf = "every",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE,
    bigmark = TRUE,
    max_friendly = 100
) {
  numbers <- check_is_whole(numbers)
  one <- check_is_string(one)
  two <- check_is_string(two)
  zero <- check_is_string(zero)
  na <- check_is_string(na)
  nan <- check_is_string(nan)
  inf <- check_is_string(inf)
  negative <- check_is_string(negative)
  and <- check_is_bool(and)
  hyphenate <- check_is_bool(hyphenate)
  bigmark <- check_is_bool(bigmark)
  max_friendly <- check_is_number(max_friendly)

  quantifier_friendly(
    numbers = numbers,
    one = one,
    two = two,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    and = and,
    hyphenate = hyphenate,
    bigmark = bigmark,
    max_friendly = max_friendly
  )
}
