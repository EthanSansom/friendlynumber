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

# fractional -------------------------------------------------------------------

# How to format a fractional number in range (0, 1)
#' @export
format_fractional <- function(x, ...) {
  UseMethod("format_fractional")
}

#' @export
format_fractional.numeric <- function(x) {
  sub("0+$", "", sprintf("%.15f", x))
}

#' @export
format_fractional.bignum_bigfloat <- function(x) {
  sub("0+$", "", format(
    x,
    notation = "dec",
    digits = getOption("friendlynumber.bigfloat.digits")
  ))
}

#' @export
format_fractional.default <- function(x, ...) {
  stop(paste0("No `format_fractional()` method implemented for class <", class(x)[[1]], ">."))
}

# Test whether to use `format()` or `sprintf()`
if (FALSE) {
  format_1 <- function(x) {
    format(x, digits = 16, scientific = FALSE)
  }
  format_2 <- function(x) {
    # sub("0+$", "", sprintf("%.16f", x))
    sprintf("%.16f", x)
  }

  # 18 characters ("0." + 16 digits)
  format_1(1/3) |> nchar()
  format_2(1/3) |> nchar()

  # NOTE: The `digits` in `format()` seems like more of a suggestion, and reading
  # do docs it seems like that's the case. We're going to want something more
  # consistent.
  set.seed(123)
  x <- runif(1000)
  format_1(c(1/3, x)) |> nchar() |> unique() # 21 characters, unexpected
  format_2(c(1/3, x)) |> nchar() |> unique() # 18 characters, as expected

  # `sprintf()` is faster anyways
  bench::mark(
    format_1(x),
    format_2(x),
    check = FALSE
  )

}


