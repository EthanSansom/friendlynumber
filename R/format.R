# whole ------------------------------------------------------------------------

# How to format a "whole" number (e.g. <integer> or <biginteger>)
#' @export
format_whole <- function(x, ...) {
  UseMethod("format_whole")
}

#' @export
format_whole.integer <- function(x, bigmark = ",") {
  format(x, scientific = FALSE, big.mark = bigmark)
}

#' @export
format_whole.numeric <- function(x, bigmark = ",") {
  format(x, nsmall = 0, scientific = FALSE, big.mark = bigmark)
}

#' @export
format_whole.bignum_biginteger <- function(x, bigmark = ",") {
  out <- format(x, notation = "dec")
  if (bigmark != "") {
    # Use a "," initially in case `bigmark` contains a control sequence
    out <- gsub("(\\d)(?=(\\d{3})+$)", "\\1,", out, perl = TRUE)
    if (bigmark != ",") out <- gsub(",", bigmark, out, fixed = TRUE)
  }
  out
}

#' @export
format_whole.default <- function(x, ...) {
  stop(paste0("No `format_whole()` method implemented for class <", class(x)[[1]], ">."))
}

# decimal ----------------------------------------------------------------------

# How to format a "decimal" number
#' @export
format_whole <- function(x, ...) {
  UseMethod("format_whole")
}
