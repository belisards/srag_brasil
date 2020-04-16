# Dados de SRAG no Brasil
Script para extrair dados do [Info-Gripe](http://info.gripe.fiocruz.br/), sistema da Fiocruz que disponibiliza informações sobre hospitalizações por Síndrome Respiratória Aguda Grave (SRAG) desde 2009.

Os dados são exportados em dois arquivos CSVs:

* **dados_br.csv** traz o agregado do país por ano e semana epidemiológica.

* **dados_uf.csv** traz o agregado por UF, ano e semana epidemiológica.

**Atenção**: Todos os dados de 2020 são classificados como "estimados" e devem sofrer alterações (provavelmente estão ainda subnotificados). Confira o campo `situation_name` para mais informações.