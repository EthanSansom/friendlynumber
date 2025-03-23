

illions <- function(thousands_power) {
  out <- character(length(thousands_power))

  smallillions <- c(
    "thousand", "million", "billion", "trillion", "quadrillion",
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

  small <- thousands_power <= 10
  big <- !small
  out[small] <- smallillions[thousands_power[small]]

  big_thousands <- thousands_power[big] - 1

  hundreds_index <- (big_thousands %/% 100) + 1
  tens_index <- ((big_thousands %/% 10) %% 10) + 1
  units_index <- (big_thousands %% 10) + 1

  out[big] <- sub("allion$", "illion", paste0(
    units[units_index],
    hundreds[hundreds_index],
    tens[tens_index],
    "llion"
  ))
  out
}

# 1	Un        Deci	        Centi
# 2	Duo       Viginti	      Ducenti
# 3	Tre       Triginta      Trecenti
# 4	Quattuor  Quadraginta   Quadringenti
# 5	Quinqua   Quinquaginta	Quingenti
# 6	Se        Sexaginta	    Sescenti
# 7	Septe     Septuaginta	  Septingenti
# 8	Octo      Octoginta	    Octingenti
# 9	Nove	   Nonaginta	    Nongenti

my_illions <- illions(1:1004)

illions_table |>
  dplyr::mutate(us_name = tolower(us_name)) |>
  dplyr::bind_cols(my_illions = my_illions) |>
  dplyr::filter(us_name != my_illions) |>
  dplyr::mutate(diff = str_diff(us_name, my_illions)) |>
  View()

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

