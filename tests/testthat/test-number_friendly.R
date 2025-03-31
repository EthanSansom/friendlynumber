test_that("`number_friendly()` works", {
  int <- 1L
  num <- 3.1415927
  bigflt <- bignum::bigpi
  bigint <- bignum::biginteger("1000000000000")

  expect_equal(number_friendly(int), "one")
  expect_equal(number_friendly(num), "three and one million four hundred fifteen thousand nine hundred twenty-seven ten-millionths")
  expect_equal(number_friendly(bigflt), "three and one million four hundred fifteen thousand nine hundred twenty-seven ten-millionths")
  expect_equal(number_friendly(bigint), "one trillion")

  withr::local_options(list(friendlynumber.numeric.digits = 5, friendlynumber.bigfloat.digits = 7))
  expect_equal(number_friendly(num), "three and fourteen thousand one hundred fifty-nine hundred-thousandths")
  expect_equal(number_friendly(bigflt), "three and one million four hundred fifteen thousand nine hundred twenty-seven ten-millionths")

  withr::local_options(list(friendlynumber.numeric.digits = 7, friendlynumber.bigfloat.digits = 5))
  expect_equal(number_friendly(num), "three and one million four hundred fifteen thousand nine hundred twenty-seven ten-millionths")
  expect_equal(number_friendly(bigflt), "three and fourteen thousand one hundred fifty-nine hundred-thousandths")
})

test_that("`number_friendly_safe()` works", {
  int <- 1L
  num <- 3.1415927
  bigflt <- bignum::bigpi
  bigint <- bignum::biginteger("1000000000000")

  expect_equal(number_friendly_safe(int), "one")
  expect_equal(number_friendly_safe(num), "three and one million four hundred fifteen thousand nine hundred twenty-seven ten-millionths")
  expect_equal(number_friendly_safe(bigflt), "three and one million four hundred fifteen thousand nine hundred twenty-seven ten-millionths")
  expect_equal(number_friendly_safe(bigint), "one trillion")

  expect_error(number_friendly_safe(int, and = NA), class = "friendlynumber_error_input_type")
  expect_error(number_friendly_safe(num, decimal = c("a", "b")), class = "friendlynumber_error_input_type")
})

test_that("`number_friendly()` and `number_friendly_safe()` error on unimplemented types", {
  expect_error(number_friendly(TRUE), class = "friendlynumber_error_input_type")
  expect_error(number_friendly("A"), class = "friendlynumber_error_input_type")
  expect_error(number_friendly_safe(TRUE), class = "friendlynumber_error_input_type")
  expect_error(number_friendly_safe("A"), class = "friendlynumber_error_input_type")
})
