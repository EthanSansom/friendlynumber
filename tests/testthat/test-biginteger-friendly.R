test_that("Huge numbers are supported", {
  # This test is too slow to run for CRAN
  skip_on_cran()
  skip_if_not_installed("bignum")

  millinillion <- bignum::biginteger(10L)^3003L
  expect_equal(biginteger_friendly(millinillion), "one millinillion")
  expect_equal(biginteger_friendly(millinillion + 1L), "one millinillion one")

  # This is way too long to include in-line, but it looks like:
  # "nine hundred ninety-nine novenonagintanongentillion...
  # nine hundred ninety-nine thousand nine hundred ninety-nine"
  # which is correct.
  expect_snapshot(biginteger_friendly(millinillion - 1L))
})
