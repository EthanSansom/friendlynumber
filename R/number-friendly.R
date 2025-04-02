#' Translate a vector of numbers to a cardinal character vector
#'
#' @description
#'
#' Convert a vector of numbers to a cardinal numeral (e.g. one tenth, one, two).
#'
#' `number_friendly_safe()` checks that all arguments are of the correct type
#' and raises an informative error otherwise. `number_friendly()` does not
#' perform input validation to maximize its speed.
#'
#' @param numbers
#'
#' A vector of numbers to translate. The friendlynumber package defines
#' methods for integer, numeric, [bignum::biginteger()], and
#' [bignum::bigfloat()] numbers.
#'
#' * Integers are passed to [integerish_friendly()]
#' * Numeric vectors are passed to [numeric_friendly()]
#' * [bignum::biginteger()] vectors are passed to [biginteger_friendly()]
#' * [bignum::bigfloat()] vectors are passed to [bigfloat_friendly()]
#'
#' @param ...
#'
#' Additional arguments passed to or from other methods.
#'
#' @return
#'
#' A non-NA character vector of the same length as `numbers`.
#'
#' @seealso [integerish_friendly()], [numeric_friendly()],
#' [biginteger_friendly()], [bigfloat_friendly()]
#'
#' @examples
#' number_friendly(c(1/3, 0, 0.999, NA, NaN, Inf, -Inf))
#' number_friendly(c(1L, 2L, 1001L))
#'
#' # Input validation
#' try(number_friendly_safe(1L, zero = c("a", "zero")))
#' @export
number_friendly <- function(numbers, ...) {
  UseMethod("number_friendly")
}

#' @rdname number_friendly
#' @inheritParams params
#' @export
number_friendly.numeric <- function(
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
    english_fractions = NULL,
    ...
  ) {
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

#' @rdname number_friendly
#' @inheritParams params
#' @export
number_friendly.integer <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE,
    ...
  ) {
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

#' @rdname number_friendly
#' @inheritParams params
#' @export
number_friendly.bignum_biginteger <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE,
    ...
  ) {
  biginteger_friendly(
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

#' @rdname number_friendly
#' @inheritParams params
#' @export
number_friendly.bignum_bigfloat <- function(
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
    english_fractions = NULL,
    ...
  ) {
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

#' @rdname number_friendly
#' @export
number_friendly.default <- function(numbers, ...) {
  stop_unimplemented_method(numbers, "number_friendly()")
}

# safe -------------------------------------------------------------------------

#' @rdname number_friendly
#' @export
number_friendly_safe <- function(numbers, ...) {
  UseMethod("number_friendly_safe")
}

#' @rdname number_friendly
#' @export
number_friendly_safe.numeric <- function(
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
    english_fractions = NULL,
    ...
) {
  numeric_friendly_safe(
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

#' @rdname number_friendly
#' @export
number_friendly_safe.integer <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE,
    ...
) {
  integerish_friendly_safe(
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

#' @rdname number_friendly
#' @export
number_friendly_safe.bignum_biginteger <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE,
    ...
) {
  biginteger_friendly(
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

#' @rdname number_friendly
#' @export
number_friendly_safe.bignum_bigfloat <- function(
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
    english_fractions = NULL,
    ...
) {
  bigfloat_friendly_safe(
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

#' @rdname number_friendly
#' @export
number_friendly_safe.default <- function(numbers, ...) {
  stop_unimplemented_method(numbers, "number_friendly_safe()")
}
