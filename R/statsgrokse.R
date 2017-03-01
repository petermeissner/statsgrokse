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
#'
#'
#'
#' @export

statsgrokse <-
  function(
    page ,
    from        = prev_month_start(),
    to          = prev_month_end(),
    lang        = "en"
){

  # input check
  stopifnot( length(page)==length(lang) | length(lang)==1 )
  stopifnot( all( !is.na(page) ), all( !is.na(lang) ) )

  # check dates
  from <- wp_check_date_inputs(from, to)$from
  to   <- wp_check_date_inputs(from, to)$to

  # check page
  page <- stringr::str_replace( page, "^.", substring(toupper(page),1,1) )
  page <- stringr::str_replace( page, " ", "_" )
  for( i in seq_along(page) ){
    if ( !stringr::str_detect( page[i], "%" ) ){
      page[i] <- utils::URLencode(page[i])
    }
  }

  # prepare URLs
  urls <-
    wp_prepare_urls(
      page = page,
      from = from,
      to   = to,
      lang = lang
    )

  # download data and extract data
  res <- wp_get_data(urls)

  # return
  return(res)
}




