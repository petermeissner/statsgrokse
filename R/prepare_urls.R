#' function preparing URLs for downlaod
#'
#' @param df data.frame defining with columns page, from, to, lang
#'

prepare_urls <- function(df){

  # expand from-date and to-date to sequence of days // yearmonths
  timeframe <- expand_ts_v(from = df$from, to = df$to, by = "day")
  timeframe <- lapply(timeframe, function(x){unique(wp_yearmonth(x))})


  # add time frame to df
  request_data <- list()
  for( i in seq_len(nrow(df)) ){
    request_data[[i]] <-
      data.frame(
        date             = timeframe[[i]],
        lang             = df$lang[i],
        page             = df$page[i],
        stringsAsFactors = FALSE
      )
  }
  request_data <- do.call(rbind, request_data)


  # prepare urls for download
  urls <-
    apply(
      X        = request_data,
      MARGIN   = 1,
      FUN      = paste,
      collapse = "/"
    )


  # check if there is something to download at all
  if( length(urls) > 0 ){
    urls <- unique(paste0("http://stats.grok.se/json/", urls))
  }else{
    urls <- NULL
  }


  # return
  return(urls)
}

