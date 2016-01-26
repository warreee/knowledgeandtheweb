# Read file
poliAll.df <- read.table('finalPoliticians.csv', sep = ';', header = TRUE,  quote = "");
# Remove missing values
poli.df <- na.omit(poliAll.df)

# Transform popularity
poli.df$Popularity <- log(poli.df$Popularity)
poli.df$Popularity <- (poli.df$Popularity / max(poli.df$Popularity)) * 100;

# Transform productivity
poli.df$Productivity <- (poli.df$Productivity / max(poli.df$Productivity)) * 100;

# Write table
write.table(poli.df, "testingSet.csv", sep = ";",
            row.names = FALSE);