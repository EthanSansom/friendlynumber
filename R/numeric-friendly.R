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
    hyphenate_fractional = hyphenate,
    english_fractions = get_english_fractions()
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

  remaining_numbers <- abs(numbers[needs_englishifying])
  remaining_wholes <- trunc(remaining_numbers)

  # TODO: These only actually need to be equal up to a certain precision, might
  # be better to do `remaining_numbers - remaining_wholes < get_epsilon()`, or
  # we could round `remaining_numbers` to the correct digits first.
  if (all(remaining_numbers == remaining_wholes)) {
    if (all(remaining_wholes < 1000)) {
      out[needs_englishifying] <- after_format(
        english_hundreds(remaining_wholes),
        and = and,
        hyphenate = hyphenate
      )
      out[negatives] <- paste(negative, out[negatives])
      return(out)
    }
    return(english_naturals(remaining_wholes, and = and, hyphenate = hyphenate))
  }

  remaining_fractionals <- remaining_numbers - remaining_wholes
  is_whole <- remaining_fractionals == 0
  is_fractional <- remaining_wholes == 0
  is_compound <- !is_whole & !is_fractional

  out[needs_englishifying][is_whole] <- english_naturals(
    remaining_wholes[is_whole],
    and = and,
    hyphenate = hyphenate
  )
  out[needs_englishifying][is_fractional] <- english_fractionals(
    remaining_fractionals[is_fractional],
    and = and_fractional,
    hyphenate = hyphenate_fractional,
    zero = zero,
    english_fractions = english_fractions
  )

  out[needs_englishifying][is_compound] <- paste0(
    english_naturals(
      remaining_wholes[is_compound],
      and = and,
      hyphenate = hyphenate
    ),
    # Later subbed out for `decimal`. We check for trailing fractional zero's
    # (resulting from insufficient precision) using `sub()`, which errors if
    # `decimal` is a regex metacharacter.
    "<decimal>",
    english_fractionals(
      remaining_fractionals[is_compound],
      and = and,
      hyphenate = hyphenate,
      zero = "<fractional zero>", # Later removed
      english_fractions = english_fractions
    )
  )
  out[needs_englishifying][is_compound] <- sub(
    # First remove any trailing fractional zeros
    x = sub(
      x = out[needs_englishifying][is_compound],
      pattern = "<decimal><fractional zero>$",
      replacement = ""
    ),
    # Then, insert the user supplied decimal. Note that `fixed = TRUE` here
    # prevents user-supplied metacharacters from breaking things.
    pattern = "<decimal>",
    replacement = decimal,
    fixed = TRUE
  )

  out
}

# Which is faster, `all(x == y)` or `all.equal(x, y)` (looks like `all()` wins)
if (FALSE) {

  ints <- ints_off <- 1:10000
  ints_off[10000] <- 0
  bench::mark(
    all(ints == ints),
    all.equal(ints, ints)
  )
  bench::mark(
    all(ints == ints_off),
    isTRUE(all.equal(ints, ints_off))
  )

}
