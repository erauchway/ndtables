library(tidyverse)
library(magrittr)
read_csv("overall_33-38.csv") %>%
  mutate(x = case_when(x == "Federal Housing Administration" ~ "Title I",
                       x == "Title I - Notes Insured" ~ "Title II",
                       TRUE ~ x)) %>%
  filter(!str_starts(x, "Grants")) %>%
  filter(!str_starts(x, "Title II - Mort")) -> overall38
read_csv("all_33-39.csv") -> all3339

## consolidate into metacategories

all3339 %>%
  mutate(Ag = FCA_loan + `Commodity Credit Corp_loan` + FSA_loan + `Farm Tenant Purchase_loan` +
           REA_loan + AAA + FSA + Other_ag) %>%
  mutate(FHA = `Title I_loan` + `Title II_loan`) %>%
  mutate(FLA = RFC_loan + `Disaster Loan Corp_loan` + HOLC_loan + `HOLC and Treas_loan`) %>%
  mutate(War = `Rivers and Harbors`+ `Natl Guard`) %>%
  mutate(Int = `Bur of Rec`) %>%
  mutate(FRB = `Fed Res Bd_loan`) %>%
  mutate(PWA = `PWA loans_loan` + PWA_fed + PWA_nonfed) %>%
  mutate(FWA = USHA_loan + USHA + `Pub Bldgs` + `Pub Rds`) %>%
  mutate(WPA = WPA + NYA) %>%
  mutate(CCC = CCC) %>%
  mutate(SSA = SSA) %>%
  mutate(VA = VA) %>%
  mutate(ERA = `Misc ERA`) %>%
  mutate(Other = Other) %>%
  select(c(st, Ag, FHA, FLA, War, Int, FRB, PWA, FWA, WPA, CCC, SSA, VA, ERA, Other)) -> sim3339
  
## overall38 %>% distinct(x) %>% write_csv("cats38.csv")
## manually created lookup table

lookup <- read_csv("cats38.csv")

overall38 %>%
  left_join(lookup, by = "x") %>%
  pivot_longer(-c(x, cat), names_to = "year", values_to = "amount") %>%
  summarize(known_yrs = sum(amount), .by = cat) %>%
  mutate(known_yrs = known_yrs * 1000) -> totals3338

sim3339 %>%
  summarize(across(2:last_col(), sum)) %>%
  pivot_longer(everything(), names_to = "cat", values_to = "amount") -> totals3339

just39 <- totals3339 %>%
  left_join(totals3338)  %>%
  mutate(amount39 = amount - known_yrs) %>%
  mutate(prop = amount39/amount)
