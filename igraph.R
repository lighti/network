library(igraph)
library(dplyr)

df <- read.csv("R_qq_troop.csv", stringsAsFactors = F)
df <- transmute(df, qq, group = as.character(troopid))
group_count <- count(df, group, sort = T)
group_selected <- group_count$group[1:5]
df_selected <- filter(df, group %in% group_selected)
g <- graph.data.frame(df_selected, directed = F)
V(g)[group_selected]$color <- 'red'
tkplot(g, vertex.label = NA, vertex.size = 2, layout = layout.random)
