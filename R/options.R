#' Get the default options set by the friendlynumber package
#'
#' @description
#'
#' Returns a list of options provided to `options()` when the friendlynumber
#' package is loaded. Options set prior to loading the friendlynumber package
#' are not overwritten on load.
#'
#' @return
#'
#' A named list of options.
#'
#' @examples
#' friendlynumber_default_options()
#'
#' @export
# nocov start
friendlynumber_default_options <- function() {
  list(
    friendlynumber.numeric.digits = 7,
    friendlynumber.bigfloat.digits = 7
  )
}
# nocov end
