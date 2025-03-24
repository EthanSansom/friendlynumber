integer_friendly <- function(
    numbers,
    zero = "zero",
    na = "missing",
    nan = "not a number",
    inf = "infinity",
    negative = "negative",
    and = FALSE,
    hyphenate = TRUE
) {

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
    out[negatives] <- paste(negative, inf) # Only `Inf` can be -ve at this point
    return(out)
  }

  remaining_numbers <- abs(numbers[needs_englishifying])
  if (all(remaining_numbers < 1000)) {
    out[needs_englishifying] <- english_hundreds(remaining_numbers)
    out[negatives] <- paste(negative, out[negatives])
    return(out)
  }

  out[needs_englishifying] <- english_naturals(
    numbers = remaining_numbers,
    prefixes = character(length(remaining_numbers))
  )
  out[negatives] <- paste(negative, out[negatives])

  out <- trimws(out)
  if (and) out <- and(out)
  if (!hyphenate) out <- unhypenate(out)
  out
}

# NOTE: I was going to make a `scalar_integer_friendly()` version but I can't
# imagine any potential speed-up would be worthwhile.
if (FALSE) {
  bench::mark(
    na = integer_friendly(NA),
    nan = integer_friendly(NaN),
    inf = integer_friendly(Inf),
    ten = integer_friendly(10),
    million = integer_friendly(1000000),
    check = FALSE
  )
  # expression      min  median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time result memory     time       gc
  # <bch:expr> <bch:tm> <bch:t>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm> <list> <list>     <list>     <list>
  #   1 na           3.03µs  3.48µs   255715.        0B     51.2  9998     2     39.1ms <NULL> <Rprofmem> <bench_tm> <tibble>
  #   2 nan          2.95µs  3.32µs   279123.        0B     27.9  9999     1     35.8ms <NULL> <Rprofmem> <bench_tm> <tibble>
  #   3 inf          2.95µs  3.32µs   284408.        0B     56.9  9998     2     35.2ms <NULL> <Rprofmem> <bench_tm> <tibble>
  #   4 ten          4.71µs  5.21µs   184753.        0B     55.4  9997     3     54.1ms <NULL> <Rprofmem> <bench_tm> <tibble>
  #   5 million     36.28µs 38.17µs    25436.        0B     30.6  9988    12    392.7ms <NULL> <Rprofmem> <bench_tm> <tibble>

  bench::mark(
    english_one = as.character(english::english(1)),
    nom_one = as.character(nombre::nom_card(1)),
    friendly_one = as.character(integer_friendly(1)),
    english_mill = as.character(english::english(1000000)),
    nom_mill = as.character(nombre::nom_card(1000000)),
    friendly_mill = as.character(integer_friendly(1000000)),
    check = FALSE
  )
  # expression         min   median `itr/sec` mem_alloc `gc/sec` n_itr  n_gc total_time result memory     time
  # <bch:expr>    <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl> <int> <dbl>   <bch:tm> <list> <list>     <list>
  #   1 english_one       90µs  94.42µs    10081.        0B     34.8  4350    15      432ms <NULL> <Rprofmem> <bench_tm>
  #   2 nom_one       119.64µs 128.53µs     6820.        0B     20.1  2721     8      399ms <NULL> <Rprofmem> <bench_tm>
  #   3 friendly_one    4.76µs   5.29µs   181890.        0B     36.4  9998     2       55ms <NULL> <Rprofmem> <bench_tm>
  #   4 english_mill  142.84µs 148.11µs     6657.        0B     12.6  3172     6      476ms <NULL> <Rprofmem> <bench_tm>
  #   5 nom_mill       124.6µs 130.13µs     7513.        0B     17.1  3519     8      468ms <NULL> <Rprofmem> <bench_tm>
  #   6 friendly_mill  36.08µs  38.17µs    25516.        0B     15.3  9994     6      392ms <NULL> <Rprofmem> <bench_tm>
}




