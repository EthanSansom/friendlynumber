# number -----------------------------------------------------------------------

# How to format a number (e.g. `bignum::bigpi`, 10.01, 1L)
#' @export
format_number <- function(x, ...) {
  UseMethod("format_number")
}

#' @export
format_number.integer <- function(x, bigmark = ",", ...) {
  format_whole(x, bigmark = bigmark)
}

#' @export
format_number.bignum_biginteger <- function(x, bigmark = ",", ...) {
  format_whole(x, bigmark = bigmark)
}

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

#' @export
format_number.default <- function(x, ...) {
  stop_unimplemented_method(x, "format_number()")
}

# whole ------------------------------------------------------------------------
# - `.numeric()` and `.bignum_bigfloat()` are only valid if `x` is integerish

# TODO: Do I need to do anything special for an un-exported S3 method?

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
