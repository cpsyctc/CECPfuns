#' Function that converts a vector to an English language list:
#'   e.g. 1:3 becomes 1, 2 and 3
#' @param x input vector or one dimensional list to convert
#' @param andChar string to put between penultimate and last entry
#' @param quoted logical indicating whether each item should be
#'   quoted and hence
#' @param quoteChar string to put around each item to quote it
#' @param italicY logical to have items italicised
#' @return string
#' @export
#'
#' @examples
#' ### default behaviour
#' convertVector2sentence(1:4)
#' ### [1] "1, 2, 3 and 4"
#'
#' ### default behaviour
#' convertVector2sentence(1:4, quoted = TRUE)
#' ### [1] "\"1\", \"2\", \"3\" and \"4\""
#'
#' ### change andChar (note the spaces,
#' ###  I can't see why you wouldn't want them but ...)
#' convertVector2sentence(1:4, andChar = ' & ')
#' ### [1] "1, 2, 3 & 4"
#'
#' ### change the quoting character (note no spaces)
#' convertVector2sentence(1:4, quoted = TRUE, quoteChar = "'")
#' ### [1] "'1', '2', '3' and '4'"
#'
#' convertVector2sentence(1:4, italicY = TRUE) # italicises the items
#' ### and now italics and quotation:
#' convertVector2sentence(1:4, italicY = TRUE, quoted = TRUE)
#'
#' @family text utilities
#' @family converting utilities
#' @seealso \code{\link{hyphenateWords}} for another utility function to
#'  convert numbers to English words, e.g. "87" to "eighty-seven".
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Started before 5.iv.21
#' 10.iv.21: added synonym convertVectorToSentence
#'
convertVector2sentence <- function(x,
                                   andChar = " and ",
                                   quoted = FALSE,
                                   quoteChar = '"',
                                   italicY = FALSE) {
  ### takes a vector x, say c(1,2,3,4) and returns
  ### a character variable "1,2,3 and 4"
  ### where "and" will be andChar (so you can use "&")
  ### CE 20200815 adding "quoted" which allows you to quote each entry separately
  ### CE 20201215 added quoteChar so I can quote with ', " or * (or anything!)
  ### CE 20210306 added sanity checking on input and then a test-convertVector2sentence.R file
  ### sanity check 1
  if (!checkIsOneDim(x) | length(x) == 1 | is.list(x)) {
    stop("x must be vector or single dimension list and vector of length 1 input is unlikely to parse as you want so it throws an error")
  }
  ### sanity check 2
  if (!is.character(andChar) | length(andChar) > 1) {
    stop("andChar must be character of length 1")
  }
  ### sanity check 3
  if (!is.character(quoteChar) | length(quoteChar) > 1) {
    stop("quoteChar must be character of length 1")
  }
  ### sanity check 4
  if (!is.logical(quoted)) {
    stop("quoted must be logical: 'TRUE', 'FALSE' or, less safely, 'T' or 'F'")
  }
  ### sanity check 5
  if (!is.logical(italicY)) {
    stop("italicY must be logical: 'TRUE', 'FALSE' or, less safely, 'T' or 'F'")
  }

  ### end of sanity checking
  ### we put things together from the values in the vector,
  ### the comma separator: commaChar
  ### and the andChar (!)
  ### need to create quoted values for these
  ###                italic values ...
  ###     ... and both quoted _and_ italicised values
  ### italic marker ("*") has to come outside the quoteChar
  ### set up quoting
  if (!quoted) {
    quoteChar <- ""
  }
  ### need to create the quoted separators
  ### first to put between comma separated values
  commaChar <- paste0(quoteChar,
                      ", ",
                      quoteChar)
  ### now add italics
  if (italicY) {
    italicChar <- "*"
  } else {
    italicChar <- ""
  }
  commaChar <- paste0(italicChar,
                      commaChar,
                      italicChar)
  prefixChar <- termChar <- ""
  if (quoted) {
    prefixChar <- quoteChar
    termChar <- quoteChar
  }
  if (italicY) {
    prefixChar <- paste0(italicChar,
                         prefixChar)
    termChar <- paste0(termChar,
                       italicChar)
  }
  ### now we can move to handle the vector
  if (length(x) == 2) {
    ### two values, very easy
    if (quoted) {
      return(paste0(italicChar,
                    quoteChar,
                    x[1],
                    quoteChar,
                    italicChar,
                    andChar,
                    italicChar,
                    quoteChar,
                    x[2],
                    quoteChar,
                    italicChar))
    }
    return(paste0(italicChar,
                  x[1],
                  italicChar,
                  andChar,
                  italicChar,
                  x[2],
                  italicChar))
  }
  ### OK, if we get here we have more than two values in the vector
  ### so need to parse them to handle the last value correctly
  ### and put in the and separator correctly
  len <- length(x)
  endItem <- x[len] # last value
  earlyItems <- x[-len] # earlier items
  earlyItems <- paste0(x[-len],
                       collapse = commaChar)
  ### got to add the initial and terminal quotes
  earlyItems <- paste0(prefixChar,
                       earlyItems,
                       termChar)

  endItem <- paste0(andChar,
                    prefixChar,
                    endItem,
                    termChar)
  ### now put the last item on
  allItems <- paste0(earlyItems,
                     endItem)
  ### now return the result
  allItems
}
#'
#' @rdname convertVector2sentence
#' @export
convertVectorToSentence <- convertVector2sentence
