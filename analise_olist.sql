/******************************************************************************
NÍVEL 1 - PERGUNTA 1: Qual o faturamento total por categoria de produto?

OBJETIVO: Identificar as categorias de produtos que geram maior receita para a empresa,
permitindo focar estratégias de marketing e vendas.

EXPLICAÇÃO TÉCNICA:
- SELECT: Selecionamos a categoria do produto e o faturamento total, que chamamos de 'total_revenue'.
- FROM/INNER JOIN: Unimos a tabela 'order_items' (onde está o preço) com a tabela 'products' (onde está a categoria).
  A união é feita pela chave comum 'product_id'. Usamos apelidos (oi, p) para facilitar a leitura.
- GROUP BY: Agrupamos todas as linhas pela categoria do produto para que o SUM() calcule o total para cada uma delas.
- SUM(oi.price): Somamos os preços de todos os itens vendidos para cada categoria.
- ORDER BY: Ordenamos o resultado do maior faturamento para o menor, para destacar as categorias mais importantes.
******************************************************************************/

SELECT
    p.product_category_name AS categoria,
    SUM(oi.price) AS faturamento_total
FROM
    order_items AS oi
INNER JOIN
    products AS p ON oi.product_id = p.product_id
GROUP BY
    p.product_category_name
ORDER BY
    faturamento_total DESC;
	
	
	
/******************************************************************************
NÍVEL 1 - PERGUNTA 2: Qual o ticket médio (valor médio do pedido) por estado do cliente?

OBJETIVO: Entender o comportamento de compra e o poder aquisitivo dos clientes em diferentes
regiões do país, permitindo a criação de campanhas de marketing e estratégias de frete regionalizadas.

EXPLICAÇÃO TÉCNICA:
- SELECT: Selecionamos o estado do cliente e calculamos o ticket médio. O ticket médio é a SOMA de todos os preços
  dividida pela CONTAGEM de pedidos únicos.
- FROM/INNER JOIN: Iniciamos com a tabela 'customers' e a unimos com 'orders' (usando 'customer_id') e
  depois unimos o resultado com 'order_items' (usando 'order_id').
- GROUP BY: Agrupamos o resultado por estado para que os cálculos sejam feitos para cada região.
- COUNT(DISTINCT o.order_id): Contamos os pedidos únicos para garantir que, se um pedido tiver múltiplos
  itens, ele seja contado apenas uma vez no cálculo da média.
- ORDER BY: Ordenamos pelo ticket médio para facilmente identificar os estados com maior e menor poder de compra.
******************************************************************************/

SELECT
    c.customer_state AS estado,
    SUM(oi.price) / COUNT(DISTINCT o.order_id) AS ticket_medio
FROM
    customers AS c
INNER JOIN
    orders AS o ON c.customer_id = o.customer_id
INNER JOIN
    order_items AS oi ON o.order_id = oi.order_id
GROUP BY
    c.customer_state
ORDER BY
    ticket_medio DESC;
	
	
	
/******************************************************************************
NÍVEL 1 - PERGUNTA 3: Qual a nota média de avaliação (review_score) para cada método de pagamento?

OBJETIVO: Identificar se certos métodos de pagamento estão associados a uma maior ou menor
satisfação do cliente. Isso pode indicar problemas no processamento de pagamentos
ou simplesmente revelar padrões de comportamento de diferentes perfis de consumidores.

EXPLICAÇÃO TÉCNICA:
- SELECT: Selecionamos o tipo de pagamento e calculamos a nota média das avaliações.
  Também contamos o número de pedidos para dar contexto ao resultado (uma média de poucos pedidos não é confiável).
- FROM/INNER JOIN: Iniciamos com a tabela 'order_payments' e a unimos com 'orders' (usando 'order_id') e
  depois unimos o resultado com 'order_reviews' (usando 'order_id' novamente).
- GROUP BY: Agrupamos pelo tipo de pagamento para que a média seja calculada para cada método (boleto, credit_card, etc.).
- AVG(r.review_score): Calcula a média aritmética das notas de avaliação para cada grupo.
- COUNT(o.order_id): Conta o total de pedidos em cada grupo.
- ORDER BY: Ordenamos pela nota média para destacar os métodos com maior e menor satisfação.
******************************************************************************/

SELECT
    op.payment_type AS metodo_pagamento,
    AVG(r.review_score) AS nota_media_avaliacao,
    COUNT(o.order_id) AS numero_pedidos
FROM
    order_payments AS op
INNER JOIN
    orders AS o ON op.order_id = o.order_id
INNER JOIN
    order_reviews AS r ON o.order_id = r.order_id
GROUP BY
    op.payment_type
ORDER BY
    nota_media_avaliacao DESC;
	
	
	
/******************************************************************************
NÍVEL 2 - PERGUNTA 4: Identificação de Clientes Recorrentes (>1 compra)

OBJETIVO: Identificar clientes que compraram mais de uma vez para entender o tamanho da
base de clientes leais. Este é o primeiro passo para uma análise de Frequência (o 'F' de RFM).

EXPLICAÇÃO TÉCNICA:
- WITH ContagemPedidosCliente AS (...): Aqui definimos nossa Tabela Temporária (CTE).
  Ela se chamará 'ContagemPedidosCliente' e o código dentro dos parênteses é o que a gera.
- DENTRO DA CTE:
  - Usamos JOIN para conectar 'customers' e 'orders'.
  - Contamos o número de pedidos (COUNT(o.order_id)) para cada cliente único (GROUP BY c.customer_unique_id).
  - O resultado desta sub-consulta é uma tabela virtual com duas colunas: o ID do cliente e o total de pedidos dele.
- CONSULTA FINAL (após a CTE):
  - Fazemos um SELECT simples a partir da nossa CTE ('FROM ContagemPedidosCliente').
  - Usamos 'WHERE total_pedidos > 1' para filtrar e mostrar apenas os clientes recorrentes.
  - Ordenamos para ver os clientes mais frequentes no topo.
******************************************************************************/

WITH ContagemPedidosCliente AS (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS total_pedidos
    FROM
        customers AS c
    INNER JOIN
        orders AS o ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_unique_id
)
SELECT
    customer_unique_id,
    total_pedidos
FROM
    ContagemPedidosCliente
WHERE
    total_pedidos > 1
ORDER BY
    total_pedidos DESC;
	
	
	
/******************************************************************************
NÍVEL 2 - PERGUNTA 5: Análise do Lead Time de Entrega

OBJETIVO: Calcular o tempo médio de entrega (lead time) em dias. Este é um KPI
fundamental para medir a eficiência da operação logística e a qualidade do serviço
prestado ao cliente.

EXPLICAÇÃO TÉCNICA:
- WITH LeadTimes AS (...): Definimos uma CTE para primeiro calcular o tempo de entrega
  para cada pedido individualmente.
- DENTRO DA CTE:
  - SELECT JULIANDAY(...) - JULIANDAY(...): Usamos JULIANDAY para calcular a diferença
    em dias entre a data que o cliente recebeu o pedido e a data da compra.
  - WHERE order_status = 'delivered' AND order_delivered_customer_date IS NOT NULL:
    É CRUCIAL filtrar apenas os pedidos que foram de fato entregues e cuja data de
    entrega não é nula, para garantir a qualidade e a precisão da nossa análise.
- CONSULTA FINAL:
  - A partir da nossa CTE, que agora contém o lead time de cada pedido válido,
    calculamos a média (AVG) de todos esses valores.
  - Usamos ROUND(..., 2) para arredondar o resultado para duas casas decimais,
    deixando a apresentação do resultado mais limpa.
******************************************************************************/

WITH LeadTimes AS (
    SELECT
        JULIANDAY(o.order_delivered_customer_date) - JULIANDAY(o.order_purchase_timestamp) AS lead_time_dias
    FROM
        orders AS o
    WHERE
        o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    ROUND(AVG(lead_time_dias), 2) AS tempo_medio_entrega_dias
FROM
    LeadTimes;
	
	
	
/******************************************************************************
NÍVEL 3 - PERGUNTA 6: Ranking de Categorias por Faturamento

OBJETIVO: Criar um ranking de performance das categorias de produtos com base no faturamento,
para permitir uma tomada de decisão rápida sobre quais são as categorias mais estratégicas.

EXPLICAÇÃO TÉCNICA:
- WITH FaturamentoCategoria AS (...): Usamos uma CTE para primeiro agregar o faturamento por
  categoria. Essa parte da query é idêntica à nossa Pergunta 1.
- CONSULTA FINAL:
  - Selecionamos as colunas da nossa CTE.
  - RANK() OVER (ORDER BY faturamento_total DESC): Aqui está a Window Function.
    - RANK(): É a função que atribui a classificação (ex: 1, 2, 3...).
    - OVER (...): É a cláusula que define a 'janela' de dados sobre a qual a função vai operar.
      Como não usamos 'PARTITION BY', a janela é o conjunto de dados inteiro.
    - ORDER BY faturamento_total DESC: Define como os dados dentro da janela devem ser
      ordenados ANTES de a função RANK() ser aplicada. Aqui, ordenamos do maior faturamento
      para o menor, então o maior faturamento receberá o rank 1.
******************************************************************************/

WITH FaturamentoCategoria AS (
    SELECT
        p.product_category_name AS categoria,
        SUM(oi.price) AS faturamento_total
    FROM
        order_items AS oi
    INNER JOIN
        products AS p ON oi.product_id = p.product_id
    WHERE
        p.product_category_name IS NOT NULL -- Boa prática para remover categorias nulas
    GROUP BY
        p.product_category_name
)
SELECT
    categoria,
    faturamento_total,
    RANK() OVER (ORDER BY faturamento_total DESC) AS ranking
FROM
    FaturamentoCategoria;
	
	
	
/******************************************************************************
NÍVEL 3 - PERGUNTA 7: Análise de Evolução de Gastos (LAG)

OBJETIVO: Para cada pedido de um cliente, identificar o valor do pedido anterior.
Isso permite analisar se os clientes estão gastando mais ou menos ao longo do tempo,
um insight valioso para estratégias de retenção e marketing.

EXPLICAÇÃO TÉCNICA:
- WITH ValorTotalPedido AS (...): Criamos uma CTE para primeiro calcular o valor total
  de cada pedido, somando o preço dos itens e unindo com as tabelas de pedidos e clientes.
- CONSULTA FINAL:
  - Selecionamos os dados da CTE.
  - LAG(valor_total, 1, 0) OVER (PARTITION BY customer_unique_id ORDER BY data_compra): Esta é a Window Function.
    - LAG(valor_total, 1, 0): Pega o valor da coluna 'valor_total', da linha anterior (o '1' significa 'uma linha para trás').
      O '0' é o valor padrão a ser retornado caso não haja uma linha anterior (ou seja, para a primeira compra do cliente).
    - PARTITION BY customer_unique_id: Esta é a parte mais importante. Ela quebra os dados em
      'janelas' separadas para CADA cliente. Isso garante que o LAG() só vai olhar para os pedidos
      ANTERIORES DO MESMO CLIENTE, e não para o pedido anterior de um cliente diferente.
    - ORDER BY data_compra: Dentro da janela de cada cliente, os pedidos precisam ser ordenados
      cronologicamente para que "a linha anterior" seja de fato o "pedido anterior".
******************************************************************************/

WITH ValorTotalPedido AS (
    SELECT
        o.order_purchase_timestamp AS data_compra,
        c.customer_unique_id,
        o.order_id,
        SUM(oi.price) AS valor_total
    FROM
        orders AS o
    INNER JOIN
        order_items AS oi ON o.order_id = oi.order_id
    INNER JOIN
        customers AS c ON o.customer_id = c.customer_id
    GROUP BY
        o.order_id, c.customer_unique_id, o.order_purchase_timestamp
)
SELECT
    customer_unique_id,
    order_id,
    data_compra,
    valor_total,
    LAG(valor_total, 1, 0) OVER (
        PARTITION BY customer_unique_id
        ORDER BY data_compra
    ) AS valor_pedido_anterior
FROM
    ValorTotalPedido
ORDER BY
    customer_unique_id, data_compra;
	
	
	
/******************************************************************************
NÍVEL 3 - PERGUNTA 8: Análise de Share de Receita (% de Participação)

OBJETIVO: Calcular a representatividade de cada categoria de produto no faturamento total,
permitindo identificar quais categorias são o core business da empresa e onde há
oportunidades de crescimento.

EXPLICAÇÃO TÉCNICA:
- WITH FaturamentoCategoria AS (...): Novamente, usamos a mesma CTE das perguntas anteriores
  para obter o faturamento total por categoria. Isso mostra como CTEs são reutilizáveis.
- CONSULTA FINAL:
  - Selecionamos a categoria e seu faturamento.
  - SUM(faturamento_total) OVER (): Aqui está a mágica. Esta Window Function calcula a soma
    de 'faturamento_total' sobre a 'janela' de dados inteira (pois os parênteses do OVER()
    estão vazios). O resultado é uma nova coluna onde CADA linha terá o mesmo valor: o
    faturamento total geral da empresa.
  - CÁLCULO DA PORCENTAGEM: Com o faturamento da categoria e o faturamento geral na mesma
    linha, podemos facilmente calcular a porcentagem. Multiplicamos por 100.0 para garantir
    que o cálculo seja feito com casas decimais.
  - Usamos ROUND(..., 2) para formatar o resultado.
******************************************************************************/

WITH FaturamentoCategoria AS (
    SELECT
        p.product_category_name AS categoria,
        SUM(oi.price) AS faturamento_total
    FROM
        order_items AS oi
    INNER JOIN
        products AS p ON oi.product_id = p.product_id
    WHERE
        p.product_category_name IS NOT NULL
    GROUP BY
        p.product_category_name
)
SELECT
    categoria,
    faturamento_total,
    ROUND((faturamento_total * 100.0 / SUM(faturamento_total) OVER ()), 2) AS percentual_total
FROM
    FaturamentoCategoria
ORDER BY
    faturamento_total DESC;
	
	
	
/******************************************************************************
NÍVEL 4 - PERGUNTA 9: Performance Anual por Categoria (Pivoting)

OBJETIVO: Criar um relatório que mostre o faturamento de cada categoria de produto,
lado a lado, para cada ano de venda. Isso permite uma análise de tendências e
crescimento de forma clara e direta.

EXPLICAÇÃO TÉCNICA:
- GROUP BY: O primeiro passo é agrupar por categoria de produto, para que tenhamos uma
  linha única para cada uma.
- SUM(CASE WHEN ... END): Esta é a técnica de pivoting. Vamos entender a primeira coluna:
  - strftime('%Y', o.order_purchase_timestamp) = '2016': A função 'strftime' extrai o ano
    da data da compra. O CASE verifica se o ano da linha atual é '2016'.
  - THEN oi.price ELSE 0: Se o ano for '2016', ele retorna o preço do item. Se não for, retorna 0.
  - SUM(...): A função SUM vai somar todos esses valores. Para uma categoria específica,
    ela somará efetivamente apenas os preços dos itens vendidos em 2016, já que os
    outros anos contribuirão com 0 para a soma.
- Repetimos essa lógica para os anos de 2017 e 2018, criando uma coluna para cada um.
- A última coluna, SUM(oi.price), nos dá o total geral para a categoria em todo o período.
******************************************************************************/

SELECT
    p.product_category_name AS categoria,
    SUM(CASE WHEN STRFTIME('%Y', o.order_purchase_timestamp) = '2016' THEN oi.price ELSE 0 END) AS faturamento_2016,
    SUM(CASE WHEN STRFTIME('%Y', o.order_purchase_timestamp) = '2017' THEN oi.price ELSE 0 END) AS faturamento_2017,
    SUM(CASE WHEN STRFTIME('%Y', o.order_purchase_timestamp) = '2018' THEN oi.price ELSE 0 END) AS faturamento_2018,
    SUM(oi.price) AS faturamento_total_periodo
FROM
    order_items AS oi
INNER JOIN
    products AS p ON oi.product_id = p.product_id
INNER JOIN
    orders AS o ON oi.order_id = o.order_id
WHERE
    p.product_category_name IS NOT NULL
GROUP BY
    p.product_category_name
ORDER BY
    faturamento_total_periodo DESC;
	
	
	
/******************************************************************************
NÍVEL 5 - PERGUNTA 10: Análise de Coorte para Retenção de Clientes

OBJETIVO: Construir uma tabela de retenção que mostre, para cada "safra" de novos clientes
(o coorte, definido pelo mês da primeira compra), quantos deles retornaram nos meses subsequentes.

EXPLICAÇÃO TÉCNICA:
- CTE 1: `ClienteCoorte`
  - Usamos a Window Function MIN() OVER (PARTITION BY ...) para encontrar a data da primeira compra
    de cada cliente.
  - `strftime('%Y-%m-01', ...)` padroniza a data para o primeiro dia do mês, criando o Coorte.
- CTE 2: `AtividadeMensal`
  - Juntamos os pedidos com a informação do Coorte de cada cliente.
  - Calculamos o 'lifetime_month', que é a diferença em meses entre a data de um pedido qualquer
    e a data do Coorte daquele cliente. Isso nos diz em qual "mês de vida" o cliente fez a compra.
- CONSULTA FINAL:
  - Agrupamos os dados por Coorte e por Mês de Vida (`lifetime_month`).
  - `COUNT(DISTINCT customer_unique_id)` nos dá o número de clientes únicos daquele Coorte que
    estiveram ativos (fizeram uma compra) em um determinado mês de vida.
  - O resultado é a tabela de retenção em números absolutos. Para calcular a porcentagem,
    bastaríamos dividir cada valor pelo total de clientes no 'lifetime_month = 0' de cada coorte.
******************************************************************************/

WITH ClienteCoorte AS (
    SELECT
        c.customer_unique_id,
        STRFTIME('%Y-%m-01', MIN(o.order_purchase_timestamp)) AS cohort_date
    FROM
        orders AS o
    INNER JOIN
        customers AS c ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_unique_id
),
AtividadeMensal AS (
    SELECT
        STRFTIME('%Y-%m-01', o.order_purchase_timestamp) AS activity_date,
        cc.customer_unique_id,
        cc.cohort_date
    FROM
        orders AS o
    INNER JOIN
        customers AS c ON o.customer_id = c.customer_id
    INNER JOIN
        ClienteCoorte AS cc ON c.customer_unique_id = cc.customer_unique_id
)
SELECT
    a.cohort_date,
    (JULIANDAY(a.activity_date) - JULIANDAY(a.cohort_date)) / 30 AS lifetime_month,
    COUNT(DISTINCT a.customer_unique_id) AS clientes_ativos
FROM
    AtividadeMensal AS a
GROUP BY
    a.cohort_date,
    lifetime_month
ORDER BY
    a.cohort_date,
    lifetime_month;