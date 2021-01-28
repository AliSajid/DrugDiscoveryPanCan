library(tidyverse)
devtools::load_all()

target <- c("HCK", "ABL2", "FYN")
input_lib <- c("KD")
output_lib <- c("CP")
filter_threshold <- c(0, 0.26, 0.5, 0.85, 1)
paired <- c(TRUE, FALSE)
discordant <- c(TRUE, FALSE)
similarity_threshold <- 0

g <- expand_grid(target, input_lib, output_lib, filter_threshold, similarity_threshold, paired, discordant)

filenames <- g %>%
  mutate(ispaired = if_else(paired, "paired", "unpaired"),
         isdiscordant = if_else(discordant, "discordant", "concordant")) %>%
  unite(file, target, input_lib, filter_threshold, ispaired, isdiscordant) %>%
  pull(file) %>%
  paste("csv", sep = ".") %>%
  file.path("inst", "results", .)

g %>%
  pmap(investigate_target) %>%
  walk2(filenames, ~ write.csv(.x, .y))
