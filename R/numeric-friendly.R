# todos ------------------------------------------------------------------------

# TODO: Before we venture too far down the rabbit hole, let's get some unit tests
# going for all of these things. `numeric_friendly()` and `integer_friendly()`
# and `ordinal_friendly()` in particular.

# TODO: `scalar_numeric_friendly()`, take advantage of the scalar-ness

# functions --------------------------------------------------------------------

# TODO: Implement this by splitting apart the fractional and whole parts. Pass
# the whole part to `integer_friendly()` and the fractional part can be constructed
# utilizing `format_fractional()` and `english_fractionals()`. You'll want to define
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
    hyphenate = TRUE,
    and_fractional = and,
    hyphenate_fractional = hyphenate
  ) {

  # NOTE: No, this doesn't yield any speedup.
  #
  # RESOLVED: Is there a potential speedup if we just let this be one of the common
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

  remaining_numbers <- numbers[needs_englishifying]
  remaining_wholes <- trunc(remaining_numbers)
  remaining_fractionals <- remaining_numbers - remaining_wholes

  is_whole <- remaining_fractionals == 0
  is_fractional <- remaining_wholes == 0
  is_compound <- !is_whole & !is_fractional

  # TODO: Is there a speed difference if we do both naturals and fractions for
  # every element of `out[needs_englishifying]` and then drop the whole or
  # fractional portion as needed?

  out[needs_englishifying][is_whole] <- english_naturals(
    remaining_wholes[is_whole],
    and = and,
    hyphenate = hyphenate
  )
  out[needs_englishifying][is_fractional] <- english_fractionals(
    remaining_fractionals[is_fractional],
    and = and_fractional,
    hyphenate = hyphenate_fractional,
    zero = zero
  )

  out[needs_englishifying][is_compound] <- paste0(
    english_naturals(remaining_wholes[is_compound], and = and, hyphenate = hyphenate),
    decimal,
    english_fractionals(remaining_fractionals[is_compound], and = and, hyphenate = hyphenate, zero = zero)
  )

  # TODO: We might have to be more careful about this `sub()`, since `decimal`
  # or `zero` might be control sequences. Look into how you're supposed to do
  # regular expressions containing a user output. I think an easy thing to do
  # is to add my own trailing symbol (e.g. "-") that we can use to detect
  # fractional zeros.

  # Removes trailing zeros (e.g. " and zero") which occur when we don't have
  # enough precision to format small `remaining_fractionals`.
  out <- sub(paste0(decimal, zero, "$"), "", out)
  out
}
