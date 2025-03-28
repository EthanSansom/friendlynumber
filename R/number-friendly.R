#' @export
number_friendly <- function(numbers, ...) {
  UseMethod("number_friendly")
}

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

#' @export
number_friendly.default <- function(numbers, ...) {
  stop_unimplemented_method(numbers, "number_friendly()")
}

# safe -------------------------------------------------------------------------

#' @export
number_friendly_safe <- function(numbers, ...) {
  UseMethod("number_friendly_safe")
}

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

#' @export
number_friendly_safe.default <- function(numbers, ...) {
  stop_unimplemented_method(numbers, "number_friendly_safe()")
}
