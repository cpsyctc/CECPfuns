#' Function to get the number of rows with complete data for a given dataset and collection variables
#'
#' @param data The data as a data frame or tibble.
#' @param vars The variables to check, in tidyselect syntax
#' @param name Optional name, if not supplied, vars will be used.
#' @param returnType Character argument specifying the return type, see description.
#'
#' @returns number of rows of complete data as a named number, an unnamed number or list.
#' @export
#'
#' @importFrom rlang quo_is_null
#' @importFrom rlang enquo
#' @importFrom rlang as_label
#' @importFrom stringr str_flatten
#' @importFrom stringr str_sub
#' @importFrom stringr str_to_upper
#'
#' @section Background:
#' This function does a very simple thing: returns the number of rows of data in the
#' dataset 'data' with non-missing values for all the variables in 'vars'.
#'
#' Depending on the value of 'returnType' it returns a raw number, a named number or
#' a list with members 'name' and 'nComplete'.
#'
#' The 'name' can be supplied in the argument 'name' or, if nothing is specified there
#' the character form of the variable selection is used as the name for the named
#' number or the list return.
#'
#' The nice thing is that you can use any tidyselect syntax to select the variables,
#' see the examples.
#'
#' The option to return a list makes it easy to write a sequence of dplyr summarise()
#' statements to build a table of the numbers of complete data for various selections
#' of variables.  These can then, of course, be embedded in a dplyr group_by()
#' specifications so the same counting can be done for subsets of the data.
#'
#' I will expand the examples below and this probably needs a vignette to explain it
#' more fully.
#'
#' Acknowledgement: this wouldn't have happened had Maren Rogaski not been keen on
#' getting these values!
#'
#' @examples
#' \dontrun{
#' valN <- 10
#'
#' tibble(a = rnorm(valN),
#'        b = rnorm(valN),
#'        c = rnorm(valN),
#'        aChar = rep("a", valN),
#'        nums = 1:valN) %>%
#'   mutate(a = if_else(row_number() == 1,
#'                      NA_real_,
#'                      a),
#'          b = if_else(row_number() == 2,
#'                      NA_real_,
#'                      b),
#'          c = if_else(row_number() == 3,
#'                      NA_real_,
#'                      c),
#'          aChar = if_else(row_number() == 4,
#'                          NA_character_,
#'                          aChar),
#'          nums = if_else(row_number() == 5,
#'                         NA_integer_,
#'                         nums)) -> tmpTib
#'
#' getNcomplete(tmpTib) # you can call the dataset by its object name
#' getNcomplete("tmpTib") # or supply that as a character variable
#' ### but those will throw an error as the function wants you to be explicit:
#' ### so use 'everything()' if you want all the variables in the dataset.
#' getNcomplete("tmpTib", everything())
#' getNcomplete(tmpTib, everything())
#' ### but you can use any 'tidyselect' specification of the variables:
#' getNcomplete(tmpTib, a : nums)
#' getNcomplete(tmpTib, a : aChar)
#' getNcomplete(tmpTib, a)
#' getNcomplete(tmpTib, "a")
#' getNcomplete(tmpTib, where(is.integer))
#' getNcomplete(tmpTib, where(is.character))
#' getNcomplete(tmpTib, where(is.numeric))
#' getNcomplete(tmpTib, c("a", "c"))
#' ### but this will throw a raw R error complaining there is no variable 'sausages'!
#' getNcomplete(tmpTib, sausages)
#' ### you can specify three return types with returnType (imaginative names eh?)
#' ### # 'named number'
#' ### # 'raw number'
#' ### # 'list'
#'
#'}
#
getNcomplete <- function(data = NULL,
                         vars = NULL,
                         name = NULL,
                         returnType = c("named number", "raw number", "list")){
  ### get arguments
  listArgs <- as.list(match.call())
  ### turn the vars selector into a quosure
  vars <- enquo(vars)

  ### check args
  if(is.null(data)) {  #listArgsChar$data[1] != "." & ) {
     stop("You haven't supplied a value for data: you must!")
  }
  if(is.character(data)) {
    ### store that:
    charData <- data
    ### get the dataset of that name if it exists
    data <- get(data)
  } else {
    ### store the name of the data argument
    charData <- deparse(substitute(data))
  }
  if(!is.data.frame(data)) {
    stop(str_c("You asked to use '",
               charData,
               "' but it isn't a data frame or tibble.  You need to supply the data in one of those forms."))
  }
  # if(varsChar == "NULL") {
  if(quo_is_null(vars)) {
    stop(str_c("You didn't supply any specification  of the variables you want to check.",
               " For clarity you must specify the variables, if you want all of them, ",
               "just put 'everything()'."))
  }
  if(!is.null(name) & !is.character(name)){
    warning(str_c("You specified '",
               name,
               "' for the name of the selection of variables.",
               "  A number seems highly unlikely to be what you wanted."))
  }
  if(length(name) > 1) {
    stop(str_c("You have specified 'name' as: '",
               str_flatten(name, collapse = ", "),
               "' i.e. with length: ",
               length(name),
               ". You need to change it to a single character value.  ",
               "(That name may, of course, have many characters!)"))
  }
  if(!is.character(returnType)) {
    stop("You have somehow managed to specify returnType as something other than a character: fix it!")
  }
  match.arg(returnType) -> returnType
  if(length(returnType) > 1) {
    stop(str_c("You have specified returnType as: '",
               str_flatten(returnType, collapse = ", "),
               "' i.e. with length: ",
               length(returnType),
               ". You need to change it to a single character value."))
  }
  returnType %>%
    str_sub(1, 1) %>%
    str_to_upper() -> retType

  ### If no name was supplied, use the vars argument
  if(is.null(name)) {
    name <- as_label(vars)
  }


  ### OK, now do the real work which is actually trivial
  ### as it can use the "{{ }}" to treat the vars argument
  ### as a tidyselect instruction
    data %>%
    select({{vars}}) %>%
    na.omit() %>%
    summarise(nComplete = n()) %>%
    pull() -> nComplete

  if (retType == "R") {
    return(nComplete)
  }
  if (retType == "N") {
    names(nComplete) <- name
    return(nComplete)
  }
  if (retType == "L") {
    return(list(name = name,
                nComplete = nComplete))
  }
}


