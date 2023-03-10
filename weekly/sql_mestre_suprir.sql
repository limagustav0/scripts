USE bkp_db_uc_kami;
SELECT  
  'cod_cliente',
  'razao_social',
  'nome_cliente',
  'tipo',
  'data_cadastro',
  'bairro',
  'cidade',
  'estado',
  'endereco',
  'numero',
  'cep',
  'cod_colaborador',
  'nome_colaborador',
  'dias_atraso',
  'valor_devido',
  'dt_ultima_compra',
  'dt_primeira_compra',
  'qtd_total_compras',
  'qtd_compras_semestre',
  'janeiro_2022',
  'janeiro_2022_desconto',
  'janeiro_2022_bonificado',
  'janeiro_2022_ENXOVAL',
  'janeiro_2023',
  'janeiro_2023_desconto',
  'janeiro_2023_bonificado',
  'janeiro_2023_ENXOVAL',
  'fevereiro_2022',
  'fevereiro_2022_desconto',
  'fevereiro_2022_bonificado',
  'fevereiro_2022_ENXOVAL',
  'fevereiro_2023',
  'fevereiro_2023_desconto',
  'fevereiro_2023_bonificado',
  'fevereiro_2023_ENXOVAL',
  'marco_2022',
  'marco_2022_desconto',
  'marco_2022_bonificado',
  'marco_2022_ENXOVAL',
  'abril_2022',
  'abril_2022_desconto',
  'abril_2022_bonificado',
  'abril_2022_ENXOVAL',
  'maio_2022',
  'maio_2022_desconto',
  'maio_2022_bonificado',
  'maio_2022_ENXOVAL',
  'junho_2022',
  'junho_2022_desconto',
  'junho_2022_bonificado',
  'junho_2022_ENXOVAL',
  'julho_2022',
  'julho_2022_desconto',
  'julho_2022_bonificado',
  'julho_2022_ENXOVAL',
  'agosto_2022',
  'agosto_2022_desconto',
  'agosto_2022_bonificado',
  'agosto_2022_ENXOVAL',
  'setembro_2022',
  'setembro_2022_desconto',
  'setembro_2022_bonificado',
  'setembro_2022_ENXOVAL',
  'outrubo_2022',
  'outrubo_2022_desconto',
  'outrubo_2022_bonificado',
  'outrubo_2022_ENXOVAL',
  'novembro_2022',
  'novembro_2022_desconto',
  'novembro_2022_bonificado',
  'novembro_2022_ENXOVAL',
  'dezembro_2022',
  'dezembro_2022_desconto',
  'dezembro_2022_bonificado',
  'dezembro_2022_ENXOVAL'
UNION ALL
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
ELSE  "0" END FROM fn_titulo_receber AS recebe WHERE recebe.cod_cliente = cliente.cod_cliente AND recebe.situacao < 30 AND recebe.dt_vencimento < CURRENT_DATE() -1  AND recebe.cod_empresa IN (10,11)  group by recebe.cod_cliente) AS dias_atraso
,(SELECT CASE WHEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa)) > 0 THEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa))
ELSE  "0" END FROM fn_titulo_receber AS recebe WHERE recebe.cod_cliente = cliente.cod_cliente AND recebe.situacao < 30 AND recebe.dt_vencimento < CURRENT_DATE() -1  AND recebe.cod_empresa IN (10,11) group by recebe.cod_cliente) AS valor_devido

,(SELECT DATE_FORMAT(max(nf2.dt_emissao),'%d/%m/%Y') FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN (10,11) AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS dt_ultima_compra

,(SELECT DATE_FORMAT(min(nf2.dt_emissao),'%d/%m/%Y') FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN (10,11) AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS dt_primeira_compra

,(SELECT count(distinct nf2.dt_emissao) FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN (10,11) AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS qtd_total_compras

,(SELECT count(distinct nf2.dt_emissao) FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN (10,11) AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP") AND nf2.dt_emissao >= SUBDATE(CURDATE(), INTERVAL 6 MONTH)) AS qtd_compras_semestre

#janeiro 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (1) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS janeiro_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (1) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS janeiro_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (1) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS janeiro_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (1) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS janeiro_2022_ENXOVAL

#janeiro 2023
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (1) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2023-01-01" AND nf.dt_emissao < "2024-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS janeiro_2023
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (1) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2023-01-01" AND nf.dt_emissao < "2024-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS janeiro_2023_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (1) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2023-01-01" AND nf.dt_emissao < "2024-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS janeiro_2023_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (1) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2023-01-01" AND nf.dt_emissao < "2024-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS janeiro_2023_ENXOVAL

#fevereiro 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (2) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS fevereiro_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (2) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS fevereiro_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (2) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS fevereiro_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (2) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS fevereiro_2022_ENXOVAL

#fevereiro 2023
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (2) THEN IFNULL((nf.vl_total_nota_fiscal),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2023-01-01" AND nf.dt_emissao < "2024-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS fevereiro_2023
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (2) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2023-01-01" AND nf.dt_emissao < "2024-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS fevereiro_2023_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (2) THEN IFNULL((nf.vl_total_nota_fiscal),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2023-01-01" AND nf.dt_emissao < "2024-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS fevereiro_2023_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (2) THEN IFNULL((nf.vl_total_nota_fiscal),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2023-01-01" AND nf.dt_emissao < "2024-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS fevereiro_2023_ENXOVAL

#marco 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (3) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS marco_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (3) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS marco_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (3) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS marco_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (3) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS marco_2022_ENXOVAL

#abril 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (4) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS abril_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (4) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS abril_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (4) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS abril_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (4) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS abril_2022_ENXOVAL

#maio 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (5) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS maio_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (5) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS maio_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (5) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS maio_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (5) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS maio_2022_ENXOVAL

#junho 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (6) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS junho_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (6) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS junho_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (6) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS junho_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (6) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS junho_2022_ENXOVAL

#julho 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (7) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS julho_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (7) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS julho_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (7) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS julho_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (7) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS julho_2022_ENXOVAL

#agosto 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (8) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS agosto_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (8) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS agosto_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (8) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS agosto_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (8) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS agosto_2022_ENXOVAL

#setembro 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (9) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS setembro_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (9) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS setembro_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (9) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS setembro_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (9) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS setembro_2022_ENXOVAL

#outubro 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (10) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS outrubo_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (10) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS outrubo_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (10) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS outrubo_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (10) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS outrubo_2022_ENXOVAL

#novembro 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (11) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS novembro_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (11) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS novembro_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (11) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS novembro_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (11) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS novembro_2022_ENXOVAL

#dezembro 2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (12) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS dezembro_2022
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (12) THEN IFNULL(((nf.vl_total_tb_kami - nf.vl_total_nota_fiscal)),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS dezembro_2022_desconto
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (12) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01" AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("BONIFICADO", "BONIFICADO_F","BONI_COMPRA","PROMOCAO","PROMO_BLACK","CAMPANHA")) AS dezembro_2022_bonificado
,(SELECT  sum(CASE WHEN MONTH(nf.dt_emissao) IN (12) THEN IFNULL((nf.vl_total_liquido),0) ELSE 0 END) FROM  vd_nota_fiscal AS nf WHERE  cliente.cod_cliente = nf.cod_cliente AND nf.dt_emissao >= "2022-01-01" AND nf.dt_emissao < "2023-01-01"  AND nf.situacao < 100 AND nf.cod_empresa IN (10,11) AND nf.nop IN ("ENXOVAL")) AS dezembro_2022_ENXOVAL

FROM
cd_cliente AS cliente
LEFT JOIN cd_cliente_endereco AS endereco ON (cliente.cod_cliente = endereco.cod_cliente AND endereco.tp_endereco = "E")
LEFT JOIN sg_colaborador AS vendedor ON (vendedor.cod_colaborador = cliente.cod_colaborador )
LEFT JOIN fn_titulo_receber AS recebe ON (recebe.cod_cliente = cliente.cod_cliente AND recebe.situacao < 31 AND recebe.cod_empresa IN (10,11))
LEFT JOIN cd_cliente_atividade AS atividade ON (atividade.cod_cliente = cliente.cod_cliente)
LEFT JOIN cd_ramo_atividade AS ramo ON (ramo.cod_ramo_atividade = atividade.cod_ramo_atividade)
WHERE

 cliente.cod_colaborador IN (378, 385, 3342, 3346, 3345, 3344, 3369, 3375, 3349, 3374, 3376, 3358, 3354, 3366, 3348, 3370)
group by  cliente.cod_cliente


INTO OUTFILE 'csv/mestres_suprir.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'