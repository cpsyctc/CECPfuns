#' Function using gender and age in input file, with a lookup, to get appropriate CSC values
#'
#' @param useInternalLookup logical: whether to use internal lookup table, defaults to TRUE
#' @param lookupTableName character: name of lookup file to use if not using internal table
#' @param lookupGenderVarChar character: name of gender variable in lookup file
#' @param lookupAgeVarChar character: name of age variable in lookup file
#' @param lookupCSCvarChar character: name of CSC variable in lookup file
#' @param lookupGenderF character: value representing female gender in lookup file
#' @param lookupGenderM character: value representing male gender in lookup file
#' @param lookupGenderO character: value representing other gender in lookup file
#' @param checkInternalLookup logical: whether to print the check for the internal lookup
#' @param checkExternalLookup logical: whether to print the check for an external lookup
#' @param dataTableName character: name of data file to use
#' @param dataGenderVarChar character: value representing female gender in data file
#' @param dataAgeVarChar character: name of gender variable in data file
#' @param dataGenderF value representing female gender in data file
#' @param dataGenderM value representing male gender in data file
#' @param dataGenderO value representing other gender in data file
#' @param dataGenderNA  vector of values (one or more) representing missing gender values in datafile
#' @param dataAgeNA vector of values (one or more) representing missing age values in data
#' @param lookupRef character: which internal referential lookup data to use
#' @param outputCSCvarChar character: name for output CSC variable, defaults to "CSC",
#' @param useClinScoring logical: whether to use item mean scoring or "clinical" scoring
#' @param checkData logical: whether to check for issues in the data
#' @param overwriteExistingVariable logical: if TRUE allows overwriting of existing variable, default FALSE
#' @param showInternalLookup logical: if TRUE shows the internal lookup table selected
#'
#' @return a tibble containing all the input data with added variable naming lookup used and CSC values
#' @export
#'
#' @importFrom dplyr ensym
#' @importFrom tibble tribble
#' @importFrom dplyr select
#' @importFrom readr read_csv
#' @importFrom dplyr case_when
#' @importFrom dplyr join_by
#' @importFrom dplyr bind_cols
#' @importFrom rlang :=
#'
#' @section Background:
#' One challenge with YP-CORE, and many other measures, is that the appropriate CSC (Clinically Significant Change)
#' value to use is not the same for all ages and genders.  This function takes new data with a gender and an age variable
#' and returns a new tibble with the same data plus the CSC for the gender and age given.  It has three lookup tables
#' built into the function but also allows you to submit your own lookup table.  Currently, that lookup is expected to be
#' a CSV (comma separated variable) file.  I'll improve that to allow a tibble and perhaps other formats.
#'
#' @examples
#' \dontrun{
#' ### simple usage of the function with comments explaining the arguments rather more
#' ### see Rblog post ... for more information
#' ###
#' lookupCSCgenderAndAge(useInternalLookup = TRUE, # so using the internal lookup data
#'                                                 # (could have omitted this, it's the default)
#'    lookupTableName = NULL, # so no need to give an external lookup table name
#'                                                 # (default again could have omitted this)
#'    lookupGenderVarChar = "Gender", # name of the gender variable in the lookup table
#'                                                 # ditto!
#'    lookupAgeVarChar = "Age", # name of the age variable ditto
#'    lookupGenderF = "F", # code for female gender in the lookup table (ditto)
#'    lookupGenderM = "M", # code for male gender ditto
#'    lookupGenderO = "O", # code for other gender ditto
#'                         # for future proofing, current lookup tables are only binary gender
#'    ### now the arguments about the data to code
#'    dataTableName = tibData, # crucial name of the data to classify, this and the following
#'    dataGenderVarChar = "Gender", # name of the gender variable in those data (default)
#'    dataAgeVarChar = "Age", # you can work out this and the following
#'    dataGenderF = "F",
#'    dataGenderM = "M",
#'    dataGenderO = "O",
#'    ### no missing values in lookup tables (would be meaningless),
#'    ### but you may have missing values in your data hence this next argument
#'    dataGenderNA = NA_character_) -> tibBlackshaw
#'
#'    ### so that call returns the raw data but now with the CSC values
#'
#'tibBlackshaw %>%
#'  group_by(Gender, Age, CSC) %>%
#'  filter(Dataset2 == "HS" & ID == 1) %>%
#'  ungroup() %>%
#'  select(ID, Gender : YPscore, Ref, CSC) %>%
#'  flextable() %>%
#'  autofit()
#' }
#'
#' @section References/acknowledgements:
#'
#' \enumerate{
#' \item The default internal lookup is the most recent UK referential data from Emily Blackshaw's PhD.  For now, see
#' \url{https://www.coresystemtrust.org.uk/home/instruments/yp-core-information/}
#' \item The next UK lookup is from Twigg, E., Cooper, M., Evans, C., Freire, E. S., Mellor-Clark, J., McInnes, B., & Barkham, M. (2016). Acceptability, reliability, referential distributions, and sensitivity to change of the YP-CORE outcome measure: Replication and refinement. Child and Adolescent Mental Health, 21(2), 115–123.
#' \url{https://doi.org/10.1111/camh.12128}
#' \item Currently the only other internal lookup is the Italian data from Di Biase, R., Evans, C., Rebecchi, D., Baccari, F., Saltini, A., Bravi, E., Palmieri, G., & Starace, F. (2021). Exploration of psychometric properties of the Italian version of the Core Young Person’s Clinical Outcomes in Routine Evaluation (YP-CORE). Research in Psychotherapy: Psychopathology, Process and Outcome, 24(2).
#' \url{https://doi.org/10.4081/ripppo.2021.554}
#' }
#'
#' @family lookup functions
#'
#' @author Chris Evans
#'
#' @section History/development log:
#' Version 1: 21.i.2024
#'
lookupCSCgenderAndAge <- function(useInternalLookup = TRUE,
                                  lookupTableName = NULL,
                                  lookupGenderVarChar, lookupAgeVarChar, lookupCSCvarChar = "CSC",
                                  lookupGenderF, lookupGenderM, lookupGenderO,
                                  checkInternalLookup = FALSE,
                                  checkExternalLookup = TRUE,
                                  dataTableName,
                                  dataGenderVarChar, dataAgeVarChar,
                                  dataGenderF, dataGenderM, dataGenderO,
                                  dataGenderNA = NA_character_,
                                  dataAgeNA = NA_real_,
                                  outputCSCvarChar = "CSC",
                                  lookupRef = "Emily_PhD",
                                  useClinScoring = FALSE,
                                  checkData = TRUE,
                                  overwriteExistingVariable = FALSE,
                                  showInternalLookup = FALSE){

  ### this is a trick to suppress notes about undefined global variables
  ICC <- CSC <- Ref <- NULL

  ### create the internal lookup table
  tribble(~Ref, ~Age,  ~Gender,  ~CSC,
          "Emily_PhD", 11, "M", 1.0,
          "Emily_PhD", 12, "M", 1.0,
          "Emily_PhD", 13, "M", 1.0,
          "Emily_PhD", 14, "M", 1.3,
          "Emily_PhD", 15, "M", 1.4,
          "Emily_PhD", 16, "M", 1.5,
          "Emily_PhD", 11, "F", 1.1,
          "Emily_PhD", 12, "F", 1.5,
          "Emily_PhD", 13, "F", 1.4,
          "Emily_PhD", 14, "F", 1.6,
          "Emily_PhD", 15, "F", 1.6,
          "Emily_PhD", 16, "F", 1.5,
          "Twigg_et_al_2016", 11, "M", 1.03,
          "Twigg_et_al_2016", 12, "M", 1.03,
          "Twigg_et_al_2016", 13, "M", 1.03,
          "Twigg_et_al_2016", 14, "M", 1.41,
          "Twigg_et_al_2016", 15, "M", 1.41,
          "Twigg_et_al_2016", 16, "M", 1.41,
          "Twigg_et_al_2016", 11, "F", 1.44,
          "Twigg_et_al_2016", 12, "F", 1.44,
          "Twigg_et_al_2016", 13, "F", 1.44,
          "Twigg_et_al_2016", 14, "F", 1.59,
          "Twigg_et_al_2016", 15, "F", 1.59,
          "Twigg_et_al_2016", 16, "F", 1.59,
          "Di_Biase_et_al_2021", 11, "F", 1.34,
          "Di_Biase_et_al_2021", 12, "F", 1.34,
          "Di_Biase_et_al_2021", 13, "F", 1.34,
          "Di_Biase_et_al_2021", 14, "F", 1.34,
          "Di_Biase_et_al_2021", 15, "F", 1.47,
          "Di_Biase_et_al_2021", 16, "F", 1.47,
          "Di_Biase_et_al_2021", 17, "F", 1.47,
          "Di_Biase_et_al_2021", 11, "M", 1.18,
          "Di_Biase_et_al_2021", 12, "M", 1.18,
          "Di_Biase_et_al_2021", 13, "M", 1.18,
          "Di_Biase_et_al_2021", 14, "M", 1.18,
          "Di_Biase_et_al_2021", 15, "M", 1.23,
          "Di_Biase_et_al_2021", 16, "M", 1.18,
          "Di_Biase_et_al_2021", 17, "M", 1.18) -> tibLookup

  ### showInternalLookup == TRUE overrides everything else so ...
  if (!is.logical(showInternalLookup)) {
    stop("showInternalLookup must be a logical value, TRUE or FALSE")
  }
  if (showInternalLookup) {
    return(tibLookup)
  }

  ### add sanity checking here
  ### start by checking the lookup arguments
  if(!useInternalLookup & is.null(lookupTableName)) {
    stop("You asked to use your own lookup table so you must give the table to use as a character variable.")
  }
  if(!is.null(lookupTableName) & !is.data.frame(lookupTableName)) {
    stop("You asked to use your own lookup table, lookupTableName, the lookup table to use must be character.")
  }
  if(!useInternalLookup) {
    if (!exists(deparse(substitute(lookupTableName)))) {
      stop(paste0("You asked to use your own lookup table, but the table you named: ",
                  lookupTableName,
                  " doesn't exist, or not where the function can find it."))
    }
  }
  if(!is.character(lookupRef)) {
    stop("lookupRef, the particular referential data to use from the internal lookup table must be character.")
  }
  if(!is.logical(useClinScoring)) {
    stop("useClinScoring, which uses the clinical scoring, i.e. 10x the item means, must be a logical, either TRUE or FALSE.")
  }
  if(!is.character(lookupGenderVarChar)) {
    stop("lookupGenderVarChar, the name of the gender variable in the lookup table must be given as a character variable, default is 'gender' for the internal table.")
  }
  if(!is.character(lookupAgeVarChar)) {
    stop("lookupAgeVarChar, the name of the age variable in the lookup table must be given as a character variable, default is 'age' for the internal table.")
  }
  if(!is.character(lookupCSCvarChar)) {
    stop("lookupCSCvarChar, the name of the CSC variable in the lookup table must be given as a character variable, default is 'CSC' for the internal table.")
  }
  if(!is.character(lookupGenderF)) {
    stop("lookupGenderF, the value representing female gender in the lookup table must be character, 'F' in the internal table.")
  }
  if(!is.character(lookupGenderM)) {
    stop("lookupGenderM, the value representing male gender in the lookup table must be character, 'M' in the internal table.")
  }
  if(!is.character(lookupGenderO)) {
    stop("lookupGenderO, the value representing non-binary gender in the lookup table must be character, 'O' in the internal table.")
  }

  ### now check the data arguments
  if(!is.character(dataGenderVarChar)) {
    stop("dataGenderVarChar, the name of the gender variable in the data must be given as a character variable.")
  }
  if(!is.character(dataAgeVarChar)) {
    stop("dataAgeVarChar, the name of the age variable in the data must be given as a character variable.")
  }
  if(!is.character(dataGenderF)) {
    stop("dataGenderF, the value representing female gender in the data must be character.")
  }
  if(is.na(dataGenderF) | dataGenderF == "") {
    stop(paste0("dataGenderF, the value representing female gender in the data must be non-missing.",
                "\nYou gave: ",
                dataGenderF,
                " please fix that!"))
  }
  if(!is.character(dataGenderM)) {
    stop("dataGenderM, the value representing male gender in the data must be character.")
  }
  if(is.na(dataGenderM) | dataGenderM == "") {
    stop(paste0("dataGenderM, the value representing male gender in the data must be non-missing.",
                "\nYou gave: ",
                dataGenderM,
                " please fix that!"))
  }
  ### other gender is more complex because there might be various values, supplied as a vector
  if(!is.character(dataGenderO[1])) {
    stop("dataGenderO, the value representing non-binary gender in the data must be character.")
  }
  ### same for NA markers
  if(!is.character(dataGenderNA[1])) {
    stop("dataGenderO, the value representing missing gender in the data must be character or NA_character.")
  }
  if(!is.numeric(dataAgeNA[1])) {
    stop("dataAgeNA, the value representing missing age in the data must be numeric or NA_real.")
  }

  ### check output arguments
  if(!is.character(outputCSCvarChar)) {
    stop("outputCSCvarChar, the name of the CSC variable in the returned data must be given as a character variable.")
  }

  if(useInternalLookup){
    if(!(lookupRef %in% c("Emily_PhD", "Twigg_et_al_2016", "Di_Biase_et_al_2021"))) {
      stop(paste0("lookupRef must be one of ",
                  convertVectorToSentence(c("Emily_PhD", "Twigg_et_al_2016", "Di_Biase_et_al_2021"), andChar = "or"),
                  "."))
    }
  }
  if(!is.logical(overwriteExistingVariable)) {
    stop("The argument overwriteExistingVariable must be a logical, FALSE (default) or TRUE")
  }
  if(!overwriteExistingVariable) {
    if(outputCSCvarChar %in% colnames(dataTableName)) {
      stop(paste0("You have given a non-default value for outputCSCvarChar: ",
                  outputCSCvarChar,
                  " but that exists in your data so you would overwrite the existing variable.",
                  "\nIf you really want to do that, you have to put overwriteExistingVariable = TRUE in the arguments."))
    }
  }

  ### handle passing of variable names
  lookupGenderVar <- ensym(lookupGenderVarChar)
  lookupAgeVar <- ensym(lookupAgeVarChar)
  lookupCSCvar <- ensym(lookupCSCvarChar)
  dataGenderVar <- ensym(dataGenderVarChar)
  dataAgeVar <- ensym(dataAgeVarChar)
  outputCSCvar <- ensym(outputCSCvarChar)

  ### get lookup table
  if (useInternalLookup) {
    ### select which referential set of CSCs
    tibLookup %>%
      filter(Ref == lookupRef) -> tibLookup

    if(useClinScoring) {
      tibLookup %>%
        mutate(CSC = CSC * 10) -> tibLookup
    }

    if(lookupRef == "Emily_PhD") {
      message("These referential data had CSC values for age by year from 11 to 16 years old")
    }

    if(lookupRef == "Twigg_et_al_2016") {
      message("These referential data had CSC values for age for two age groups: 11-13 and 14-16")
    }

    if(lookupRef == "Di_Biase_et_al_2021") {
      message("These referential data had CSC values for age for two age groups: 11-14 and 15-17")
    }

    if (checkInternalLookup){
      cat("This is the referential mapping you are using\n\n")
      tibLookup %>%
        select(!!lookupGenderVarChar, !!lookupAgeVarChar, CSC) %>%
        print()
    }

  } else {
    ### pull table in and check it
    tibLookup <- lookupTableName

    ### does it have a Ref field?
    if(!("Ref" %in% colnames(tibLookup))) {
      tibLookup %>%
        mutate(Ref = paste0("Table: ",
                            deparse(lookupTableName)))
    }

    if(useClinScoring) {
      tibLookup %>%
        mutate(!!lookupCSCvar := !!lookupCSCvar * 10) -> tibLookup
    }

    if (checkExternalLookup){
      cat("This is the referential mapping you are using\n\n")
      tibLookup %>%
        select(!!lookupGenderVarChar, !!lookupAgeVarChar, !!lookupCSCvarChar) %>%
        print()
    }
  }
  ### get all lookup gender to character
  tibLookup %>%
    mutate(!!lookupGenderVar := as.character(!!lookupGenderVar)) -> tibLookup2

  ### change the gender coding in the lookup table
  tibLookup2 %>%
    mutate(!!lookupGenderVar := case_when(
      !!lookupGenderVar == lookupGenderF ~ "F",
      !!lookupGenderVar == lookupGenderM ~ "M",
      !!lookupGenderVar == lookupGenderO ~ "O"
    )) -> tibLookup2

  ### sort out the data
  {{dataTableName}} -> tibData

  tibData %>%
    mutate(!!dataGenderVar := as.character(!!dataGenderVar)) -> tibData2

  tibData2 %>%
    mutate(!!dataGenderVar := case_when(
      !!dataGenderVar == dataGenderF ~ "F",
      !!dataGenderVar == dataGenderM ~ "M",
      !!dataGenderVar %in% dataGenderO ~ "O"),
      !!dataAgeVar := case_when(
        is.na(!!dataAgeVar) ~ NA_real_,
        !!dataAgeVar %in% dataAgeNA ~ NA_real_,
        .default = !!dataAgeVar)) -> tibData2

  ### check the data (1): missing gender values
  tibData2 %>%
    select(!!dataGenderVar) %>%
    filter(is.na(!!dataGenderVar)) %>%
    nrow() -> valNNAdataGender
  if(valNNAdataGender > 0) {
    warning(paste0("You have ",
                   valNNAdataGender,
                   " missing gender values in your data."))
  }

  ### check the data (2): nonmatchable gender values
  tibData2 %>%
    select(!!dataGenderVar) %>%
    filter(!is.na(!!dataGenderVar)) %>%
    unique() %>%
    pull() -> vecDataGenderValues

  tibLookup2 %>%
    select(!!lookupGenderVar) %>%
    unique() %>%
    pull() -> vecLookupGenderValues

  setdiff(vecDataGenderValues, vecLookupGenderValues) -> vecDiffGenderValues
  if(length(vecDiffGenderValues) > 0){
    if(length(vecDiffGenderValues) > 1) {
      warning(paste0("You have these values for gender in your data that aren't in your lookup gender variable: ",
                     convertVectorToSentence(vecDiffGenderValues)))
    } else {
      warning(paste0("You have this value for gender in your data that isn't in your lookup gender variable: ",
                     vecDiffGenderValues))
    }
  }

  ### check the data (3): missing age values
  tibData2 %>%
    select(!!dataAgeVar) %>%
    filter(is.na(!!dataAgeVar)) %>%
    nrow() -> valNNAdataAge
  if(valNNAdataAge > 0) {
    warning(paste0("You have ",
                   valNNAdataAge,
                   " missing age values in your data."))
  }

  ### check the data: 4 nonmatchable age values
  tibData2 %>%
    select(!!dataAgeVar) %>%
    filter(!is.na(!!dataAgeVar)) %>%
    unique() %>%
    pull() -> vecDataAgeValues

  tibLookup2 %>%
    select(!!lookupAgeVar) %>%
    unique() %>%
    pull() -> vecLookupAgeValues

  setdiff(vecDataAgeValues, vecLookupAgeValues) -> vecDiffAgeValues
  if(length(vecDiffAgeValues) > 0){
    if(length(vecDiffAgeValues) > 1) {
      warning(paste0("You have these values for age in your data that aren't in your lookup age variable: ",
                     convertVectorToSentence(vecDiffAgeValues)))
    } else {
      warning(paste0("You have this value for age in your data that isn't in your lookup age variable: ",
                     vecDiffAgeValues))
    }
  }

  if(outputCSCvarChar != lookupCSCvarChar){
    ### needs to rename the CSC variable
    ### change the variable in the lookup table
    colnames(tibLookup2)[which(colnames(tibLookup2) == lookupCSCvarChar)] <- outputCSCvarChar
    ### now make sure it's safe to use in the output
    if(overwriteExistingVariable){
      ### remove existing variable otherwise the join will create .x and .y named variables
      tibData2[, outputCSCvarChar] <- NULL # is a non-event with no warnings, messages or errors if variable doesn't exist
    }
  }
  ### create the join
  joinBy <- join_by({{dataAgeVarChar}} == {{lookupAgeVarChar}}, {{dataGenderVarChar}} == {{lookupGenderVarChar}})
  ### use that join
  left_join(tibData2, tibLookup2, joinBy) -> tibData2
  ### we just want Ref and CSC from that
  tibData2[, c("Ref", outputCSCvarChar)] -> tmpData2
  ### now bind those to variables onto the _original_ data, i.e. tibData, and return that tibble
  ### (had I stuck with tibData2 I might have recoded the gender and age variables in it)
  bind_cols(tibData, tmpData2)
}
