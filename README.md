
<!-- README.md is generated from README.Rmd. Please edit that file -->

# friendlynumber

<!-- badges: start -->
<!-- badges: end -->

{friendlynumber} translates vectors of numbers into character vectors of
English numerals (AKA number words). Supported numerals include:

- Cardinals: one, ten and two thirds, one thousand twenty-one
- Ordinals: first, second, one millionth, 1st, 2nd, 1,000,000th
- Counts: no times, once, twice, three times
- Quantifiers: no, the, both, all three, all 999, every

{friendlynumber} functions are intended to be used internally by other
functions (e.g. for generating friendly error messages). To this end,
{friendlynumber} is writing in base R and has no Imports.

## Installation

You can install the development version of {friendlynumber} from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("EthanSansom/friendlynumber")
```

## Features

``` r
library(friendlynumber)
```

### Cardinal Numerals

`number_friendly()` is an S3 generic which converts numbers in `R` into
cardinal numerals.

``` r
number_friendly(c(0:3, 2/3, 1/100, NA, NaN, Inf))
#> [1] "zero"          "one"           "two"           "three"        
#> [5] "two thirds"    "one hundredth" "missing"       "not a number" 
#> [9] "infinity"
```

`number_friendly()` currently defines methods for four types of numbers:

- Base `<integer>` vectors
- Base `<numeric>` vectors
- [{bignum}](https://davidchall.github.io/bignum/) `<bignum_biginteger>`
  vectors, which can store arbitrarily large integers
- {bignum} `<bignum_bigfloat>` vectors, which store numbers with 50
  decimal digits of precision

Each method has a corresponding standalone `*_friendly()` function which
expects a number of a specific class.

``` r
number_friendly(1L)                     # integerish_friendly()
#> [1] "one"
```

``` r
number_friendly(1.0)                    # numeric_friendly()
#> [1] "one"
```

``` r
number_friendly(bignum::biginteger(1L)) # biginteger_friendly()
#> [1] "one"
```

``` r
number_friendly(bignum::bigfloat(1.0))  # bigfloat_friendly()
#> [1] "one"
```

### Other Numerals

{friendlynumber} provides an additional set of functions for translating
whole numbers (e.g. `1L` or `1.00`) into common numeral types.

``` r
# Ordinals
ordinal_friendly(0:5)
#> [1] "zerothth" "first"    "second"   "third"    "fourth"   "fifth"
```

``` r

# Numeric Ordinals
nth_friendly(0:5)
#> [1] "zeroth" "1st"    "2nd"    "3rd"    "4th"    "5th"
```

``` r

# Counts
ntimes_friendly(0:5)
#> [1] "no times"    "once"        "twice"       "three times" "four times" 
#> [6] "five times"
```

``` r

# Quantifiers
quantifier_friendly(0:5)
#> [1] "no"        "the"       "both"      "all three" "all four"  "all five"
```

### Precision

{friendlynumber} provides two `options()` for setting the number of
decimals that {friendlynumber} function report.

``` r
options(
  friendlynumber.numeric.digits = 3, # Effects `<numeric>` numbers
  friendlynumber.bigfloat.digits = 5 # Effects `<bignum_bigfloat>` numbers
)

numeric_friendly(0.12345)
#> [1] "one hundred twenty-three thousandths"
```

``` r
bigfloat_friendly(bignum::bigfloat(0.12345))
#> [1] "twelve thousand three hundred forty-five hundred-thousandths"
```

`format_number()` is a utility function which formats numbers via
`format()` and abides by these options.

``` r
format_number(0.12345)
#> [1] "0.123"
```

``` r
format_number(bignum::bigfloat(0.12345))
#> [1] "0.12345"
```

This is useful for verifying whether unexpected results are a
consequence of precision issues. For instance, look what happens when we
attempt to translate the number “ten billion and one
hundred-thousandth”.

``` r
options(
  friendlynumber.numeric.digits = 7, 
  friendlynumber.bigfloat.digits = 7
)

numeric_friendly(10000000000.00001)
#> [1] "ten billion and ninety-five ten-millionths"
```

``` r
bigfloat_friendly(bignum::bigfloat("10000000000.00001"))
#> [1] "ten billion and one hundred-thousandth"
```

We can use `format_number()` to confirm that, on my machine, a
`<numeric>` vector lacks the precision to store this number accurately.

``` r
format_number(10000000000.00001)
#> [1] "10,000,000,000.0000095"
```

``` r
format_number(bignum::bigfloat("10000000000.00001"))
#> [1] "10,000,000,000.00001"
```

Similar problems can arise when working with whole numbers. Consider the
number “ten quadrillion” minus one.

``` r
numeric_friendly(10000000000000000 - 1)
#> [1] "ten quadrillion"
```

``` r
biginteger_friendly(bignum::biginteger("10000000000000000") - 1L)
#> [1] "nine quadrillion nine hundred ninety-nine trillion nine hundred ninety-nine billion nine hundred ninety-nine million nine hundred ninety-nine thousand nine hundred ninety-nine"
```

## Advantages

{friendlynumber} is faster than other alternatives written in base R -
such as the
[{english}](https://cran.r-project.org/web/packages/english/index.html)
and [{nombre}](https://nombre.rossellhayes.com/) packages.

``` r
# Scalar (small)
bench::mark(
  english = as.character(english::english(1L)),
  nombre = as.character(nombre::nom_card(1L)),
  friendlynumber = as.character(number_friendly(1L))
)[1:6]
#> # A tibble: 3 × 6
#>   expression          min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>     <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 english          89.2µs  92.72µs    10638.     140KB     33.8
#> 2 nombre          121.5µs 125.38µs     7837.     685KB     29.3
#> 3 friendlynumber    6.6µs   7.26µs   134007.        0B     53.6
```

``` r

# Scalar (large)
bench::mark(
  english = as.character(english::english(100000)),
  nombre = as.character(nombre::nom_card(100000)),
  friendlynumber = as.character(number_friendly(100000))
)[1:6]
#> # A tibble: 3 × 6
#>   expression          min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>     <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 english         173.6µs    179µs     5492.    8.26KB     25.1
#> 2 nombre          126.4µs    130µs     7557.        0B     31.7
#> 3 friendlynumber   34.6µs     36µs    27316.        0B     30.1
```

``` r

# Vector
bench::mark(
  english = as.character(english::english(1:10000)),
  nombre = as.character(nombre::nom_card(1:10000)),
  friendlynumber = as.character(integerish_friendly(1:10000)),
  filter_gc = FALSE
)[1:6]
#> # A tibble: 3 × 6
#>   expression          min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>     <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 english           1.24s    1.24s     0.805    2.34MB    12.9 
#> 2 nombre          44.91ms  47.72ms    21.4     11.43MB    11.7 
#> 3 friendlynumber   8.93ms   9.16ms   104.       3.87MB     7.87
```

To increase the speed of processing scalar inputs, the set of
`*_friendly()` functions do not check that their arguments are of valid
types. All `*_friendly()` functions have a (very-slightly) slower
`*_friendly_safe()` alternative which confirms that it’s arguments are
of the correct type and emits an informative error otherwise.

``` r
try(integerish_friendly_safe(1/2))
#> Error : `numbers` must be coercible to an integer without loss of precision.
```

When used with the {bignum} package, {friendlynumber} is capable of
translating extremely large numbers into cardinal numerals. Here, we
translate a number equal to 1 followed by three thousand and three 0’s.

``` r
number_friendly(bignum::biginteger(10L)^3003L)
#> [1] "one millinillion"
```

## Inspiration

This package was originally inspired by the
[{english}](https://cran.r-project.org/web/packages/english/index.html)
package by John Fox, Bill Venables, Anthony Damico and Anne Pier
Salverda, which spurred my brief fixation with the programming puzzle of
converting numbers to numerals.

Several functions in {friendlynumber} were inspired by Alexander Rossell
Hayes’ [{nombre}](https://nombre.rossellhayes.com/) package:

- `ntimes_friendly()` is based on
  [nombre::adverbial()](https://nombre.rossellhayes.com/reference/adverbial.html)
- `quantifier_friendly()` is based on
  [nombre::collective()](https://nombre.rossellhayes.com/reference/collective.html)

The following sources were very helpful for naming extremely large
numbers:

- The blog [Pointless Large Number
  Stuff](https://sites.google.com/site/pointlesslargenumberstuff/home/1/extendedillions1)
  by cookiefonster informed the naming of numbers larger than 1,000,000
- Robert Munafo’s writing on the [Conway-Wechsler
  system](https://www.mrob.com/pub/math/largenum.html#conway-wechsler)
  for naming arbitrarily large numbers was used for the naming of
  numbers greater than 10^3003
- Steve Olsen’s table of [“Big-Ass
  Numbers”](https://www.olsenhome.com/bignumbers/) was very helpful for
  testing `number_friendly()`
