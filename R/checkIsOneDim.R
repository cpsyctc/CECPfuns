#' Function returning TRUE for a vector (regardless of attributes) and a one dimensional list
#'
#' @param x object to test
#'
#' @return TRUE if x is one dimensional,i.e. a vector or list
#' @noRd
#'
#' @examples
#' tmpList <- as.list(letters[1:5])
#' tmpList
#' is.list(tmpList) # doh!
#' is.vector(tmpList) # perhaps surprisingly is TRUE
#' checkIsVector(tmpList) # FALSE
#' checkIsOneDim(tmpList) # TRUE
#'
#' @author Chris Evans
#' @section History/development log:
#' Started 12.iv.21
#'
checkIsOneDim <- function(x){
  if(checkIsVector(x)){
    return(TRUE)
  } else {
    if (is.list(x) & length(x) == 1) {
      return(TRUE)
    }
  }
  FALSE
}
