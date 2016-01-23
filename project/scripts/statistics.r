library(tikzDevice)
library(plyr)

# Read file
nobelAll.df <- read.table('finalData.csv', sep = ';', header = TRUE,  quote = "");
# Remove missing values
nobel.df <- na.omit(nobelAll.df)

##############
# POPULARITY #
##############

# # Boxplot of popularity
# tikz('../paper/figures/initialBox.tex', standAlone = TRUE)
# boxplot(nobel.df$Popularity, axes = F)
# axis(2,
#      at = c(0, 5e+06,              1e+07,    1.5e+07),
#  labels = c(0, "$5 \\times 10^6$", "$10^7$", "$1.5 \\times 10^7$"))
# box()
# dev.off()
# 
# # Density plot of popularity
# tikz('../paper/figures/initialDensity.tex', standAlone = TRUE)
# plot(density(nobel.df$Popularity), main = "",
#      axes = FALSE,
#      zero.line = false)
# axis(1, at = c(0, 10000000, max(nobel.df$Popularity)), 
#     labels = c(0, "$10^7$",   "$17 \\cdot 10^7$"))
# axis(2)
# box()
# dev.off()

# Log-transform popularity
nobel.df$LogPopularity = log(nobel.df$Popularity)
nobel.df$LogPopularity[nobel.df$LogPopularity == -Inf] <- 0

# # Density and boxplot of log-transformed popularity
# tikz('../paper/figures/transformedBox.tex', standAlone = TRUE)
# boxplot(nobel.df$LogPopularity, las = 2)
# dev.off()
# 
# tikz('../paper/figures/transformedDensity.tex', standAlone = TRUE)
# plot(density(nobel.df$LogPopularity), main = "",
#      zero.line = FALSE)
# dev.off()

# Standardise by category
nobel.df$LogPopularityStand <- ave(nobel.df$LogPopularity, 
                                   nobel.df$Type, 
                                   FUN = function(x) x / max(x))

# Test if there is sufficient difference in means
t.test(nobel.df$LogPopularityStand[nobel.df$Nobel == "yes"],
       nobel.df$LogPopularityStand[nobel.df$Nobel == "no"])
# Luckily -> yes.

################
# PRODUCTIVITY #
################

# tikz('../paper/figures/prodInitialBox.tex', standAlone = TRUE)
# boxplot(nobel.df$Productivity)
# dev.off()
# 
# tikz('../paper/figures/prodInitialDensity.tex', standAlone = TRUE)
# plot(density(nobel.df$Productivity))
# dev.off()

# Normalise popularity by category
nobel.df$ProductivityStand <- ave(nobel.df$Productivity, 
                                  nobel.df$Type, 
                                  FUN = function(x) x / max(x))

# Verify whether the means are different
t.test(nobel.df$ProductivityStand[nobel.df$Nobel == "yes"],
       nobel.df$ProductivityStand[nobel.df$Nobel == "no"])
# Luckily -> yes (although only slightly).

# Save resulting files
variables <- c("Nobel", "Country", "Year", "UniversityScore", 
               "LogPopularityStand", "ProductivityStand")
nobel.subs <- nobel.df[variables]
names(nobel.subs)[5] = "Popularity"
names(nobel.subs)[6] = "Productivity"
write.table(nobel.subs, "trainingSet.csv", sep = ";",
            row.names = FALSE)
