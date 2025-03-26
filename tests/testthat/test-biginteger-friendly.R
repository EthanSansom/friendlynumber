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

  # millinillion <- bignum::biginteger(10L)^3003L
  # expect_equal(biginteger_friendly(millinillion), "one millinillion")
  # expect_equal(biginteger_friendly(millinillion + 1L), "one millinillion one")

  # This is way too long to include in-line, but it looks like:
  # "nine hundred ninety-nine novenonagintanongentillion...
  # nine hundred ninety-nine thousand nine hundred ninety-nine"
  # which is correct.

  # expect_snapshot(biginteger_friendly(millinillion - 1L))
})
