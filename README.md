Scihub downloads
================

This is a data set of sci-hub. A log of pdf downloads from sci-hub
between 22 September 2011 and 14 October 2013. Posted by Alexandra
Elbakyan, founder of sci-hub.

Sci-hub allows users to download PDF versions of scholarly articles,
including many articles that are paywalled at their journal’s site. It
is a very simple website with a simple ui, you paste the DOI (Digital
object identifyer) and if they have that pdf available you can download
it. If not they try to download it, using borrowed credentials. Strictly
speaking, Sci-hub is illegal. They are providing ‘pirated’ content
outside of the monopolies of the publishers.

From the readme:

    contains raw unprocessed PDF download
    log from Sci-Hub starting from 22 September 2011 and ending on 14 October 2013.
    Statistics from 14 October to 18 Jan 2014 were not recorded for technical reasons.
    Statistics before 22 September were not collected.
    
    Each PDF download is recorded on separate line in following format:
    Time-and-Date   DOI URL IP-address  User-ID Country
    
    I do not remember the time zone, and it changes multiple
    times in this log because the server location was changing. You can assume GMT+3 or
    close to it. The first three parts of the IP address are unmasked; since these are
    stats that were collected several years ago, there is no way it can harm the user,
    but it can be interesting for research purposes.

Source file is found at
<http://sci-hub.se/downloads/ancient.sci-hub.stats.7z> or
<https://t.co/7LW7Xs3heB?amp=1> It is a massive dataset of 4.728.537
rows. earliest date found is: 2011-09-22 22:29:24 and latest 2013-10-14
00:46:22.

I’ve added the files as rds, fst, csv, and sqlite database file. Because
github is not a file storage, there is a limit and it probably doesn’t
like uploading 800mb files. Even zipped the csv is too big.

I’ve put the files on the open science framework:
<https://osf.io/cphtu/>

### How can I get the files?

You can either download and extract yourself Or download the files from
OSF by going to the link above, or use the package {osfr} created by
[the many great people at Ropensci]()

``` r
library(osfr)
```

    ## Automatically registered OSF personal access token

``` r
link <- "https://osf.io/cphtu/" # I created it manually.
project <- osf_retrieve_node(link)
data_files <- osf_ls_files(project,path = "data")
data_files
```

    ## # A tibble: 5 x 3
    ##   name          id                       meta            
    ##   <chr>         <chr>                    <list>          
    ## 1 data_clean    5ec2d790edc58c002d0aadef <named list [3]>
    ## 2 data_raw      5ec2d792edc58c002d0aadf5 <named list [3]>
    ## 3 scihub.fst    5ec2da85edc58c002d0ab12f <named list [3]>
    ## 4 scihub.rds    5ec2db72c7d4ab002621caa1 <named list [3]>
    ## 5 scihub.sqlite 5ec2dc5aedc58c002e0ac261 <named list [3]>

``` r
# download the fst format
# I'm assuming you created a data folder
osf_download(data_files[,3], path="data/")
```

### Supersimple overview of the data

When data gets into the millions of rows I often switch to a database.
Databases were designed to deal with lots of data. If you are using
tidyverse you can use almost all of your dplyr stuff on the database,
and it happens automatically. You only need to create a connection and
tbl object. (But the praises of a database are not why you came to this
page). In this case I created a sqlite database.

``` r
library(DBI)
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──

    ## ✓ ggplot2 3.3.0     ✓ purrr   0.3.4
    ## ✓ tibble  3.0.1     ✓ dplyr   0.8.5
    ## ✓ tidyr   1.0.2     ✓ stringr 1.4.0
    ## ✓ readr   1.3.1     ✓ forcats 0.5.0

    ## ── Conflicts ────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(dbplyr)
```

    ## 
    ## Attaching package: 'dbplyr'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     ident, sql

``` r
con <- DBI::dbConnect(RSQLite::SQLite(), "data/scihub.sqlite")
tbl_scihub <- tbl(con, "scihub")
```

Top DOI

``` r
tbl_scihub %>% count(DOI, sort=TRUE) %>% head(10) %>% collect()
```

    ## # A tibble: 10 x 2
    ##    DOI                                n
    ##    <chr>                          <int>
    ##  1 <NA>                          775160
    ##  2 10.1016/S0376-7388(03)00311-9    309
    ##  3 10.1038/nmat3258                 202
    ##  4 10.1016/S0378-8733(03)00013-3     97
    ##  5 10.1080/14736489.2011.596785      85
    ##  6 10.1016/j.cell.2012.05.044        84
    ##  7 10.1016/j.socnet.2009.07.001      82
    ##  8 10.1016/j.fct.2012.08.005         78
    ##  9 10.1038/nmat1849                  75
    ## 10 10.1021/cr100449n                 71

``` r
tbl_scihub %>% count(country, sort=TRUE) %>% head(10) %>% collect()
```

    ## # A tibble: 10 x 2
    ##    country         n
    ##    <chr>       <int>
    ##  1 Russia    1491679
    ##  2 Ukraine    447660
    ##  3 Iran       433392
    ##  4 India      229771
    ##  5 Brazil     218905
    ##  6 Argentina  122766
    ##  7 Belarus    103360
    ##  8 Portugal    94395
    ##  9 Germany     83887
    ## 10 China       82634

Are there super download users?

``` r
tbl_scihub %>% count(userid, sort=TRUE) %>% head(10) %>% collect()
```

    ## # A tibble: 10 x 2
    ##     userid     n
    ##      <dbl> <int>
    ##  1      NA 54013
    ##  2   -3916  5613
    ##  3   11091  5315
    ##  4 -402865  3826
    ##  5   16718  3797
    ##  6 -224684  3661
    ##  7 -559750  3208
    ##  8 -559751  3074
    ##  9 -226919  2985
    ## 10  218424  2974

``` r
# clean up
DBI::dbDisconnect(con)
```

Other links

  - <https://greenelab.github.io/scihub-manuscript/> tells us that “as
    of March 2017, Sci-Hub’s database contains 68.9% of the 81.6 million
    scholarly articles registered with Crossref and 85.1% of articles
    published in toll access journals”.
