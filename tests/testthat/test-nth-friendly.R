test_that("`nth_friendly()` works", {
  # Basic uses
  expect_equal(
    nth_friendly(c(1:29, 1001)),
    c(
      "1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th",
      "10th", "11th", "12th", "13th", "14th", "15th", "16th", "17th",
      "18th", "19th", "20th", "21st", "22nd", "23rd", "24th", "25th",
      "26th", "27th", "28th", "29th", "1,001st"
    )
  )
  expect_equal(
    nth_friendly(-c(1:29, 1001)),
    c(
      "negative 1st", "negative 2nd", "negative 3rd", "negative 4th",
      "negative 5th", "negative 6th", "negative 7th", "negative 8th",
      "negative 9th", "negative 10th", "negative 11th", "negative 12th",
      "negative 13th", "negative 14th", "negative 15th", "negative 16th",
      "negative 17th", "negative 18th", "negative 19th", "negative 20th",
      "negative 21st", "negative 22nd", "negative 23rd", "negative 24th",
      "negative 25th", "negative 26th", "negative 27th", "negative 28th",
      "negative 29th", "negative 1,001st"
    )
  )
  # Special numbers
  expect_equal(
    nth_friendly(c(0, NaN, NA, -Inf, Inf)),
    c("0th", "not a numberth", "missingth", "negative infinitieth", "infinitieth")
  )
  # Special number arguments
  expect_equal(
    nth_friendly(
      c(0, NaN, NA, -Inf, Inf),
      na = "NAth",
      nan = "NaNth",
      inf = "Infth",
      zero = "zeroth",
      negative = "-"
    ),
    c("zeroth", "NaNth", "NAth", "-Infth", "Infth")
  )
  # Empty input
  expect_identical(nth_friendly(integer()), character())
  expect_identical(nth_friendly(numeric()), character())
})

test_that("`bigmark` argument works", {
  expect_identical(nth_friendly(c(1, 1001), bigmark = TRUE), c("1st", "1,001st"))
  expect_identical(nth_friendly(c(1, 1001), bigmark = FALSE), c("1st", "1001st"))
})

test_that("`nth_friendly_safe()` enforces input types", {

  expect_input_error <- function(object) {
    expect_error(object, class = "friendlynumber_error_input_type")
  }

  int <- 0L
  fraction <- 0.5
  twochr <- c("a", "b")
  string <- "A"
  bool <- FALSE

  expect_input_error(nth_friendly_safe(bool))
  expect_input_error(nth_friendly_safe(fraction))
  expect_input_error(nth_friendly_safe(int, zero = int))
  expect_input_error(nth_friendly_safe(int, na = twochr))
  expect_input_error(nth_friendly_safe(int, nan = int))
  expect_input_error(nth_friendly_safe(int, inf = twochr))
  expect_input_error(nth_friendly_safe(int, negative = int))
  expect_input_error(nth_friendly_safe(int, bigmark = NA))

  expect_no_error(nth_friendly_safe(int))
  expect_no_error(
    nth_friendly_safe(
      numbers = int,
      zero = string,
      na = string,
      nan = string,
      negative = string,
      bigmark = bool
    )
  )
})
