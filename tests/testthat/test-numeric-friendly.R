test_that("`numeric_friendly()` works", {
  expect_equal(
    numeric_friendly(c(-Inf, Inf, 0, NA, NaN)),
    c("negative infinity", "infinity", "zero", "missing", "not a number")
  )
  expect_equal(
    numeric_friendly(
      c(-Inf, Inf, 0, NA, NaN),
      negative = "-",
      inf = "Inf",
      zero = "0",
      na = "NA",
      nan = "NaN"
    ),
    paste(c(-Inf, Inf, 0, NA, NaN))
  )
  expect_equal(
    numeric_friendly(c(1, 1.001, 0.001, 0.002, 10.002, 1001, 999999, 999.123)),
    c(
      "one",
      "one and one thousandth",
      "one thousandth",
      "two thousandths",
      "ten and two thousandths",
      "one thousand one",
      "nine hundred ninety-nine thousand nine hundred ninety-nine",
      "nine hundred ninety-nine and one hundred twenty-three thousandths"
    )
  )
})

test_that("`numeric_friendly()` returns `character(0)` on zero-length input", {
  expect_identical(numeric_friendly(numeric()), character())
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
    numeric_friendly(c(1, 1001, 1021, 1.1, 1021.1, 1021.1021), and = TRUE, decimal = " point "),
    c(
      "one",
      "one thousand and one",
      "one thousand and twenty-one",
      "one point one tenth",
      "one thousand and twenty-one point one tenth",
      "one thousand and twenty-one point one thousand and twenty-one ten thousandths"
    )
  )
  expect_equal(
    numeric_friendly(c(1, 1001, 1021, 1.1, 1021.1, 1021.1021), and = FALSE, decimal = " point "),
    c(
      "one",
      "one thousand one",
      "one thousand twenty-one",
      "one point one tenth",
      "one thousand twenty-one point one tenth",
      "one thousand twenty-one point one thousand twenty-one ten thousandths"
    )
  )
  expect_equal(
    numeric_friendly(1021.1021, and = TRUE, and_fractional = FALSE, decimal = " point "),
    "one thousand and twenty-one point one thousand twenty-one ten thousandths"
  )
})

test_that("`decimal` argument works", {
  expect_equal(numeric_friendly(1, decimal = "-"), "one")
  expect_equal(numeric_friendly(0.1, decimal = "-"), "one tenth")
  expect_equal(numeric_friendly(1.1, decimal = "-"), "one-one tenth")
})

test_that("Regex metacharacters in `decimal` are handled correctly", {
  expect_equal(numeric_friendly(1.1, decimal = "\\1"), "one\\1one tenth")
  expect_equal(numeric_friendly(1, decimal = "\\1"), "one")
  expect_equal(numeric_friendly(1.1, decimal = "$"), "one$one tenth")
})
