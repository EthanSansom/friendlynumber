test_that("`numeric_friendly.numeric() works", {
  expect_equal(
    numeric_friendly(c(-Inf, Inf, 0, NA, NaN)),
    c("negative infinity", "infinity", "zero", "missing", "not a number")
  )
  expect_equal(numeric_friendly(1), "one")
  expect_equal(numeric_friendly(1.001), "one and one thousandth")
  expect_equal(numeric_friendly(0.001), "one thousandth")
  expect_equal(numeric_friendly(0.002), "two thousandths")
  expect_equal(numeric_friendly(10.002), "ten and two thousandths")
  expect_equal(numeric_friendly(1001), "one thousand one")
  expect_equal(numeric_friendly(999999), "nine hundred ninety-nine thousand nine hundred ninety-nine")
  expect_equal(numeric_friendly(999.123), "nine hundred ninety-nine and one hundred twenty-three thousandths")
})
