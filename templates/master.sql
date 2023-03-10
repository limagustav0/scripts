USE bkp_db_uc_kami;
SELECT 
cliente.cod_cliente AS cod_cliente
,cliente.razao_social AS razao_social
,cliente.nome_cliente AS nome_cliente
,max(ramo.desc_abrev) AS tipo
,DATE_FORMAT(cliente.dt_implant,'%d/%m/%Y') AS data_cadastro
,endereco.bairro AS bairro
,endereco.cidade AS cidade
,endereco.sigla_uf AS uf
,endereco.endereco AS endereco
,endereco.numero AS numero
,endereco.cep AS cep
,cliente.cod_colaborador AS cod_vendedor
,vendedor.nome_colaborador AS nome_vendedor
,(SELECT  CASE WHEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa)) > 0 THEN  ( TIMESTAMPDIFF(DAY,recebe.dt_vencimento, CURRENT_DATE()))  
ELSE  "0" END FROM fn_titulo_receber AS recebe WHERE recebe.cod_cliente = cliente.cod_cliente AND recebe.situacao < 30 AND recebe.dt_vencimento < CURRENT_DATE() -1  AND recebe.cod_empresa IN {{ company_ids }}  group by recebe.cod_cliente) AS dias_atraso

,(SELECT CASE WHEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa)) > 0 THEN  (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa))  
ELSE  "0" END FROM fn_titulo_receber AS recebe WHERE recebe.cod_cliente = cliente.cod_cliente AND recebe.situacao < 30 AND recebe.dt_vencimento < CURRENT_DATE() -1  AND recebe.cod_empresa IN {{ company_ids }} group by recebe.cod_cliente) AS valor_devido

,(SELECT DATE_FORMAT(max(nf2.dt_emissao),'%d/%m/%Y') FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN {{ company_ids }} AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS dt_ultima_compra

,(SELECT DATE_FORMAT(max(nf2.dt_emissao),'%d/%m/%Y') FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN {{ company_ids }} AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS dt_primeira_compra

,(SELECT count(distinct nf2.dt_emissao) FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN {{ company_ids }} AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS qtd_total_compras

,(SELECT count(distinct nf2.dt_emissao) FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN {{ company_ids }} AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP") AND nf2.dt_emissao >= SUBDATE(CURDATE(), INTERVAL 6 MONTH)) AS qtd_compras_semestre

{{ months_values }}

FROM
cd_cliente AS cliente
LEFT JOIN cd_cliente_endereco AS endereco ON (cliente.cod_cliente = endereco.cod_cliente AND endereco.tp_endereco = "E")
LEFT JOIN sg_colaborador AS vendedor ON (vendedor.cod_colaborador = cliente.cod_colaborador )
LEFT JOIN cd_cliente_atividade AS atividade ON (atividade.cod_cliente = cliente.cod_cliente)
LEFT JOIN cd_ramo_atividade AS ramo ON (ramo.cod_ramo_atividade = atividade.cod_ramo_atividade)

WHERE

 cliente.cod_colaborador IN {{ seller_ids }}

group by  cliente.cod_cliente

INTO OUTFILE 'csv/{{ filename }}.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
