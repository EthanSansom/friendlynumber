# todos ------------------------------------------------------------------------

# TODO: Before we venture too far down the rabbit hole, let's get some unit tests
# going for all of these things. `numeric_friendly()` and `integer_friendly()`
# and `ordinal_friendly()` in particular.

# TODO: `scalar_numeric_friendly()`, take advantage of the scalar-ness

# functions --------------------------------------------------------------------

# TODO: Implement this by splitting apart the fractional and whole parts. Pass
# the whole part to `integer_friendly()` and the fractional part can be constructed
# utilizing `format_fractional()` and `english_fractional()`. You'll want to define
# some `english$fractions <- c(`0.5` = "a half")` and use those for the common cases.
#
# Also allow them to provide the `english_fractions` as a named character vector,
# which overrides these defaults. A package implementer can wrap that in an option
# or something.
numeric_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative",
    decimal = " and ",
    and = FALSE,
    hyphenate = TRUE
  ) {

  # TODO: Is there a potential speedup if we just let this be one of the common
  # cases? Like we could initialize with `rep_len(zero, length(numbers))` and
  # then not do `out[zeros] <-`.
  #
  # We're doing a lot of zero imputing, I think that would be helpful so long
  # as `character(length(numbers))` and `rep_len()` are similar speeds.
  out <- character(length(numbers))

  infinites <- is.infinite(numbers)
  missings <- is.na(numbers)
  zeros <- !missings & numbers == 0
  negatives <- !missings & numbers < 0

  # `is.na()` is TRUE for NaN
  nans <- is.nan(numbers)
  nas <- !nans & missings

  out[infinites] <- inf
  out[nas] <- na
  out[nans] <- nan
  out[zeros] <- zero

  needs_englishifying <- !(infinites | missings | zeros)
  if (!any(needs_englishifying)) {
    out[negatives] <- paste(negative, inf)
    return(out)
  }

  # TODO: This needs work, I think I do want to use the character representation
  # via `format_fractional()` for this instead of actually getting the fractional
  # part of the number. `whole` can stay the same because truncating is fast.
  remaining_numbers <- numbers[needs_englishifying]
  whole <- trunc(remaining_numbers)
  fractional <- remaining_numbers - whole

  whole_only <- fractional == 0
  fractional_only <- whole == 0
  compound <- !whole_only & !fractional_only

  out[needs_englishifying][whole_only] <- english_naturals(whole[whole_only])
  out[needs_englishifying][fractional_only] <- english_fractional(fractional[fractional_only])

  # TODO: Add `hyphenate` and `add` to the `english_whole` component. We'll
  # need to specify separately what to do for the fractional. Maybe
  # `and_fractional = and`, `hyphenate_fractional = hyphenate`.

  # Want to allow `decimal` to be spaced (e.g. " and ") or non-spaced (e.g. "-")
  # so using `paste0()`. Recall `english_naturals()` has a trailing space, so we
  # have to trim it.
  out[needs_englishifying][compound] <- paste0(
    trimws(english_naturals(whole[compound])),
    decimal,
    english_fractional(fractional[compound])
  )
  trimws(out)
}


if (FALSE) {
  load_all()

  numeric_friendly(999.123)

  numbers <- 999.123
  decimal <- " and "

  needs_englishifying <- TRUE

  remaining_numbers <- numbers[needs_englishifying]
  english_whole <- integer_friendly(trunc(remaining_numbers))

  # english_fractional <- english_fractional(remaining_numbers)

  fractionals <- 0.123

  fractional_characters <- format_fractional(fractionals)
  n_decimals <- nchar(fractional_characters) - 2L # Adjust for the prefix "0."
  naturals <- as.numeric(fractional_characters) * 10^n_decimals

  # `english_naturals()` leaves a space after it's output, so can use `paste0()`
  paste0(
    english_naturals(naturals),
    nice_tenillions(n_decimals),
    # "one thousandth" for "0.001" vs. "two thousandths" for "0.002"
    ifelse(grepl("1$", fractional_characters), "th", "ths")
  )


  whole <- trunc(remaining_numbers)
  fractional <- remaining_numbers - whole

  whole_only <- fractional == 0
  fractional_only <- whole == 0
  compound <- !whole_only & !fractional_only

  remaining_numbers[rounded_zeros] <- zero
  remaining_numbers[whole_only] <- english_naturals(whole[whole_only])
  remaining_numbers[fractional_only] <- english_fractional(fractional[fractional_only])

  remaining_numbers[compound] <- paste0(
    trimws(english_naturals(whole[compound])),
    decimal,
    english_fractional(fractional[compound])
  )

}



