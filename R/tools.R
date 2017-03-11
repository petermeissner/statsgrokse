
#' function downloading content
#' @param url url to content
#' @param ... further arguments passed trough to httr::GET()
html <- function(url, ...){
  httr::content(
    httr::GET(url, ...),
    type="text/plain",
    encoding="UTF-8"
  )
}


#' function for pasting together the HTTP user-agent field
#'
#' @export


http_header <- function(){
  list(
    'user-agent' =
      paste0(
        R.version$version.string, " ",
        "statsgrokse/", utils::packageVersion("statsgrokse"), " ",
        "httr/", utils::packageVersion("httr")
      )
  )
}



#' Helper function for statsgrokse() that transforms a time span into a series
#' of months
#'
#' @param from start of timespan
#' @param to end of timespan
#' @param by in which time unit expansion should take place: \code{"day"},
#'   \code{"month"}, \code{"year"}
#'

expand_ts <- function(from, to, by="day"){
  dates <- seq(wp_date(from), wp_date(to), by)
  return(dates)
}


#' vectorized version of expand_ts()
#'
#' @inheritParams expand_ts
#'
#' @rdname exapnd_ts
#'

expand_ts_v <-
  Vectorize(
    FUN            = expand_ts,
    vectorize.args = c("from", "to"),
    USE.NAMES      = FALSE,
    SIMPLIFY       = FALSE
  )










#' Helper function for statsgrokse()
#'
#' @param from first date of timespan to check
#' @param to second date of timespan to check
#'
#'

check_date_inputs <- function(from, to){
  from <- as.character(from)
  to   <- as.character(to)
  # could it be parsed?
  if( is.na(wp_date(from)) ){
    stop("from parameter could not be parsed, sure the date exists?")
  }
  if( is.na(wp_date(to  )) ){
    stop("to parameter could not be parsed, sure the date exists?")
  }
  # from larger than to
  if ( !(wp_date(from) <= wp_date(to)) ) {
    stop("In check_date_inputs: from-date larger than to-date.")
  }
  # to small a value (no data before 2007)
  if ( wp_date(from) < wp_date("2007-12-01")  ) {
    from <- wp_date("2007-12-01")
  }
  if ( wp_date(to) < wp_date("2007-12-01")  ) {
    to <- wp_date("2007-12-01")
  }
  # to large a value (data beyond today)
  if ( wp_date(to) > Sys.Date()  ) {
    to <- Sys.Date()
  }
  if ( wp_date(from) > Sys.Date()  ) {
    from <- Sys.Date()
  }
  return( list(from=from, to=to) )
}

