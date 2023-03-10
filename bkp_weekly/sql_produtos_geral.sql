USE bkp_db_uc_kami;
SELECT
'empresa',
'cod_interno',
'ano',
'mes',
'data_completa',
'cod_cliente',
'razao_social',
'cod_colaborador',
'nome_colaborador',
'cod_produto',
'nome_produto',
'cod_grupo',
'nome_grupo',
'cod_grupo_pai',
'nome_grupo_pai',
'nop',
'qtd',
'tipo_venda',
'codigo_venda',
'preco_total',
'vl_total_liquido',
'marca',
'desconto',
'% desconto',
'vl_tb_kami',
'vl_total_item_tb_kami'
UNION ALL
SELECT
nf.cod_empresa AS empresa,
nfitem.cod_nota_fiscal AS cod_interno,
year(nf.dt_emissao) AS ANO ,
month(nf.dt_emissao) AS Mes,
DATE_FORMAT(nf.dt_emissao,'%d/%m/%Y') AS data_completa,
nf.cod_cliente AS cod_cliente,
nf.razao_social AS razao_social,
cliente.cod_colaborador,
vendedor.nome_colaborador,
nfitem.cod_produto  AS cod_produto,
nfitem.desc_nota_fiscal AS nome_produto, 
item.cod_grupo_produto AS cod_grupo, 
grupo.desc_abrev AS nome_grupo, 
grupo.cod_grupo_pai AS cod_grupo_pai, 
grupop.desc_abrev AS nome_grupo_pai,
nf.nop AS nop,
nfitem.qtd AS qtd,
(CASE WHEN nf.nop IN ("6.102","6.404","BLACKFRIDAY","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP") THEN "VENDA" ELSE "BONIFICADO" END) tipo_venda,
 (CASE WHEN nf.nop IN ("6.102","6.404","BLACKFRIDAY","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP") THEN "1" ELSE "2" END) codigo_venda,
nfitem.preco_total as preco_total,
nf.vl_total_liquido as vl_total_liquido,
marca.desc_abrev as marca,
ifnull((nf.vl_total_tb_kami - nf.vl_total_liquido),0) as desconto,
ifnull(((nf.vl_total_tb_kami - nf.vl_total_liquido)/nf.vl_total_liquido),0) as '% desconto',
nfitem.vl_tb_kami as vl_tb_kami,
nfitem.vl_total_item_tb_kami as vl_total_item_tb_kami

FROM

vd_nota_fiscal_item AS nfitem
LEFT JOIN vd_nota_fiscal AS nf ON (nfitem.cod_nota_fiscal = nf.cod_nota_fiscal)
LEFT JOIN cd_cliente AS cliente ON (cliente.cod_cliente = nf.cod_cliente)
LEFT JOIN cd_grupo_item AS item ON (nfitem.cod_produto = item.cod_produto)
LEFT JOIN cd_grupo_produto AS grupo ON (grupo.cod_grupo_produto = item.cod_grupo_produto)
LEFT JOIN cd_grupo_produto AS grupop ON (grupop.cod_grupo_produto = grupo.cod_grupo_pai)
LEFT JOIN sg_colaborador AS vendedor ON (cliente.cod_colaborador = vendedor.cod_colaborador)
left join cd_produto AS produto on (produto.cod_produto = nfitem.cod_produto)
left join cd_marca AS marca on (marca.cod_marca = produto.cod_marca)

WHERE 
nf.nop IN ("6.102","6.404","BLACKFRIDAY","CAMPANHA","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP","BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","ENXOVAL")
AND nf.situacao < 100
AND year(nf.dt_emissao) = year(CURRENT_DATE())

INTO OUTFILE 'csv/produtos_geral.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'