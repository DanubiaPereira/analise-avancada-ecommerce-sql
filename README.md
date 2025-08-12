# 📊 Análise Aprofundada de E-commerce com SQL Avançado

## 🎯 Objetivo do Projeto

Este projeto consiste em uma análise de dados aprofundada do dataset público de e-commerce da Olist. O objetivo principal é utilizar SQL avançado para responder a perguntas de negócio complexas, demonstrando proficiência em `JOINs`, funções de agregação, `CTEs` (Common Table Expressions) e `Window Functions` para extrair insights sobre performance de vendas, comportamento de clientes e eficiência logística.

---

## 🛠️ Ferramentas Utilizadas

* **Linguagem:** SQL
* **Banco de Dados:** SQLite
* **Ferramenta de Interface:** DB Browser for SQLite
* **Versionamento de Código:** Git & GitHub

---

## 🗃️ Estrutura do Banco de Dados

O banco de dados `olist.db` foi populado a partir de 9 arquivos CSV distintos, resultando nas seguintes tabelas:

1.  `customers`: Dados dos clientes.
2.  `geolocation`: Dados de geolocalização (códigos postais).
3.  `order_items`: Itens dentro de cada pedido.
4.  `order_payments`: Informações sobre os pagamentos dos pedidos.
5.  `order_reviews`: Avaliações dos pedidos feitas pelos clientes.
6.  `orders`: Dados principais dos pedidos.
7.  `products`: Dados dos produtos.
8.  `sellers`: Dados dos vendedores.
9.  `category_name_translation`: Tradução dos nomes das categorias de produtos para o inglês.

---

## 📈 Trilha de Análise Estratégica

A análise foi segmentada em 5 níveis de complexidade, partindo de métricas de negócio fundamentais até análises comportamentais avançadas. Cada nível demonstra uma habilidade específica em SQL aplicada a um problema de negócio real.

<details>
<summary><strong>NÍVEL 1: KPIs Fundamentais de Negócio (JOINs & Agregações)</strong></summary>
<br>
<i><strong>Objetivo:</strong> Mapear a performance de vendas e o comportamento de consumo através da união de dados de pedidos, produtos e clientes para gerar Indicadores Chave de Performance (KPIs).</i>

1.  **Análise de Receita por Categoria:** Qual o faturamento (`revenue`) por categoria de produto, para identificar as categorias de maior impacto financeiro?
2.  **Análise Geográfica de Vendas:** Qual o ticket médio de compra por estado, visando entender o poder de compra e a performance regional?
3.  **Análise de Satisfação vs. Pagamento:** Existe correlação entre o método de pagamento utilizado e a satisfação do cliente (medida pelo `review_score`)?

</details>

<details>
<summary><strong>NÍVEL 2: Eficiência Operacional e Segmentação (CTEs)</strong></summary>
<br>
<i><strong>Objetivo:</strong> Utilizar Common Table Expressions (CTEs) para analisar a eficiência do processo de venda e segmentar clientes, demonstrando a capacidade de estruturar consultas SQL complexas de forma clara e modular.</i>

4. **Identificação de Clientes Recorrentes:** Quais clientes realizaram mais de uma compra, estabelecendo uma base para futuras análises de lealdade (RFM)?
5. **Análise do Lead Time de Entrega:** Qual o tempo médio (em dias) entre a confirmação da compra e a entrega do pedido, um KPI chave para a eficiência logística?

</details>

<details>
<summary><strong>NÍVEL 3: Análises Comparativas e de Ranking (Window Functions)</strong></summary>
<br>
<i><strong>Objetivo:</strong> Aplicar `Window Functions` para criar análises de ranking e séries temporais, extraindo insights relacionais profundos sobre a performance de produtos e o comportamento de compra dos clientes.</i>

6. **Ranking de Categorias:** Qual o ranking de categorias por faturamento, para otimizar a alocação de investimentos e planejamento de estoque?
7. **Análise de Evolução de Gastos:** Qual o valor do pedido atual de um cliente em comparação com o seu pedido anterior (análise com `LAG`)?
8. **Análise de Share de Receita:** Qual a contribuição percentual de cada categoria para a receita total da empresa?

</details>

<details>
<summary><strong>NÍVEL 4: Análise de Performance Temporal (Pivoting)</strong></summary>
<br>
<i><strong>Objetivo:</strong> Criar relatórios sumarizados em formato de matriz, transformando dados de formato longo para largo (`long-to-wide`) diretamente em SQL para visualizar a evolução da performance ao longo do tempo.</i>

9. **Performance Anual por Categoria:** Qual a evolução do faturamento por categoria de produto, ano a ano?

</details>

<details>
<summary><strong>NÍVEL 5: Análise de Retenção de Clientes (Cohort Analysis)</strong></summary>
<br>
<i><strong>Objetivo:</strong> Implementar uma Análise de Coorte para mensurar a retenção de clientes, um dos indicadores mais importantes para a saúde e sustentabilidade do negócio a longo prazo.</i>

10. **Taxa de Retenção Mensal:** Qual a taxa de retenção de novos clientes, mês a mês, a partir do mês de sua primeira compra?

</details>

---

## 🚀 Como Replicar a Análise

1.  Clone este repositório.
2.  Abra o arquivo `olist.db` com o DB Browser for SQLite.
3.  Crie um novo script SQL ou abra o arquivo `analise_olist.sql`.
4.  Execute as queries presentes no script para obter os resultados de cada análise.
