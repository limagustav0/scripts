USE bkp_db_uc_kami;
SELECT
'cod_cliente',
'nome_cliente',
'tp_cliente',
'razao_social',
'classificacao',
'dt_ultima_compra',
'dias_sem_compra',
'dias_atraso',
'valor_devido',
'sigla_uf',
'cod_empresa',
'nome_empresa'
UNION ALL
SELECT 
nf.cod_cliente AS cod_cliente,
cliente.nome_cliente, 
cliente.tp_cliente,
nf.razao_social,
ramo.desc_abrev AS classificacao
,(SELECT DATE_FORMAT(max(nf2.dt_emissao),'%d/%m/%Y') FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN (1,2,3,4,5,6)) AS dt_ultima_compra
,(SELECT TIMESTAMPDIFF(DAY,max(nf2.dt_emissao),CURRENT_DATE() ) FROM vd_nota_fiscal AS nf2 WHERE cliente.cod_cliente = nf2.cod_cliente AND nf2.situacao < 81 AND nf2.cod_empresa IN (1,2,3,4,5,6)) AS dias_sem_compra
,(SELECT  CASE WHEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa)) > 0 THEN  ( TIMESTAMPDIFF(DAY,recebe.dt_vencimento, CURRENT_DATE()))  
ELSE  "0" END FROM fn_titulo_receber AS recebe WHERE recebe.cod_cliente = nf.cod_cliente AND recebe.situacao < 30 AND recebe.dt_vencimento < CURRENT_DATE() -1  AND recebe.cod_empresa IN (1,2,3,4,5,6)  group by recebe.cod_cliente) AS dias_atraso
,(SELECT CASE WHEN (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa)) > 0 THEN  (sum(recebe.vl_total_titulo) - sum(recebe.vl_total_baixa))  
ELSE  "0" END FROM fn_titulo_receber AS recebe WHERE recebe.cod_cliente = nf.cod_cliente AND recebe.situacao < 30 AND recebe.dt_vencimento < CURRENT_DATE() -1  AND recebe.cod_empresa IN (1,2,3,4,5,6) group by recebe.cod_cliente) AS valor_devido
,nf.sigla_uf
,nf.cod_empresa
,empresa.nome_fantasia
FROM
vd_nota_fiscal AS nf
LEFT JOIN cd_cliente AS cliente ON (nf.cod_cliente = cliente.cod_cliente)
LEFT JOIN cd_cliente_atividade AS atividade ON(atividade.cod_cliente = nf.cod_cliente)
LEFT JOIN cd_ramo_atividade AS ramo ON (ramo.cod_ramo_atividade = atividade.cod_ramo_atividade)
LEFT JOIN cd_empresa AS empresa ON (empresa.cod_empresa = nf.cod_empresa)
WHERE
nf.situacao < 100
AND nf.dt_emissao > "2021-01-01"
group by
nf.cod_cliente

INTO OUTFILE 'csv/clientes_overdue.csv'
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'