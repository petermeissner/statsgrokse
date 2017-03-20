#' Function for getting access statistics for wikipedia pages from stats.grok.se
#'
#'
#' @param page The name of the Wikipedia page as to be found in the URL to the
#'   wikipedia article. If e.g. the URL is:
#'   \code{https://en.wikipedia.org/wiki/Peter_Fox_(musician)}, than the page
#'   name equals to \code{Peter_Fox_(musician)}.
#'
#' @param lang The language shorthand identifying which Wikipedia access
#'   statistics are to be used: e.g. \code{"en"} for the English version found
#'   at https://en.wikipedia.org, \code{"de"} for the German version found at
#'   https://de.wikipedia.org or perhaps \code{"als"} for the Alemannic dialect
#'   found under https://als.wikipedia.org/.
#'
#' @param from The starting date of the timespan for which access statistics
#'   should be retrieved - note that there is no data prior to 2007-12-01.
#'   Supply some sort of timestamp e.g. of class POSIXlt, POSIXct, Date, or
#'   character. If the option is of type character it should be in the form of
#'   yyyy-mm-dd.
#'
#' @param to The last date for which access statistics should be retrieved.
#'   Supply some sort of timestamp e.g. of class POSIXlt, POSIXct, Date, or
#'   character. If the option is of type character it should be in the form of
#'   yyyy-mm-dd.
#'
#' @param warn should the function warn if it does, e.g. overwrite parameter
#'   inputs to make things work or just do it and not erport
#'
#' @param verbose should function report freely on what it is doing or not
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(statsgrokse)
#' pageviews <-
#'   statsgrokse(
#'     page = "Edward_Snowden",
#'     from = "2013-06-01",
#'     to   = "2013-07-31",
#'     lang = c("en","de")
#'   )
#' }

statsgrokse <-
  function(
    page,
    from,
    to,
    lang        = "en",
    verbose     = TRUE,
    warn        = TRUE
){

  # check dates
  from <- check_date_inputs(from, to)$from
  to   <- check_date_inputs(from, to)$to

  # check page
  page <- check_page_inputs(page)

  # expand combinations
  df <- data.frame(page, from, to, lang, stringsAsFactors = FALSE)

  # download data and extract data
  res <- get_data(df, verbose=verbose)

  # return
  return(res)
}




#' function for getting data (download + extraction)
#'
#' @param df data.frame defining with columns page, from, to, lang
#' @inheritParams statsgrokse

get_data <- function(df, verbose=TRUE){

  urls <- prepare_urls(df)

  tmp <- list()

  for ( i in seq_along(urls) ){
    url       <- urls[i]
    json      <- download_data(url, wait = 1, verbose = verbose)
    tmp[[i]]  <- jsons_to_df(json, basename(url) )
  }

  # combine data
  res           <- do.call(rbind, tmp)
  rownames(res) <- NULL

  # return
  return(res)
}




#' helperp function for statsgrokse() that checks and corrects page input
#'
#' @param page the page titles to be checked
#'
check_page_inputs <- function(page){

  # make first letter uppercase
  page <- stringr::str_replace( page, "^.", substring(toupper(page),1,1) )

  # make spaces undescore instead
  page <- stringr::str_replace( page, " ", "_" )

  # check if url encoding is necessary
  for( i in seq_along(page) ){
    if ( !stringr::str_detect( page[i], "%" ) ){
      page[i] <- utils::URLencode(page[i])
    }
  }

  # return
  return(page)
}




#' function downloading prepared URLs
#'
#' @param urls a vector of urls to be downloaded
#' @param wait the time to wait in seconds before downloading the next chunk (default=1)
#' @inheritParams statsgrokse

download_data <- function(urls, wait=1, verbose=TRUE){
  # make http requests
  jsons <- list()
  # looping
  for(i in seq_along(urls)){
    jsons <- c(
      jsons,
      try(
        html( #### todo: make dependency explicit
          urls[i],
          httr::user_agent(http_header()$`user-agent`)
        )
      )
    )
    if(verbose){
      message(urls[i])
    }
    Sys.sleep(wait)
  }
  # return
  return(jsons)
}

