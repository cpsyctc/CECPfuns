#' Fix variable names e.g. YP1, YP2 ... YP10 to YP01, YP02 ... YP10
#'
#' @param nameTxt character vector of variable names
#' @param width number, restricted to 2 or 3
#' @param newText character, to replace the existing character part of the names
#'
#' @return vector of the zero padded names, perhaps with new text element
#'
#' @export
#'
#' @importFrom stringr str_extract
#' @importFrom tibble tribble
#' @importFrom dplyr rename_with
#' @importFrom tidyr "%>%"
#'
#' @family utility functions
#'
#' @section Background:
#' This is just a utility function that comes in useful if you want to change a vector
#' of variable names that have the format xxxx# where "xxxx" is a character component
#' and "#" is a number component. The function is vectorized, i.e. you can give it a
#' vector of names or a single name.  It can be used within the tidyverse dplyr
#' pipeline with "rename_with()" which will apply the function to
#'
#' @examples
#' ### these show the function acting on single values (unusual use case but ...!)
#' fixVarNames("YP1")
#' fixVarNames("YP10")
#' fixVarNames("YP1", 3) # if you want that to become YP010, i.e. three digits
#' fixVarNames("YP10", 3) # same
#' fixVarNames("YP10", 3, "YPCORE_") # replaces "YP" with "YPCORE_"
#'
#' ### same but with vector (two element vector is hardly more sensible use case!)
#' fixVarNames(c("YP1", "YP2"))
#' fixVarNames(c("YP10", "YP11"))
#' fixVarNames(c("YP1", "YP2"), 3)
#' fixVarNames(c("YP10", "YP11"), 3)
#' fixVarNames(c("YP10", "YP11"), 3, "YPCORE_")
#'
#'
#' ### create a dataset
#' ### library(tidyverse) # to get the tidyverse functionality including tribble()
#' library(tidyr)
#' library(tibble)
#' library(dplyr)
#' tribble(~ID, ~I1, ~I2, ~I3, ~I4, ~I5, ~I6, ~I7, ~I8, ~I9, ~I10,
#'          "P1", 4, 0, 2, 3, 1, 1, 0, 2, 3, 2,
#'          "P2", 2, 3, 4, 2, 1, 2, 4, 3, 1, 2,
#'          "P3", 4, 1, 1, 2, 3, 1, 0, 4, 0, 3) -> tmpTib
#'
#' ### simple example, the "-ID" says "don't do this to the ID variable"
#' tmpTib %>%
#'   rename_with(fixVarNames, -ID)
#'
#' ### this next uses column indices to select the variables to recode
#' tmpTib %>%
#'   rename_with(fixVarNames, 2:10)
#'
#' ### this next uses explicit selection
#' tmpTib %>%
#'   rename_with(fixVarNames, .cols = I1 : I10)
#'
#' ### this illustrates passing arguments to fixVarNames() as trailing arguments
#' tmpTib %>%
#'   rename_with(fixVarNames, .cols = I1 : I10, width = 3, newText = "YP")
#'
#' ### new dataset so ID coding doesn't start with "I" so I can illustrate
#' ### selecting with "starts_with()"
#' tribble(~P_ID, ~I1, ~I2, ~I3, ~I4, ~I5, ~I6, ~I7, ~I8, ~I9, ~I10,
#'         "P1", 4, 0, 2, 3, 1, 1, 0, 2, 3, 2,
#'         "P2", 2, 3, 4, 2, 1, 2, 4, 3, 1, 2,
#'         "P3", 4, 1, 1, 2, 3, 1, 0, 4, 0, 3) -> tmpTib
#'
#' ### select using starts_with()
#' tmpTib %>%
#' rename_with(fixVarNames, starts_with("I"))
#'
#' ### as before, put arguments after selection of the variables/columns
#' tmpTib %>%
#' rename_with(fixVarNames, starts_with("I"), width = 3, newText = "YP")
#'
#'
#' @author Chris Evans
#' @section History/development log:
#' Started 17.x.24
#'
#'
fixVarNames <- function(nameTxt, width = 2, newText = ""){
  ### sanity checking
  if (!is.character(nameTxt)){
    stop(paste0("You have entered ",
                nameTxt,
                " for the vector of names but it must be a character variable."))
  }
  if (!is.numeric(width)) {
    stop(paste0("You have entered ",
                width,
                " for the width you want but that must be a number."))
  }
  if (length(width) != 1) {
    stop("The value for width must be a single number, 2 or 3.  Please fix it!")
  }
  if (!(width %in% 2:3)) {
    stop(paste0("You have entered ",
                width,
                " for the width of the numeric bit of the names you want but ",
                " I have only allowed for 2 or 3 as other values seem unlikely."))
  }
  if (!is.character(newText)){
    stop(paste0("You have entered ",
                newText,
                " for the value of newText.  That must be a character variable.",
                "  Please fix it!"))
  }
  if (length(newText) != 1) {
    stop(paste0("You have entered ",
                newText,
                " for the value of newText but that must be a single character",
                " value.  Please fix it!"))
  }
  if (nchar(newText) > 24) {
    stop(paste0("You have entered ",
                newText,
                " for newText but I have only allowed for up to 24 characters",
                " as I thought it unlikely people would really need more."))
  }

  ### OK do the work
  ### get the letters
  stub <- str_extract(nameTxt, "([[:alpha:]]*)")
  ### if newText has been used ...
  if (newText != "") {
    stub <- newText
  }
  ### get the numbers (still as characters)
  num <- str_replace(nameTxt, "([[:alpha:]]*)([[:digit:]]*)", "\\2")
  ###  get them to numeric so that you can then ...
  num <- as.numeric(num)
  ### reformat them to
  fmt <- str_c("%0",
               width,
               ".0f")
  # num <- sprintf("%02.0f", num)
  num <- sprintf(fmt, num)
  str_c(stub, num)
}


fixVarNames <- Vectorize(fixVarNames,
                         USE.NAMES = FALSE)
