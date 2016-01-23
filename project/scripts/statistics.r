nobelAll.df <- read.table('finalData.csv', sep = ';', header = TRUE,  quote = "");
nobel.df <- na.omit(nobelAll.df)

plot(density(log(nobel.df$Popularity)))

n <- length(nobel.df$Popularity)
sort(nobel.df$Popularity, partial=n-16)[n-16]

NewPop <- nobel.df$Popularity[which(nobel.df$Popularity < 175000)]

popBp <- boxplot.stats(nobel.df$Popularity, coef = 3)
summary(popBp)
plot(popBp)



nobel.popularity.bp <- boxplot.stats(nobel.df$Popularity)
plot(density(nobel.df$Popularity, na.rm = TRUE))

par(mfrow = c(2,2))
by(nobel.df$Productivity, nobel.df$Type, function(x) plot(density(x)))
by(nobel.df$Popularity, nobel.df$Type, function(x) plot(density(x)))

# Normalise by category
by(nobel.df$Productivity, nobel.df$Type, function(x) (x / max(x, na.rm = TRUE)));
by(nobel.df$Popularity, nobel.df$Type, function(x) (x / max(x, na.rm = TRUE)));

# Scholar <- Scholar[rowSums(is.na(Scholar)) == 0,];
# ScholarRankings <- Scholar$V2;
# ScholarRankings <- (ScholarRankings - min(ScholarRankings)) / (max(ScholarRankings - min(ScholarRankings)))
# 
# Speeches <- read.table('numberofspeeches.csv', sep = ',', header = TRUE, quote = "");
# SpeechesRankings <- Speeches$count;
# SpeechesRankings <- (SpeechesRankings - min(SpeechesRankings)) / (max(SpeechesRankings - min(SpeechesRankings)))
# 
# boxplot(SpeechesRankings);
# boxplot(ScholarRankings);
# 
# par(mfrow=c(1,2));
# plot(density(ScholarRankings), main = 'Scholar');
# plot(density(SpeechesRankings), main = 'Speeches');
# 
# # remove outliers
# x1 <- ScholarRankings[!ScholarRankings %in% boxplot.stats(ScholarRankings)$out];
# x2 <- SpeechesRankings[!SpeechesRankings %in% boxplot.stats(SpeechesRankings)$out];
# 
# boxplot(x1);
# boxplot(x2);
# 
# par(mfrow=c(1,2));
# plot(density(x1), main = 'Scholar');
# plot(density(x2), main = 'Speeches');
