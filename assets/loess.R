library(tidyverse)
library(broom)

data("diamonds")
set.seed(76)
diamonds <- diamonds %>%
  sample_n(500)

# Fit model: What do you think span does?
span <- 0.2
model_loess <- loess(price ~ depth, diamonds, span=span)

# Get augmented data set: price, depth, .fitted, etc
diamonds_augmented <- model_loess %>%
  augment() %>%
  tbl_df()
diamonds_augmented

ggplot(data=diamonds_augmented, aes(x=depth)) +
  # plot points:
  geom_point(aes(y=price)) +
  # show default ggplot2::geom_smooth() output:
  geom_smooth(aes(y=price), se=FALSE, span=span, size=2) +
  # same as loess() fitted values
  geom_line(aes(y=.fitted), col="red", size=1)

# In fact, geom_smooth() uses loess() as the default smoother when we have less
# than 1000 observations. See Arguments -> method in the following help file:
?geom_smooth
