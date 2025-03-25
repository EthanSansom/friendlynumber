test_that("`numeric_friendly.numeric() works", {
  expect_equal(
    numeric_friendly(c(-Inf, Inf, 0, NA, NaN)),
    c("negative infinity", "infinity", "zero", "missing", "not a number")
  )

  # TODO: Test negatives, and just put all of these in one `expect_equal()`
  expect_equal(numeric_friendly(1), "one")
  expect_equal(numeric_friendly(1.001), "one and one thousandth")
  expect_equal(numeric_friendly(0.001), "one thousandth")
  expect_equal(numeric_friendly(0.002), "two thousandths")
  expect_equal(numeric_friendly(10.002), "ten and two thousandths")
  expect_equal(numeric_friendly(1001), "one thousand one")
  expect_equal(numeric_friendly(999999), "nine hundred ninety-nine thousand nine hundred ninety-nine")
  expect_equal(numeric_friendly(999.123), "nine hundred ninety-nine and one hundred twenty-three thousandths")
})

test_that("Nice fractions (e.g. 'one half') work", {
  fractionals <- c(1/4, 3/4, 1/2, 1/3, 2/3)
  expect_equal(
    numeric_friendly(fractionals),
    c(
      "one quarter",
      "three quarters",
      "one half",
      "one third",
      "two thirds"
    )
  )
})

test_that("`and` and `and_fractional` arguments work", {
  # `and` (`and_fractional = and` by default)
  expect_equal(
    numeric_friendly(c(1, 1001, 1021), and = TRUE),
    c("one", "one thousand and one", "one thousand and twenty-one")
  )
  expect_equal(
    numeric_friendly(c(1, 1001, 1021), and = FALSE),
    c("one", "one thousand one", "one thousand twenty-one")
  )
  expect_equal(
    numeric_friendly(c(1, 1001, 1021), and = FALSE),
    c("one", "one thousand one", "one thousand twenty-one")
  )

  expect_equal(
    numeric_friendly(c(1, 1001, 1021), and = FALSE),
    c("one", "one thousand one", "one thousand twenty-one")
  )
})

test_that("`decimal` argument works", {
  expect_equal(numeric_friendly(1.1, decimal = "-"), "one-one tenth")
})

test_that("Regex metacharacters in `decimal` are handled correctly", {
  expect_equal(numeric_friendly(1.1, decimal = "\\1"), "one\\1one tenth")
  expect_equal(numeric_friendly(1.1, decimal = "$"), "one$one tenth")
})
