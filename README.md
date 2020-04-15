# Dados de SRAG no Brasil
Script para extrair dados do [Info-Gripe](http://info.gripe.fiocruz.br/), sistema da FIOCRUZ que registra hospitalizações por Síndrome Respiratória Aguda Grave (SRAG) desde 2009. O script foi escrito em R, baseado nessa outra abordagem feita em Python por [@rodolfo-viana](https://github.com/rodolfo-viana/dailylog/blob/master/scripts/covid19srag.py).

Os dados são exportados em dois arquivos CSVs:

* **dados_br.csv** traz o agregado do país por ano e semana epidemiológica.

* **dados_uf.csv** traz o agregado por UF e semana epidemiológica.

**Atenção**: os dados são atualizados retroativamente. Ou seja, quanto mais recente, maior a chance de estar subestimado em relação aos números reais. Confira o campo `situation_namme` para saber mais sobre a atualização do dado.
