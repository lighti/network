library(igraph)
library(dplyr)

##get active users
auser<-read.csv("SQL_login_signup.csv", stringsAsFactors = F) %>% 
  transmute(spellname, lastlogindiff)
auser <- filter(auser, lastlogindiff <= 7)
userqq <- read.csv("SQL_spellname_qq.csv", stringsAsFactors = F)
auser <- left_join(auser, userqq, by = c("spellname" = "spellname")) %>% 
  filter(!is.na(qq)) %>% transmute(qq = qq, lastlogindays = lastlogindiff)

##get edges associated with auserqq
df <- read.csv("R_qq_troop.csv", stringsAsFactors = F)
df <- transmute(df, qq, group = as.character(troopid))
df_auserqq <- filter(df, qq %in% auser$qq)
df_ausergroup <- filter(df, group %in% df_auserqq$group)
ausergroup_count <- count(df_ausergroup, group, sort = T)
group_selected <- filter(ausergroup_count, n > 100)
df_selected <- filter(df_auserqq, group %in% group_selected$group)

##plot graph
g <- graph.data.frame(df_selected, directed = F)
V(g)$color <- 'black'
V(g)[unique(df_selected$group)]$color <- 'red'
tkplot(g, vertex.label = NA, vertex.size = 2, layout = layout.grid)
