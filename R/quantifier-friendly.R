#' Translate integer-ish numbers to a character vector of quantifiers (the, both, all three)
#'
#' @description
#'
#' Convert an integer vector, or numeric vector which is coercible to an integer
#' without loss of precision, to a quantifier (e.g. no, the, every, all five).
#'
#' `quantifier_friendly_safe()` checks that all arguments are of the correct type
#' and raises an informative error otherwise. `quantifier_friendly()` does not
#' perform input validation to maximize its speed.
#'
#' @inheritParams params
#'
#' @param max_friendly `[numeric]`
#'
#' The maximum number to convert to a numeral. Elements of `numbers` above
#' `max_friendly` are converted to formatted numbers (e.g. `"all 1,000"`
#' instead of `"all one thousand"`). `max_friendly` is `100` by default.
#'
#' Use the `bigmark` argument to determine whether these formatted numbers
#' are comma separated (e.g. `"all 1,000"` vs. `"all 1000"`).
#'
#' @returns
#'
#' A non-NA character vector of the same length as `numbers`.
#'
#' @examples
#' quantifier_friendly(c(0, 1, 2, 3, NA, NaN, Inf))
#'
#' # The `negative` prefix appears after the `"all"` prefix
#' quantifier_friendly(-4)
#'
#' # `-1` and `-2` are not translated using `one` and `two`
#' quantifier_friendly(c(1, 2, -1, -2), one = "the", two = "both")
#'
#' # Suppress the translation of large numbers
#' quantifier_friendly(c(99, 1234), max_friendly = -Inf)
#' quantifier_friendly(c(99, 1234), max_friendly = 100)
#' quantifier_friendly(c(99, 1234), max_friendly = 1500)
#'
#' # Specify the translations of "special" numbers
#' quantifier_friendly(c(1, Inf), one = "a", inf = "all")
#'
#' # Arguments `one`, `two`, `inf`, etc. take precedence over `max_friendly`
#' quantifier_friendly(1:3, one = "one", two = "two", max_friendly = -1)
#'
#' # Modify the output formatting
#' quantifier_friendly(1021, max_friendly = Inf)
#' quantifier_friendly(1021, and = TRUE, max_friendly = Inf)
#' quantifier_friendly(1021, hyphenate = FALSE, max_friendly = Inf)
#' quantifier_friendly(1021, bigmark = FALSE, max_friendly = 10)
#' quantifier_friendly(1021, bigmark = TRUE, max_friendly = 10)
#'
#' # Input validation
#' try(quantifier_friendly_safe(1234, max_friendly = NA))
#' @export
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
  bigs <- !(missings | infinites | ones | twos) & numbers > max_friendly
  out[bigs] <- format_whole(numbers[bigs], bigmark = bigmark)

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

#' @rdname quantifier_friendly
#' @export
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
