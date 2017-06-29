# Scatterplot with fitted regression line
# Nick Evangelopoulos, University of North Texas, March 2015-March 2016
# Adapted from Code School's Try R tutorial
#
# Notes:
#   - save files Piracy2013.csv and GDP2013.csv in the working directory
#   - wd is here set to D:\RApps, but C:\temp may work better for you

# Step 1: Read the data into two matrices, then merge them
setwd("D:/RApps")  # Set working directory
piracy <- read.csv("Piracy2013.csv")
gdp <- read.csv("GDP2013.csv")
countries <- merge(x = gdp, y = piracy)

# Step 2: produce a scatterplot and add a fitted regression line
plot(countries$PCGDP, countries$PiracyRate)
line <- lm(countries$PiracyRate ~ countries$PCGDP)
abline(line)

# Step 3: fit a quadratic regression model
gdpsq <- countries$PCGDP^2
fit <- lm(PiracyRate ~ PCGDP + gdpsq, data=countries)
summary(fit)       # model summary
plot(fit)          # diagnostic plots: hit enter to get the next plot

# Step 4: delete row #81, and refit the model
countries <- countries[-c(81), ]
gdpsq <- countries$PCGDP^2
fit <- lm(PiracyRate ~ PCGDP + gdpsq, data=countries)
summary(fit)       # model summary
plot(fit)          # diagnostic plots: hit enter to get the next plot
