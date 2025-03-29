#' Format a vector of numbers
#'
#' @description
#'
#' Format a vector of numbers using `format()`.
#'
#' @details
#'
#' The number of decimal digits shown in the output of `format_number()` is
#' controlled the `friendlynumber.numeric.digits` option for numeric vectors
#' and `friendlynumber.bigfloat.digits` for [bignum::bigfloat()] vectors.
#'
#' These options also control the number of decimal digits translated by
#' [numeric_friendly()] and [bigfloat_friendly()] respectively. Because of
#' this, `format_number()` is useful for verifying that the output of these
#' `*_friendly()` functions is correct.
#'
#' @param x
#'
#' A vector of numbers to format. The {friendlynumber} package defines
#' methods for integer, numeric, [bignum::biginteger()], and
#' [bignum::bigfloat()] numbers.
#'
#' @param bigmark `[TRUE / FALSE]`
#'
#' Whether the thousands places of formatted numbers should be separated with
#' a comma (e.g. `"10,000,000"` vs. `"10000000"`). `bigmark` is `TRUE` by
#' default.
#'
#' @param ...
#'
#' Additional arguments passed to or from other methods.
#'
#' @returns
#'
#' A non-NA character vector of the same length as `x`.
#'
#' @examples
#' format_number(c(1/3, 0, 0.999, NA, NaN, Inf, -Inf))
#' format_number(c(1L, 2L, 1001L))
#' format_number(1001L, bigmark = FALSE)
#'
#' # Set `friendlynumber.numeric.digits` to control the decimal output
#' opts <- options()
#' options(friendlynumber.numeric.digits = 2)
#' format_number(1234.1234)
#' options(opts)
#'
#' if (requireNamespace("bignum", quietly = TRUE)) {
#'   format_number(bignum::bigfloat(1234.1234))
#'   format_number(bignum::biginteger(2000000))
#'
#'   # Set `friendlynumber.bigfloat.digits` to control the decimal output
#'   opts <- options()
#'   options(friendlynumber.bigfloat.digits = 3)
#'   format_number(bignum::bigfloat(1234.1234))
#'   options(opts)
#' }
#' @export
format_number <- function(x, ...) {
  UseMethod("format_number")
}

#' @rdname format_number
#' @export
format_number.integer <- function(x, bigmark = ",", ...) {
  format_whole(x, bigmark = bigmark)
}

#' @rdname format_number
#' @export
format_number.bignum_biginteger <- function(x, bigmark = ",", ...) {
  format_whole(x, bigmark = bigmark)
}

#' @rdname format_number
#' @export
format_number.numeric <- function(x, bigmark = ",", ...) {
  negative <- !is.na(x) & x < 0
  x <- abs(x)
  x_trunc <- trunc(x)

  # Format the whole part and the fractional part separately
  whole <- format_whole(x_trunc, bigmark = bigmark)
  fractional <- paste0(".", format_fractional(x - x_trunc))

  # Removes fractional part if fractional component is NA or 0
  fractional[nchar(fractional) == 1 | fractional == ".N"] <- ""

  out <- trimws(paste0(whole, fractional))
  out[negative] <- paste0("-", out[negative])
  out
}

#' @rdname format_number
#' @export
format_number.bignum_bigfloat <- function(x, bigmark = ",", ...) {
  negative <- !is.na(x) & x < 0
  x <- abs(x)
  x_trunc <- trunc(x)

  whole <- format_whole(x_trunc, bigmark = bigmark)
  fractional <- paste0(".", format_fractional(x - x_trunc))

  # Removes fractional part if fractional component is NA, NaN, Inf, -Inf, or 0
  fractional[nchar(fractional) == 1 | fractional %in% c(".NA", ".N")] <- ""

  out <- paste0(whole, fractional)
  out[negative] <- paste0("-", out[negative])
  out
}

#' @rdname format_number
#' @export
format_number.default <- function(x, ...) {
  stop_unimplemented_method(x, "format_number()")
}

# whole ------------------------------------------------------------------------
# - `.numeric()` and `.bignum_bigfloat()` are only valid if `x` is integerish

# How to format a "whole" number (e.g. <integer>, <biginteger>, 1.0)
format_whole <- function(x, ...) {
  UseMethod("format_whole")
}

format_whole.integer <- function(x, bigmark = ",", ...) {
  out <- sprintf("%i", x)
  out <- gsub("(\\d)(?=(\\d{3})+$)", "\\1,", out, perl = TRUE)
  if (bigmark != ",") out <- gsub(",", bigmark, out, fixed = TRUE)
  out
}

format_whole.numeric <- function(x, bigmark = ",", ...) {
  # Using `format()` here since `sprintf("%i", ...)` can't handle numbers
  # outside of the maximum integer
  format(x, scientific = FALSE, big.mark = bigmark, trim = TRUE)
}

format_whole.bignum_bigfloat <- function(x, bigmark = ",", ...) {
  out <- format(x, notation = "dec")
  if (bigmark != "") {
    # Use a "," initially in case `bigmark` contains a control sequence
    out <- gsub("(\\d)(?=(\\d{3})+$)", "\\1,", out, perl = TRUE)
    if (bigmark != ",") out <- gsub(",", bigmark, out, fixed = TRUE)
  }
  out
}

format_whole.bignum_biginteger <- function(x, bigmark = ",", ...) {
  out <- format(x, notation = "dec")
  if (bigmark != "") {
    out <- gsub("(\\d)(?=(\\d{3})+$)", "\\1,", out, perl = TRUE)
    if (bigmark != ",") out <- gsub(",", bigmark, out, fixed = TRUE)
  }
  out[is.na(out)] <- "NA" # `format.bignum_biginteger(NA)` is `NA`, not "NA"
  out
}

format_whole.default <- function(x, ...) {
  stop_unimplemented_method(x, "format_whole()")
}

# fractional -------------------------------------------------------------------

# How to format a fractional number between 0 and 1 (e.g. `0.34567`)
format_fractional <- function(x, ...) {
  UseMethod("format_fractional")
}

format_fractional.numeric <- function(x, ...) {
  fmt <- paste0("%.", getOption("friendlynumber.numeric.digits", 7), "f")
  out <- sub("0+$", "", sprintf(fmt, x))
  # Remove the leading "0.", we only want the decimal components
  substr(out, 3, nchar(out))
}

format_fractional.bignum_bigfloat <- function(x, ...) {
  out <- sub("0+$", "", format(
    x,
    notation = "dec",
    digits = getOption("friendlynumber.bigfloat.digits", 7)
  ))
  substr(out, 3, nchar(out))
}

format_fractional.default <- function(x, ...) {
  stop_unimplemented_method(x, "format_fractional()")
}
