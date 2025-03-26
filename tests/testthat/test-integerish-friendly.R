# basics -----------------------------------------------------------------------

test_that("`integerish_friendly()` works", {
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

  numbers <- c(Inf, 10000000, -10000000, 10000000 + 1, 10000000 - 1, NaN, NA)
  expect_equal(
    integerish_friendly(numbers),
    c(
      "infinity", "ten million", "negative ten million", "ten million one",
      "nine million nine hundred ninety-nine thousand nine hundred ninety-nine",
      "not a number", "missing"
    )
  )
  expect_equal(
    integerish_friendly(-numbers),
    c(
      "negative infinity", "negative ten million", "ten million",
      "negative ten million one",
      "negative nine million nine hundred ninety-nine thousand nine hundred ninety-nine",
      "not a number", "missing"
    )
  )
})
