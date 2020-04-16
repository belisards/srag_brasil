# Script para extrair dados de SRAG do site Infogripe - http://info.gripe.fiocruz.br/
library(tidyverse)

# Gera os links, criando todas as combinações de semanas (1:53) e anos (2018:2020), no formato da URL
lista_links = do.call(sprintf, c(expand.grid(2009:2020,1:53), fmt = 'http://info.gripe.fiocruz.br/data/detailed/1/2/%s/%s/1/Brasil/data-table'))

# Ao raspar os dados, descataremos JSON nulos e vamos adicionar um campo com a URL de onde foram extraídos.
raspa_link = function(link){
  print(paste("Acessando a URL: ",link))
  arquivo = jsonlite::fromJSON(link) %>% purrr::pluck("data") 
  if (!is.null(arquivo)) { 
    arquivo %>% mutate(url = link)
  }
}

# Cria a base e adiciona um campo numérico com os casos e outro com o ano
base = bind_rows(lapply(lista_links,raspa_link)) %>% mutate(casos = as.integer(str_extract(value,"[0-9]+"))) %>% mutate(ano = str_extract(url,'\\d{4}'))

# Separamos os dados agregados por UF dos dados agregados nacionais
nacional = base %>% filter(territory_name == 'Brasil') 
estadual = base %>% filter(territory_name != 'Brasil') 

# Vamos reordenar as colunas na hora de exportar os dados para facilitar a leitura
ordem_colunas = c("ano","epiweek","casos","territory_name", "situation_name","value")

# Exporta os arquivos
write_csv(estadual[,ordem_colunas],"dados_uf.csv")
write_csv(nacional[,ordem_colunas],"dados_br.csv")