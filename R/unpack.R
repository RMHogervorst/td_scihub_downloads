# requires  package I had not heard of before, requires libarchive on macos.
# devtools::install_github("jimhester/archive")
# http://sci-hub.se/downloads/ancient.sci-hub.stats.7z
# raw file explroation
archive::archive("data/data_raw/ancient.sci-hub.stats.7z")
# # A tibble: 2 x 3
# path                              size date
# <chr>                            <dbl> <dttm>
# 1 ancient.sci-hub.stats.readme      1821 2020-01-27 16:54:26
# 2 ancient.sci-hub.stats.tab    752870894 2020-01-27 16:27:57
# extract
archive::archive_extract("data/data_raw/ancient.sci-hub.stats.7z",dir = "data/data_clean/")
