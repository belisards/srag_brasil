# Dados de SRAG no Brasil
Script para extrair dados do [Info-Gripe](http://info.gripe.fiocruz.br/), sistema da Fiocruz que disponibiliza informações sobre hospitalizações por Síndrome Respiratória Aguda Grave (SRAG) desde 2009. O script foi escrito em R, inicialmente inspirado nessa [outra abordagem feita em Python por @rodolfo-viana](https://github.com/rodolfo-viana/dailylog/blob/master/scripts/covid19srag.py) para coleta dos agregados por estado.

Os dados são exportados em três arquivos CSVs:

* **casos_br.csv** traz o total de casos agregado do país por ano e semana epidemiológica.

* **casos_uf.csv** traz o total de casos agregado por UF, ano e semana epidemiológica.

* **detalhe_br.csv** traz o detalhamento de casos por gênero e faixa etária.

**Atenção**: Os dados de 2020 são classificados como "estimados" e devem sofrer alterações (provavelmente estão ainda subnotificados). Confira o campo `situation_name` para mais informações.
