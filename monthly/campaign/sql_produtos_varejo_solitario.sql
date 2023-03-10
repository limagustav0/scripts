USE bkp_db_uc_kami;

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
(case when nf.nop in ("6.102","6.404","BLACKFRIDAY","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP") then "VENDA" else "BONIFICADO" end) Tipo_Venda,
 (case when nf.nop in ("6.102","6.404","BLACKFRIDAY","TRUSS LOVER","VENDA","VENDA_S_ESTOQUE","WORKSHOP") then "1" else "2" end) codigo_Tipo_Venda,
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
 else "0" end) tipo_produto
 

from

vd_nota_fiscal_item as nfitem
left join vd_pedido_item as pditem on (pditem.cod_pedido = nfitem.cod_pedido and pditem.cod_produto = nfitem.cod_produto)
left join vd_nota_fiscal as nf on (nfitem.cod_nota_fiscal = nf.cod_nota_fiscal)
left join cd_cliente as cliente on (cliente.cod_cliente = nf.cod_cliente and  cliente.cod_colaborador in (18,52,56,73,159,161))
left join cd_grupo_item as item on (nfitem.cod_produto = item.cod_produto)
left join cd_grupo_produto as grupo on (grupo.cod_grupo_produto = item.cod_grupo_produto)
left join cd_grupo_produto as grupop on (grupop.cod_grupo_produto = grupo.cod_grupo_pai)
left join sg_colaborador as vendedor on (cliente.cod_colaborador = vendedor.cod_colaborador)


where 
nfitem.cod_produto in ("574-2","MAT001","MAT002","5755")
and nf.nop in ("CAMPANHA","BONIFICADO", "BONIFICADO_F","BONI_COMPRA")
and nfitem.cod_empresa in (1,3)
and nf.situacao < 100
and nf.dt_emissao > "2021-01-01" 
and nf.cod_cliente  in (32,36,52,94,140,142,146,147,185,212,214,281,287,313,343,361,386,408,411,412,433,484,495,556,593,595,610,664,751,774,776,805,823,838,845,853,867,872,886,909,910,914,963,1011,1031,1046,1067,1116,1149,1170,1247,1262,1263,1321,1347,1369,1379,1385,1412,1429,1495,1513,1517,1518,1531,1536,1600,1700,1708,1734,1782,1790,1791,1792,1793,1794,1795,1796,1797,1801,1929,1935,1954,1974,1984,2005,2043,2109,3127,3239,7174,7591,8123,8263,9044,9220,9419,14018,14044,14048,14050,14051,14052,14077,14098,14149,14275,14378,14390,14396,14421,14438,14497,14545,14558,14559,14595,14603,14609,14642,14655,14679,14725,14747,14800,14857,14917,14954,14989,15003,15018,15019,15020,15021,15022,15023,15024,15026,15027,15028,15029,15030,15031,15032,15033,15034,15035,15036,15037,15038,15039,15040,15041,15042,15054,15076,15085,15097,15098,15116,15172,15174,15243,15244,15332,15340,17014,17018,17019,17025,17026,17031,17034,17037,17038,17040,17055,17061,17066,17067,17074,17153,17159,17167,17168,17181,17182,17188,17189,17194,17230,17252,17253,17283,17309,17310,17311,17372,17379,17380,17381,17451,17632,17637,17638,17639,17666,17688,17707,17708,18527,19708,20296,20767,21502,21757,24491,25112,25239,25780,26199,26843,28455,29311,29314,30206,30665,31090,32528,33675,34609,34621,34651,34711)


INTO OUTFILE 'csv/produtos_varejo_solitario.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'