SHELL=/bin/bash

dataset_stats.pdf: dataset_stats.tsv
	R --no-save < generate_graph.R

dataset_stats.tsv:
	# retrieve dataset info
	R --no-save < generate_dataset_report.R
	cut -f2- namespace_datasets.tsv  | sort > namespace_datasets_sorted.tsv
	cat namespace_formats.tsv | sort > namespace_formats_sorted.tsv
	# merge info with formats
	join -t $$'\t' namespace_datasets_sorted.tsv namespace_formats_sorted.tsv > dataset_formats.tsv
	cat dataset_formats.tsv | cut -f2,3,4,7,8,10 | awk -F '\t' '{ print $$1 "\t" $$2 "\t" $$6 "\t" $$4 "\t" $$5 }' | sort | uniq | sort -nr > dataset_stats_no_header.tsv
	# add header
	echo -e "n_taxa\tn_interactions\tformat\tarchiveURI\tdateAccessed" | cat - dataset_stats_no_header.tsv > dataset_stats.tsv


