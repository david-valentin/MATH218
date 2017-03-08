library(tidyverse)
library(broom)

data("diamonds")
set.seed(76)
diamonds <- diamonds %>%
  sample_n(500)

# Fit model: What do you think span does?
span <- 0.8
model_loess <- loess(price ~ depth, diamonds, span=span)

# Again, the model object isn't all that useful by itself:
model_loess

# broom to the rescue! Get augmented data set: price, depth, .fitted, etc
diamonds_augmented <- model_loess %>%
  augment() %>%
  tbl_df()
diamonds_augmented

# Plot it all
ggplot(data=diamonds_augmented, aes(x=depth)) +
  # Plot points
  geom_point(aes(y=price)) +
  # Show default ggplot2::geom_smooth() output
  geom_smooth(aes(y=price), se=TRUE, span=span, size=2) +
  # Same loess() fitted values
  geom_line(aes(y=.fitted), col="red", size=1)

# In fact, geom_smooth() uses loess() as the default smoother when we have less
# than 1000 observations. See Arguments -> method in the following help file:
?geom_smooth

# EXERCISE: Visually compare smooth.spline() with loess() on the PS03 data,
# toying with both "smoothing" parameters: df and span respectively.
