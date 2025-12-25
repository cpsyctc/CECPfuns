# Function using gender and age in input file, with a lookup, to get appropriate CSC values

Function using gender and age in input file, with a lookup, to get
appropriate CSC values

## Usage

``` r
lookupCSCgenderAndAge(
  useInternalLookup = TRUE,
  lookupTableName = NULL,
  lookupGenderVarChar,
  lookupAgeVarChar,
  lookupCSCvarChar = "CSC",
  lookupGenderF,
  lookupGenderM,
  lookupGenderO,
  checkInternalLookup = FALSE,
  checkExternalLookup = TRUE,
  dataTableName,
  dataGenderVarChar,
  dataAgeVarChar,
  dataGenderF,
  dataGenderM,
  dataGenderO,
  dataGenderNA = NA_character_,
  dataAgeNA = NA_real_,
  outputCSCvarChar = "CSC",
  lookupRef = "Emily_PhD",
  useClinScoring = FALSE,
  checkData = TRUE,
  overwriteExistingVariable = FALSE,
  showInternalLookup = FALSE
)
```

## Arguments

- useInternalLookup:

  logical: whether to use internal lookup table, defaults to TRUE

- lookupTableName:

  character: name of lookup file to use if not using internal table

- lookupGenderVarChar:

  character: name of gender variable in lookup file

- lookupAgeVarChar:

  character: name of age variable in lookup file

- lookupCSCvarChar:

  character: name of CSC variable in lookup file

- lookupGenderF:

  character: value representing female gender in lookup file

- lookupGenderM:

  character: value representing male gender in lookup file

- lookupGenderO:

  character: value representing other gender in lookup file

- checkInternalLookup:

  logical: whether to print the check for the internal lookup

- checkExternalLookup:

  logical: whether to print the check for an external lookup

- dataTableName:

  character: name of data file to use

- dataGenderVarChar:

  character: value representing female gender in data file

- dataAgeVarChar:

  character: name of gender variable in data file

- dataGenderF:

  value representing female gender in data file

- dataGenderM:

  value representing male gender in data file

- dataGenderO:

  value representing other gender in data file

- dataGenderNA:

  vector of values (one or more) representing missing gender values in
  datafile

- dataAgeNA:

  vector of values (one or more) representing missing age values in data

- outputCSCvarChar:

  character: name for output CSC variable, defaults to "CSC",

- lookupRef:

  character: which internal referential lookup data to use

- useClinScoring:

  logical: whether to use item mean scoring or "clinical" scoring

- checkData:

  logical: whether to check for issues in the data

- overwriteExistingVariable:

  logical: if TRUE allows overwriting of existing variable, default
  FALSE

- showInternalLookup:

  logical: if TRUE shows the internal lookup table selected

## Value

a tibble containing all the input data with added variable naming lookup
used and CSC values

## Background

One challenge with YP-CORE, and many other measures, is that the
appropriate CSC (Clinically Significant Change) value to use is not the
same for all ages and genders. This function takes new data with a
gender and an age variable and returns a new tibble with the same data
plus the CSC for the gender and age given. It has three lookup tables
built into the function but also allows you to submit your own lookup
table. Currently, that lookup is expected to be a CSV (comma separated
variable) file. I'll improve that to allow a tibble and perhaps other
formats.

## References/acknowledgements

1.  The default internal lookup is the most recent UK referential data
    from Emily Blackshaw's PhD. For now, see
    <https://www.coresystemtrust.org.uk/home/instruments/yp-core-information/>

2.  The next UK lookup is from Twigg, E., Cooper, M., Evans, C.,
    Freire, E. S., Mellor-Clark, J., McInnes, B., & Barkham, M. (2016).
    Acceptability, reliability, referential distributions, and
    sensitivity to change of the YP-CORE outcome measure: Replication
    and refinement. Child and Adolescent Mental Health, 21(2), 115–123.
    <https://doi.org/10.1111/camh.12128>

3.  Currently the only other internal lookup is the Italian data from Di
    Biase, R., Evans, C., Rebecchi, D., Baccari, F., Saltini, A., Bravi,
    E., Palmieri, G., & Starace, F. (2021). Exploration of psychometric
    properties of the Italian version of the Core Young Person’s
    Clinical Outcomes in Routine Evaluation (YP-CORE). Research in
    Psychotherapy: Psychopathology, Process and Outcome, 24(2).
    <https://doi.org/10.4081/ripppo.2021.554>

## History/development log

Version 1: 21.i.2024

## Author

Chris Evans

## Examples

``` r
if (FALSE) { # \dontrun{
### simple usage of the function with comments explaining the arguments rather more
### see Rblog post ... for more information
###
lookupCSCgenderAndAge(useInternalLookup = TRUE, # so using the internal lookup data
                                                # (could have omitted this, it's the default)
   lookupTableName = NULL, # so no need to give an external lookup table name
                                                # (default again could have omitted this)
   lookupGenderVarChar = "Gender", # name of the gender variable in the lookup table
                                                # ditto!
   lookupAgeVarChar = "Age", # name of the age variable ditto
   lookupGenderF = "F", # code for female gender in the lookup table (ditto)
   lookupGenderM = "M", # code for male gender ditto
   lookupGenderO = "O", # code for other gender ditto
                        # for future proofing, current lookup tables are only binary gender
   ### now the arguments about the data to code
   dataTableName = tibData, # crucial name of the data to classify, this and the following
   dataGenderVarChar = "Gender", # name of the gender variable in those data (default)
   dataAgeVarChar = "Age", # you can work out this and the following
   dataGenderF = "F",
   dataGenderM = "M",
   dataGenderO = "O",
   ### no missing values in lookup tables (would be meaningless),
   ### but you may have missing values in your data hence this next argument
   dataGenderNA = NA_character_) -> tibBlackshaw

   ### so that call returns the raw data but now with the CSC values

tibBlackshaw %>%
 group_by(Gender, Age, CSC) %>%
 filter(Dataset2 == "HS" & ID == 1) %>%
 ungroup() %>%
 select(ID, Gender : YPscore, Ref, CSC) %>%
 flextable() %>%
 autofit()
} # }
```
