#' Translate integer-ish numbers to a character vector of nths (1st, 2nd, 3rd)
#'
#' @description
#'
#' Convert an integer vector, or numeric vector which is coercible to an integer
#' without loss of precision, to an "nth" (e.g. 1st, 2nd, 3rd, 22nd, 1,000th).
#'
#' `nth_friendly_safe()` checks that all arguments are of the correct type
#' and raises an informative error otherwise. `nth_friendly()` does not
#' perform input validation to maximize its speed.
#'
#' @inheritParams params
#'
#' @return
#'
#' A non-NA character vector of the same length as `numbers`.
#'
#' @examples
#' nth_friendly(c(0, 1, 2, 3, 22, 1001, NA, NaN, Inf, -Inf))
#'
#' # Specify the translations of "special" numbers
#' nth_friendly(c(1, 0, NA), zero = "noneth", na = "?")
#'
#' # Use `bigmark` to add or remove commas
#' nth_friendly(1234, bigmark = TRUE)
#' nth_friendly(1234, bigmark = FALSE)
#'
#' # Input validation
#' try(nth_friendly_safe(1234, bigmark = ","))
#' @export
nth_friendly <- function(
    numbers,
    zero = "0th",
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
  out[needs_englishifying] <- format_whole(abs(numbers[needs_englishifying]), bigmark = bigmark)
  out[needs_englishifying] <- sub("(?<!1)3th$", "3rd",
                                  sub("(?<!1)2th$", "2nd",
                                      sub("(?<!1)1th$", "1st",
                                          paste0(out[needs_englishifying], "th"), perl = TRUE), perl = TRUE), perl = TRUE)

  out[negatives] <- paste0(negative, out[negatives])
  trimws(out)
}

#' @rdname nth_friendly
#' @export
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
