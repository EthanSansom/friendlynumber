stop_unimplemented_method <- function(x, method) {
  friendlynumber_stop(
    message = paste0("No `", method, "` method implemented for class <", class(x)[1], ">."),
    "friendlynumber_error_input_type"
  )
}

check_is_string <- function(x, x_name = arg_name(x)) {
  if (is_string(x)) {
    return(x)
  }
  friendlynumber_stop(
    message = must_be_not(x, x_name, must = "a string", length = TRUE),
    class = "friendlynumber_error_input_type"
  )
}

check_is_bool <- function(x, x_name = arg_name(x)) {
  if (is_bool(x)) {
    return(x)
  }
  friendlynumber_stop(
    message = must_be_not(x, x_name, must = "`TRUE` or `FALSE`", length = TRUE),
    class = "friendlynumber_error_input_type"
  )
}

check_is_numeric <- function(x, x_name = arg_name(x)) {
  if (is.numeric(x)) {
    return(x)
  }
  friendlynumber_stop(
    message = must_be_not(x, x_name, must = "a numeric vector"),
    class = "friendlynumber_error_input_type"
  )
}

check_is_integer <- function(x, x_name = arg_name(x)) {
  if (is.integer(x)) {
    return(x)
  }
  friendlynumber_stop(
    message = must_be_not(x, x_name, must = "an integer vector"),
    class = "friendlynumber_error_input_type"
  )
}

check_is_whole <- function(x, x_name = arg_name(x)) {
  if (is_whole(x)) {
    return(x)
  }
  if (is_numericish(x)) {
    friendlynumber_stop(
      message = must_be(x_name, must = "coercible to an integer without loss of precision"),
      class = "friendlynumber_error_input_type"
    )
  }
  friendlynumber_stop(
    message = must_be_not(x, x_name, must = "an integerish vector"),
    class = "friendlynumber_error_input_type"
  )
}

# tests ------------------------------------------------------------------------

is_bool <- function(x) {
  is.logical(x) && length(x) == 1 && !anyNA(x)
}

is_string <- function(x) {
  is.character(x) && length(x) == 1 && !anyNA(x)
}

# From `chk::chk_whole_numeric()`
# https://github.com/poissonconsulting/chk/blob/a8fe0fa24a1fc68c30ef6d92c19af172fc1d5850/R/chk-whole-numeric.R#L26
is_whole <- function(x) {
  is.integer(x) || (is_numericish(x) && isTRUE(all.equal(x[!is.na(x)], trunc(x[!is.na(x)]))))
}

is_numericish <- function(x) {
  is.numeric(x) || is_bignumeric(x)
}

is_bignumeric <- function(x) {
  if (requireNamespace("bignum", quietly = TRUE)) {
    bignum::is_biginteger(x) || bignum::is_bigfloat(x)
  } else {
    inherits(x, c("bignum_biginteger", "bignum_bigfloat"))
  }
}

# error helpers ----------------------------------------------------------------

arg_name <- function(x) {
  arg <- substitute(x)
  deparse1(do.call(substitute, list(arg), envir = parent.frame()))
}

must_be <- function(x_name, must, length = FALSE, value = TRUE) {
  paste0("`", x_name, "` must be ",  must, ".")
}

must_be_not <- function(x, x_name, must, length = FALSE, value = TRUE) {
  x_type <- obj_type_friendly(x, length = length, value = value)
  paste0("`", x_name, "` must be ",  must, ", not ", x_type, ".")
}

friendlynumber_stop <- function(message, class) {
  stop(friendlynumber_error_cnd(message, class))
}

friendlynumber_error_cnd <- function(message, class = character()) {
  structure(
    class = c(class, "friendlyr_error", "error", "condition"),
    list(message = message)
  )
}

# obj_type_friendly ------------------------------------------------------------

# Adapted from r-lib/rlang script standalone-obj-type.R (version 2024-02-14):
# https://github.com/r-lib/rlang/blob/main/R/standalone-obj-type.R
#
# I've removed {rlang}-specific dependencies (e.g. `abort()`) from the function.

obj_type_friendly <- function(x, value = TRUE, length = FALSE) {
  if (is_missing(x)) {
    return("absent")
  }

  if (is.object(x)) {
    if (inherits(x, "quosure")) {
      type <- "quosure"
    } else {
      type <- class(x)[[1L]]
    }
    return(sprintf("a <%s> object", type))
  }

  if (!is.vector(x)) {
    return(as_friendly_type(typeof(x)))
  }

  n_dim <- length(dim(x))

  if (!n_dim) {
    if (!is.list(x) && length(x) == 1) {
      if (is.na(x)) {
        return(switch(
          typeof(x),
          logical = "`NA`",
          integer = "an integer `NA`",
          double =
            if (is.nan(x)) {
              "`NaN`"
            } else {
              "a numeric `NA`"
            },
          complex = "a complex `NA`",
          character = "a character `NA`",
          "an unknown type"
        ))
      }

      show_infinites <- function(x) {
        if (x > 0) {
          "`Inf`"
        } else {
          "`-Inf`"
        }
      }
      str_encode <- function(x, width = 30, ...) {
        if (nchar(x) > width) {
          x <- substr(x, 1, width - 3)
          x <- paste0(x, "...")
        }
        encodeString(x, ...)
      }

      if (value) {
        if (is.numeric(x) && is.infinite(x)) {
          return(show_infinites(x))
        }

        if (is.numeric(x) || is.complex(x)) {
          number <- as.character(round(x, 2))
          what <- if (is.complex(x)) "the complex number" else "the number"
          return(paste(what, number))
        }

        return(switch(
          typeof(x),
          logical = if (x) "`TRUE`" else "`FALSE`",
          character = {
            what <- if (nzchar(x)) "the string" else "the empty string"
            paste(what, str_encode(x, quote = "\""))
          },
          raw = paste("the raw value", as.character(x)),
          "an unknown type"
        ))
      }

      return(switch(
        typeof(x),
        logical = "a logical value",
        integer = "an integer",
        double = if (is.infinite(x)) show_infinites(x) else "a number",
        complex = "a complex number",
        character = if (nzchar(x)) "a string" else "\"\"",
        raw = "a raw value",
        "an unknown type"
      ))
    }

    if (length(x) == 0) {
      return(switch(
        typeof(x),
        logical = "an empty logical vector",
        integer = "an empty integer vector",
        double = "an empty numeric vector",
        complex = "an empty complex vector",
        character = "an empty character vector",
        raw = "an empty raw vector",
        list = "an empty list",
        "an unknown type"
      ))
    }
  }

  vec_type_friendly(x, length = length)
}

vec_type_friendly <- function(x, length = FALSE) {
  if (!is.vector(x)) {
    stop("`x` must be a vector.")
  }
  type <- typeof(x)
  n_dim <- length(dim(x))

  add_length <- function(type) {
    if (length && !n_dim) {
      paste0(type, sprintf(" of length %s", length(x)))
    } else {
      type
    }
  }

  if (type == "list") {
    if (n_dim < 2) {
      return(add_length("a list"))
    } else if (is.data.frame(x)) {
      return("a data frame")
    } else if (n_dim == 2) {
      return("a list matrix")
    } else {
      return("a list array")
    }
  }

  type <- switch(
    type,
    logical = "a logical %s",
    integer = "an integer %s",
    numeric = ,
    double = "a double %s",
    complex = "a complex %s",
    character = "a character %s",
    raw = "a raw %s",
    type = paste0("a ", type, " %s")
  )

  if (n_dim < 2) {
    kind <- "vector"
  } else if (n_dim == 2) {
    kind <- "matrix"
  } else {
    kind <- "array"
  }
  out <- sprintf(type, kind)

  if (n_dim >= 2) {
    out
  } else {
    add_length(out)
  }
}

as_friendly_type <- function(type) {
  switch(
    type,

    list = "a list",

    NULL = "`NULL`",
    environment = "an environment",
    externalptr = "a pointer",
    weakref = "a weak reference",
    S4 = "an S4 object",

    name = ,
    symbol = "a symbol",
    language = "a call",
    pairlist = "a pairlist node",
    expression = "an expression vector",

    char = "an internal string",
    promise = "an internal promise",
    ... = "an internal dots object",
    any = "an internal `any` object",
    bytecode = "an internal bytecode object",

    primitive = ,
    builtin = ,
    special = "a primitive function",
    closure = "a function",

    type
  )
}

is_missing <- function(x) {
  missing(x) || identical(x, quote(expr = ))
}
