#' Translate a biginteger to a cardinal character vector
#'
#' @description
#'
#' Convert a `<bignum_biginteger>` to a cardinal numeral (e.g. one, two, three).
#'
#' A [bignum::biginteger()] can store any integer (i.e. arbitrary precision),
#' which is useful for manipulating numbers too large to be represented (accurately)
#' in an `<integer>` or `<numeric>` vector.
#'
#' `biginteger_friendly_safe()` checks that all arguments are of the correct type
#' and raises an informative error otherwise. `biginteger_friendly()` does not
#' perform input validation to maximize its speed.
#'
#' @inheritParams params
#'
#' @param numbers `[bignum_biginteger]`
#'
#' A [bignum::biginteger()] vector to translate.
#'
#' @return
#'
#' A non-NA character vector of the same length as `numbers`.
#'
#' @examplesIf requireNamespace("bignum", quietly = TRUE)
#' biginteger_friendly(bignum::biginteger(c(0, 1, 2, NA, 10001)))
#'
#' # Specify the translations of "special" numbers
#' biginteger_friendly(bignum::biginteger(-10), negative = "minus ")
#' biginteger_friendly(bignum::biginteger(NA), na = "unknown")
#'
#' # Modify the output formatting
#' biginteger_friendly(bignum::biginteger(9999))
#' biginteger_friendly(bignum::biginteger(9999), and = TRUE)
#' biginteger_friendly(bignum::biginteger(9999), hyphenate = FALSE)
#'
#' # Translate large numbers
#' large <- bignum::biginteger(10L)^1001L
#' biginteger_friendly(large)
#'
#' # Input validation
#' try(biginteger_friendly_safe(1L))
#' @export
biginteger_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number", # Vestigial, since <bignum_biginteger> is never NaN
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
) {
  # It looks like `integerish_friendly()` "just works" for <bignum_biginteger>,
  # but we'll have to see if there are any edge cases that require differentiation
  integerish_friendly(
    numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    and = and,
    hyphenate = hyphenate
  )
}

#' @rdname biginteger_friendly
#' @export
biginteger_friendly_safe <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
) {
  # Some paths of `integerish_friendly()` don't evaluate every one of these
  # arguments, so we need to force the checks here.
  numbers <- check_is_class(numbers, is_biginteger, "bignum_biginteger")
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
