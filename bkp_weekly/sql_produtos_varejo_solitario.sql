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
'tipo_venda',
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
 (case when nfitem.desc_nota_fiscal like ("USO OBRIGATORIO - RECONSTRUTOR CAPILAR 260ML%") then "USO_TRADICIONAL" 
  when nfitem.desc_nota_fiscal like ("%Net%")  then "NET_MASK" 
  when nfitem.desc_nota_fiscal like ("%night%")  then "NIGHT_SPA" 
 when nfitem.desc_nota_fiscal like ("%hair protector%")  then "HAIR_PROTECTOR" 
 when nfitem.desc_nota_fiscal like ("%MIRACLE MASK COND%")  then "MIRACLE_MASK" 
 when nfitem.desc_nota_fiscal like ("%SPECIFIC MASK%")  then "SPECIFIC_MASK" 
 when nfitem.desc_nota_fiscal like ("%SHAMPOO EQUILIBRIUM%")  then "SHAMPOO_EQUILIBRIUM" 
 when nfitem.desc_nota_fiscal like ("%CONDICIONADOR EQUILIBRIUM%")  then "CONDICIONADOR_EQUILIBRIUM"
 when nfitem.desc_nota_fiscal like ("%SHAMPOO INFUSION 300ML%")  then "SHAMPOO_INFUSION" 
 when nfitem.desc_nota_fiscal like ("%CONDICIONADOR INFUSION 300ML%")  then "CONDICIONADOR_INFUSION" 
 when nfitem.desc_nota_fiscal like ("%SHAMPOO ULTRA HYDRATION 300ML")  then "SHAMPOO_ULTRA_HYDRATION" 
 when nfitem.desc_nota_fiscal like ("%CONDICIONADOR ULTRA HYDRATION 300ML")  then "CONDICIONADOR_ULTRA_HYDRATION" 
  when nfitem.desc_nota_fiscal like ("%SHAMPOO ULTRA HYDRATION PLUS%")  then "SHAMPOO_ULTRA_HYDRATION_PLUS" 
 when nfitem.desc_nota_fiscal like ("%CONDICIONADOR ULTRA HYDRATION PLUS%")  then "CONDICIONADOR_ULTRA_HYDRATION_PLUS" 
   when nfitem.desc_nota_fiscal like ("%SHAMPOO MIRACLE TRUSS%")  then "SHAMPOO_MIRACLE" 
 when nfitem.desc_nota_fiscal like ("%CONDICIONADOR MIRACLE TRUSS%%")  then "CONDICIONADOR_MIRACLE_TRUSS" 
else "0" end) as  tipo_produto,
marca.desc_abrev as marca,
ifnull((nf.vl_total_tb_kami - nf.vl_total_liquido),0) as desconto,
ifnull(((nf.vl_total_tb_kami - nf.vl_total_liquido)/nf.vl_total_liquido),0) as '% desconto',
nfitem.vl_tb_kami as vl_tb_kami,
nfitem.vl_total_item_tb_kami as vl_total_item_tb_kami

 

from

vd_nota_fiscal_item as nfitem
left join vd_pedido_item as pditem on (pditem.cod_pedido = nfitem.cod_pedido and pditem.cod_produto = nfitem.cod_produto)
left join vd_nota_fiscal as nf on (nfitem.cod_nota_fiscal = nf.cod_nota_fiscal)
left join cd_cliente as cliente on (cliente.cod_cliente = nf.cod_cliente and  cliente.cod_colaborador in (18,52,56,73,159,161))
left join cd_grupo_item as item on (nfitem.cod_produto = item.cod_produto)
left join cd_grupo_produto as grupo on (grupo.cod_grupo_produto = item.cod_grupo_produto)
left join cd_grupo_produto as grupop on (grupop.cod_grupo_produto = grupo.cod_grupo_pai)
left join sg_colaborador as vendedor on (cliente.cod_colaborador = vendedor.cod_colaborador)
left join cd_produto as produto on (produto.cod_produto = nfitem.cod_produto)
left join cd_marca as marca on (marca.cod_marca = produto.cod_marca)


where 
nf.nop in ("6.102","6.404","BLACKFRIDAY","CAMPANHA","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP","BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","ENXOVAL")
and nfitem.cod_empresa in (1,3)
and nf.situacao < 100
and nf.dt_emissao > "2020-01-01" 

INTO OUTFILE 'csv/produtos_varejo_solitario.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'