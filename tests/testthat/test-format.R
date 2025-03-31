test_that("format_number.numeric() works", {
  expect_equal(
    format_number(c(NaN, NA, Inf, -Inf, 0, 0.0)),
    c("NaN", "NA", "Inf", "-Inf", "0", "0")
  )
  expect_equal(
    format_number(c(123, 1234, 1234.0, 1234.5, 1234.567, 0.1, 0.123, 0.1234)),
    c("123", "1,234", "1,234", "1,234.5", "1,234.567", "0.1", "0.123", "0.1234")
  )
  expect_equal(format_number(-c(123, 0.1234)), c("-123", "-0.1234"))

  withr::local_options(list(friendlynumber.numeric.digits = 2))
  expect_equal(
    format_number(c(1234.0, 1234.5, 1234.567, 0.1, 0.123, 0.1234)),
    c("1,234", "1,234.5", "1,234.57", "0.1", "0.12", "0.12")
  )
})

test_that("format_number.integer() works", {
  expect_equal(format_number(c(NA_integer_, 0L)), c("NA", "0"))
  expect_equal(format_number(c(1L, 123L, 1234L)), c("1", "123", "1,234"))
  expect_equal(format_number(-c(1L, 123L, 1234L)), c("-1", "-123", "-1,234"))
})

test_that("format_number.bignum_bigfloat() works", {
  skip_if_not_installed("bignum")

  expect_equal(
    format_number(bignum::bigfloat(c(NaN, NA, Inf, -Inf, 0, 0.0))),
    c("NaN", "NA", "Inf", "-Inf", "0", "0")
  )
  expect_equal(
    format_number(bignum::bigfloat(c(123, 1234, 1234.0, 1234.5, 1234.567, 0.1, 0.123, 0.1234))),
    c("123", "1,234", "1,234", "1,234.5", "1,234.567", "0.1", "0.123", "0.1234")
  )
  expect_equal(format_number(bignum::bigfloat(-c(123, 0.1234))), c("-123", "-0.1234"))

  withr::local_options(list(friendlynumber.bigfloat.digits = 2))
  expect_equal(
    format_number(bignum::bigfloat(c(1234.0, 1234.5, 1234.567, 0.1, 0.123, 0.1234))),
    c("1,234", "1,234.5", "1,234.57", "0.1", "0.12", "0.12")
  )
  expect_equal(format_number(bignum::bigfloat(-c(123, 0.1234))), c("-123", "-0.12"))
})

test_that("format_number.bignum_biginteger() works", {
  skip_if_not_installed("bignum")

  expect_equal(format_number(bignum::biginteger(c(NA, 0, 0.0))), c("NA", "0", "0"))
  expect_equal(format_number(bignum::biginteger(c(1, 123, 1234))), c("1", "123", "1,234"))
  expect_equal(format_number(bignum::biginteger(-c(1, 123, 1234))), c("-1", "-123", "-1,234"))
})

test_that("`format_number()` raises an error on invalid types", {
  expect_error(format_number("A"), class = "friendlynumber_error_input_type")
  expect_error(format_number(data.frame()), class = "friendlynumber_error_input_type")
})
