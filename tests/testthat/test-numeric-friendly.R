# basics -----------------------------------------------------------------------

test_that("`numeric_friendly()` works", {
  # Basic usage
  expect_equal(
    numeric_friendly(c(1, 1.001, 0.001, 0.002, 10.002, 1001, 999999, 999.123)),
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
    numeric_friendly(-c(1, 1.001, 0.001, 0.002, 10.002, 1001, 999999, 999.123)),
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
  expect_equal(
    numeric_friendly(c(-Inf, Inf, 0, NA, NaN)),
    c("negative infinity", "infinity", "zero", "missing", "not a number")
  )
  # Special number arguments
  expect_equal(
    numeric_friendly(
      c(-Inf, Inf, 0, NA, NaN),
      negative = "-",
      inf = "Inf",
      zero = "0",
      na = "NA",
      nan = "NaN"
    ),
    paste(c(-Inf, Inf, 0, NA, NaN))
  )
  # Empty input
  expect_identical(numeric_friendly(numeric()), character())
})

test_that("`friendlynumber.numeric.digits` option works", {
  number <- 0.123456789

  withr::local_options(list(friendlynumber.numeric.digits = 9))
  expect_equal(
    numeric_friendly(number),
    "one hundred twenty-three million four hundred fifty-six thousand seven hundred eighty-nine billionths"
  )

  withr::local_options(list(friendlynumber.numeric.digits = 3))
  expect_equal(numeric_friendly(number), "one hundred twenty-three thousandths")
})

# fractions --------------------------------------------------------------------

test_that("Nice fractions (e.g. 'one half') work", {
  # Default digits
  fractionals <- c(1/4, 3/4, 1/2, 1/3, 2/3)
  expect_equal(
    numeric_friendly(fractionals),
    c("one quarter", "three quarters", "one half", "one third", "two thirds")
  )
  expect_equal(
    numeric_friendly(-fractionals),
    c(
      "negative one quarter", "negative three quarters", "negative one half",
      "negative one third", "negative two thirds"
    )
  )
  expect_equal(
    numeric_friendly(fractionals + 1),
    c("one and one quarter", "one and three quarters", "one and one half", "one and one third", "one and two thirds")
  )
  # Non-default digits
  withr::local_options(list(friendlynumber.numeric.digits = 3))
  expect_equal(
    numeric_friendly(fractionals),
    c("one quarter", "three quarters", "one half", "one third", "two thirds")
  )
  expect_equal(
    numeric_friendly(fractionals + 1),
    c("one and one quarter", "one and three quarters", "one and one half", "one and one third", "one and two thirds")
  )
})

test_that("`english_fractions` argument works", {

  # No fractions
  expect_equal(
    numeric_friendly(c(1/2, 3/4, 1/8), english_fractions = character()),
    c("five tenths", "seventy-five hundredths", "one hundred twenty-five thousandths")
  )
  expect_equal(
    numeric_friendly(1 + c(1/2, 3/4, 1/8), english_fractions = character()),
    c("one and five tenths", "one and seventy-five hundredths", "one and one hundred twenty-five thousandths")
  )

  # User supplied fractions
  expect_equal(
    numeric_friendly(c(1/2, 3/4, 1/8), english_fractions = c(`5` = "1/2", `75` = "3/4", `125` = "1/8")),
    c("1/2", "3/4", "1/8")
  )
  expect_equal(
    numeric_friendly(1 + c(1/2, 3/4, 1/8), english_fractions = c(`5` = "1/2", `75` = "3/4", `125` = "1/8")),
    c("one and 1/2", "one and 3/4", "one and 1/8")
  )

  withr::local_options(list(friendlynumber.numeric.digits = 3))
  expect_equal(
    numeric_friendly(c(1/2, 1/3, 1/6), english_fractions = c(`5` = "1/2", `333` = "1/3", `167` = "1/6")),
    c("1/2", "1/3", "1/6")
  )
  expect_equal(
    numeric_friendly(1 + c(1/2, 1/3, 1/6), english_fractions = c(`5` = "1/2", `333` = "1/3", `167` = "1/6")),
    c("one and 1/2", "one and 1/3", "one and 1/6")
  )
})

# arguments --------------------------------------------------------------------

test_that("`hyphentate` and `hyphenate_fractional` arguments work", {
  # `hyphenate`
  expect_equal(
    numeric_friendly(c(1, 21, 123), hyphenate = TRUE),
    c("one", "twenty-one", "one hundred twenty-three")
  )
  expect_equal(
    numeric_friendly(c(1, 21, 123), hyphenate = FALSE),
    c("one", "twenty one", "one hundred twenty three")
  )
  # `hyphenate_fractional`
  expect_equal(
    numeric_friendly(c(0.1, 0.21, 0.0123), hyphenate_fractional = TRUE),
    c("one tenth", "twenty-one hundredths", "one hundred twenty-three ten-thousandths")
  )
  expect_equal(
    numeric_friendly(c(0.1, 0.21, 0.0123), hyphenate_fractional = FALSE),
    c("one tenth", "twenty one hundredths", "one hundred twenty three ten thousandths")
  )
  # both
  expect_equal(
    numeric_friendly(c(123.0123), hyphenate = FALSE, hyphenate_fractional = TRUE),
    "one hundred twenty three and one hundred twenty-three ten-thousandths"
  )
  expect_equal(
    numeric_friendly(c(123.0123), hyphenate = TRUE, hyphenate_fractional = FALSE),
    "one hundred twenty-three and one hundred twenty three ten thousandths"
  )
})

test_that("`and` and `and_fractional` arguments work", {
  # `and` (`and_fractional = and` by default)
  expect_equal(
    numeric_friendly(c(1, 1001, 1021, 1.1, 1021.1, 1021.1021), and = TRUE, decimal = " point "),
    c(
      "one",
      "one thousand and one",
      "one thousand and twenty-one",
      "one point one tenth",
      "one thousand and twenty-one point one tenth",
      "one thousand and twenty-one point one thousand and twenty-one ten-thousandths"
    )
  )
  expect_equal(
    numeric_friendly(c(1, 1001, 1021, 1.1, 1021.1, 1021.1021), and = FALSE, decimal = " point "),
    c(
      "one",
      "one thousand one",
      "one thousand twenty-one",
      "one point one tenth",
      "one thousand twenty-one point one tenth",
      "one thousand twenty-one point one thousand twenty-one ten-thousandths"
    )
  )
  expect_equal(
    numeric_friendly(1021.1021, and = TRUE, and_fractional = FALSE, decimal = " point "),
    "one thousand and twenty-one point one thousand twenty-one ten-thousandths"
  )
})

test_that("`decimal` argument works", {
  expect_equal(numeric_friendly(1, decimal = "-"), "one")
  expect_equal(numeric_friendly(0.1, decimal = "-"), "one tenth")
  expect_equal(numeric_friendly(1.1, decimal = "-"), "one-one tenth")
})

test_that("Regex metacharacters in `decimal` are handled correctly", {
  expect_equal(numeric_friendly(1.1, decimal = "\\1"), "one\\1one tenth")
  expect_equal(numeric_friendly(1, decimal = "\\1"), "one")
  expect_equal(numeric_friendly(1.1, decimal = "$"), "one$one tenth")
})

# safe -------------------------------------------------------------------------

test_that("`numeric_friendly_safe()` enforces input types", {

  expect_input_error <- function(object) {
    expect_error(object, class = "friendlynumber_error_input_type")
  }

  int <- 1L
  fraction <- 0.5
  twochr <- c("a", "b")
  string <- "A"
  bool <- FALSE
  chr <- c("333" = "one third")

  expect_input_error(numeric_friendly_safe(bool))
  expect_input_error(numeric_friendly_safe(fraction, zero = twochr))
  expect_input_error(numeric_friendly_safe(fraction, na = int))
  expect_input_error(numeric_friendly_safe(fraction, nan = twochr))
  expect_input_error(numeric_friendly_safe(fraction, inf = int))
  expect_input_error(numeric_friendly_safe(fraction, negative = twochr))
  expect_input_error(numeric_friendly_safe(fraction, negative = int))
  expect_input_error(numeric_friendly_safe(fraction, and = NA))
  expect_input_error(numeric_friendly_safe(fraction, hyphenate = int))
  expect_input_error(numeric_friendly_safe(fraction, and_fractional = NA))
  expect_input_error(numeric_friendly_safe(fraction, hyphenate_fractional = int))
  expect_input_error(numeric_friendly_safe(fraction, english_fractions = int))

  expect_no_error(numeric_friendly_safe(fraction))
  expect_no_error(
    numeric_friendly_safe(
      numbers = fraction,
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
