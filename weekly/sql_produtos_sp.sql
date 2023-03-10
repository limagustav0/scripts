USE bkp_db_uc_kami;
SELECT
'empresa',
'cod_interno',
'ano',
'mes',
'data_completa',
'cod_cliente',
'razao_social',
'tipo',
'cod_colaborador',
'nome_colaborador',
'cod_produto',
'nome_produto',
'cod_grupo',
'nome_grupo',
'cod_grupo_pai',
'nome_grupo_pai',
'marca',
'nop',
'vl_tb_kami',
'preco_unit',
'qtd',
'vl_total_item_tb_kami',
'preco_total',
'vl_total_tb_kami',
'vl_total_nota_fiscal',
'tipo_venda',
'codigo_venda',
'vl_total_liquido'
UNION ALL
SELECT
nf.cod_empresa AS empresa,
nfitem.cod_nota_fiscal AS cod_interno,
YEAR(nf.dt_emissao) AS ANO ,
MONTH(nf.dt_emissao) AS Mes,
DATE_FORMAT(nf.dt_emissao,'%d/%m/%Y') AS data_completa,
nf.cod_cliente AS cod_cliente,
nf.razao_social AS razao_social,
ramo.desc_abrev AS tipo,
cliente.cod_colaborador,
vendedor.nome_colaborador,
nfitem.cod_produto  AS cod_produto,
nfitem.desc_nota_fiscal AS nome_produto, 
item.cod_grupo_produto AS cod_grupo, 
grupo.desc_abrev AS nome_grupo, 
grupo.cod_grupo_pai AS cod_grupo_pai, 
grupop.desc_abrev AS nome_grupo_pai,
marca.desc_abrev AS marca,
nf.nop AS nop,
nfitem.vl_tb_kami AS vl_tb_kami,
nfitem.preco_unit AS preco_unit,
nfitem.qtd AS qtd,
nfitem.vl_total_item_tb_kami AS vl_total_item_tb_kami,
nfitem.preco_total AS preco_total,
nf.vl_total_tb_kami AS vl_total_tb_kami,
nf.vl_total_nota_fiscal AS vl_total_nota_fiscal,
(CASE WHEN nf.nop IN ("6.102","6.404","BLACKFRIDAY","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP") THEN "VENDA" ELSE "BONIFICADO" END) tipo_venda,
 (CASE WHEN nf.nop IN ("6.102","6.404","BLACKFRIDAY","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP") THEN "1" ELSE "2" END) codigo_venda,
nf.vl_total_liquido AS vl_total_liquido

FROM vd_nota_fiscal_item AS nfitem
LEFT JOIN vd_nota_fiscal AS nf ON (nfitem.cod_nota_fiscal = nf.cod_nota_fiscal)
LEFT JOIN cd_cliente AS cliente ON (cliente.cod_cliente = nf.cod_cliente AND  cliente.cod_colaborador IN (9,15,45,23,57,31,54,66,89,24,231,352,353,3334) )
LEFT JOIN cd_grupo_item AS item ON (nfitem.cod_produto = item.cod_produto)
LEFT JOIN cd_grupo_produto AS grupo ON (grupo.cod_grupo_produto = item.cod_grupo_produto)
LEFT JOIN cd_grupo_produto AS grupop ON (grupop.cod_grupo_produto = grupo.cod_grupo_pai)
LEFT JOIN sg_colaborador AS vendedor ON (cliente.cod_colaborador = vendedor.cod_colaborador)
LEFT JOIN cd_produto AS produto ON (nfitem.cod_produto = produto.cod_produto)
LEFT JOIN cd_marca AS marca ON (produto.cod_marca = marca.cod_marca)
LEFT JOIN cd_cliente_atividade AS atividade ON (atividade.cod_cliente = cliente.cod_cliente)
LEFT JOIN cd_ramo_atividade AS ramo ON (ramo.cod_ramo_atividade = atividade.cod_ramo_atividade)

WHERE nf.nop IN ("6.102","6.404","BLACKFRIDAY","CAMPANHA","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP","BONIFICADO","BONI_COMPRA","PROMOCAO","PROMO_BLACK","ENXOVAL")
AND nfitem.cod_empresa IN (1,3)
AND nf.situacao < 100
AND nf.dt_emissao > "2021-01-01" 
AND vendedor.cod_colaborador IN (9,15,45,23,57,31,54,66,89,24,231,3361)

INTO OUTFILE 'csv/produtos_sp.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'




