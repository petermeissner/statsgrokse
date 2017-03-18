
<!-- README.md is generated from README.Rmd. Please edit that file -->
R API Binding to Stats.grok.se Server
=====================================

**Status**

<a href="https://travis-ci.org/petermeissner/statsgrokse"> <img src="https://api.travis-ci.org/petermeissner/statsgrokse.svg?branch=master"> <a/> <a href="https://cran.r-project.org/package=statsgrokse"> <img src="http://www.r-pkg.org/badges/version/statsgrokse"> </a> <img src="http://cranlogs.r-pkg.org/badges/grand-total/statsgrokse"> <img src="http://cranlogs.r-pkg.org/badges/statsgrokse">

*lines of R code:* 322, *lines of test code:* 180

**Version**

0.1.0.90000 ( 2017-03-18 15:37:49 )

**Description**

The '<http://stats.grok.se>' server provides data and an API for Wikipedia page view statistics prior from December 2007 up to January 2016. This package provides R bindings to the API.

**License**

GPL (&gt;= 2) <br>Peter Meissner \[aut, cre\], R Core Team \[ctb\]

**Citation**

``` r
citation("statsgrokse")
```

**BibTex for citing**

``` r
toBibtex(citation("statsgrokse"))
```

**Installation**

Stable version from CRAN:

``` r
install.packages("statsgrokse")
```

Latest development version from Github:

``` r
devtools::install_github("petermeissner/wikipediatrend")
```

Purpose
=======

The statsgrokse package is a pure API binding to the stats.grok.se server providing Wikipedia page access statistics from start of 2008 up the very beginning of 2015.

Usage
=====

getting data
------------

The workhorse of the package is the `wp_trend()` function:

``` r
library(statsgrokse)

pageviews <-   
  statsgrokse(
    page = 
      c(
        "Application_programming_interface", 
        "Programmierschnittstelle"
      ), 
    from = "2014-12-01", 
    to   = "2015-01-06", 
    lang = c("en","de")
  )
## http://stats.grok.se/json/en/201412/Application_programming_interface
## http://stats.grok.se/json/en/201501/Application_programming_interface
## http://stats.grok.se/json/de/201412/Programmierschnittstelle
## http://stats.grok.se/json/de/201501/Programmierschnittstelle
```

plotting data
-------------

![](README-unnamed-chunk-14-1.png)
