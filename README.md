
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CECPfuns

<!-- badges: start -->

![Package:
CECPfuns](https://img.shields.io/badge/Package-CECPfuns-lightgrey)
![Lifecycle:
developing](https://img.shields.io/badge/Lifecycle-developing-orange)
![Licence: MIT](https://img.shields.io/badge/Licence-MIT-brightgreen)
[![Codecov test
coverage](https://codecov.io/gh/cpsyctc/CECPfuns/branch/main/graph/badge.svg)](https://codecov.io/gh/cpsyctc/CECPfuns?branch=main)
[![R-CMD-check](https://github.com/cpsyctc/CECPfuns/workflows/R-CMD-check/badge.svg)](https://github.com/cpsyctc/CECPfuns/actions)
<!-- badges: end -->

The goal driving the creation of CECPfuns is largely selfish: to make
sure I have a single, up to date, repository where I can find
potentially reusable functions I have written. However, it is something
that has been very much encouraged by (Dr. Clara Paz)\[
<https://investigacion.udla.edu.ec/udla_teams/clara-paz/>\] and she has
contributed to some of these functions and to the general idea of the
package. Input has also come from (Emily
Blackshaw)\[<https://www.researchgate.net/profile/Emily_Blackshaw2>\].
It is possible that these functions may be of use to others so I am now
uploading it to GitHub at <https://github.com/cpsyctc/CECPfuns> after
any significant changes.

There is also now a pkgdown produced web site for the package at
<https://cecpfuns.psyctc.org/>.

## Installation

You can install the latest version of CECPfuns from
<https://github.com/cpsyctc/CECPfuns>.

To get it with the vignettes use one of these instructions within R.

``` r
devtools::install_github("cpsyctc/CECPfuns", build_vignettes = TRUE)
### or
remotes::install_github("cpsyctc/CECPfuns", build_vignettes = TRUE)
```

However, that may fail with a complaint if you don’t have pandoc
installed on your machine as R uses pandoc to build vignettes. You can
install it following the instructions at
<https://pandoc.org/installing.html>. I would then close and reopen R
(just in case it needs to find pandoc) and then repeat one of the above
instructions. Alternatively, you can install it without the vignettes
using one of the following.

``` r
devtools::install_github("cpsyctc/CECPfuns", build_vignettes = FALSE)
### or
remotes::install_github("cpsyctc/CECPfuns", build_vignettes = FALSE)
```

If you really want to make sure you always have the latest version, you
can look for it every time you launch R, see
[here](https://www.psyctc.org/Rblog/posts/2021-02-10-making-my-first-usable-package/#how-i-am-synching-my-package-to-machines-other-than-my-main-machine).

## Background information

- As above, you can find out more about Clara at
  <https://investigacion.udla.edu.ec/udla_teams/clara-paz/>,
- you can find out more about Emily at
  <https://www.researchgate.net/profile/Emily_Blackshaw2> and about her
  PhD which I am supervising on ResearchGate,
  [here](https://www.researchgate.net/project/Young-Persons-Clinical-Outcomes-in-Routine-Evaluation-YP-CORE-Scale-psychometric-properties-and-utility)
  and
- my own biggest research programme, which overlaps with Emily’s work,
  is the CORE system: <https://www.corestemtrust.org.uk/> and a web site
  about my non-CORE work is slowly building (from a much earlier one) at
  <https://www.psyctc.org/psyctc/> and my personal site is
  <https://www.psyctc.org/pelerinage2016>.

## Licence and disclaimer

The package is licensed under the MIT licence
<https://opensource.org/licenses/MIT> which means you should be able to
reuse anything here that you find useful with no fee to me as long as
you comply with the terms of that licence. The licence has a very
capitalised disclaimer:

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
