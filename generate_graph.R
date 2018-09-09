install.packages('ggplot2')

library(ggplot2)

data_stats <- read.table('dataset_stats.tsv', sep='\t', header=T)

png(filename="dataset_stats.png")

qplot(data_stats$n_taxa, data_stats$n_interactions, data = data_stats, shape = data_stats$format, colour = data_stats$format, log="xy", xlab ="log(# taxa)", ylab = "log( # interactions)", main = 'interaction datasets by number of taxa, interactions and format\nSource: globalbioticinteractions.org accessed at 2018-09-10.')

dev.off()

