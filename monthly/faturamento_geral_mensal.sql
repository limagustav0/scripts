USE bkp_db_uc_kami;
SELECT
'ano', 
'mes', 
'cod_empresa', 
'cod_pedido', 
'cod_cliente', 
'nome_cliente', 
'nr_ped_compra_cli', 
'situacao_pedido', 
'nop', 
'desc_abrev_cfop', 
'desc_abreviada', 
'cod_colaborador', 
'nome_colaborador', 
'cod_cond_pagto', 
'cod_forma_pagto', 
'desc_abrev', 
'cod_produto', 
'desc_comercial', 
'qtd', 
'custo_total', 
'custo_kami', 
'tb_preco', 
'preco_unit_original', 
'pr_tot_original', 
'margem_bruta', 
'preco_total', 
'preco_desconto_rateado', 
'vl_total_pedido', 
'desconto_pedido', 
'valor_nota', 
'dt_implante_pedido', 
'dt_entrega_comprometida', 
'situacao_entrega', 
'descricao', 
'dt_faturamento', 
'marca', 
'empresa_pedido', 
'empresa_nf'
UNION ALL
select 
year(pd.dt_implant) as ano,
MONth(pd.dt_implant) as mes, 
pd.cod_empresa,
pd.cod_pedido,
pd.cod_cliente,
pd.nome_cliente,
#DATE_FORMAT(pd.dt_implant, "%d/%m/%Y") as data_pedido,
ifnull(pd.nr_ped_compra_cli, pd.cod_pedido_pda) AS nr_ped_compra_cli,
pd.situacao,
pd.nop,
nf2.desc_abrev_cfop,
ra.desc_abrev,
pd.cod_colaborador,
sc.nome_colaborador,
pd.cod_cond_pagto,
pp.cod_forma_pagto,
fp.desc_abrev,
pdi.cod_produto,
pdi.desc_comercial,
pdi.qtd,
ce.vl_custo_total as custo_total,
ifnull(
  ce.vl_custo_kami, (
    select cpi.preco_unit from cd_preco_item as cpi 
    where cpi.cod_produto = pdi.cod_produto 
    and cpi.tb_preco = 'TabTbCusto'
  )
) as custo_kami,
pdi.tb_preco,
pdi.preco_venda as preco_unit_original,
pdi.qtd * pdi.preco_venda as pr_tot_original,
(((pdi.preco_venda / ce.vl_custo_total)*100)-100)  as margem_bruta,
pdi.preco_total as preco_total ,
(pdi.preco_total -( pdi.preco_total / pd.vl_total_produtos) * COALESCE(pd.vl_desconto,0))  as preco_desconto_rateado,
pd.vl_total_produtos  as  vl_total_pedido,
(pd.vl_desconto * -1) as  desconto_pedido,
case when nf.vl_total_nota_fiscal > 0 then nf.vl_total_nota_fiscal else nf2.vl_total_nota_fiscal end as valor_nota ,
DATE_FORMAT(pd.dt_implant, "%d/%m/%Y")as  dt_implante_pedido,
DATE_FORMAT(pd.dt_entrega_comprometida, "%d/%m/%Y")as dt_entrega_comprometida,
pd.situacao,
vp.descricao,
DATE_FORMAT(case when nf.dt_emissao >0 then nf.dt_emissao   else nf2.dt_emissao end, "%d/%m/%Y") as dt_faturamento,

marca.desc_abrev as marca,
pd.cod_empresa as empresa_pedido,
nf2.cod_empresa as empresa_nf

 FROM vd_pedido as pd
 left join sg_colaborador as sc on (sc.cod_colaborador = pd.cod_colaborador)
 left join cd_cond_pagto as cp on  (cp.cod_cond_pagto = pd.cod_cond_pagto)

 left join vd_ponto_controle as vp on (vp.cod_controle = pd.situacao)
 left join vd_pedido_pagto as pp on (pp.cod_pedido = pd.cod_pedido )
 left join cd_forma_pagto as fp on  (pp.cod_forma_pagto = fp.cod_forma_pagto)
 left join cd_cliente_atividade as ca  on (ca.cod_cliente = pd.cod_cliente)
 left join cd_ramo_atividade as ra  on (ca.cod_ramo_atividade = ra.cod_ramo_atividade)
 left join vd_nota_fiscal as nf on (nf.cod_pedido = pd.cod_pedido and nf.situacao < 86 and nf.situacao > 79 and  pd.cod_empresa = nf.cod_empresa)
 left join vd_nota_fiscal as nf2 on (nf2.cod_pedido = pd.cod_pedido and nf2.situacao < 86 and nf2.situacao > 79 )
 left join vd_pedido_item as pdi on (pd.cod_pedido = pdi.cod_pedido and pd.cod_empresa = pdi.cod_empresa)
 left join cd_produto_empresa as ce on (pdi.cod_produto = ce.cod_produto and pd.cod_empresa = ce.cod_empresa)
 left join cd_produto as produto on (produto.cod_produto = pdi.cod_produto)
 left join cd_marca as marca on (marca.cod_marca = produto.cod_marca)

 
where
pd.dt_implant >= "2021-01-01" and
pd.dt_implant < "2024-01-01" and
pd.situacao < 200

group by
ano, mes, pd.cod_pedido, pd.cod_cliente, pdi.cod_produto

INTO OUTFILE 'csv/faturamento_geral_mensal.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
