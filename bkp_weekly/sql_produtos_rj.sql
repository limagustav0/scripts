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
select
nf.cod_empresa AS empresa,
nfitem.cod_nota_fiscal as cod_interno,
year(nf.dt_emissao) as ANO ,
month(nf.dt_emissao) as Mes,
DATE_FORMAT(nf.dt_emissao,'%d/%m/%Y') as data_completa,
nf.cod_cliente as cod_cliente,
nf.razao_social as razao_social,
cliente.cod_colaborador,
vendedor.nome_colaborador,
nfitem.cod_produto  as cod_produto,
nfitem.desc_nota_fiscal as nome_produto, 
item.cod_grupo_produto as cod_grupo, 
grupo.desc_abrev as nome_grupo, 
grupo.cod_grupo_pai as cod_grupo_pai, 
grupop.desc_abrev as nome_grupo_pai,
nf.nop as nop,
nfitem.qtd as qtd,
(case when nf.nop in ("6.102","6.404","BLACKFRIDAY","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP") then "VENDA" else "BONIFICADO" end) tipo_venda,
 (case when nf.nop in ("6.102","6.404","BLACKFRIDAY","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP") then "1" else "2" end) codigo_venda,
nfitem.preco_total as preco_total,
nf.vl_total_liquido as vl_total_liquido,
marca.desc_abrev as marca,
ifnull((nf.vl_total_tb_kami - nf.vl_total_liquido),0) as desconto,
ifnull(((nf.vl_total_tb_kami - nf.vl_total_liquido)/nf.vl_total_liquido),0) as '% desconto',
nfitem.vl_tb_kami as vl_tb_kami,
nfitem.vl_total_item_tb_kami as vl_total_item_tb_kami


from

vd_nota_fiscal_item as nfitem
left join vd_nota_fiscal as nf on (nfitem.cod_nota_fiscal = nf.cod_nota_fiscal)
left join cd_cliente as cliente on (cliente.cod_cliente = nf.cod_cliente and  cliente.cod_colaborador in (306,307,317,313,315,312,303,314,222,211,381,22,3349))
left join cd_grupo_item as item on (nfitem.cod_produto = item.cod_produto)
left join cd_grupo_produto as grupo on (grupo.cod_grupo_produto = item.cod_grupo_produto)
left join cd_grupo_produto as grupop on (grupop.cod_grupo_produto = grupo.cod_grupo_pai)
left join sg_colaborador as vendedor on (cliente.cod_colaborador = vendedor.cod_colaborador)
left join cd_produto as produto on (produto.cod_produto = nfitem.cod_produto)
left join cd_marca as marca on (marca.cod_marca = produto.cod_marca)

where 
nf.nop in ("6.102","6.404","BLACKFRIDAY","CAMPANHA","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP","BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","ENXOVAL")
and nfitem.cod_empresa in (6)
and nf.situacao < 100
and nf.dt_emissao > "2020-01-01" 

INTO OUTFILE 'csv/produtos_rj.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'