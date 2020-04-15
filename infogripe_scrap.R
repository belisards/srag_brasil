# Script para extrair dados de SRAG do site Infogripe
# Baseado neste script de Rodolfo Viana
# https://github.com/rodolfo-viana/dailylog/blob/master/scripts/covid19srag.py

library(tidyverse)

df = data.frame()

for (ano in 2009:2020){
  
  #SE = Semana Epidemiológica (epiweek)
  for (SE in 1:53){
    
    print(paste('Acessando a SE',SE,"do ano",ano))
    url = stringr::str_glue('http://info.gripe.fiocruz.br/data/detailed/1/2/{ano}/{SE}/1/Brasil/data-table')
    dados_json = jsonlite::fromJSON(url) %>% purrr::pluck("data") 
    
    # Solicitar a SE 53 para anos que não a possuem geram JSON nulos. Não os queremos.
    if (!is.null(dados_json)) { 
    dados = dados_json %>% mutate(ano = ano)
    }
    df = rbind(df,dados)
  }
}

# Vamos remover registros duplicados. E criar um campo numérico para os casos.
df = df[!duplicated(df),] %>% mutate(casos = as.integer(str_extract(value,"[0-9]+"))) 

# E separar 2 datasets. Um nacional agregado e outro por UF.
df_brasil = df %>% filter(territory_name == 'Brasil') 
df = df %>% filter(territory_name != 'Brasil') 

write_csv(df[,c("ano","epiweek","casos","territory_name", "situation_name","value")],"dados_uf.csv")

write_csv(df[,c("ano","epiweek","casos","territory_name", "situation_name","value")],"dados_br.csv")

