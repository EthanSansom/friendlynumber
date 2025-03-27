test_that("`biginteger_friendly()` works", {
  skip_if_not_installed("bignum")

  bigintegers <- bignum::biginteger(c(0L, NA_integer_, 1L, 3L, -100L, 10000L, 999999L))
  expect_equal(
    biginteger_friendly(bigintegers),
    c(
      "zero", "missing", "one", "three", "negative one hundred",
      "ten thousand", "nine hundred ninety-nine thousand nine hundred ninety-nine"
    )
  )
  expect_equal(
    biginteger_friendly(-bigintegers),
    c(
      "zero", "missing", "negative one", "negative three",
      "one hundred", "negative ten thousand",
      "negative nine hundred ninety-nine thousand nine hundred ninety-nine"
    )
  )

  # Empty input
  expect_identical(biginteger_friendly(bignum::biginteger()), character())
})

test_that("Huge numbers are supported", {
  # This test is too slow to run for CRAN
  skip_on_cran()
  skip_if_not_installed("bignum")

  # TODO: Add these back later, they're annoyingly slow for interactive tests
  skip("Skipping slow <bignum_biginteger> tests")

  millinillion <- bignum::biginteger(10L)^3003L
  expect_equal(biginteger_friendly(millinillion), "one millinillion")
  expect_equal(biginteger_friendly(millinillion + 1L), "one millinillion one")

  # This is way too long to include in-line, but it looks like:
  # "nine hundred ninety-nine novenonagintanongentillion...
  # nine hundred ninety-nine thousand nine hundred ninety-nine"
  # which is correct.
  expect_snapshot(biginteger_friendly(millinillion - 1L))
})

test_that("`biginteger_friendly_safe()` enforces input types", {
  skip_if_not_installed("bignum")

  expect_input_error <- function(object) {
    expect_error(object, class = "friendlynumber_error_input_type")
  }

  bigint <- bignum::biginteger(1L)
  twochr <- c("a", "b")
  int <- 1L
  string <- "A"
  bool <- FALSE

  expect_input_error(biginteger_friendly_safe(int))
  expect_input_error(biginteger_friendly_safe(bigint, zero = int))
  expect_input_error(biginteger_friendly_safe(bigint, na = twochr))
  expect_input_error(biginteger_friendly_safe(bigint, nan = int))
  expect_input_error(biginteger_friendly_safe(bigint, inf = twochr))
  expect_input_error(biginteger_friendly_safe(bigint, negative = int))
  expect_input_error(biginteger_friendly_safe(bigint, and = int))
  expect_input_error(biginteger_friendly_safe(bigint, hyphenate = NA))

  expect_no_error(biginteger_friendly_safe(bigint))
  expect_no_error(
    biginteger_friendly_safe(
      numbers = bigint,
      zero = string,
      na = string,
      nan = string,
      negative = string,
      and = bool,
      hyphenate = bool
    )
  )
})
