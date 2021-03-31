# Version 0.0.0.9029
Added checkAllUnique()

# Version 0.0.0.9028
Some tweaks to classifyScoresVectorByRCI() and plotBinconf() to please lintR!  R-CMD-check.yaml 
tweaked to get R 3.5.0 checked on windows to see if error report from 3.5 in Ubuntu is replicated.
Added isOneToOne().

# Version 0.0.0.9027
Tweaked ./.github/workflows/R-CMD-check.yaml to removing checking on R < 3.5, tests added for 
classifyScoresVectorByRCI() and plotBinconf(), introductory vignette fleshed out and 
package help page now largely replaced by a link to that vignette.

# Version 0.0.0.9026
Corrected mistake in classifyScoresVectorByRCI() help examples.  
Added suppressMessages to plotBinconf() to get rid of irritating messages from dplyr.

# Version 0.0.0.9025
Added classifyScoresVectorByRCI() and plotBinconf(). 
Both still need work on help and tests but usable.

# Version 0.0.0.9024
Renamed classifyRCIfromScores to classifyScoresByRCI.  Some dependency hunting. 

# Version 0.0.0.9023
More work to get continuous integration testing on github with github actions running.
Moved linting off GitHub, some linting of some of the code.

# Version 0.0.0.9021
Added classifyRCIfromScores() which at first seemed a trivial function, 
it is really, but it turned into a huge amount of work bizarrely.
Added internal data directory data-raw for test data and hence
sysdata.rda.  Some R style improvements.

# Version 0.0.0.9020

I have skipped updating here through 12 changes.  The 9000 came
in as it's a convention that says the version is alpha/testing.
Latest change was adding classifyRCIfromScores() and a lot of
tweaking and trying to improve lint checking complaints.

# Version 0.0.0.8

Added getCSC() and some more tweaks to documentation and help.

# Version 0.0.0.7

Improved documentation, building README.Rd from README.Rmd just by 
knitting it in Rstudio.

