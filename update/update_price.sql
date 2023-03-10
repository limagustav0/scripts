
UPDATE cd_produto_empresa AS cp
INNER JOIN temp AS tp ON tp.cod_produto = cp.cod_produto
SET cp.vl_custo_total = tp.custo;

SELECT 
  cp.cod_produto AS cod_produto,
  cp.vl_custo_total as custo_uno,  
  tp.custo AS custo_novo  

FROM cd_produto AS cp
INNER JOIN temp AS tp ON tp.cod_produto = cp.cod_produto

INTO OUTFILE "csv/tab_atualiza_check.csv"
CHARACTER SET utf8
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n';