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
left join cd_cliente as cliente on (cliente.cod_cliente = nf.cod_cliente and  cliente.cod_colaborador in (8,21,32,107,120,160,172))
left join cd_grupo_item as item on (nfitem.cod_produto = item.cod_produto)
left join cd_grupo_produto as grupo on (grupo.cod_grupo_produto = item.cod_grupo_produto)
left join cd_grupo_produto as grupop on (grupop.cod_grupo_produto = grupo.cod_grupo_pai)
left join sg_colaborador as vendedor on (cliente.cod_colaborador = vendedor.cod_colaborador)


where 
nfitem.cod_produto in ("574-2","MAT001","MAT002","5755")
and nf.nop in ("CAMPANHA","BONIFICADO", "BONIFICADO_F","BONI_COMPRA")
and nfitem.cod_empresa in (2)
and nf.situacao < 100
and nf.dt_emissao > "2021-01-01" 
and nf.cod_cliente  in (25,53,56,77,81,106,110,123,129,179,217,227,229,241,247,276,333,345,364,366,406,413,435,512,522,547,553,566,572,588,590,603,643,646,674,677,678,699,748,755,771,780,862,866,881,882,955,1052,1058,1074,1103,1128,1134,1189,1191,1197,1225,1235,1330,1368,1408,1417,1449,1451,1453,1455,1457,1458,1785,1799,1804,1806,1810,1823,1860,1864,1877,1890,1964,1982,2023,2024,2032,2037,2041,2054,2058,2062,2063,2087,2088,2092,2093,2094,2096,2099,2100,2101,2102,2115,2118,2120,2121,2122,2123,14025,14049,14058,14070,14079,14081,14093,14095,14100,14107,14109,14118,14124,14125,14131,14153,14157,14164,14169,14173,14174,14175,14177,14179,14181,14183,14189,14193,14198,14212,14217,14235,14249,14252,14258,14276,14288,14296,14307,14318,14330,14332,14335,14339,14344,14348,14350,14351,14374,14387,14389,14392,14403,14405,14408,14411,14412,14413,14425,14426,14429,14430,14431,14432,14449,14451,14455,14456,14469,14474,14477,14487,14488,14494,14495,14504,14511,14518,14523,14526,14540,14565,14590,14591,14592,14605,14606,14607,14612,14624,14629,14633,14660,14662,14667,14669,14671,14674,14675,14687,14688,14689,14697,14704,14705,14706,14712,14718,14724,14726,14731,14736,14742,14757,14758,14784,14785,14788,14791,14795,14813,14814,14818,14828,14844,14854,14866,14884,14888,14895,14902,14907,14911,14913,14915,14923,14930,14935,14937,14938,14966,14980,14981,14982,14985,14987,14998,15044,15055,15075,15081,15101,15111,15121,15130,15139,15155,15156,15189,15206,15207,15227,15229,15232,15238,15247,15250,15253,15254,15256,15266,15268,15284,15285,15303,15311,15318,15326,15328,15341,15358,15361,15395,15397,15400,15405,17084,17085,17091,17096,17099,17100,17103,17106,17107,17109,17120,17122,17154,17155,17158,17173,17179,17200,17201,17209,17235,17237,17238,17239,17241,17243,17250,17260,17263,17293,17298,17299,17303,17308,17316,17319,17336,17337,17340,17356,17373,17389,17395,17398,17400,17402,17405,17415,17422,17423,17435,17438,17440,17445,17450,17453,17649,17652,17659,17663,17664,17665,17674,17678,17681,17686,17687,17693,17714,17716,17725,18523,18526,18528,18540,18542,18549,18556,18557,18558,19103,19104,19191,19904,20052,20083,20116,20170,21054,21198,21630,21631,21632,21680,21724,21739,22215,22370,22372,22386,22441,22547,22893,22938,23400,23672,24113,24128,24637,24677,24875,24878,24897,24898,25044,25045,25046,25557,25711,26126,26129,26220,26924,27003,27011,27291,27295,27742,29183,29249,29347,31216,31226,31800,31823,32829,32867,33064,34001,34484,34485,34588,34607,34616,34659)


INTO OUTFILE 'csv/produtos_rs.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
