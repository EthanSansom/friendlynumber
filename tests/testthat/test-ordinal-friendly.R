test_that("`ordinal_friendly()` works", {
  expect_equal(
    ordinal_friendly(c(1:20, 100 + 0:20)),
    c(
      "first", "second", "third", "fourth", "fifth", "sixth", "seventh",
      "eighth", "ninth", "tenth", "eleventh", "twelfth", "thirteenth",
      "fourteenth", "fifteenth", "sixteenth", "seventeenth", "eighteenth",
      "nineteenth", "twentieth", "one hundredth", "one hundred first",
      "one hundred second", "one hundred third", "one hundred fourth",
      "one hundred fifth", "one hundred sixth", "one hundred seventh",
      "one hundred eighth", "one hundred ninth", "one hundred tenth",
      "one hundred eleventh", "one hundred twelfth", "one hundred thirteenth",
      "one hundred fourteenth", "one hundred fifteenth", "one hundred sixteenth",
      "one hundred seventeenth", "one hundred eighteenth", "one hundred nineteenth",
      "one hundred twentieth"
    )
  )
  expect_equal(
    ordinal_friendly(c(0, NaN, NA, -Inf, Inf)),
    c("zeroth", "not a numberth", "missingth", "negative infinitieth", "infinitieth")
  )
  expect_identical(ordinal_friendly(integer()), character())
  expect_identical(ordinal_friendly(numeric()), character())
})
