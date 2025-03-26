test_that("`integerish_friendly()` works", {
  # Integer input
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

  # Integer-ish input
  numbers <- c(10000000, -10000000, 10000000 + 1, 10000000 - 1, NaN, NA, Inf)
  expect_equal(
    integerish_friendly(numbers),
    c(
      "ten million", "negative ten million", "ten million one",
      "nine million nine hundred ninety-nine thousand nine hundred ninety-nine",
      "not a number", "missing", "infinity"
    )
  )
  expect_equal(
    integerish_friendly(-numbers),
    c(
      "negative ten million", "ten million",
      "negative ten million one",
      "negative nine million nine hundred ninety-nine thousand nine hundred ninety-nine",
      "not a number", "missing", "negative infinity"
    )
  )

  # Custom special inputs
  expect_equal(
    integerish_friendly(
      c(-Inf, Inf, 0, NA, NaN),
      negative = "-",
      inf = "Inf",
      zero = "0",
      na = "NA",
      nan = "NaN"
    ),
    paste(c(-Inf, Inf, 0, NA, NaN))
  )

  # Empty input
  expect_identical(integerish_friendly(integer()), character())
  expect_identical(integerish_friendly(numeric()), character())
})

test_that("`hyphentate` argument works", {
  expect_equal(
    integerish_friendly(c(1L, 21L, 123L), hyphenate = TRUE),
    c("one", "twenty-one", "one hundred twenty-three")
  )
  expect_equal(
    integerish_friendly(c(1L, 21L, 123L), hyphenate = FALSE),
    c("one", "twenty one", "one hundred twenty three")
  )
})

test_that("`and` argument works", {
  expect_equal(
    integerish_friendly(c(1L, 1001L, 1021L), and = TRUE),
    c("one", "one thousand and one", "one thousand and twenty-one")
  )
  expect_equal(
    integerish_friendly(c(1L, 1001L, 1021L), and = FALSE),
    c("one", "one thousand one", "one thousand twenty-one")
  )
})
