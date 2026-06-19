library(tidyverse)
library(magrittr)
library(pdftools)
library(reticulate)
library(magick)
library(rvest)
library(janitor)
use_virtualenv("./ndt-env")

## we already have the first AK page from a previous exercise
## second AK page
file = "./terrtables9_1a.png"
system2(py_exe(), 
        args = c('-m mlx_vlm generate',
                 "--model mlx-community/GLM-OCR-bf16",
                 paste0("--image ", file),
                 "--max-tokens 24576",
                 "--temperature 0.0",
                 "--prompt \"Table Recognition: Extract the table exactly as shown. Do not repeat rows or columns. Output only the table, no explanation.\""),
        stdout = paste0(file, ".html")
)


## AK: read and clean ocr'ed data
read_html("./terrtables9_1.png.html") %>%
  html_table() %>%
  pluck(1) %>%
  clean_names() -> ak_1
read_html("./terrtables9_1a.png.html") %>%
  html_table() %>%
  pluck(1) %>%
  clean_names() -> ak_2
rbind(ak_1, ak_2) %>%
  filter(!str_starts(x, "Loans")) %>%
  filter(!str_starts(x, "TOTAL")) %>%
  filter(!str_starts(x, "Grants")) %>%
  mutate(across(2:last_col(), ~ gsub("\\$", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("\\,", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("\\-", "0", .))) %>%
  mutate(across(2:last_col(), ~ gsub("\\(", "", .))) %>% 
  mutate(across(2:last_col(), ~ gsub("\\)", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("f", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("g", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("\\/", "", .))) %>%
  replace(is.na(.), 0) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) -> ak_data
write_csv(ak_data, "ak_data.csv")
## first HI page
file = "./terrtables9_2.png"
system2(py_exe(), 
        args = c('-m mlx_vlm generate',
                 "--model mlx-community/GLM-OCR-bf16",
                 paste0("--image ", file),
                 "--max-tokens 24576",
                 "--temperature 0.0",
                 "--prompt \"Table Recognition: Extract the table exactly as shown. Do not repeat rows or columns. Output only the table, no explanation.\""),
        stdout = paste0(file, ".html")
)
## second HI page
file = "./terrtables9_3.png"
system2(py_exe(), 
        args = c('-m mlx_vlm generate',
                 "--model mlx-community/GLM-OCR-bf16",
                 paste0("--image ", file),
                 "--max-tokens 24576",
                 "--temperature 0.0",
                 "--prompt \"Table Recognition: Extract the table exactly as shown. Do not repeat rows or columns. Output only the table, no explanation.\""),
        stdout = paste0(file, ".html")
)
## read in and clean HI pages
read_html("./terrtables9_2.png.html") %>%
  html_table() %>%
  pluck(1) %>%
  clean_names() -> hi_1
read_html("./terrtables9_3.png.html") %>%
  html_table() %>%
  pluck(1) %>%
  clean_names() -> hi_2
# rbind(hi_1, hi_2) %>%
#   write_csv("hi_clean.csv")
## manual cleaning for cat names

read_csv("hi_clean.csv") %>%
  mutate(across(2:last_col(), ~ gsub("\\$", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("\\,", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("\\-", "0", .))) %>%
  mutate(across(2:last_col(), ~ gsub("\\(", "", .))) %>% 
  mutate(across(2:last_col(), ~ gsub("\\)", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("f", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("g", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("a\\/", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("e", "0", .))) %>%
  mutate(across(2:last_col(), ~ gsub("c", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("b", "", .))) %>%
  mutate(across(2:last_col(), ~ gsub("\\/", "", .))) %>%
  replace(is.na(.), "0") %>%
  mutate(across(2:last_col(), ~ as.numeric(.)))  -> hi_data
write_csv(hi_data, "hi_data.csv")

## Puerto Rico pages
file = "./terrtables9_4.png"
system2(py_exe(), 
        args = c('-m mlx_vlm generate',
                 "--model mlx-community/GLM-OCR-bf16",
                 paste0("--image ", file),
                 "--max-tokens 24576",
                 "--temperature 0.0",
                 "--prompt \"Table Recognition: Extract the table exactly as shown. Do not repeat rows or columns. Output only the table, no explanation.\""),
        stdout = paste0(file, ".html")
)
file = "./terrtables9_5.png"
system2(py_exe(), 
        args = c('-m mlx_vlm generate',
                 "--model mlx-community/GLM-OCR-bf16",
                 paste0("--image ", file),
                 "--max-tokens 24576",
                 "--temperature 0.0",
                 "--prompt \"Table Recognition: Extract the table exactly as shown. Do not repeat rows or columns. Output only the table, no explanation.\""),
        stdout = paste0(file, ".html")
)

## read in and clean PR pages
read_html("terrtables9_4.png.html") %>%
  html_table() %>%
  pluck(1) -> pr_1
read_html("terrtables9_5.png.html") %>%
  html_table() %>%
  pluck(1) -> pr_2
rbind(pr_1, pr_2) %>%
  clean_names() %>%
  filter(!str_starts(x, "Loans")) %>%
  filter(!str_starts(x, "TOTAL")) %>%
  filter(!str_starts(x, "Grants")) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> pr_data
write_csv(pr_data, "pr_data.csv")  

## VI page, OCR it
file = "./terrtables9_6.png"
system2(py_exe(), 
        args = c('-m mlx_vlm generate',
                 "--model mlx-community/GLM-OCR-bf16",
                 paste0("--image ", file),
                 "--max-tokens 24576",
                 "--temperature 0.0",
                 "--prompt \"Table Recognition: Extract the table exactly as shown. Do not repeat rows or columns. Output only the table, no explanation.\""),
        stdout = paste0(file, ".html")
)
## read and clean VI data
read_html("./terrtables9_6.png.html") %>%
  html_table() %>%
  pluck(1) %>%
  clean_names() %>%
  filter(!str_starts(x, "Loans")) %>%
  filter(!str_starts(x, "TOTAL")) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> vi_data
write_csv(vi_data, "vi_data.csv")

## PI & PC pages, OCR
file = "./terrtables9_7.png"
system2(py_exe(), 
        args = c('-m mlx_vlm generate',
                 "--model mlx-community/GLM-OCR-bf16",
                 paste0("--image ", file),
                 "--max-tokens 24576",
                 "--temperature 0.0",
                 "--prompt \"Table Recognition: Extract the table exactly as shown. Do not repeat rows or columns. Output only the table, no explanation.\""),
        stdout = paste0(file, ".html")
)

## read in and clean
read_html("terrtables9_7.png.html") %>%
  html_table() %>% pluck(1) %>%
  clean_names() %>%
  mutate(rn = row_number()) %>%
  relocate(rn) %>%
  filter(rn < 11) -> pc_raw
read_html("terrtables9_7.png.html") %>%
  html_table() %>% pluck(1) %>%
  clean_names() %>%
  mutate(rn = row_number()) %>%
  relocate(rn) %>%
  filter(rn >= 11) -> pi_raw
pc_raw %>%
  select(-rn) %>%
  filter(!str_starts(x, "Loans")) %>%
  filter(!str_starts(x, "TOTAL")) %>%
  filter(!str_starts(x, "Panama")) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~as.numeric(.))) %>%
  replace(is.na(.), 0) -> pc_data
write_csv(pc_data, "pc_data.csv")
pi_raw %>%
  select(-rn) %>%
  filter(!str_starts(x, "Loans")) %>%
  filter(!str_starts(x, "TOTAL")) %>%
  filter(!str_starts(x, "Phili")) %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> pi_data
write_csv(pi_data, "pi_data.csv")

## overall for 1933--1938
file = "terrtables9_overall.png"
system2(py_exe(), 
        args = c('-m mlx_vlm generate',
                 "--model mlx-community/GLM-OCR-bf16",
                 paste0("--image ", file),
                 "--max-tokens 24576",
                 "--temperature 0.0",
                 "--prompt \"Table Recognition: Extract the table exactly as shown. Do not repeat rows or columns. Output only the table, no explanation.\""),
        stdout = paste0(file, ".html")
)
read_html(paste0(file, ".html")) %>%
  html_table() %>% pluck(1) %>%
  clean_names() %>%
  rename("x" = "loans_closed") %>%
  mutate(across(2:last_col(), ~ gsub("[^0-9.]", "", .))) %>%
  mutate(across(2:last_col(), ~ as.numeric(.))) %>%
  replace(is.na(.), 0) -> overall_data
write_csv(overall_data, "overall_data.csv")
  
