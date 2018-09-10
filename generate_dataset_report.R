install.packages('rglobi')

queryFile <- file('cypher.txt', 'r')
query <- readLines(queryFile)
query_string <- paste(query, sep= " ", collapse = " ")
rglobi::query(query_string)
datasets <- rglobi::query(query_string)
write.table(datasets, file='namespace_datasets.tsv', sep='\t', row.names=F, quote=F)
write.table(datasets, file='namespace_datasets.csv', sep='\t', row.names=F)
