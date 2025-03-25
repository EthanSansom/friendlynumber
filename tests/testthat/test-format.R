# TODO: You'll need to add test using `withr::with_options` to see how digits
# effects this

test_that("format_number.numeric() works", {
  expect_equal(
    format_number(c(NaN, NA, Inf, -Inf, 0, 0.0)),
    c("NaN", "NA", "Inf", "-Inf", "0", "0")
  )
  expect_equal(format_number(123), "123")
  expect_equal(format_number(1234), "1,234")
  expect_equal(format_number(1234.0), "1,234")
  expect_equal(format_number(1234.5), "1,234.5")
  expect_equal(format_number(1234.567), "1,234.567")
  expect_equal(format_number(0.1), "0.1")
  expect_equal(format_number(0.123), "0.123")
  expect_equal(format_number(0.1234), "0.1234")
})
