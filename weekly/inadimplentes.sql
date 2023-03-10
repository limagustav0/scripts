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
  'cod_empresa',
  'nome_empresa',
  'dias_atraso',
  'valor_devido',
  'dt_ultima_compra',
  'dt_primeira_compra',
  'qtd_total_compras',
  'qtd_compras_semestre'
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
,cliente.cod_empresa
,empresa.nomes_fantasia

,(SELECT  CASE WHEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa)) > 0 THEN  ( TIMESTAMPDIFF(DAY,recebe.dt_vencimento, CURRENT_DATE()))  
ELSE  "0" END FROM fn_titulo_receber AS recebe WHERE recebe.cod_cliente = cliente.cod_cliente AND recebe.situacao < 30 AND recebe.dt_vencimento < CURRENT_DATE() -1  AND recebe.cod_empresa IN (1,3)  group by recebe.cod_cliente) AS dias_atraso

,(SELECT CASE WHEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa)) > 0 THEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa))
ELSE  "0" END FROM fn_titulo_receber AS recebe WHERE recebe.cod_cliente = cliente.cod_cliente AND recebe.situacao < 30 AND recebe.dt_vencimento < CURRENT_DATE() -1  AND recebe.cod_empresa IN (1,3) group by recebe.cod_cliente) AS valor_devido

,(SELECT DATE_FORMAT(max(nf2.dt_emissao),'%d/%m/%Y') FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS dt_ultima_compra

,(SELECT DATE_FORMAT(max(nf2.dt_emissao),'%d/%m/%Y') FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS dt_primeira_compra

,(SELECT count(distinct nf2.dt_emissao) FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP")) AS qtd_total_compras

,(SELECT count(distinct nf2.dt_emissao) FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.nop IN ("6.102","6.404","BLACKFRIDAY","VENDA","VENDA_S_ESTOQUE","WORKSHOP") AND nf2.dt_emissao >= SUBDATE(CURDATE(), INTERVAL 6 MONTH)) AS qtd_compras_semestre


FROM
cd_cliente AS cliente
LEFT JOIN cd_cliente_endereco AS endereco ON (cliente.cod_cliente = endereco.cod_cliente AND endereco.tp_endereco = "E")
LEFT JOIN sg_colaborador AS vendedor ON (vendedor.cod_colaborador = cliente.cod_colaborador )
#LEFT JOIN fn_titulo_receber AS recebe ON (nf.cod_cliente = recebe.cod_cliente AND recebe.situacao < 31)
LEFT JOIN cd_cliente_atividade AS atividade ON (atividade.cod_cliente = cliente.cod_cliente)
LEFT JOIN cd_ramo_atividade AS ramo ON (ramo.cod_ramo_atividade = atividade.cod_ramo_atividade)
LEFT JOIN cd_empresa AS empresa ON (empresa.cod_empresa = client.cod_empresa)

group by  cliente.cod_cliente


INTO OUTFILE 'csv/inadimplentes.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'