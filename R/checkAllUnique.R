#' Function to check all values of a vector or data frame/tibble column are unique
#'
#' @param dat vector, or columns of data frame or tibble to test to see if values/rows are all unique
#' @param errIfNA logical: defaults to TRUE to disallow any NA values
#' @param allowJustOneNA logical: defaults to TRUE so if errIfNA is FALSE but you have more than one NA function returns FALSE
#' @param allowMultipleColumns logical: defaults to FALSE but if you really do want to allow all of multi-column dat, set to TRUE
#'
#' @return logical: TRUE if all unique (see examples)
#' @export
#'
#' @section Background:
#' This is a utility function to check that all the values of a vector, or a single column of a data frame or tibble,
#' or the rows of multiple columns of a data frame or tibble, are all unique.  This is important where you expect a
#' single row of data for each participant say, and so you expect the values of participantID in a data set to be
#' unique.  It will cripple things later if you don't identify duplicated ID values.  Sometimes it's not just a single
#' variable that should be unique, a typical example of this is when you have data from multiple services and ID values
#' for participants from each service.  Then there may be multiple values for ID but they should each come from a different
#' service.  (Mind you, once I have established that rows are unique across serviceID and participantID I usally paste
#' the two variables together with something like
#' ```
#' data$superID = paste0(data$serviceID, ":", data$participantID)
#' ```
#' or a tidyverse way of doing it:
#' ```
#' data %>%
#'          mutate(superID = str_c(serviceID, ":", participantID))
#' ````
#'
#' Making sure things are unique also prevents all sorts of sometimes very confusing error messages if you want to pivot
#' data depending on an ID variable whose values ought to be unique but aren't.  Checking for this is in my
#' [Wisdom! Rblog page](https://www.psyctc.org/Rblog/wisdom.html) .
#'
#' @examples
#' \dontrun{
#' ### letters gets us the 26 lower case letters of the English alphabet so should test OK
#' checkAllUnique(letters)
#' # [1] TRUE
#' ### good!
#'
#' ### the checking is case sensitive:
#' checkAllUnique(c("A", letters), errIfNA = FALSE, allowJustOneNA = FALSE)
#' # [1] TRUE
#' ### but ...
#' checkAllUnique(c("a", letters), errIfNA = FALSE, allowJustOneNA = FALSE)
#' # [1] FALSE
#' ### both good!
#'
#' ### by default checkAllUnique doesn't allow any NA values,
#' ### generally sensible for my data: ID codes or table indices
#' checkAllUnique(c(letters, NA))
#' # [1] FALSE
#' ### good!
#'
#' ### but we can override that:
#' checkAllUnique(c(letters, NA), errIfNA = FALSE)
#' # [1] TRUE
#' ### good!
#'
#' ### but generally I wouldn't want multiple NA values
#' ### in the typical situations I'd be using
#' ### checkAllUnique() so I have forced you to allow
#' ### that explicitly if you really want it ...
#' checkAllUnique(c(NA, letters, NA), errIfNA = FALSE)
#' # [1] FALSE
#' ### good!
#'
#' ### but you _can_ override that if you need to ...
#' checkAllUnique(c(NA, letters, NA), errIfNA = FALSE, allowJustOneNA = FALSE)
#' # [1] TRUE
#' ### good!
#' ### but you _can_ override that if you need to ...
#' checkAllUnique(c(NA, letters, NA), errIfNA = FALSE, allowJustOneNA = FALSE)
#' # [1] TRUE
#' ### good!
#'
#' ### by default checkAllUnique expects vector input but it can handle data
#' ### in multiple columns in a data frame or tibble
#' tmpDat <- as.data.frame(matrix(1:10, ncol = 2))
#' tmpDat
#' # V1 V2
#' # 1  1  6
#' # 2  2  7
#' # 3  3  8
#' # 4  4  9
#' # 5  5 10
#' checkAllUnique(tmpDat[, 1])
#' # [1] TRUE
#' checkAllUnique(tmpDat[, 2])
#' # [1] TRUE
#' ### but remember column indexing a tibble returns a tibble not a vector
#' tmpTib <- as_tibble(tmpDat)
#' tmpTib
#' # # A tibble: 5 x 2
#' # V1    V2
#' # <int> <int>
#' #   1     1     6
#' # 2     2     7
#' # 3     3     8
#' # 4     4     9
#' # 5     5    10
#' checkAllUnique(tmpTib[, 1])
#' # Error in checkAllUnique(tmpTib[, 1]) :
#' #   You have input an object of length one to checkAllUnique(): makes no sense!
#' ### whoops, I remember, must pull() to extract as vector
#' checkAllUnique(tmpTib %>% pull(1))
#' # [1] TRUE
#' checkAllUnique(tmpTib %>% pull(2))
#' # [1] TRUE
#'
#' ### you _can_ allow multiple columns
#' checkAllUnique(tmpDat, allowMultipleColumns = TRUE)
#' # [1] TRUE
# Warning message:
#' #   In checkAllUnique(tmpDat, allowMultipleColumns = TRUE) :
#' #   Input of dat to checkAllUnique was not a vector: be careful please!
#' checkAllUnique(tmpTib, allowMultipleColumns = TRUE)
#' # [1] TRUE
#' # Warning message:
#' #   In checkAllUnique(tmpTib, allowMultipleColumns = TRUE) :
#' #   Input of dat to checkAllUnique was not a vector: be careful please!
#'
#' ### but it is checking all content in all columns so if two rows are the
#' ### same it will return FALSE:
#' tmpDat2 <- tmpDat
#' tmpDat2[2, ] <- tmpDat[1, ] # make row 2 same as row 1
#' tmpDat2
#' # V1 V2
#' # 1  1  6
#' # 2  1  6
#' # 3  3  8
#' # 4  4  9
#' # 5  5 10
#' checkAllUnique(tmpDat2, allowMultipleColumns = TRUE)
#' # [1] FALSE
#' # Warning message:
#' #   In checkAllUnique(tmpDat2, allowMultipleColumns = TRUE) :
#' #   Input of dat to checkAllUnique was not a vector: be careful please!
#'
#'
#' ### what about columns of different classes, e.g. numeric and character
#' cbind(tmpDat2, letters[1:5]) -> tmpDatMixed
#' tmpDatMixed
#' # V1 V2 letters[1:5]
#' # 1  1  6            a
#' # 2  1  6            b
#' # 3  3  8            c
#' # 4  4  9            d
#' # 5  5 10            e
#' checkAllUnique(tmpDatMixed, allowMultipleColumns = TRUE)
#' # [1] TRUE
#' # Warning message:
#' #   In checkAllUnique(tmpDatMixed, allowMultipleColumns = TRUE) :
#' #   Input of dat to checkAllUnique was not a vector: be careful please!
#' ### that came out as TRUE because R "promoted" the numerics to character
#' ### and because the two different letters in rows 1 and 2 of column 3
#' ### broke the non-unique tie of rows 1 and 2 in columns 1 and 2
#'
#' ### what about having NA in a multicolumn input?
#' tmpDatNA <- tmpDat
#' tmpDatNA[2, 1] <- NA
#' tmpDatNA
#' # 1  1  6
#' # 2 NA  7
#' # 3  3  8
#' # 4  4  9
#' # 5  5 10
#' checkAllUnique(tmpDatNA, allowMultipleColumns = TRUE)
#' # [1] FALSE
#' # Warning message:
#' #   In checkAllUnique(tmpDatNA, allowMultipleColumns = TRUE) :
#' #   Input of dat to checkAllUnique was not a vector: be careful please!
#' ### but
#' checkAllUnique(tmpDatNA, allowMultipleColumns = TRUE, errIfNA = FALSE)
#' }
#'
#' @family data checking functions
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Started before 5.iv.21
#'
checkAllUnique <- function(dat,
                           errIfNA = TRUE,
                           allowJustOneNA = TRUE,
                           allowMultipleColumns = FALSE) {
  ### trivial function to check that each value in dat occurs only once
  ### as you often want for ID codes or table indices in multidimensional table
  ### data structures and particularly if you are pivoting things around
  ###
  ### sanity check 1: don't allow multiple NA and multiple columns
  if (allowMultipleColumns & !errIfNA) {
    stop("You have asked to use multiple columns and to all multiple NA values. I'm so sure this is a bad idea that I've blocked it. Sorry.")
  }
  ###
  ### sanity check 2
  if (length(dat) == 1) {
    stop("You have input an object of length one to checkAllUnique(): makes no sense!")
  }
  ###
  ### sanity check 3
  if (!is.data.frame(dat) & !is.vector(dat)) {
    stop("dat input to checkAllUnique is not a vector, data frame or tibble: no go!")
  }
    ###
  ### sanity check 4
  if (length(errIfNA) != 1 | !is.logical(errIfNA)) {
    stop("Argument errIfNA must be logical and length 1")
  }
  ###
  ### sanity check 5
  if (length(allowJustOneNA) != 1 | !is.logical(allowJustOneNA)) {
    stop("Argument allowJustOneNA must be logical and length 1")
  }
  ###
  ### sanity check 6
  if (length(allowMultipleColumns) != 1 | !is.logical(allowMultipleColumns)) {
    stop("Argument allowMultipleColumns must be logical and length 1")
  }
  ###
  ### now we have all the arguments can move to check input that isn't a vector
  ### sanity check 7
  if (is.data.frame(dat)) {
    ### that will be TRUE for data frame or tibble
    if (ncol(dat) > 1 & !allowMultipleColumns) {
      stop("dat input to checkAllUnique has more than one column and allMultipleColumns is default FALSE so no go!")
    }
    if (ncol(dat) > 1 & allowMultipleColumns) {
      warning("Input of dat to checkAllUnique was not a vector: be careful please!")
    }
  }
  ###
  ### finished sanity checks, check dat
  ###
  ### simple bit if errIfNA:
  if (getNNA(dat) == 1 & errIfNA) {
    ### got one NA but errIfNA set so ...
    return(FALSE)
  }

  if (is.vector(dat)) {
    if (!errIfNA & # allowing NA within dat
        !allowJustOneNA) {
      ### allowing multiple NA values in dat
      ### so just remove them
      dat <- na.omit(dat)
      ### and pass it onwards!
    }
    if (length(dat) == length(unique(dat))) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  } else {
    ### got tibble or data.frame
    nRows <- nrow(dat)
    dat %>%
      dplyr::distinct() -> dat
    if (nrow(dat) == nRows) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}
