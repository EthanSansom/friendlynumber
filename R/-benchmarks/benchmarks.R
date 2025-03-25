# setup ------------------------------------------------------------------------

# TODO: Move functionality to `benchmarks.qmd`
load_all()

# between packages -------------------------------------------------------------

# Scalar (small number)
bench::mark(
  english = as.character(english::english(1)),
  nombre = as.character(nombre::nom_card(1)),
  integer_friendly = as.character(integer_friendly(1)),
  numeric_friendly = as.character(numeric_friendly(1))
)[c("expression", "median", "itr/sec", "gc/sec")]

# Scalar (small compound fractional)
bench::mark(
  nombre = as.character(nombre::nom_card(1.1)),
  numeric_friendly = as.character(numeric_friendly(1.1))
)[c("expression", "median", "itr/sec", "gc/sec")]

# Scalar (small fractional)
bench::mark(
  nombre = as.character(nombre::nom_card(0.1)),
  numeric_friendly = as.character(numeric_friendly(0.1))
)[c("expression", "median", "itr/sec", "gc/sec")]

# Scalar (very small fractional)
bench::mark(
  nombre = as.character(nombre::nom_card(0.0000001)),
  numeric_friendly = as.character(numeric_friendly(0.0000001)),
  check = FALSE
)[c("expression", "median", "itr/sec", "gc/sec")]

# Scalar (large number)
bench::mark(
  english = as.character(english::english(1000000000)),
  nombre = as.character(nombre::nom_card(1000000000)),
  integer_friendly = as.character(integer_friendly(1000000000)),
  numeric_friendly = as.character(numeric_friendly(1000000000))
)[c("expression", "median", "itr/sec", "gc/sec")]

# Medium-length
x <- 1:10000
bench::mark(
  english = as.character(english::english(x)),
  nombre = as.character(nombre::nom_card(x)),
  integer_friendly = as.character(integer_friendly(x)),
  numeric_friendly = as.character(numeric_friendly(x))
)[c("expression", "median", "itr/sec", "gc/sec")]
