library(tidyverse)
library(magrittr)
library(rvest)

read_html("htmls/terrtables9_overall.png.html") %>% html_table() %>%
  pluck(1) %>% janitor::clean_names() %>% rename("x" = "loans_closed") -> overall1
read_html("htmls/terrtables9_overall2.png.html") %>% html_table() %>%
  pluck(1) %>% janitor::clean_names() %>% rename("x" = "grants_etc_contd") -> overall2

rbind(overall1, overall2) %>%
  filter(!str_starts(x, "Loans")) %>%
  filter(!str_starts(x, "TOTAL")) %>%
  mutate(x = gsub("\\*", "", x)) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> overall38
write_csv(overall38, "overall_33-38.csv")

