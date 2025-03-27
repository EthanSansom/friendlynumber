# TODO: Go through and quickly make sure the other arguments work, like `and` and `hyphenate`
test_that("`ntimes_friendly()` works", {
  # Basic uses
  expect_equal(
    ntimes_friendly(c(1:5, 1001)),
    c("once", "twice", "three times", "four times", "five times", "one thousand one times")
  )
  expect_equal(
    ntimes_friendly(-c(1:5, 1001)),
    c(
      "negative once", "negative twice", "negative three times",
      "negative four times", "negative five times", "negative one thousand one times"
    )
  )
  # Special numbers
  expect_equal(
    ntimes_friendly(c(0, NaN, NA, -Inf, Inf)),
    c(
      "no times", "an undefined number of times", "an unknown number of times",
      "negative infinite times", "infinite times"
    )
  )
  # Special number arguments
  expect_equal(
    ntimes_friendly(
      c(1, 2, 3, 0, NaN, NA, -Inf, Inf),
      one = "1",
      two = "2",
      three = "3",
      na = "NA",
      nan = "NaN",
      inf = "Inf",
      zero = "0",
      negative = "-"
    ),
    paste(c(1, 2, 3, 0, NaN, NA, -Inf, Inf))
  )
  # Empty input
  expect_identical(ntimes_friendly(integer()), character())
  expect_identical(ntimes_friendly(numeric()), character())
})

test_that("`ntimes_friendly_safe()` enforces input types", {

  expect_input_error <- function(object) {
    expect_error(object, class = "friendlynumber_error_input_type")
  }

  int <- 1L
  fraction <- 0.5
  twochr <- c("a", "b")
  string <- "A"
  bool <- FALSE

  expect_input_error(ntimes_friendly_safe(bool))
  expect_input_error(ntimes_friendly_safe(fraction))
  expect_input_error(ntimes_friendly_safe(int, one = int))
  expect_input_error(ntimes_friendly_safe(int, one = twochr))
  expect_input_error(ntimes_friendly_safe(int, two = int))
  expect_input_error(ntimes_friendly_safe(int, two = twochr))
  expect_input_error(ntimes_friendly_safe(int, three = int))
  expect_input_error(ntimes_friendly_safe(int, three = twochr))
  expect_input_error(ntimes_friendly_safe(int, zero = int))
  expect_input_error(ntimes_friendly_safe(int, zero = twochr))
  expect_input_error(ntimes_friendly_safe(int, na = int))
  expect_input_error(ntimes_friendly_safe(int, na = twochr))
  expect_input_error(ntimes_friendly_safe(int, nan = int))
  expect_input_error(ntimes_friendly_safe(int, nan = twochr))
  expect_input_error(ntimes_friendly_safe(int, inf = int))
  expect_input_error(ntimes_friendly_safe(int, inf = twochr))
  expect_input_error(ntimes_friendly_safe(int, negative = int))
  expect_input_error(ntimes_friendly_safe(int, negative = twochr))
  expect_input_error(ntimes_friendly_safe(int, and = int))
  expect_input_error(ntimes_friendly_safe(int, and = NA))
  expect_input_error(ntimes_friendly_safe(int, hyphenate = int))
  expect_input_error(ntimes_friendly_safe(int, hyphenate = NA))

  expect_no_error(ntimes_friendly_safe(int))
  expect_no_error(
    ntimes_friendly_safe(
      numbers = int,
      one = string,
      two = string,
      three = string,
      zero = string,
      na = string,
      nan = string,
      negative = string,
      and = bool,
      hyphenate = bool
    )
  )
})
