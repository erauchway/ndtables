library(tidyverse)
library(magrittr)
library(ggrepel)
source("map_chart_defaults.R")
hide_zero <- function(fmt) {
  function(x) {
    labels <- fmt(x)
    labels[x == 0] <- ""
    labels
  }
}
my_pal = c("chocolate3", "midnightblue")

read_csv("nd_ttl.csv") %>%
  left_join(read_csv("popvar.csv")) %>%
  mutate(isterr = case_when(st == "AK" | st == "HI" | st == "PR" | st == "VI" | st == "PC" | st == "PI" ~ TRUE,
                            TRUE ~ FALSE)) -> nd

nd %>%
  ggplot() +
  ## geom_smooth(aes(x = log(mean_pop), y = log(le)), method = "lm", se = FALSE,
  ##            color = alpha(c("indianred"), 0.3)) +
  geom_text_repel(aes(x = log(mean_pop), y = log(le), label = st, color = isterr),
                  min.segment.length = Inf, seed = 42, force_pull = 10, 
                  size = 8, max.overlaps = 100, 
                  family = "Averia Serif Libre", 
                  arrow = arrow(length = unit(1, "mm"))) +
  scale_color_manual(values = my_pal) +
  theme(
    text = element_text(size = 14),
    plot.title = element_markdown(size = 24, margin = unit(c(0,1,1,0), "mm")),
    plot.subtitle = element_markdown(size = 18, margin = unit(c(2,0,6,0), "mm")),
    plot.caption = element_markdown(size = 16, margin = unit(c(4,3,1,0), "mm"), lineheight = 1.1),
    plot.margin = unit(c(10,18,10,12), "mm"),
    axis.title = element_markdown(margin = unit(c(2,2,3,2), "mm")),
    axis.ticks = element_blank(),
    axis.text = element_text(color = NA),
    axis.line = element_blank(),
    panel.background = element_rect(fill = alpha("aliceblue", alpha = 0.4))
  ) +
  labs(
    title = "Federal Loans and Expenditures by State or Territory, 1933--1940",
    subtitle = "As a function of population (log relation)",
    x = "Mean population, 1930--1940",
    y = "New Deal Spending in Dollars",
    caption = "Chart made with R and ggplot by Eric Rauchway with data in \"Consolidated State Report of Federal Loans and Expenditures\" for 1933--1939<br>
    and for 1939--1940, kindly supplied by the California State Library. Standard USPS abbreviations plus VI = Virgin Islands, PR = Puerto Rico,<br>
    PI = Philippine Islands, PC = Panama Canal zone."
    
  ) +
  guides(color = "none")
ggsave("nd.png", height = 16, width = 16, dpi = 300, bg = "floralwhite")
