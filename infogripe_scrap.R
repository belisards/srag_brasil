# Script para extrair dados de SRAG do site Infogripe - http://info.gripe.fiocruz.br/
library(tidyverse)
##################### PARÂMETROS GERAIS ############################################
semana = 1:53
ano = 2009:2020
url_base = 'http://info.gripe.fiocruz.br/data/detailed/1/2/'
#estados = read.csv('https://raw.githubusercontent.com/belisards/dados_auxiliares/master/UFs.csv')

# Gera os links, criando todas as combinações de semanas (1:53) e anos (2018:2020), no formato da URL
url_casos = paste(url_base,"%s/%s/1/Brasil/","data-table", sep = '')
url_detalhe = paste(url_base,"%s/%s/Brasil/","age-distribution", sep = '')
#url_detalheUF = paste(url_base,"%s/%s/%s/","age-distribution",sep='')

lista_casos = do.call(sprintf, c(expand.grid(ano,semana), fmt = url_casos))
lista_detalhe = do.call(sprintf, c(expand.grid(ano,semana), fmt = url_detalhe))
#lista_detalheUF = do.call(sprintf, c(expand.grid(ano,semana,estados$estado), fmt = url_detalheUF))


##################### FUNÇÕES ############################################
# Ao raspar os dados, descataremos JSON nulos e vamos adicionar um campo com a URL de onde foram extraídos.
# Vamos criar expressões regulares para extrair ano e semana da URL, quando ausente nos dados
regex_ano = '\\d{4}'

raspa_casos = function(link){
  print(paste("Acessando a URL: ",link))
  arquivo = jsonlite::fromJSON(link) %>% purrr::pluck("data") 
  if (!is.null(arquivo)) { 
    arquivo %>% mutate(url = link) %>%
    mutate(ano = str_extract(link,regex_ano))
  }
}

# Para ler os dados de faixa etária no Brasil
regex_epiweek = '(?<=\\d{4}\\/)\\d+'

raspa_detalhe = function(link){
  print(paste("Acessando a URL: ",link))
  arquivo = read.csv(link)
  if (!is.null(arquivo)) { 
    arquivo %>% mutate(url = link) %>%
    mutate(ano = str_extract(link,regex_ano)) %>%
    mutate(epiweek = str_extract(link,regex_epiweek))
  }
}


##################### SCRAP ############################################
## DETALHADO POR GÊNERO E FAIXA ETÁRIA
# Para raspar os dados de faixa etária, podemos ler como CSV diretamente. 
df_detalhe = bind_rows(lapply(lista_detalhe,raspa_detalhe)) 

unique(df_detalhe$epiweek)

# CASOS TOTAIS POR ESTADO E NACIONAL
# Cria a base de casos e adiciona um campo numérico limpo com os casos totais
df_casos = bind_rows(lapply(lista_casos,raspa_casos)) %>% 
mutate(casos = as.integer(str_extract(value,"[0-9]+")))

# Separamos os dados agregados por UF dos dados agregados nacionais
df_casos_br = df_casos %>% filter(territory_name == 'Brasil') 
df_casos_uf = df_casos %>% filter(territory_name != 'Brasil') 


##################### EXPORTAÇÃO ############################################
# Vamos reordenar as colunas na hora de exportar os dados para facilitar a leitura
ordem_colunas = c("ano","epiweek","casos","territory_name", "situation_name","value")

# Exporta CSV
write_csv(df_casos_uf[,ordem_colunas],"casos_uf.csv")
write_csv(df_casos_br[,ordem_colunas],"casos_br.csv")
write_csv(df_detalhe,"detalhe_br.csv")