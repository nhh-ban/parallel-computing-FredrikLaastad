library(tictoc)

#Function for printing tictoc log to table
printTicTocLog <-
  function() {
    tic.log() %>%
      unlist %>%
      tibble(logvals = .) %>%
      separate(logvals,
               sep = ":",
               into = c("Function type", "log")) %>%
      mutate(log = str_trim(log)) %>%
      separate(log,
               sep = " ",
               into = c("Seconds"),
               extra = "drop")
  }
#Clear log
tic.clearlog()

#Timer for Alternative 1:
tic("Alt1 Total - Sequential")
source("scripts/alt1.r")
toc(log = TRUE)

#Timer for Alternative 2:
tic("Alt2 Total - Parallel")
source("scripts/alt2.r")
toc(log = TRUE)

#Timer for Alternative 3: 
tic("Alt3 Total - MTweedietests with furrr")
source("scripts/alt3.r")
toc(log = TRUE)

printTicTocLog() %>%
  knitr::kable()

#My results:
#|Function type                        |Seconds |
#|:------------------------------------|:-------|
#|Sequential loop                      |99.41   |
#|Alt1 Total - Sequential              |146.86  |
#|Parallel loop, 8 cores               |76.89   |
#|Alt2 Total - Parallel                |124.55  |
#|Modified loop                        |42.53   |
#|Alt3 Total - MTweedietests with furrr |86.76   |

# As can be clearly seen, running the modification with the furrr package
# significantly reduces the time needed to complete the loop, so much so that
# the full runtime with furrr is less than running the first default loop.
# This is mainly caused by better utilization of the CPU during the loop:
# Default: 30-35%, Parallel: 40-80% (very sporadic), Furrr: 80-88% (locked)

