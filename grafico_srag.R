
pop = read.csv("https://raw.githubusercontent.com/belisards/coronabr/master/dados/auxiliares/populacao.csv")

df = estadual %>% filter(ano == 2020) %>% left_join(.,pop) %>% mutate(taxa = (casos/populacao)*1000000) 

plot = df %>% filter(epiweek < max(epiweek)-3) 

top = plot %>% arrange(taxa) %>% head(5) %>% select(uf) %>% unlist()

grafico = plot %>% filter(uf %in% top)

ggplot(grafico,aes(epiweek,taxa,group=territory_name,colour=uf)) + geom_line()
