test_that("`integerish_friendly()` works", {
  # Integer input
  integers <- c(0L, NA_integer_, 1L, 3L, -100L, 10000L, 999999L)
  expect_equal(
    integerish_friendly(integers),
    c(
      "zero", "missing", "one", "three", "negative one hundred",
      "ten thousand", "nine hundred ninety-nine thousand nine hundred ninety-nine"
    )
  )
  expect_equal(
    integerish_friendly(-integers),
    c(
      "zero", "missing", "negative one", "negative three",
      "one hundred", "negative ten thousand",
      "negative nine hundred ninety-nine thousand nine hundred ninety-nine"
    )
  )

  # Integer-ish input
  numbers <- c(10000000, -10000000, 10000000 + 1, 10000000 - 1, NaN, NA, Inf)
  expect_equal(
    integerish_friendly(numbers),
    c(
      "ten million", "negative ten million", "ten million one",
      "nine million nine hundred ninety-nine thousand nine hundred ninety-nine",
      "not a number", "missing", "infinity"
    )
  )
  expect_equal(
    integerish_friendly(-numbers),
    c(
      "negative ten million", "ten million",
      "negative ten million one",
      "negative nine million nine hundred ninety-nine thousand nine hundred ninety-nine",
      "not a number", "missing", "negative infinity"
    )
  )

  # Custom special inputs
  expect_equal(
    integerish_friendly(
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
  expect_identical(integerish_friendly(integer()), character())
  expect_identical(integerish_friendly(numeric()), character())
})

test_that("`hyphentate` argument works", {
  expect_equal(
    integerish_friendly(c(1L, 21L, 123L), hyphenate = TRUE),
    c("one", "twenty-one", "one hundred twenty-three")
  )
  expect_equal(
    integerish_friendly(c(1L, 21L, 123L), hyphenate = FALSE),
    c("one", "twenty one", "one hundred twenty three")
  )
})

test_that("`and` argument works", {
  expect_equal(
    integerish_friendly(c(1L, 1001L, 1021L), and = TRUE),
    c("one", "one thousand and one", "one thousand and twenty-one")
  )
  expect_equal(
    integerish_friendly(c(1L, 1001L, 1021L), and = FALSE),
    c("one", "one thousand one", "one thousand twenty-one")
  )
})

test_that("`integerish_friendly_safe()` enforces input types", {

  expect_input_error <- function(object) {
    expect_error(object, class = "friendlynumber_error_input_type")
  }

  int <- 1L
  fraction <- 0.5
  twochr <- c("a", "b")
  string <- "A"
  bool <- FALSE

  expect_input_error(integerish_friendly_safe(bool))
  expect_input_error(integerish_friendly_safe(fraction))
  expect_input_error(integerish_friendly_safe(int, zero = twochr))
  expect_input_error(integerish_friendly_safe(int, na = int))
  expect_input_error(integerish_friendly_safe(int, nan = twochr))
  expect_input_error(integerish_friendly_safe(int, inf = int))
  expect_input_error(integerish_friendly_safe(int, negative = twochr))
  expect_input_error(integerish_friendly_safe(int, and = NA))
  expect_input_error(integerish_friendly_safe(int, hyphenate = int))

  expect_no_error(integerish_friendly_safe(int))
  expect_no_error(
    integerish_friendly_safe(
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
