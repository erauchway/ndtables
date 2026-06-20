library(tidyverse)
library(magrittr)
library(rvest)

tibble(state = c("District of Columbia", "Puerto Rico", "Virgin Islands", 
                 "Philippine Islands", "Panama Canal"), 
       st = c("DC", "PR", "VI", "PI", "PC")) %>%
  rbind(tibble(state = state.name, st = state.abb)) -> id

read_html("htmls/consol_loans1_justcols.png.html") %>%
  html_table() %>% pluck(1) %>%
  select(-"X15") %>%
  rename("state" = "X1")  %>%
  right_join(id) %>%
  relocate(st) %>%
  select(-state) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) %>%
  rename("FCA" = "X2", "Commodity Credit Corp" = "X3", "FSA" = "X4", 
         "Farm Tenant Purchase" = "X5", "REA" = "X6", "Fed Res Bd" = "X7", 
         "USHA" = "X8", "PWA loans" = "X9", "RFC" = "X10", 
         "Disaster Loan Corp" = "X11", "HOLC" = "X12", 
         "HOLC and Treas" = "X13", "Total Loans" = "X14") %>%
  rename_with(~ paste0(., "_loan")) %>%
  rename("st" = "st_loan") -> loans1_39

read_html("htmls/consol_loans2_justcols.png.html") %>%
  html_table() %>% pluck(1) %>%
  rename("state" = "X4") %>% right_join(id) %>% relocate(st) %>%
  select(-state) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) %>%
  rename("Title I" = "X1", "Title II" = "X2", "Total Insured" = "X3") %>%
  rename_with(~ paste0(., "_loan")) %>%
  rename("st" = "st_loan") -> loans2_39

left_join(loans1_39, loans2_39) -> loans_39

tibble(state = c("District of Col.", "Puerto Rico", "Virgin Islands", 
                 "Philippine Is.", "Panama Canal"), 
       st = c("DC", "PR", "VI", "PI", "PC")) %>%
  rbind(tibble(state = state.name, st = state.abb)) -> id

read_html("htmls/consol_exp1_justcols.png.html") %>%
  html_table() %>% pluck(1) %>%
  rename("state" = "X1") %>% right_join(id) %>% relocate(st) %>%
  select(-state) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) %>%
  rename("AAA" = "X2", "FSA" = "X3", "Other_ag" = "X4",
         "Bur of Rec" = "X5", "Rivers and Harbors" = "X6", "Natl Guard" = "X7",
         "CCC" = "X8", "SSA" = "X9", "NYA" = "X10", "Pub Bldgs" = "X11") -> exp1_39
read_html("htmls/consol_exp2_justcols.png.html") %>%
  html_table() %>% pluck(1) %>% rename("state" = "X10") %>%
  mutate(rn = row_number()) %>%
  relocate(rn) %>% ## missed out on some labels
  mutate("state" = case_when(rn == 20 ~ "Massachusetts",
                             rn == 50 ~ "Continental U.S. Total",
                             rn == 51 ~ "Alaska",
                             rn == 52 ~ "Hawaii",
                             rn == 53 ~ "Puerto Rico",
                             rn == 54 ~ "Virgin Islands",
                             rn == 55 ~ "Panama Canal",
                             rn == 56 ~ "Philippine Is.",
                             rn == 57 ~ "Territories Total",
                             TRUE ~ state)) %>%
  right_join(id) %>%
  relocate(st) %>% select(-c(rn, state)) %>%
  rename("Pub Rds" = "X1", "PWA_fed" = "X2", "PWA_nonfed" = "X3", "USHA" = "X4", "WPA" = "X5",
         "VA" = "X6", "Misc ERA" = "X7", "Other" = "X8", "Total_exp" = "X9") %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> exp2_39

right_join(exp1_39, exp2_39) -> exp_39

left_join(loans_39, exp_39) -> all_39

write_csv(all_39, "all_33-39.csv")

tibble(state = c("District of Columbia", "Puerto Rico", "Virgin Islands", 
                 "Philippine Islands", "Panama Canal"), 
       st = c("DC", "PR", "VI", "PI", "PC")) %>%
  rbind(tibble(state = state.name, st = state.abb)) -> id
read_html("htmls/consol_40_loans1_justcols.png.html") %>% 
  html_table() %>% pluck(1) %>%
  rename("state" = "X1") %>% mutate(state = gsub("\\.", "", state)) %>%
  rename("FCA_loan" = "X2", "Commodity Credit Corp_loan" = "X3",
         "FSA_loan" = "X4", "Farm Tenant Purchase_loan" = "X5", 
         "REA_loan" = "X6", "Fed Res Bd_loan" = "X7", "PWA loans_loan" = "X8", 
         "RFC_loan" = "X9", "Disaster Loan Corp_loan" = "X10", 
         "HOLC_loan" = "X11", "HOLC and Treas_loan" = "X12", 
         "Total Loans_loan" = "X13") %>%
  right_join(id) %>%
  relocate(st) %>% select(-state) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> loans1_40

read_html("htmls/consol_40_loans2_justcols.png.html") %>%
  html_table() %>% pluck(1) %>%
  rename("state" = "X11") %>%
  right_join(id) %>% relocate(st) %>% select(-state) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) %>%
  rename("Title I_loans" = "X1", "Title II_loans" = "X2", 
         "Total Insured_loan" = "X3", "AAA" = "X4", "Rur Rehab" = "X5", 
         "Resettlement" = "X6", "Fed Surp Comm" = "X7", "Reg Soil Con" = "X8", 
         "Land Util" = "X9", "Other Ag" = "X10") -> loans2_40

left_join(loans1_40, loans2_40) -> loans_40

read_html("htmls/consol_40_2b_justcols.png.html") %>% html_table() %>% pluck(1) %>%
  rename("state" = "X1", "CCC reg" = "X2", "CCC Indian" = "X3", "SSA" = "X4", 
         "USES" = "X5", "NYA" = "X6", "Pub Health" = "X7", "Pub Bldg" = "X8", 
         "Pub Rds" = "X9", "PWA_fed" = "X10", "PWA_nonfed" = "X11", 
         "USHA" = "X12", "WPA" = "X13") %>% right_join(id) %>%
  relocate(st) %>% select(-state) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> exp1_40
read_html("htmls/consol_40_2b2_justcols.png.html") %>% html_table() %>% pluck(1) %>%
  janitor::clean_names() %>% select(-x) %>%
  rename("state" = "x_9", "Bur of Rec" = "x_2", "Rivers and Harbors" = "x_3", 
         "Natl Guard" = "x_4", "VA" = "x_5", "Misc ERA" = "x_6", 
         "Other" = "x_7", "Total_exp" = "x_8") %>%
  right_join(id) %>% relocate(st) %>% select(-state) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> exp2_40

left_join(exp1_40, exp2_40) -> exp_40

left_join(loans_40, exp_40) -> all_40

write_csv(all_40, "all_40.csv")
