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

# 3009


# 1	Un        Deci	        Centi
# 2	Duo       Viginti	      Ducenti
# 3	Tre       Triginta      Trecenti
# 4	Quattuor  Quadraginta   Quadringenti
# 5	Quinqua   Quinquaginta	Quingenti
# 6	Se        Sexaginta	    Sescenti
# 7	Septe     Septuaginta	  Septingenti
# 8	Octo      Octoginta	    Octingenti
# 9	Nove	   Nonaginta	    Nongenti

# my_illions <- gsub("xd", "d", my_illions)
# my_illions <- gsub("xv", "sv", my_illions)
# my_illions <- gsub("md", "nd", my_illions)
# my_illions <- gsub("nv", "mv", my_illions) # exclude `un`
# my_illions <- gsub("nv", "mv", my_illions) # exclude

# septe^mn + ms^viginti = septemviginti because both superscripts contain an m;
# but se^sx + n^ducenti = seducenti with no added letter because there is no
# matching letter in "sx" and "{n}". Another example: se^sx + ns^quingenti = sesquingenti

my_illions |> stringr::str_subset("quadraginta")


# Firsts: (sx), (mn), t
# Seconds: n, ms, ns, nx, mx

my_nice_illions_raw <- nice_illions(1:1004)
my_nice_illions <- my_nice_illions_raw

my_nice_illions <- sub("-sx(nx|mx)-", "x", my_nice_illions)
my_nice_illions <- sub("-sx(ns|ms)-", "s", my_nice_illions)
my_nice_illions <- sub("-mn(n|ns|nx)-", "n", my_nice_illions)
my_nice_illions <- sub("-mn(ms|mx)-", "m", my_nice_illions)
my_nice_illions <- sub("-t(ns|ms|nx|mx)-", "s", my_nice_illions)
my_nice_illions <- gsub("-.*?-", "", my_nice_illions)

raw <- "-n-strecenti--llion"
(raw <- sub("-sx(nx|mx)-", "x", raw))
(raw <- sub("-sx(ns|ms)-", "s", raw))
(raw <- sub("-mn(n|ns|nx)-", "n", raw))
raw <- sub("-mn(ms|mx)-", "m", raw)
raw <- sub("-t(ns|ms|nx|mx)-", "s", raw)
raw <- gsub("-.*?-", "", raw)

# my_illions <- illions(1:1004)

head(my_nice_illions, 20)

illions_table |>
  dplyr::mutate(us_name = tolower(us_name)) |>
  dplyr::bind_cols(my_illions = nice_illions(1:1004)) |>
  dplyr::filter(us_name != my_illions)
  # dplyr::mutate(diff = str_diff(us_name, my_illions))

illions_table$us_name |> tolower() |> dput()

sub("nv", "mv", "septenvigintillion")

str_diff <- function(x, y) {
  as.character(.mapply(str_diff1, list(x = x, y = y), list()))
}

str_diff1 <- function(x, y) {
  x_chars <- strsplit(x, "")[[1]]
  y_chars <- strsplit(y, "")[[1]]

  nchar_x_less_y <- nchar(x) - nchar(y)
  if (nchar_x_less_y > 0) {
    y_chars <- c(y_chars, rep_len(" ", nchar_x_less_y))
  } else {
    x_chars <- c(x_chars, rep_len(" ", abs(nchar_x_less_y)))
  }

  diff_at <- x_chars != y_chars
  x_chars[diff_at] <- toupper(x_chars[diff_at])
  paste(x_chars, collapse = "")
}


hundreds_index <- (index %/% 100) + 1
tens_index <- ((index %/% 10) %% 10) + 1
units_index <- (index %% 10) + 1



tenillions <- function(tens_power) {
  paste(
    c("", "ten", "hundred")[(tens_power %% 3) + 1],
    illions(tens_power %/% 3)
  )
}

if (FALSE) {
  load_all()

  tens_power <- 6

  thousands_power <- tens_power %/% 3
  tens <- tens_power %% 3

  paste(
    c("", "ten", "hundred")[(tens_power %% 3) + 1],
    illions(tens_power %/% 3)
  )

}



# 1 -> "ten"
# 2 -> "hundred"
# 3 -> "thousand"

?rvest::`rvest-package`

if (FALSE) {
  html <- rvest::read_html("https://www.olsenhome.com/bignumbers/")
  tables <- html |> rvest::html_elements("table")

  illions_table_raw <- tables[[4]] |> rvest::html_table()
  names(illions_table_raw) <- c("base_thousands", "base_tens", "us_name", "comments")

  illions_table <- illions_table_raw[-1, c("base_thousands", "base_tens", "us_name")]
  illions_table <- illions_table |>
    dplyr::filter(base_thousands != "...", base_tens != "...") |>
    dplyr::mutate(
      base_thousands = as.numeric(base_thousands) + 1L,
      base_tens = as.numeric(sub("10", "", base_tens))
    )
}

# old --------------------------------------------------------------------------

# TODO: Follow this and get it working!!!
# https://sites.google.com/site/pointlesslargenumberstuff/home/1/extendedillions1


# Thanks:
# - https://en.wikipedia.org/wiki/Names_of_large_numbers
# - cookiefonster99 https://sites.google.com/site/pointlesslargenumberstuff/home/1/extendedillions1
# These suffixes use Conway and Guy's simplified system for `illions`.
#
# TODO: conway_and_guy(20L) should be "Novendecillion" but it's "vigintillion", fix this!
conway_and_guy <- function(thousands) {
  stopifnot(is.integer(thousands) && length(thousands) == 1L && thousands >= 0)

  if (thousands <= 11L) {
    return(
      c(
        "one", "thousand", "million", "billion", "trillion", "quadrillion",
        "quintillion", "sextillion", "septillion", "octillion", "nonillion",
        "decillion"
      )[thousands + 1L]
    )
  }
  # index <- thousands

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

  hundreds_index <- (index %/% 100) + 1
  tens_index <- ((index %/% 10) %% 10) + 1
  units_index <- (index %% 10) + 1

  out <- paste0(
    units[(thousands %% 10)],
    hundreds[(thousands %/% 100) + 1],
    tens[((thousands %/% 10) %% 10) + 1],
    "llion"
  )
  sub("allion$", "illion", out)
}

