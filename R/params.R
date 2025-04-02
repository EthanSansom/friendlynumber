# From {chk} package: https://github.com/poissonconsulting/chk/blob/main/R/params.R

#' Parameter Descriptions for friendlynumber Package
#'
#' Default parameter descriptions which may be overridden in individual
#' functions.
#'
#' @param numbers `[integer / numeric]`
#'
#' An integer or integer-ish numeric vector to translate.
#'
#' @param one `[character(1)]`
#'
#' What to call values of `1` in `numbers` (e.g. `one = "the"`).
#'
#' @param two `[character(1)]`
#'
#' What to call values of `2` in `numbers` (e.g. `two = "both"`).
#'
#' @param three `[character(1)]`
#'
#' What to call values of `3` in `numbers` (e.g. `three = "thrice"`).
#'
#' @param zero `[character(1)]`
#'
#' What to call values of `0` in `numbers` (e.g. `zero = "zero"`).
#'
#' @param na `[character(1)]`
#'
#' What to call values of `NA` in `numbers` (e.g. `na = "missing"`).
#'
#' @param nan `[character(1)]`
#'
#' What to call values of `NaN` in `numbers` (e.g. `nan = "undefined"`).
#'
#' @param inf `[character(1)]`
#'
#' What to call values of `Inf` in `numbers` (e.g. `inf = "infinity"`).
#'
#' @param negative `[character(1)]`
#'
#' A prefix added to the translation of negative elements of `numbers`.
#' `negative` is the string `"negative "` by default.
#'
#' @param decimal `[character(1)]`
#'
#' A word inserted between the whole and fractional part of translated
#' `numbers`. `decimal` is the string `" and "` by default.
#'
#' @param and `[TRUE / FALSE]`
#'
#' Whether to insert an `" and "` before the tens place of translated `numbers`.
#' `and` is `FALSE` by default.
#'
#' @param hyphenate `[TRUE / FALSE]`
#'
#' Whether to hyphenate numbers 21 through 99 (e.g. `"twenty-one"` vs. `"twenty one"`).
#' `hyphenate` is `TRUE` by default.
#'
#' @param and_fractional `[TRUE / FALSE]`
#'
#' Whether to insert an `" and "` before the smallest fractional tens place
#' of translated `numbers` (e.g. `"one hundred one thousandths"` vs.
#' `"one hundred and one thousandths"`).
#'
#' `and_fractional` is equal to `and` by default.
#'
#' @param hyphenate_fractional `[TRUE / FALSE]`
#'
#' Whether to hyphenate numbers 21 through 99 in the fractional part of translated
#' `numbers` (e.g. `"twenty-one hundredths"` or `"twenty one hundredths"`). This
#' also determines the hyphenation of the fractional units (e.g. `"one ten-millionth"`
#' vs. `"one ten millionth"`).
#'
#' `hyphenate_fractional` is equal to `hyphenate` by default.
#'
#' @param bigmark `[TRUE / FALSE]`
#'
#' Whether the thousands places of formatted numbers should be separated with
#' a comma (e.g. `"10,000,000"` vs. `"10000000"`). `bigmark` is `TRUE` by
#' default.
#'
#' @param english_fractions `[character]`
#'
#' A named character vector used as a dictionary for the translation of the
#' fractional part of `numbers`. The names (i.e. keys) are the decimal digits
#' of a fractional number and the values are the corresponding translations.
#'
#' For example `english_fractions = c("5" = "a half")` matches the number
#' `0.5` (translated as `"a half"`) and `2.5` (translated as `"two and a half"`).
#'
#' By default `english_fractions` is a named character vector with translations
#' for fractions `x / y` for `x = 1, 2, ..., 8` and `y = 1, 2, ..., 9`. For
#' example, `2 / 3` is translated as `"two thirds"` and `1 / 2` is translated
#' as `"one half"`.
#'
#' Provide an empty character to `english_fractions` to opt out of any such
#' translations. In this case `1 / 2` is translated as `"five tenths"` instead
#' of `"one half"`.
#'
#' @return
#'
#' The value `NULL`.
#'
#' @keywords internal
#' @aliases parameters arguments args
#' @usage NULL
# nocov start
params <- function(...) NULL
# nocov end
