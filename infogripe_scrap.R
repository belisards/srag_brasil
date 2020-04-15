# Script para extrair dados de SRAG do site Infogripe
# Baseado neste script de Rodolfo Viana
# https://github.com/rodolfo-viana/dailylog/blob/master/scripts/covid19srag.py

library(tidyverse)

df <- data.frame()

for (ano in 2009:2020){
  #SE = Semana Epidemiológicaa
  for (SE in 1:53){
    print(paste('baixando a SE',SE,"do ano",ano))
    
    url = stringr::str_glue('http://info.gripe.fiocruz.br/data/detailed/1/2/{ano}/{SE}/1/Brasil/data-table')
    base <- jsonlite::fromJSON(url) %>% purrr::pluck("data") %>% mutate(casos = str_extract(value,"[0-9]+")) %>% mutate(ano = ano)
    df <- rbind(df,base)
  }
}

ordem_colunas <- c("ano","epiweek", "territory_name","casos", "situation_name","value")

df <- df[, ordem_colunas] %>% filter(territory_name != 'Brasil') %>% arrange(-ano)

write_csv(df,"dados.csv")
