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

#' function downloading content
#' @param url url to content
#' @param ... further arguments passed trough to httr::GET()
html2 <- function(url, ...){
    xml2::read_html(url, ...)
}
