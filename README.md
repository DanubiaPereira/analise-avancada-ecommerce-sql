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

## 📈 Questões de Negócio e Análise

As seguintes perguntas foram investigadas para gerar insights para a empresa:

#### Nível 1: Análise com `JOINs` e Agregações

**1. Qual o faturamento total por categoria de produto?**
* **Insight:** [A ser preenchido após a análise...]

**2. Qual o ticket médio (valor médio do pedido) por estado do cliente?**
* **Insight:** [A ser preenchido após a análise...]

**3. Qual a nota média de avaliação (`review_score`) para cada método de pagamento?**
* **Insight:** [A ser preenchido após a análise...]

#### Nível 2: Análise com `CTEs` (Common Table Expressions)

**4. Quais clientes fizeram mais de 2 pedidos e qual o valor total gasto por eles?**
* **Insight:** [A ser preenchido após a análise...]

**5. Qual o tempo médio, em dias, entre a data da compra e a data de entrega?**
* **Insight:** [A ser preenchido após a análise...]

#### Nível 3: Análise com `Window Functions`

**6. Qual o ranking das categorias de produto mais vendidas em termos de faturamento?**
* **Insight:** [A ser preenchido após a análise...]

**7. Para cada cliente, qual foi o valor do pedido atual e o valor do pedido anterior?**
* **Insight:** [Esta análise gera uma tabela exploratória e o insight será uma descrição do seu potencial de uso...]

**8. Qual a participação percentual do faturamento de cada categoria no faturamento total?**
* **Insight:** [A ser preenchido após a análise...]

---

## 🚀 Como Replicar a Análise

1.  Clone este repositório.
2.  Abra o arquivo `olist.db` com o DB Browser for SQLite.
3.  Crie um novo script SQL ou abra o arquivo `analise_olist.sql`.
4.  Execute as queries presentes no script para obter os resultados de cada análise.
