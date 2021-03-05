#' Function that converts a vector to an English language list: e.g. 1:3 becomes 1, 2 and 3
#' @param x input vector to convert
#' @param andVal string to put between penultimate and last entry
#' @param quoted logical indicating whether each item should be quoted and hence
#' @param quoteChar string to put around each item to quote it
#'
#' @return string
#' @export
#'
#' @examples
#' convertVector2sentence(1:4)
#'
#' @family text utilities
#' @family converting utilities
#' @seealso \code{\link{hyphenateWords}} for another utility function to convert numbers to English words, e.g. "87" to "eighty-seven".
#'
#' @author Chris Evans
#'
convertVector2sentence <- function(x, andVal = " and ", quoted = FALSE, quoteChar = '"'){
  ### takes a vector x, say c(1,2,3,4) and returns
  ### a character variable "1,2,3 and 4"
  ### where "and" will be andVal (so you can use "&")
  ### CE 20200815 adding "quoted" which allows you to quote each entry separately
  ### CE 20201215 added quoteChar so I can quote with ', " or * (or anything!)
  if (quoted) {
    ### need to create the quoted separators
    ### first to put between comma separated values
    quotedComma <- paste0(quoteChar,
                          ", ",
                          quoteChar)
    ### and create the quoted andVal
    quotedAnd <- paste0(quoteChar,
                        andVal,
                        quoteChar)
  } else {
    quoteChar <- ""
  }
  ### now we can move to handle the vector
  if (length(x) == 1){
    ### just one value in the vector
    if (quoted) {
      return(paste0(quoteChar,
                    x,
                    quoteChar))
    } else {
      return(x)
    }
  }
  if (length(x) == 2){
    ### two values, very easy
    if (quoted) {
      return(paste0(quoteChar,
                    x[1],
                    quotedAnd,
                    x[2],
                    quoteChar))
    } else {}
    return(paste0(x[1],
                  andVal,
                  x[2]))
  }
  ### OK, if we get here we have more than two values in the vector
  ### so need to parse them to handle the last value correctly and put in the and separator correctly
  len <- length(x)
  endItem <- x[len] # last value
  earlyItems <- x[-len] # earlier items
  if (quoted){
    earlyItems <- paste0(x[-len],
                         collapse = quotedComma)
    ### got to add the initial quote
    earlyItems <- paste0(quoteChar,
                         earlyItems)
    endItem <- paste0(quotedAnd,
                      endItem,
                      quoteChar)
  } else {
    earlyItems <- paste0(x[-len],
                         collapse = ", ")
    ### got to add the initial quote
    earlyItems <- paste0(quoteChar,
                         earlyItems)
    endItem <- paste0(andVal,
                      endItem)
  }
  ### now put the last item on
  allItems <- paste0(earlyItems, endItem)
  ### now return the result (for length(x) > 2, had already dealt with shorter vectors)
  allItems
}
