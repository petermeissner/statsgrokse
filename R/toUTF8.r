
#' function to convert character vectors to UTF-8 encoding
#'
#' @param x the vector to be converted


toUTF8 <-
  function(x){
    worker <- function(x){
      iconv(x,
            from = ifelse( Encoding(x)=="unknown", "",Encoding(x) ),
            to = "UTF-8")
    }
    unlist(lapply(x, worker))
  }









