.onLoad <- function(libname, pkgname) {
  opts <- options()
  friendlynumber_opts <- list(
    friendlynumber.numeric.digits = 7,
    friendlynumber.bigfloat.digits = 7
  )
  set_opts_at <- !(names(friendlynumber_opts) %in% names(opts))
  if (any(set_opts_at)) options(friendlynumber_opts[set_opts_at])
  invisible()
}
