test_that("`bigfloat_friendly()` works", {
  # Basic usage
  bigfloat <- bignum::bigfloat(c(1, 1.001, 0.001, 0.002, 10.002, 1001, 999999, 999.123))
  expect_equal(
    bigfloat_friendly(bigfloat),
    c(
      "one",
      "one and one thousandth",
      "one thousandth",
      "two thousandths",
      "ten and two thousandths",
      "one thousand one",
      "nine hundred ninety-nine thousand nine hundred ninety-nine",
      "nine hundred ninety-nine and one hundred twenty-three thousandths"
    )
  )
  expect_equal(
    bigfloat_friendly(-bigfloat),
    c(
      "negative one",
      "negative one and one thousandth",
      "negative one thousandth",
      "negative two thousandths",
      "negative ten and two thousandths",
      "negative one thousand one",
      "negative nine hundred ninety-nine thousand nine hundred ninety-nine",
      "negative nine hundred ninety-nine and one hundred twenty-three thousandths"
    )
  )
  # Special numbers
  specialbigfloat <- bignum::bigfloat(c(-Inf, Inf, 0, NA, NaN))
  expect_equal(
    bigfloat_friendly(specialbigfloat),
    c("negative infinity", "infinity", "zero", "missing", "not a number")
  )
  # Special number arguments
  expect_equal(
    bigfloat_friendly(
      specialbigfloat,
      negative = "-",
      inf = "Inf",
      zero = "0",
      na = "NA",
      nan = "NaN"
    ),
    paste(c(-Inf, Inf, 0, NA, NaN))
  )
  # Empty input
  expect_identical(bigfloat_friendly(bignum::bigfloat()), character())
})

test_that("`friendlynumber.bigfloat.digits` option works", {
  bigfloat <- bignum::bigfloat(0.123456789)

  withr::local_options(list(friendlynumber.bigfloat.digits = 9))
  expect_equal(
    bigfloat_friendly(bigfloat),
    "one hundred twenty-three million four hundred fifty-six thousand seven hundred eighty-nine billionths"
  )

  withr::local_options(list(friendlynumber.bigfloat.digits = 3))
  expect_equal(bigfloat_friendly(bigfloat), "one hundred twenty-three thousandths")
})

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
