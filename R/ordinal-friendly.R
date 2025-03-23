ordinal_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative",
    and = FALSE,
    hyphenate = TRUE
) {
  english_ordinals <- paste0(integer_friendly(
    numbers = numbers,
    zero = zero,
    na = na,
    nan = nan,
    inf = inf,
    negative = negative,
    and = and,
    hyphenate = hyphenate
  ), "th")

  # Special rules for word endings:
  # one     -> first
  # two     -> second
  # three   -> third
  # five    -> fifth, twelve -> twelfth
  # eight   -> eight, nine -> ninth
  # twenty  -> twentieth
  sub(
    "yth$", "ieth",
    sub("[et]th$", "th",
        sub("veth$", "fth",
            sub("threeth", "third",
                sub("twoth$", "second",
                    sub("oneth$", "first", english_ordinals))))))
}
