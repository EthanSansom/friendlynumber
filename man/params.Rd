% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/params.R
\name{params}
\alias{params}
\alias{parameters}
\alias{arguments}
\alias{args}
\title{Parameter Descriptions for friendlynumber Package}
\arguments{
\item{numbers}{\verb{[integer / numeric]}

An integer or integer-ish numeric vector to translate.}

\item{one}{\verb{[character(1)]}

What to call values of \code{1} in \code{numbers} (e.g. \code{one = "the"}).}

\item{two}{\verb{[character(1)]}

What to call values of \code{2} in \code{numbers} (e.g. \code{two = "both"}).}

\item{three}{\verb{[character(1)]}

What to call values of \code{3} in \code{numbers} (e.g. \code{three = "thrice"}).}

\item{zero}{\verb{[character(1)]}

What to call values of \code{0} in \code{numbers} (e.g. \code{zero = "zero"}).}

\item{na}{\verb{[character(1)]}

What to call values of \code{NA} in \code{numbers} (e.g. \code{na = "missing"}).}

\item{nan}{\verb{[character(1)]}

What to call values of \code{NaN} in \code{numbers} (e.g. \code{nan = "undefined"}).}

\item{inf}{\verb{[character(1)]}

What to call values of \code{Inf} in \code{numbers} (e.g. \code{inf = "infinity"}).}

\item{negative}{\verb{[character(1)]}

A prefix added to the translation of negative elements of \code{numbers}.
\code{negative} is the string \code{"negative "} by default.}

\item{decimal}{\verb{[character(1)]}

A word inserted between the whole and fractional part of translated
\code{numbers}. \code{decimal} is the string \code{" and "} by default.}

\item{and}{\verb{[TRUE / FALSE]}

Whether to insert an \code{" and "} before the tens place of translated \code{numbers}.
\code{and} is \code{FALSE} by default.}

\item{hyphenate}{\verb{[TRUE / FALSE]}

Whether to hyphenate numbers 21 through 99 (e.g. \code{"twenty-one"} vs. \code{"twenty one"}).
\code{hyphenate} is \code{TRUE} by default.}

\item{and_fractional}{\verb{[TRUE / FALSE]}

Whether to insert an \code{" and "} before the smallest fractional tens place
of translated \code{numbers} (e.g. \code{"one hundred one thousandths"} vs.
\code{"one hundred and one thousandths"}).

\code{and_fractional} is equal to \code{and} by default.}

\item{hyphenate_fractional}{\verb{[TRUE / FALSE]}

Whether to hyphenate numbers 21 through 99 in the fractional part of translated
\code{numbers} (e.g. \code{"twenty-one hundredths"} or \code{"twenty one hundredths"}). This
also determines the hyphenation of the fractional units (e.g. \code{"one ten-millionth"}
vs. \code{"one ten millionth"}).

\code{hyphenate_fractional} is equal to \code{hyphenate} by default.}

\item{bigmark}{\verb{[TRUE / FALSE]}

Whether the thousands places of formatted numbers should be separated with
a comma (e.g. \code{"10,000,000"} vs. \code{"10000000"}). \code{bigmark} is \code{TRUE} by
default.}

\item{english_fractions}{\verb{[character]}

A named character vector used as a dictionary for the translation of the
fractional part of \code{numbers}. The names (i.e. keys) are the decimal digits
of a fractional number and the values are the corresponding translations.

For example \code{english_fractions = c("5" = "a half")} matches the number
\code{0.5} (translated as \code{"a half"}) and \code{2.5} (translated as \code{"two and a half"}).

By default \code{english_fractions} is a named character vector with translations
for fractions \code{x / y} for \verb{x = 1, 2, ..., 8} and \verb{y = 1, 2, ..., 9}. For
example, \code{2 / 3} is translated as \code{"two thirds"} and \code{1 / 2} is translated
as \code{"one half"}.

Provide an empty character to \code{english_fractions} to opt out of any such
translations. In this case \code{1 / 2} is translated as \code{"five tenths"} instead
of \code{"one half"}.}
}
\value{
The value \code{NULL}.
}
\description{
Default parameter descriptions which may be overridden in individual
functions.
}
\keyword{internal}
