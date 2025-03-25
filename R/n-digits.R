# TODO: I don't think we need this anymore

# whole digits -----------------------------------------------------------------

n_whole_digits <- function(numbers, ...) {
  UseMethod("n_whole_digits")
}

# Thanks Gregor Thomas
# https://stackoverflow.com/questions/47190693/count-the-number-of-integer-digits
n_whole_digits.integer <- function(numbers) {
  out <- floor(log10(abs(numbers))) + 1
  replace(out, is.infinite(out), 1)
}

n_whole_digits.bignum_biginteger <- function(numbers) {
  out <- floor(log10(abs(numbers))) + 1
  replace(out, is.infinite(out), 1)
}

n_whole_digits.numeric <- function(numbers) {
  out <- floor(log10(abs(numbers))) + 1
  replace(out, is.infinite(out), 1)
}

n_whole_digits.bignum_bigfloat <- function(numbers) {
  out <- floor(log10(abs(numbers))) + 1
  replace(out, is.infinite(out), 1)
}

n_whole_digits.default <- function(numbers) {

}

# fractional digits ------------------------------------------------------------

n_fractional_digits <- function(numbers, ...) {
  UseMethod("n_fractional_digits")
}

n_fractional_digits.integer <- function(numbers) {
  rep_len(0, length(numbers))
}

n_fractional_digits.bignum_biginteger <- function(numbers) {
  rep_len(0, length(numbers))
}

# TODO: These are just dependent on the number of digits that results from
#       calling format_fractional().
n_fractional_digits.numeric <- function(numbers) {
  # format_fractional(numbers)
}

n_fractional_digits.bignum_bigfloat <- function(numbers) {

}

n_fractional_digits.default <- function(numbers) {

}
