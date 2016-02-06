library(igraph)
library(dplyr)

df <- read.csv("R_qq_troop.csv", stringsAsFactors = F)
df <- transmute(df, qq, group = as.character(troopid))
group_count <- count(df, group, sort = T)
group_selected <- group_count$group[1:50]
df_selected <- filter(df, group %in% group_selected)
qq_count <- count(df_selected, qq, sort=T)
qq_selected <- filter(qq_count, n > 10)$qq
df_selected <- filter(df_selected, qq %in% qq_selected)
g <- graph.data.frame(df_selected, directed = F)
V(g)$color <- 'black'
V(g)[unique(df_selected$group)]$color <- 'red'
tkplot(g, vertex.label = NA, vertex.size = 2, layout = layout.kamada.kawai)
