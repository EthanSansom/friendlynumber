.onLoad <- function(libname, pkgname) {
  opts <- options()
  friendlynumber_opts <- list(
    friendlynumber.bigfloat.digits = 15
  )
  set_opts_at <- !(names(friendlynumber_opts) %in% names(opts))
  if (any(set_opts_at)) options(friendlynumber_opts[set_opts_at])
  invisible()
}
