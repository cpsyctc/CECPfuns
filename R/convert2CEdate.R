#' Function to convert Dates to my date format strings
#' @param date Date
#'
#' @return string
#' @export
#'
#' @section Background:
#' I like to write dates in the format dd.mm.yyyy but doing the months, mm,
#'  in Roman numerals, i.e. i = January, xii = December.  This, unless someone
#'  has never met the Roman's weird numbering system seems always to promote
#'  initial bemusement but then recognition and I've never had anyone say
#'  "but why not use Roman numerals for the days?" so I think it does disambiguate dates.
#'  It is a trivial function and perhaps I'm the only person who will ever use it but here it is.
#'  It expects input as a Date and can handle a vector of dates.
#'
#' @examples
#' date1 <- as.Date("1/1/2021", format = "%d/%m/%Y")
#' convert2CEdate(date1)
#' date2 <- as.Date("2/1/2021", format = "%d/%m/%Y")
#' dates12 <- c(date1, date2)
#' convert2CEdate(dates12)
#'
#' @family converting utilities
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Started before 5.iv.21
#' 10.iv.21: tweaked to add synonym convertToCEdate
#'
convert2CEdate <- function(date) {
  ### I like to write dates in the format dd.mm.yyyy but doing the months, mm
  ### in Roman numerals, i.e. i = January, xii = December
  ### This, unless someone has never met the Roman's weird numbering system
  ### seems always to promote bemusement but then recognition and I've never
  ### had anyone say "but why not use Roman numerals for the days?" so I think
  ### it does disambiguate dates
  ### trivial and perhaps I'm the only person who will ever use it but here it is
  ### expects input as a Date,
  ### can handle a vector of dates.
  ###
  ### requires lubridate
  invisible(stopifnot(requireNamespace("lubridate")))
  ### check input
  if (!lubridate::is.Date(date)) {
    stop("Input must have class Date")
  }
  thisDay <- lubridate::day(date)
  thisMonth <- lubridate::month(date, label = FALSE)
  thisYear <- lubridate::year(date)
  toRoman <- function(n) {
    romanNos <- c("i",
                  "ii",
                  "iii",
                  "iv",
                  "v",
                  "vi",
                  "vii",
                  "viii",
                  "ix",
                  "x",
                  "xi",
                  "xii")
    romanNos[n]
  }
  paste0(thisDay,
         ".",
         toRoman(thisMonth),
         ".",
         thisYear)
}
#'
#' @rdname convert2CEdate
#' @export
convertToCEdate <- convert2CEdate
