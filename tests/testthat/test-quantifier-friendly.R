test_that("`quantifier_friendly()` works", {
  # Basic uses
  expect_equal(
    quantifier_friendly(c(1:5, 1001)),
    c("the", "both", "all three", "all four", "all five", "all 1,001")
  )
  expect_equal(
    quantifier_friendly(-c(1:5, 1001)),
    c(
      "all negative one", "all negative two", "all negative three",
      "all negative four", "all negative five", "all negative 1,001"
    )
  )
  # Special numbers
  expect_equal(
    quantifier_friendly(c(0, NaN, NA, -Inf, Inf)),
    c("no", "an undefined", "a missing", "negative every", "every")
  )
  # Special number arguments
  expect_equal(
    quantifier_friendly(
      c(1, 2, 0, NaN, NA, -Inf, Inf),
      one = "1",
      two = "2",
      na = "NA",
      nan = "NaN",
      inf = "Inf",
      zero = "0",
      negative = "-"
    ),
    paste(c(1, 2, 0, NaN, NA, -Inf, Inf))
  )
  # Empty inputs
  expect_identical(quantifier_friendly(integer()), character())
  expect_identical(quantifier_friendly(numeric()), character())
})

test_that("`quantifier_friendly_safe()` enforces input types", {

  expect_input_error <- function(object) {
    expect_error(object, class = "friendlynumber_error_input_type")
  }

  int <- 0L
  fraction <- 0.5
  twochr <- c("a", "b")
  string <- "A"
  bool <- FALSE

  expect_input_error(quantifier_friendly_safe(bool))
  expect_input_error(quantifier_friendly_safe(fraction))
  expect_input_error(quantifier_friendly_safe(int, one = int))
  expect_input_error(quantifier_friendly_safe(int, two = int))
  expect_input_error(quantifier_friendly_safe(int, zero = twochr))
  expect_input_error(quantifier_friendly_safe(int, na = int))
  expect_input_error(quantifier_friendly_safe(int, nan = twochr))
  expect_input_error(quantifier_friendly_safe(int, inf = int))
  expect_input_error(quantifier_friendly_safe(int, negative = twochr))
  expect_input_error(quantifier_friendly_safe(int, and = NA))
  expect_input_error(quantifier_friendly_safe(int, hyphenate = int))
  expect_input_error(quantifier_friendly_safe(int, bigmark = NA))
  expect_input_error(quantifier_friendly_safe(int, max_friendly = twochr))

  expect_no_error(quantifier_friendly_safe(int))
  expect_no_error(
    quantifier_friendly_safe(
      numbers = int,
      one = string,
      two = string,
      zero = string,
      na = string,
      nan = string,
      negative = string,
      and = bool,
      hyphenate = bool,
      bigmark = bool,
      max_friendly = int
    )
  )
})
