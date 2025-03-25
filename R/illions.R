# illions ----------------------------------------------------------------------

illions <- function(thousands_power) {
  n <- length(thousands_power)
  if (n == 0) {
    return(character())
  }
  out <- character(n)
  illi <- out

  smallillions <- c(
    "", "thousand", "million", "billion", "trillion", "quadrillion",
    "quintillion", "sextillion", "septillion", "octillion", "nonillion"
  )
  units <- c(
    "", "un", "duo", "tre", "quattuor", "quin", "sex", "septen", "octo", "novem"
  )
  tens <- c(
    "", "deci", "viginti", "triginta", "quadraginta", "quinquaginta",
    "sexaginta", "septuaginta", "octoginta", "nonaginta"
  )
  hundreds <- c(
    "", "centi", "ducenti", "trecenti", "quadringenti", "quingenti",
    "sescenti", "septingenti", "octingenti", "nongenti"
  )

  # `thousands_power` in [0, 10]
  small <- thousands_power <= 10
  out[small] <- smallillions[thousands_power[small] + 1]

  # `thousands_power` in [1001, Inf).
  #
  # For "huge" numbers use the Conway-Wechsler extension which adds an "illi"
  # for increasing power of 1000. For example, "XilliYilliZillion" denotes the
  # (1000000X  +  1000Y  +  Z)th -illion.
  #
  # We first encounter this with "millinillion" where X = 0, Y == 1, Z = 1. Note
  # that the normal -illions start at the second 1000's power, but we start at
  # the first 1000's power. So we do some shifting about to adjust.
  huge <- thousands_power > 1000
  huge_thousands <- thousands_power[huge] - 1
  out[huge] <- paste0(
    sub("on$", "", illions((huge_thousands %/% 1000) + 1)),
    sub("thousand$", "nillion", illions((huge_thousands %% 1000) + 1))
  )

  # `thousands_power` in [11, 1000]
  big <- !small & !huge
  big_thousands <- thousands_power[big] - 1

  hundreds_index <- (big_thousands %/% 100) + 1
  tens_index <- ((big_thousands %/% 10) %% 10) + 1
  units_index <- (big_thousands %% 10) + 1

  out[big] <- sub("allion$", "illion", paste0(
    units[units_index],
    tens[tens_index],
    hundreds[hundreds_index],
    "llion"
  ))
  out
}

nice_illions <- function(thousands_power) {
  n <- length(thousands_power)
  if (n == 0) {
    return(character())
  }
  out <- character(n)
  illi <- out

  smallillions <- c(
    "", "thousand", "million", "billion", "trillion", "quadrillion",
    "quintillion", "sextillion", "septillion", "octillion", "nonillion"
  )

  # Conway and Guy's original -illions have rules for joining the units, tens,
  # hundreds terms depending on their ending letter. For each "-suffix/prefix-"
  # obtained by pasting together the `units`, `tens`, `hundreds` we implement a
  # Conway and Guy rule to replace it (e.g. "-sxms-" becomes "s").
  units <- c(
    "-", "un-", "duo-", "tre-t", "quattuor-", "quin-", "se-sx", "septe-mn", "octo-",
    "nove-mn"
  )
  tens <- c(
    "", "n-deci-", "ms-viginti-", "ns-triginta-", "ns-quadraginta-",
    "ns-quinquaginta-", "n-sexaginta-", "n-septuaginta-", "mx-octoginta-",
    "-nonaginta-"
  )
  hundreds <- c(
    "", "nx-centi-", "n-ducenti-", "ns-trecenti-", "ns-quadringenti-",
    "ns-quingenti-", "n-sescenti-", "n-septingenti-", "mx-octingenti-",
    "-nongenti-"
  )

  # `thousands_power` in [0, 10]
  small <- thousands_power <= 10
  out[small] <- smallillions[thousands_power[small] + 1]

  # `thousands_power` in [1001, Inf)
  huge <- thousands_power > 1000
  huge_thousands <- thousands_power[huge] - 1
  out[huge] <- paste0(
    sub("on$", "", nice_illions((huge_thousands %/% 1000) + 1)),
    sub("thousand$", "nillion", nice_illions((huge_thousands %% 1000) + 1))
  )

  # `thousands_power` in [11, 1000]
  big <- !small & !huge
  big_thousands <- thousands_power[big] - 1

  hundreds_index <- (big_thousands %/% 100) + 1
  tens_index <- ((big_thousands %/% 10) %% 10) + 1
  units_index <- (big_thousands %% 10) + 1

  out[big] <- sub("a--llion$", "i--llion", paste0(
    units[units_index],
    tens[tens_index],
    hundreds[hundreds_index],
    "-llion"
  ))

  # Implement the adjacent letter rules, thanks an illion Robert Munafo:
  # https://www.mrob.com/pub/math/largenum.html#conway-wechsler
  # "-sx(ns|ms)-"       -> "s"
  # "-sx(mx|nx)-"       -> "x"
  # "-mn(n|ns|nx)-"     -> "n"
  # "-mn(ms|mx)-"       -> "m"
  # "-t(ns|ms|nx|mx)-"  -> "s"
  out[big] <- gsub(
    x = sub("-sx(ns|ms)-", "s", sub("-sx(mx|nx)-", "x", sub("-mn(n|ns|nx)-", "n", sub("-mn(ms|mx)-", "m", sub("-t(ns|ms|nx|mx)-", "s", out[big]))))),
    # Clean up the remaining control symbols `--`
    pattern = "-.*?-", replacement = ""
  )
  out
}

# tenillions -------------------------------------------------------------------

tenillions <- function(tens_power) {
  illions <- illions(tens_power %/% 3)
  trimws(paste(c("", "ten", "hundred")[(tens_power %% 3) + 1], illions))
}

nice_tenillions <- function(tens_power) {
  nice_illions <- nice_illions(tens_power %/% 3)
  trimws(paste(c("", "ten", "hundred")[(tens_power %% 3) + 1], nice_illions))
}
