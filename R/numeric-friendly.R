#' Translate a numeric vector to a cardinal character vector
#'
#' @description
#'
#' Convert a numeric vector to a cardinal numeral (e.g. one tenth, one, two).
#'
#' `numeric_friendly_safe()` checks that all arguments are of the correct type
#' and raises an informative error otherwise. `numeric_friendly()` does not
#' perform input validation to maximize its speed.
#'
#' @inheritParams params
#'
#' @param numbers `[numeric]`
#'
#' A numeric vector to translate.
#'
#' @return
#'
#' A non-NA character vector of the same length as `numbers`.
#'
#' @examples
#' numeric_friendly(c(1/3, 0, 0.999, NA, NaN, Inf, -Inf))
#'
#' # Specify the translations of "special" numbers
#' numeric_friendly(c(1, 0, Inf), zero = "none", inf = "all")
#'
#' # Modify the output formatting
#' frac <- 8765.4321
#' numeric_friendly(frac)
#' numeric_friendly(frac, decimal = " dot ")
#' numeric_friendly(frac, hyphenate = TRUE, hyphenate_fractional = FALSE)
#' numeric_friendly(frac, and = TRUE, and_fractional = TRUE, decimal = " . ")
#'
#' # The `friendlynumber.numeric.digits` option specifies the number of
#' # numeric digits mentioned by `numeric_friendly()`
#' opts <- options()
#' options(friendlynumber.numeric.digits = 5)
#' numeric_friendly(0.0987654321)
#'
#' options(friendlynumber.numeric.digits = 10)
#' numeric_friendly(0.0987654321)
#' options(opts)
#'
#' # Set `english_fractions` to specify the translation of certain
#' # fractions. The names (keys) of `english_fractions` should match
#' # the decimal part of a fraction (e.g. `"5"` matches `0.5`).
#' numeric_friendly(
#'   c(1/2, 6/5, 12),
#'   english_fractions = c(`5` = "1/2", `2` = "1/5")
#' )
#'
#' # Input validation
#' try(numeric_friendly_safe("A"))
#' @export
numeric_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    decimal = " and ",
    and = FALSE,
    hyphenate = TRUE,
    and_fractional = and,
    hyphenate_fractional = hyphenate,
    english_fractions = NULL
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
    out[negatives] <- paste0(negative, inf)
    return(out)
  }

  remaining_numbers <- abs(numbers[needs_englishifying])
  remaining_wholes <- trunc(remaining_numbers)

  # These only need to be equal up to a certain precision. One of these may work:
  # - `remaining_numbers - remaining_wholes < get_epsilon()`
  # - `round(remaining_numbers, get_digits()) == remaining_wholes`
  # `get_digits()/get_epsilon()` depend on the `friendlynumber.*.digits` option.
  # Today, 0's from imprecision are caught later within `english_fractionals()`.
  if (all(remaining_numbers == remaining_wholes)) {
    if (all(remaining_wholes < 1000)) {
      out[needs_englishifying] <- after_format(
        english_hundreds(remaining_wholes),
        and = and,
        hyphenate = hyphenate
      )
      out[negatives] <- paste0(negative, out[negatives])
      return(out)
    }
    return(english_naturals(remaining_wholes, and = and, hyphenate = hyphenate))
  }

  # This isn't required until now
  if (is.null(english_fractions)) {
    # `remaining_numbers[1]^0` provides a `1` of the correct class (e.g. a
    # <numeric> or <bignum_bigfloat>).
    english_fractions <- get_english_fractions(one = remaining_numbers[1]^0)
  }

  remaining_fractionals <- remaining_numbers - remaining_wholes
  is_whole <- remaining_fractionals == 0
  is_fractional <- remaining_wholes == 0
  is_compound <- !is_whole & !is_fractional

  out[needs_englishifying][is_whole] <- english_naturals(
    remaining_wholes[is_whole],
    and = and,
    hyphenate = hyphenate
  )
  out[needs_englishifying][is_fractional] <- english_fractionals(
    remaining_fractionals[is_fractional],
    and = and_fractional,
    hyphenate = hyphenate_fractional,
    zero = zero,
    english_fractions = english_fractions
  )

  out[needs_englishifying][is_compound] <- paste0(
    english_naturals(
      remaining_wholes[is_compound],
      and = and,
      hyphenate = hyphenate
    ),
    # "<decimal>" is later replaced with `decimal`. This is needed as we check
    # for trailing fractional zero's (resulting from insufficient precision)
    # using `sub()`, which errors if `decimal` is a regex metacharacter.
    "<decimal>",
    english_fractionals(
      remaining_fractionals[is_compound],
      and = and_fractional,
      hyphenate = hyphenate_fractional,
      zero = "<fractional zero>", # Later removed
      english_fractions = english_fractions
    )
  )
  out[needs_englishifying][is_compound] <- sub(
    # First remove any trailing fractional zeros
    x = sub(
      x = out[needs_englishifying][is_compound],
      pattern = "<decimal><fractional zero>$",
      replacement = ""
    ),
    # Then, insert the user supplied decimal. Note that `fixed = TRUE` here
    # prevents user-supplied metacharacters from breaking things.
    pattern = "<decimal>",
    replacement = decimal,
    fixed = TRUE
  )

  out[negatives] <- paste0(negative, out[negatives])
  out
}

#' @rdname numeric_friendly
#' @export
numeric_friendly_safe <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    decimal = " and ",
    and = FALSE,
    hyphenate = TRUE,
    and_fractional = and,
    hyphenate_fractional = hyphenate,
    english_fractions = NULL
) {
  numbers <- check_is_type(numbers, is.numeric, "numeric")
  zero <- check_is_string(zero)
  na <- check_is_string(na)
  nan <- check_is_string(nan)
  inf <- check_is_string(inf)
  negative <- check_is_string(negative)
  decimal <- check_is_string(decimal)
  and <- check_is_bool(and)
  hyphenate <- check_is_bool(hyphenate)
  and_fractional <- check_is_bool(and_fractional)
  hyphenate_fractional <- check_is_bool(hyphenate_fractional)
  english_fractions <- check_is_type(
    english_fractions, is.character, "a character", null_ok = TRUE
  )

  numeric_friendly(
    numbers = numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    decimal = decimal,
    and = and,
    hyphenate = hyphenate,
    and_fractional = and_fractional,
    hyphenate_fractional = hyphenate_fractional,
    english_fractions = english_fractions
  )
}
