# TODO: This is an S3 method.
# - number_friendly.integer -> integerish_friendly
# - number_friendly.numeric -> numeric_friendly
# - number_friendly.bignum_biginteger -> biginteger_friendly
# - number_friendly.bignum_bigfloat -> bigfloat_friendly

#' @export
number_friendly <- function(numbers, ...) {
  UseMethod("number_friendly")
}

#' @export
number_friendly.numeric <- function(numbers, ...) {

}

#' @export
number_friendly.integer <- function(numbers, ...) {

}

#' @export
number_friendly.bignum_biginteger <- function(numbers, ...) {

}

#' @export
number_friendly.bignum_bigfloat <- function(numbers, ...) {

}

#' @export
number_friendly.default <- function(numbers, ...) {
  stop_unimplemented_method(numbers, "number_friendly()")
}
