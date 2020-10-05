
<!-- README.md is generated from README.Rmd. Please edit that file -->

# renumber

<!-- badges: start -->

<!-- badges: end -->

The goal of `renumber` is to make it easy to number or renumber files
and directories. See Jenny Bryan’s
[presentation](http://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf)
on why you might want to do that.

## Installation

You can install the released version of renumber from
[gihub](https://github.com/richardjtelford/renumber) with:

``` r
install.packages("remotes")
remotes::install_github("richardjtelford/renumber")
```

## Example

To number files in the working directory, you could use this code.

``` r
library(renumber)
renumber(path = ".", number_dir = FALSE, test_only = TRUE)
```

Set `test_only` to FALSE for things to actually happen for real. Please
be careful
