#' Translate integer-ish numbers to a character vector of counts (once, twice, three times)
#'
#' @description
#'
#' Convert an integer vector, or numeric vector which is coercible to an integer
#' without loss of precision, to a count (e.g. no times, once, twice, four times).
#'
#' `ntimes_friendly_safe()` checks that all arguments are of the correct type
#' and raises an informative error otherwise. `ntimes_friendly()` does not
#' perform input validation to maximize its speed.
#'
#' @inheritParams params
#'
#' @returns
#'
#' A non-NA character vector of the same length as `numbers`.
#'
#' @examples
#' ntimes_friendly(c(0, 1, 2, 3, 22, 1001, NA, NaN, Inf, -Inf))
#'
#' # Specify the translations of "special" numbers
#' ntimes_friendly(c(3, NA), three = "thrice", na = "some times")
#'
#' # Modify the output formatting
#' ntimes_friendly(5678)
#' ntimes_friendly(5678, and = TRUE)
#' ntimes_friendly(5678, hyphenate = FALSE)
#'
#' # Input validation
#' try(ntimes_friendly_safe(1234, and = " - "))
#' @export
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
