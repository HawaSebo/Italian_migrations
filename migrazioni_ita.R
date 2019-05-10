### animated plot of italian internal migrations

# libraries
library(tidyverse)
library(haven)
library(gganimate)
library(scales)

# setwd
setwd("/home/paolo/Dropbox/R playground/migrazioni ita/")

# migration data
df <- read_csv("saldi_migratori.csv")

# reshape migration data
df <- df %>% 
  gather(region, migration, -Year) %>% 
  mutate(region = tolower(region))

# shapefile data, regional level
load("shapefile_istat_regioni.rda")
it <- shapedata_istat_regioni
rm(shapedata_istat_regioni)


#renaming variables to match
it <- it %>% 
  mutate(region = tolower(region)) %>% 
  as_tibble()

## merging the two datasets
data <- full_join(it, df, by = c("region")) %>% as_tibble()

## taking care of data types
data <- data %>% 
  mutate(migration = as.numeric(migration))


### plotting

# theme TODO
base_family = "Roboto Condensed"
base_size = 11.5
plot_title_family = base_family
plot_title_size = 18
plot_title_face = "bold"
plot_title_margin = 10
subtitle_family = "Roboto Condensed Light"
subtitle_size = 13
subtitle_face = "plain"
subtitle_margin = 15
caption_family = "Roboto Condensed Light"
caption_size = 9
caption_face = "plain"
caption_margin = 10
plot_margin = margin(30, 30, 30, 30)

theme_set(theme_void(base_family = "Roboto Condensed", base_size = 11.5)+
            theme(legend.position = "right")+
            theme(plot.title = element_text(hjust = 0, 
                                            size = plot_title_size, 
                                            margin = margin(b = plot_title_margin), 
                                            family = plot_title_family, 
                                            face = plot_title_face))+
            theme(plot.subtitle = element_text(hjust = 0,
                                               size = subtitle_size, 
                                               margin = margin(b = subtitle_margin), 
                                               family = subtitle_family, 
                                               face = subtitle_face))+
            theme(plot.caption = element_text(hjust = 1,
                                              size = caption_size,
                                              margin = margin(t = caption_margin), 
                                              family = caption_family, 
                                              face = caption_face))+
            theme(plot.margin = plot_margin))



## plot
anim <- data %>% 
  mutate(migrationF = cut(migration, 
                          breaks = c(-100 , -20 ,-10 , -5, -2.5, -1, 0 , 1,  2.5,  5 , 10 , 100),
                          labels = c("<-20","-20 to -10","-10 to -5","-5 to -2.5","-2.5 to -1","-1 to 0",
                                     "0 to 1", "1 to 2.5", "2.5 to 5", "5 to 10",">10"))) %>% 
  ggplot(aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill=migrationF), colour = "grey90")+
  coord_fixed()+
  scale_fill_brewer(name ="", palette = "RdYlGn")+
  transition_manual(Year)+
  ease_aes()+
  labs(title = "Internal migration rates in Italy • {frame+1951}",
       subtitle = "Yearly incoming internal migrants over resident population",
       caption = "Data: ISTAT  •  code: @PaoloCrosetto")+
  guides(fill = guide_legend(reverse = TRUE))

#animation
animate(plot = anim, 
        fps = 1, 
        duration = 63)
anim_save("italian_migrations.gif")
