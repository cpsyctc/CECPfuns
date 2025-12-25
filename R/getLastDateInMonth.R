#' Function that takes a date and returns the last date in that month
#' @description
#' This uses ceiling_date function from the lubridate package
#'
#' @param vecDate date to convert, single value or vector
#'
#' @return date: last date in the same month as the date input
#'
#' @family utility functions
#'
#' @section Background:
#' I found it convenient to be able to get the first and last dates for the month
#' of a date when mapping between dated data and data from months.
#'
#' It's easy to get this using the ceiling_date() function from the lubridate package.
#' ceiling_date() actually gives you the first date in the next month so I just
#' subtract one day from that date.
#'
#' I thought about writing the function to handle character dates but decided it
#' was more sensible to restrict to dates but use the example to remind people
#' how to convert from character/text format to date format
#'
#' @export
#'
#' @importFrom lubridate is.Date
#' @importFrom lubridate days
#' @importFrom lubridate ceiling_date
#'
#' @examples
#' ### this shows that the function is vectorised, i.e. can handle a vector of dates
#' ### and that it handles leap years correctly
#' ### (of course both are true: it's basically reusing function from lubridate package!)
#' getLastDateInMonth(as.Date(c("15/02/1975",  "15/02/1976"), format = "%d/%m/%Y"))
#' ### [1] "1975-02-28" "1976-02-29"
#'
#' @author Chris Evans
#' @section History/development log:
#' Started 25.xii.25.
#'
getLastDateInMonth <- function(vecDate){
  ### uses the lubridate funtion ceiling_date()
  ### to get last date in current month
  ### ceiling date is first date in next month
  if(!is.Date(vecDate[1])) {
    stop("The argument 'date' must be a date variable.  Use as.Date() to get date format, see example.")
  }
  vecCeilingDates <- ceiling_date(vecDate, unit = "months") - days(1)
  return(vecCeilingDates)
}

