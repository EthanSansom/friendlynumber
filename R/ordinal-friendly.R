ordinal_friendly <- function(
    numbers,
    zero = "zeroth",
    na = "missingth",
    nan = "not a numberth",
    inf = "infinitieth",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
) {

  out <- character(length(numbers))

  infinites <- is.infinite(numbers)
  missings <- is.na(numbers)
  zeros <- !missings & numbers == 0
  negatives <- !missings & numbers < 0
  nans <- is.nan(numbers)
  nas <- !nans & missings

  out[infinites] <- inf
  out[nas] <- na
  out[nans] <- nan
  out[zeros] <- zero

  needs_englishifying <- !(infinites | missings | zeros)
  if (!any(needs_englishifying)) {
    out[negatives] <- paste0(negative, inf)
    return(out)
  }

  remaining_numbers <- abs(numbers[needs_englishifying])
  if (all(remaining_numbers < 1000)) {
    out[needs_englishifying] <- after_format(
      english_hundreds(remaining_numbers),
      and = and,
      hyphenate = hyphenate
    )
    out[negatives] <- paste0(negative, out[negatives])
    return(ordinalify(out))
  }

  out[needs_englishifying] <- ordinalify(english_naturals(
    remaining_numbers,
    and = and,
    hyphenate = hyphenate
  ))
  out
}

ordinal_friendly_safe <- function(
    numbers,
    zero = "zeroth",
    na = "missingth",
    nan = "not a numberth",
    inf = "infinitieth",
    negative = "negative ",
    and = FALSE,
    hyphenate = TRUE
) {
  numbers <- check_is_whole(numbers)
  zero <- check_is_string(zero)
  na <- check_is_string(na)
  nan <- check_is_string(nan)
  inf <- check_is_string(inf)
  negative <- check_is_string(negative)
  and <- check_is_bool(and)
  hyphenate <- check_is_bool(hyphenate)

  ordinal_friendly(
    numbers = numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    and = and,
    hyphenate = hyphenate
  )
}

# Ordinal rules for word endings:
# *       -> Append "th"
# one     -> first
# two     -> second
# three   -> third
# five    -> fifth, twelve -> twelfth
# eight   -> eighth, nine -> ninth
# twenty  -> twentieth
ordinalify <- function(english_numbers) {
  sub(
    "yth$", "ieth",
    sub("[et]th$", "th",
        sub("veth$", "fth",
            sub("threeth$", "third",
                sub("twoth$", "second",
                    sub("oneth$", "first", paste0(english_numbers, "th")))))))
}
