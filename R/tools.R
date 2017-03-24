
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
#' @param warn should the function warn if it does, e.g. overwrite parameter
#'   inputs to make things work or just do it and not erport
#'

check_date_inputs <- function(from, to, warn = TRUE){
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
    if(warn){
      warning("statsgrokse(), check_date_inputs(): there is no data before 2007-12-01, from parameter will be overwritten accordingly")
    }
    from <- wp_date("2007-12-01")
  }
  if ( wp_date(to) < wp_date("2007-12-01")  ) {
    if(warn){
      warning("statsgrokse(), check_date_inputs(): there is no data before 2007-12-01, to parameter will be overwritten accordingly")
    }
    to <- wp_date("2007-12-01")
  }
  # to large a value (no data after 2015-12)
  if ( wp_date(from) > wp_date("2015-12-31")  ) {
    if(warn){
      warning("statsgrokse(), check_date_inputs(): there is no data beyond 2015-12-31, from parameter will be overwritten accordingly")
    }
    from <- wp_date("2015-12-31")
  }
  if ( wp_date(to) > wp_date("2015-12-31")  ) {
    if(warn){
      warning("statsgrokse(), check_date_inputs(): there is no data beyond 2015-12-31, to parameter will be overwritten accordingly")
    }
    to <- wp_date("2015-12-31")
  }
  # to large a value (data beyond today)
  if ( wp_date(to) > Sys.Date()  ) {
    if(warn){
      warning("statsgrokse(), check_date_inputs(): there is no data beyond today, to parameter will be overwritten accordingly")
    }
    to <- Sys.Date()
  }
  if ( wp_date(from) > Sys.Date()  ) {
    if(warn){
      warning("statsgrokse(), check_date_inputs(): there is no data beyond today, from parameter will be overwritten accordingly")
    }
    from <- Sys.Date()
  }
  return( list(from=from, to=to) )
}





jsons_to_df <- function(wp_json, page){
  # function doing the extraction work
  worker <- function(wp_json, page){
    tmp <-
      tryCatch(
        {
          jsonlite::fromJSON(wp_json)
        },
        error=function(e){
          warning("[jsons_to_df()]\nCould not extract data from server response. Data for one month will be missing.")
          message("\ndata from server was: ", wp_json, "\n")
          data.frame(stringsAsFactors = FALSE)
        }
      )
    # no data? OR some data?
    if( length(tmp$daily_views)==0 ){
      return( data.frame(stringsAsFactors = FALSE) )
    }else{
      tmp_data <-
        data.frame(
          date             = wp_date( names(tmp$daily_views) ),
          count            = unlist(tmp$daily_views),
          lang             = tmp$project,
          page             = page,
          rank             = tmp$rank,
          month            = tmp$month,
          title            = tmp$title,
          stringsAsFactors = FALSE
        )
      return(tmp_data)
    }
  }
  # case of no data
  if( length(wp_json)==0 ){
    res <- data.frame(stringsAsFactors = FALSE)
    return(unique(res))
  }
  # case of only one json
  if( length(wp_json)==1 & is.character(wp_json[[1]])){
    res <- worker(wp_json[[1]], page = page)
    suppressWarnings(res <- res[!is.na(res$date),])
    return(unique(res))
  }
  # case of multiple jsons
  if(length(wp_json)> 1 & is.character(wp_json[[1]])){
    tmp <- lapply(wp_json, worker, page = page)
    res <- do.call(rbind, tmp)
    rownames(res) <- NULL
    suppressWarnings(res <- res[!is.na(res$date),])
    return(unique(res))
  }
}

