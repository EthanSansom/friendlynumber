nth_friendly <- function(
    numbers,
    zero = "zeroth",
    na = "missingth",
    nan = "not a numberth",
    inf = "infinityth",
    negative = "negative",
    bigmark = TRUE
  ) {

  out <- paste0(format(numbers, big.mark = if (bigmark) "," else "", scientific = FALSE), "th")

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
  out[negatives] <- paste(negative, out[negatives])

  needs_englishifying <- !(infinites | missings | zeros)
  if (!any(needs_englishifying)) {
    out[negatives] <- paste(negative, inf)
    return(out)
  }

  # TODO: Maybe needs something for <biginteger>
  englishified <- paste0(format(
    x = numbers[needs_englishifying],
    # Allowing `big.mark` to be specified would complicate the regex
    big.mark = if (bigmark) "," else "",
    scientific = FALSE
  ), "th")

  # Special rules for word endings:
  # 1     -> 1st (but not 11 -> 11st)
  # 2     -> 2nd
  # 3     -> 3rd
  out[needs_englishifying] <- sub("3th$", "3rd", sub("2th$", "2nd", sub("(?<!1)1th$", "1st", englishified, perl = TRUE)))
  trimws(out)
}

english_nth_friendly <- function(numbers, bigmark = TRUE) {
  if (length(numbers) == 0) {
    return(character())
  }

  # Allowing `big.mark` to be specified would complicate the regex
  big.mark <- if (bigmark) "," else ""
  english_ordinals <- paste0(format(numbers, big.mark = big.mark, scientific = FALSE), "th")

  # Special rules for word endings:
  # 1     -> 1st (but not 11 -> 11st)
  # 2     -> 2nd
  # 3     -> 3rd
  trimws(
    sub(
      "3th$", "3rd",
      sub("2th$", "2nd",
          sub("(?<!1)1th$", "1st", english_ordinals, perl = TRUE))))
}
