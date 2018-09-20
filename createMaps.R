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

world <- map_data("world")

install.packages(c('gridExtra', 'cowplot'))

library(grid)
library(gridExtra)
library(cowplot)

plotMap <- function(lat_range = c(-90, 90), 
                        lng_range = c(-180, 180), 
                        t_range = c(as.POSIXct('1900-01-01'), as.POSIXct('2019-01-01')),
                        bins = 160,
                        title = 'Geospatial-temporal species interaction record count\n1900-2019 source: GloBI Sept 2018') {

    lat_time <- ggplot(elton) + stat_bin_2d(bins = bins, aes(x=time, y=lat)) 
    lat_time <- lat_time + scale_x_datetime(limits = t_range)
    lat_time <- lat_time + scale_fill_viridis_c(name='count', trans='log1p', option='magma') 
    lat_time <- lat_time + scale_y_continuous(limits = lat_range) + guides(fill=FALSE) + theme_nothing();


    lng_time <- ggplot(elton) + stat_bin_2d(bins = bins, aes(x=lng, y=time)) 
    lng_time <- lng_time + scale_y_datetime(limits = t_range) 
    lng_time <- lng_time + scale_fill_viridis_c(name='count', trans='log1p', option='magma') 
    lng_time <- lng_time + scale_x_continuous(limits = lng_range) + guides(fill=FALSE) + theme_nothing();


    lng_lat <- ggplot(elton) + stat_bin_2d(bins = bins, aes(x=lng, y=lat)) 
    lng_lat <- lng_lat + scale_fill_viridis_c(name='count', trans='log1p') + guides(fill=FALSE) 
    lng_lat <- lng_lat + geom_map(data=world, map=world, aes(x=long, y=lat, map_id=region), color="white", fill="#7f7f7f", size=0.05, alpha=1/4)  
    lng_lat <- lng_lat + theme_nothing() 
    lng_lat <- lng_lat + scale_x_continuous(limits = lng_range) 
    lng_lat <- lng_lat + scale_y_continuous(limits = lat_range);

    blank_plot <- ggplot() + geom_blank(aes(1,1))
    blank_plot <- blank_plot + annotate("text", x = 15, y = 20, label = "<-- time", hjust = 1)
    blank_plot <- blank_plot + annotate("text", x = 20, y = 15, label = "time --> ", angle = -90, hjust=-1)
    blank_plot <- blank_plot + theme_nothing()

    grid.arrange(lat_time, lng_lat, blank_plot, lng_time, ncol=2, nrow=2, top = title)
}


pngImage <- function(name) {
    png(file=name, width=1024, height=768)
}

pngImage(name = 'figures/time_lat_lng.png')
plotMap()
dev.off()

pngImage('figures/time_lat_lng_north_sea.png')
# north sea
plotMap(lat_range =c(50,60), 
            lng_range = c(-2,9), 
            t_range = c(as.POSIXct('1950-01-01'), as.POSIXct('2019-01-01')),
            bins = 100,
            title = 'Geospatial-temporal species interaction record count\nNorth Sea 1950-2019 source: GloBI Sept 2018')
dev.off()

pngImage('figures/time_lat_lng_pacific_north_east.png')
plotMap(lat_range =c(50, 70), 
            lng_range = c(-180, -160), 
            t_range = c(as.POSIXct('1950-01-01'), as.POSIXct('2019-01-01')),
            bins = 100,
            title = 'Geospatial-temporal species interaction record count\nPacific North East 1950-2019 source: GloBI Sept 2018')
dev.off()

