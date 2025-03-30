
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
packages (e.g. for generating friendly error messages). To this end,
{friendlynumber} is written in base R and has no Imports.

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

`number_friendly()` defines methods for four number classes included in
base `R` and the [{bignum}](https://davidchall.github.io/bignum/)
package:

- Base `<integer>` and `<numeric>` vectors
- {bignum} `<bignum_biginteger>` vectors, which can store arbitrarily
  large integers
- {bignum} `<bignum_bigfloat>` vectors, which store numbers with 50
  decimal digits of precision

Each method has a corresponding standalone `*_friendly()` function which
expects a number of a specific class.

``` r
number_friendly(1L)                     # integerish_friendly()
#> [1] "one"
number_friendly(1.0)                    # numeric_friendly()
#> [1] "one"
number_friendly(bignum::biginteger(1L)) # biginteger_friendly()
#> [1] "one"
number_friendly(bignum::bigfloat(1.0))  # bigfloat_friendly()
#> [1] "one"
```

### Other Numerals

{friendlynumber} provides an additional set of functions for translating
whole numbers (e.g. `1L` or `1.00`) into common numeral types.

``` r
# Ordinals
ordinal_friendly(0:4)
#> [1] "zeroth" "first"  "second" "third"  "fourth"

# Numeric Ordinals
nth_friendly(0:4)
#> [1] "0th" "1st" "2nd" "3rd" "4th"

# Counts
ntimes_friendly(0:4)
#> [1] "no times"    "once"        "twice"       "three times" "four times"

# Quantifiers
quantifier_friendly(0:4)
#> [1] "no"        "the"       "both"      "all three" "all four"
```

### Precision

{friendlynumber} provides two `options()` for setting the number of
decimals that {friendlynumber} functions report.

``` r
options(
  friendlynumber.numeric.digits = 3, # Effects `<numeric>` numbers
  friendlynumber.bigfloat.digits = 5 # Effects `<bignum_bigfloat>` numbers
)

numeric_friendly(0.12345)
#> [1] "one hundred twenty-three thousandths"
bigfloat_friendly(bignum::bigfloat(0.12345))
#> [1] "twelve thousand three hundred forty-five hundred-thousandths"
```

`format_number()` is a utility function which formats numbers via
`format()` and abides by these options.

``` r
format_number(0.12345)
#> [1] "0.123"
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
bigfloat_friendly(bignum::bigfloat("10000000000.00001"))
#> [1] "ten billion and one hundred-thousandth"
```

We can use `format_number()` to confirm that, on my machine, a
`<numeric>` vector lacks the precision to store this number accurately.

``` r
format_number(10000000000.00001)
#> [1] "10,000,000,000.0000095"
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
#> 1 english          89.1µs  93.28µs    10476.     140KB     33.8
#> 2 nombre            120µs 126.89µs     7651.     685KB     29.4
#> 3 friendlynumber    6.6µs   7.34µs   128386.        0B     38.5
# Scalar (large)
bench::mark(
  english = as.character(english::english(100000)),
  nombre = as.character(nombre::nom_card(100000)),
  friendlynumber = as.character(number_friendly(100000))
)[1:6]
#> # A tibble: 3 × 6
#>   expression          min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr>     <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 english         175.3µs    180µs     5450.    8.26KB     25.1
#> 2 nombre            126µs    131µs     7479.        0B     33.8
#> 3 friendlynumber   34.6µs     36µs    27355.        0B     30.1
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
#> 1 english           1.25s    1.25s     0.801    2.34MB    12.8 
#> 2 nombre           45.1ms  47.91ms    21.0     11.43MB    13.4 
#> 3 friendlynumber   8.92ms    9.2ms   103.       3.87MB     7.90
```

To increase the speed of processing scalar inputs, the set of
`*_friendly()` functions do not check that their arguments are of valid
types. All `*_friendly()` functions have a slightly slower
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
Salverda, which spurred my fixation with the programming puzzle of
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
  by @cookiefonster informed the naming of numbers larger than 1,000,000
- Robert Munafo’s writing on the [Conway-Wechsler
  system](https://www.mrob.com/pub/math/largenum.html#conway-wechsler)
  for naming arbitrarily large numbers was used for the naming of
  numbers 10^3003 and larger
- Steve Olsen’s table of [“Big-Ass
  Numbers”](https://www.olsenhome.com/bignumbers/) was used for testing
  `number_friendly()`
