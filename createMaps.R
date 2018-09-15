install.packages('tidyverse')

library(tidyverse)

elton <- read_delim('interactions-elton-20180913-interactgroups-time-lat-lng.tsv.gz', delim='\t', quote='', col_names=T)

world <- map_data("world")

# plot single
png(file='figures/map_all.png')
d <- ggplot()
d <- d + geom_map(data=world, map=world, aes(x=long, y=lat, map_id=region), color="white", fill="#7f7f7f", size=0.05, alpha=1/4)
d <- d + geom_hex(data=elton, mapping=aes(x=lng, y=lat), binwidth=c(4,2)) 
d <- d + xlim(-180, 180) + ylim(-90, 90)
d <- d + coord_quickmap() + labs(title='geospatial distribution of interaction records') + scale_fill_viridis_c(name='count', trans='log1p')
d
dev.off()

png(file='figures/map_types.png')
# plot with facets
d + geom_hex(data=elton, mapping=aes(x=lng, y=lat), binwidth=c(8,4)) + coord_quickmap() + scale_fill_viridis_c(name="count", trans="log1p") + facet_wrap( ~ type) + labs(title='geospatial distribution interaction record types')
dev.off()

png(file='figures/temporal_types.png')
t <- ggplot(elton, aes(x = time)) + xlim(parse_datetime("1850-01-01"), parse_datetime("2019-01-01")) + scale_y_continuous(trans="log1p") + labs(title='temporal distribution of interaction record types') 
t + geom_histogram() + facet_wrap( ~ type)
dev.off()
