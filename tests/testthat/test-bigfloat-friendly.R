# TODO: Add some regular tests for `bigfloat_friendly()`

test_that("`bigfloat_friendly_safe()` enforces input types", {
  skip_if_not_installed("bignum")

  expect_input_error <- function(object) {
    expect_error(object, class = "friendlynumber_error_input_type")
  }

  bigfloat <- bignum::bigfloat(0.5)
  int <- 1L
  twochr <- c("a", "b")
  string <- "A"
  bool <- FALSE
  chr <- c("333" = "one third")

  expect_input_error(bigfloat_friendly_safe(bool))
  expect_input_error(bigfloat_friendly_safe(bigfloat, zero = twochr))
  expect_input_error(bigfloat_friendly_safe(bigfloat, na = int))
  expect_input_error(bigfloat_friendly_safe(bigfloat, nan = twochr))
  expect_input_error(bigfloat_friendly_safe(bigfloat, inf = int))
  expect_input_error(bigfloat_friendly_safe(bigfloat, negative = twochr))
  expect_input_error(bigfloat_friendly_safe(bigfloat, negative = int))
  expect_input_error(bigfloat_friendly_safe(bigfloat, and = NA))
  expect_input_error(bigfloat_friendly_safe(bigfloat, hyphenate = int))
  expect_input_error(bigfloat_friendly_safe(bigfloat, and_fractional = NA))
  expect_input_error(bigfloat_friendly_safe(bigfloat, hyphenate_fractional = int))
  expect_input_error(bigfloat_friendly_safe(bigfloat, english_fractions = int))

  expect_no_error(bigfloat_friendly_safe(bigfloat))
  expect_no_error(
    bigfloat_friendly_safe(
      numbers = bigfloat,
      zero = string,
      na = string,
      nan = string,
      negative = string,
      decimal = string,
      and = bool,
      hyphenate = bool,
      and_fractional = bool,
      hyphenate_fractional = bool,
      english_fractions = chr
    )
  )
})
