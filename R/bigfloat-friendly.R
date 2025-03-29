#' Translate a bigfloat to a cardinal character vector
#'
#' @description
#'
#' Convert a `<bignum_bigfloat>` to a cardinal numeral (e.g. one tenth, one, two).
#'
#' A [bignum::bigfloat()] can store numbers with up to 50 decimal digits of
#' precision, which is useful for manipulating numbers which can't be accurately
#' represented in a `<numeric>` vector.
#'
#' `bigfloat_friendly_safe()` checks that all arguments are of the correct type
#' and raises an informative error otherwise. `bigfloat_friendly()` does not
#' perform input validation to maximize its speed.
#'
#' @inheritParams params
#'
#' @param numbers `[bignum_bigfloat]`
#'
#' A [bignum::bigfloat()] vector to translate.
#'
#' @returns
#'
#' A non-NA character vector of the same length as `numbers`.
#'
#' @examples
#' if (requireNamespace("bignum", quietly = TRUE)) {
#'   bigfloat_friendly(bignum::bigfloat(c(0.5, 0, 0.123, NA, NaN, Inf)))
#'
#'   # Specify the translations of "special" numbers
#'   bigfloat_friendly(bignum::bigfloat(NaN), nan = "NAN")
#'
#'   # Modify the output formatting
#'   big <- bignum::bigfloat(1234.5678)
#'   bigfloat_friendly(big)
#'   bigfloat_friendly(big, decimal = " point ")
#'   bigfloat_friendly(big, hyphenate_fractional = FALSE)
#'   bigfloat_friendly(big, and = TRUE, and_fractional = TRUE, decimal = " . ")
#'
#'   # The `friendlynumber.bigfloat.digits` option specifies the number of
#'   # `<bignum_bigfloat>` digits mentioned by `bigfloat_friendly()`
#'   opts <- options()
#'   options(friendlynumber.bigfloat.digits = 5)
#'   bigfloat_friendly(bignum::bigpi)
#'
#'   options(friendlynumber.bigfloat.digits = 10)
#'   bigfloat_friendly(bignum::bigpi)
#'   options(opts)
#'
#'   # Set `english_fractions` to specify the translation of certain
#'   # fractions. The names (keys) of `english_fractions` should match
#'   # the decimal part of a fraction (e.g. `"04"` matches `0.04`).
#'   bigfloat_friendly(
#'     bignum::bigfloat(c(1/2, 0.04, 1.5, 10)),
#'     english_fractions = c(`5` = "1/2", `04` = "4/100")
#'   )
#'
#'   # Input validation
#'   try(bigfloat_friendly_safe(bignum::bigpi, and = NA))
#' }
#' @export
bigfloat_friendly <- function(
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
  # It looks like `bigfloat_friendly()` "just works" for <bignum_bigfloat>, but
  # we'll need to see if edge case differences arise.
  numeric_friendly(
    numbers,
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

#' @rdname bigfloat_friendly
#' @export
bigfloat_friendly_safe <- function(
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
  numbers <- check_is_class(numbers, is_bigfloat, "bignum_bigfloat")
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

  bigfloat_friendly(
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
