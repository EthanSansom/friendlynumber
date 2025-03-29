#' Translate integer-ish numbers to a cardinal character vector
#'
#' @description
#'
#' Convert an integer vector, or numeric vector which is coercible to an integer
#' without loss of precision, to a cardinal numeral (e.g. one, two, three).
#'
#' `integerish_friendly_safe()` checks that all arguments are of the correct type
#' and raises an informative error otherwise. `integerish_friendly()` does not
#' perform input validation to maximize its speed.
#'
#' @inheritParams params
#'
#' @param numbers `[integer / numeric]`
#'
#' An integer or integer-ish numeric vector to translate.
#'
#' @returns
#'
#' A non-NA character vector of the same length as `numbers`.
#'
#' @examples
#' integerish_friendly(c(0, 1, 2, NA, NaN, Inf, -Inf))
#' integerish_friendly(10^10)
#'
#' # Specify the translations of "special" numbers
#' integerish_friendly(-10, negative = "minus ")
#' integerish_friendly(NaN, nan = "undefined")
#'
#' # Modify the output formatting
#' integerish_friendly(1234)
#' integerish_friendly(1234, and = TRUE)
#' integerish_friendly(1234, hyphenate = FALSE)
#'
#' # Input validation
#' try(integerish_friendly(0.5))
#' try(integerish_friendly(1L, na = TRUE))
#' @export
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

#' @rdname integerish_friendly
#' @export
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
  numbers <- check_is_whole(numbers)
  zero <- check_is_string(zero)
  na <- check_is_string(na)
  nan <- check_is_string(nan)
  inf <- check_is_string(inf)
  negative <- check_is_string(negative)
  and <- check_is_bool(and)
  hyphenate <- check_is_bool(hyphenate)

  integerish_friendly(
    numbers = numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    and = and,
    hyphenate = hyphenate
  )
}
