#' function for getting data (download + extraction)
#'
#'
#' @param urls urls to be downloeded

wp_get_data <- function(urls){

  tmp <- list()

  for ( i in seq_along(urls) ){
    url       <- urls[i]
    json      <- wp_download_data(url, wait = 1)
    tmp[[i]]  <- wp_jsons_to_df(json, basename(url) )
  }

  # combine data
  res           <- do.call(rbind, tmp)
  rownames(res) <- NULL

  # return
  return(res)
}


