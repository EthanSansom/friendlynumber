test_that("`ordinal_friendly()` works", {
  # Basic usage
  expect_equal(
    ordinal_friendly(c(1:20, 100 + 0:20)),
    c(
      "first", "second", "third", "fourth", "fifth", "sixth", "seventh",
      "eighth", "ninth", "tenth", "eleventh", "twelfth", "thirteenth",
      "fourteenth", "fifteenth", "sixteenth", "seventeenth", "eighteenth",
      "nineteenth", "twentieth", "one hundredth", "one hundred first",
      "one hundred second", "one hundred third", "one hundred fourth",
      "one hundred fifth", "one hundred sixth", "one hundred seventh",
      "one hundred eighth", "one hundred ninth", "one hundred tenth",
      "one hundred eleventh", "one hundred twelfth", "one hundred thirteenth",
      "one hundred fourteenth", "one hundred fifteenth", "one hundred sixteenth",
      "one hundred seventeenth", "one hundred eighteenth", "one hundred nineteenth",
      "one hundred twentieth"
    )
  )
  expect_equal(
    ordinal_friendly(-c(1:20, 100 + 0:20)),
    c(
      "negative first", "negative second", "negative third", "negative fourth",
      "negative fifth", "negative sixth", "negative seventh", "negative eighth",
      "negative ninth", "negative tenth", "negative eleventh", "negative twelfth",
      "negative thirteenth", "negative fourteenth", "negative fifteenth",
      "negative sixteenth", "negative seventeenth", "negative eighteenth",
      "negative nineteenth", "negative twentieth", "negative one hundredth",
      "negative one hundred first", "negative one hundred second",
      "negative one hundred third", "negative one hundred fourth",
      "negative one hundred fifth", "negative one hundred sixth",
      "negative one hundred seventh",
      "negative one hundred eighth", "negative one hundred ninth",
      "negative one hundred tenth", "negative one hundred eleventh",
      "negative one hundred twelfth", "negative one hundred thirteenth",
      "negative one hundred fourteenth", "negative one hundred fifteenth",
      "negative one hundred sixteenth", "negative one hundred seventeenth",
      "negative one hundred eighteenth", "negative one hundred nineteenth",
      "negative one hundred twentieth"
    )
  )
  # Special numbers
  expect_equal(
    ordinal_friendly(c(0, NaN, NA, -Inf, Inf, 10)),
    c("zeroth", "not a numberth", "missingth", "negative infinitieth", "infinitieth", "tenth")
  )
  # Special number arguments
  expect_equal(
    ordinal_friendly(
      c(0, NaN, NA, -Inf, Inf),
      na = "NAth",
      nan = "NaNth",
      inf = "Infth",
      zero = "0th",
      negative = "-"
    ),
    c("0th", "NaNth", "NAth", "-Infth", "Infth")
  )
  # Empty inputs
  expect_identical(ordinal_friendly(integer()), character())
  expect_identical(ordinal_friendly(numeric()), character())
})

test_that("`ordinal_friendly_safe()` enforces input types", {

  expect_input_error <- function(object) {
    expect_error(object, class = "friendlynumber_error_input_type")
  }

  int <- 0L
  fraction <- 0.5
  twochr <- c("a", "b")
  string <- "A"
  bool <- FALSE

  expect_input_error(ordinal_friendly_safe(bool))
  expect_input_error(ordinal_friendly_safe(fraction))
  expect_input_error(ordinal_friendly_safe(int, zero = twochr))
  expect_input_error(ordinal_friendly_safe(int, na = int))
  expect_input_error(ordinal_friendly_safe(int, nan = twochr))
  expect_input_error(ordinal_friendly_safe(int, inf = int))
  expect_input_error(ordinal_friendly_safe(int, negative = twochr))
  expect_input_error(ordinal_friendly_safe(int, and = int))
  expect_input_error(ordinal_friendly_safe(int, hyphenate = NA))

  expect_no_error(ordinal_friendly_safe(int))
  expect_no_error(
    ordinal_friendly_safe(
      numbers = int,
      zero = string,
      na = string,
      nan = string,
      negative = string,
      and = bool,
      hyphenate = bool
    )
  )
})
