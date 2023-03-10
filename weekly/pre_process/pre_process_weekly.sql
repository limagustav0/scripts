USE bkp_db_uc_kami;
DROP TRIGGER IF EXISTS `vd_pedido_item_delete`;
DROP TRIGGER IF EXISTS `vd_pedido_item_insert`;
DROP TRIGGER IF EXISTS `vd_pedido_item_update`;

UPDATE `cd_param_empresa` SET `valor`=NULL WHERE  `nome_param`='emailSMTP';
UPDATE `cd_param_empresa` SET `valor`=NULL WHERE  `nome_param`='emailSMTP';
UPDATE `cd_param_empresa` SET `valor`='0' WHERE  `nome_param`='diasEnvioEmailCobranca';
UPDATE `cd_param_empresa` SET `valor`='0' WHERE  `nome_param`='indEmailCobrancaModeloEmail';
UPDATE `cd_param_empresa` SET `valor`=NULL WHERE  `nome_param`='emailCobranca';
UPDATE `cd_param_empresa` SET `valor`=NULL WHERE  `nome_param`='senhaSMTP';

ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `vl_tb_kami` double(20,10) NULL DEFAULT 0;
ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `vl_total_item_tb_kami` double(20,10) NULL DEFAULT 0;
ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `ano_nota` varchar(20) NULL DEFAULT NULL;

ALTER TABLE `vd_nota_fiscal`
  ADD COLUMN `vl_total_tb_kami` double(20,10) NULL DEFAULT 0;

ALTER TABLE `vd_pedido_item`
  ADD COLUMN `vl_tb_kami` double(20,10) NULL DEFAULT 0;
ALTER TABLE `vd_pedido_item`
  ADD COLUMN `vl_total_item_tb_kami` double(20,10) NULL DEFAULT 0;

ALTER TABLE `vd_pedido`
  ADD COLUMN `vl_total_tb_kami` double(20,10) NULL DEFAULT 0;

UPDATE `vd_nota_fiscal_item`
INNER JOIN `vd_nota_fiscal` ON vd_nota_fiscal.cod_nota_fiscal = vd_nota_fiscal_item.cod_nota_fiscal
SET `ano_nota` = (YEAR(vd_nota_fiscal.dt_emissao));
 
UPDATE `vd_nota_fiscal_item` 
 SET `vl_tb_kami`= (
  SELECT item.preco_unit FROM cd_preco_item AS item  
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto 
  AND item.tb_preco = (
    CASE
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 1 THEN "TabKami22" 
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 1 THEN "TabKami21/1"
      WHEN produto.cod_marca = 13 THEN "TabMultMarca" 
      WHEN produto.cod_marca = 17 THEN "TabBRAE" 
      WHEN produto.cod_marca = 20 THEN "TabLAMODA" 
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` IN (1,3);

UPDATE `vd_nota_fiscal_item` 
 SET `vl_total_item_tb_kami`= vd_nota_fiscal_item.qtd * (
  SELECT item.preco_unit FROM cd_preco_item AS item
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto AND item.tb_preco = (
    CASE
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 1 THEN "TabKami22" 
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 1 THEN "TabKami21/1"
      WHEN produto.cod_marca = 13 THEN "TabMultMarca" 
      WHEN produto.cod_marca = 17 THEN "TabBRAE" 
      WHEN produto.cod_marca = 20 THEN "TabLAMODA" 
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` IN (1,3);

 UPDATE `vd_nota_fiscal_item` 
 SET `vl_tb_kami`= (
  SELECT item.preco_unit FROM cd_preco_item AS item  
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto 
  AND item.tb_preco = (
    CASE
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 1 THEN "TabKRS22" 
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 1 THEN "TabKRS"
      WHEN produto.cod_marca = 13 THEN "TabMultMarca"  
      WHEN produto.cod_marca = 20 THEN "TabLAMODARGS"  
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 2;
UPDATE `vd_nota_fiscal_item` 
 SET `vl_total_item_tb_kami`= vd_nota_fiscal_item.qtd * (
  SELECT item.preco_unit FROM cd_preco_item AS item
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto AND item.tb_preco = (
    CASE
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 1 THEN "TabKRS22" 
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 1 THEN "TabKRS"
      WHEN produto.cod_marca = 13 THEN "TabMultMarca"
      WHEN produto.cod_marca = 20 THEN "TabLAMODARGS"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 2;

 UPDATE `vd_nota_fiscal_item` 
 SET `vl_tb_kami`= (
  SELECT item.preco_unit FROM cd_preco_item AS item  
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto 
  AND item.tb_preco = (
    CASE
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 1 THEN "TabKami22"
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 1 THEN "TabKami21/1"
      WHEN produto.cod_marca = 2 THEN "TabJoico"
      WHEN produto.cod_marca = 3 THEN "TabMultMarca"
      WHEN produto.cod_marca = 6 THEN "TbKERASTASE"
      WHEN produto.cod_marca = 8 THEN "TabSENS22"
      WHEN produto.cod_marca = 9 THEN "TabMultMarca"
      WHEN produto.cod_marca = 16 THEN "TabWella"
      WHEN produto.cod_marca = 17 THEN "TabBRAE"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 4;
UPDATE `vd_nota_fiscal_item` 
 SET `vl_total_item_tb_kami`= vd_nota_fiscal_item.qtd * (
  SELECT item.preco_unit FROM cd_preco_item AS item
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto AND item.tb_preco = (
    CASE
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 1 THEN "TabKami22"
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 1 THEN "TabKami21/1"
      WHEN produto.cod_marca = 2 THEN "TabJoico"
      WHEN produto.cod_marca = 3 THEN "TabMultMarca"
      WHEN produto.cod_marca = 6 THEN "TbKERASTASE"
      WHEN produto.cod_marca = 8 THEN "TabSENS22"
      WHEN produto.cod_marca = 9 THEN "TabMultMarca"
      WHEN produto.cod_marca = 16 THEN "TabWella"
      WHEN produto.cod_marca = 17 THEN "TabBRAE"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 4;

  UPDATE `vd_nota_fiscal_item` 
 SET `vl_tb_kami`= (
  SELECT item.preco_unit FROM cd_preco_item AS item  
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto 
  AND item.tb_preco = (
    CASE      
      WHEN produto.cod_marca = 3 THEN "TabMultMarca"
      WHEN produto.cod_marca = 4 THEN "TabMultMarca"
      WHEN produto.cod_marca = 5 THEN "TabKPRO22"
      WHEN produto.cod_marca = 6 THEN "TbKERASTASE"
      WHEN produto.cod_marca = 7 THEN "TabMultMarca"
      WHEN produto.cod_marca = 9 THEN "TabMultMarca"
      WHEN produto.cod_marca = 10 THEN "TabWella"
      WHEN produto.cod_marca = 11 THEN "TabMultMarca"
      WHEN produto.cod_marca = 13 THEN "TabMultMarca"
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 15 THEN "TabBLZ-2022"
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 15 THEN "TabBelNat"
      WHEN produto.cod_marca = 16 THEN "TabWella"
      WHEN produto.cod_marca = 18 THEN "TabMultMarca"
      WHEN produto.cod_marca = 23 THEN "TABISSUE"
      WHEN produto.cod_marca = 24 THEN "TabMoro"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 5;
UPDATE `vd_nota_fiscal_item` 
 SET `vl_total_item_tb_kami`= vd_nota_fiscal_item.qtd * (
  SELECT item.preco_unit FROM cd_preco_item AS item
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto AND item.tb_preco = (
    CASE
      WHEN produto.cod_marca = 3 THEN "TabMultMarca"
      WHEN produto.cod_marca = 4 THEN "TabMultMarca"
      WHEN produto.cod_marca = 5 THEN "TabKPRO22"
      WHEN produto.cod_marca = 6 THEN "TbKERASTASE"
      WHEN produto.cod_marca = 7 THEN "TabMultMarca"
      WHEN produto.cod_marca = 9 THEN "TabMultMarca"
      WHEN produto.cod_marca = 10 THEN "TabWella"
      WHEN produto.cod_marca = 11 THEN "TabMultMarca"
      WHEN produto.cod_marca = 13 THEN "TabMultMarca"
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 15 THEN "TabBLZ-2022"
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 15 THEN "TabBelNat"
      WHEN produto.cod_marca = 16 THEN "TabWella"
      WHEN produto.cod_marca = 18 THEN "TabMultMarca"
      WHEN produto.cod_marca = 23 THEN "TABISSUE"
      WHEN produto.cod_marca = 24 THEN "TabMoro"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 5;

 UPDATE `vd_nota_fiscal_item` 
 SET `vl_tb_kami`= (
  SELECT item.preco_unit FROM cd_preco_item AS item  
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto 
  AND item.tb_preco = (
    CASE
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 1 THEN "TabKami22" 
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 1 THEN "TabKami21/1"
      WHEN produto.cod_marca = 2 THEN "TbSouthJC" 
      WHEN produto.cod_marca = 20 THEN "TbLAMODA"       
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 6;

UPDATE `vd_nota_fiscal_item` 
 SET `vl_total_item_tb_kami`= vd_nota_fiscal_item.qtd * (
  SELECT item.preco_unit FROM cd_preco_item AS item
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto AND item.tb_preco = (
    CASE
      WHEN `ano_nota` >= 2022 AND produto.cod_marca = 1 THEN "TabKami22"
      WHEN `ano_nota` <= 2021 AND produto.cod_marca = 1 THEN "TabKami21/1"
      WHEN produto.cod_marca = 2 THEN "TbSouthJC"
      WHEN produto.cod_marca = 20 THEN "TbLAMODA"      
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 6;

UPDATE `vd_nota_fiscal_item` 
 SET `vl_tb_kami`= (
  SELECT item.preco_unit FROM cd_preco_item AS item  
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto 
  AND item.tb_preco = (
    CASE
      WHEN produto.cod_marca = 5 THEN "TabKPRO22"
      WHEN produto.cod_marca = 17 THEN "TabBRAE"
      WHEN produto.cod_marca = 21 THEN "TabLOF"
      WHEN produto.cod_marca = 24 THEN "TabMoro"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 10;

UPDATE `vd_nota_fiscal_item` 
 SET `vl_total_item_tb_kami`= vd_nota_fiscal_item.qtd * (
  SELECT item.preco_unit FROM cd_preco_item AS item
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto AND item.tb_preco = (
    CASE
      WHEN produto.cod_marca = 5 THEN "TabKPRO22"
      WHEN produto.cod_marca = 17 THEN "TabBRAE"
      WHEN produto.cod_marca = 21 THEN "TabLOF"
      WHEN produto.cod_marca = 24 THEN "TabMoro"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 10;

 UPDATE `vd_nota_fiscal_item` 
 SET `vl_tb_kami`= (
  SELECT item.preco_unit FROM cd_preco_item AS item  
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto 
  AND item.tb_preco = (
    CASE      
      WHEN produto.cod_marca = 17 THEN "TabBRAE"
      WHEN produto.cod_marca = 21 THEN "TabLOF"
      WHEN produto.cod_marca = 24 THEN "TabMoro"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 11;

UPDATE `vd_nota_fiscal_item` 
 SET `vl_total_item_tb_kami`= vd_nota_fiscal_item.qtd * (
  SELECT item.preco_unit FROM cd_preco_item AS item
  INNER JOIN cd_produto AS produto ON (produto.cod_produto = item.cod_produto)
  WHERE vd_nota_fiscal_item.cod_produto = item.cod_produto AND item.tb_preco = (
    CASE      
      WHEN produto.cod_marca = 17 THEN "TabBRAE"
      WHEN produto.cod_marca = 21 THEN "TabLOF"
      WHEN produto.cod_marca = 24 THEN "TabMoro"
    ELSE "TabMultMarca" END)
 ) WHERE `cod_empresa` = 11;

UPDATE `vd_nota_fiscal` 
 SET `vl_total_tb_kami`= (SELECT sum(item.vl_total_item_tb_kami) FROM vd_nota_fiscal_item AS item WHERE item.cod_nota_fiscal = vd_nota_fiscal.cod_nota_fiscal) ;

UPDATE `vd_pedido` 
 SET `vl_total_tb_kami`= (SELECT sum(item.vl_total_item_tb_kami) FROM vd_pedido_item AS item WHERE item.cod_pedido = vd_pedido.cod_pedido);

ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `grupo_produto` int(11) NULL DEFAULT NULL;

  UPDATE `vd_nota_fiscal_item` 
 SET `grupo_produto`=  
(SELECT grupo.cod_grupo_produto FROM cd_grupo_item AS grupo WHERE grupo.cod_produto = vd_nota_fiscal_item.cod_produto AND grupo.cod_grupo_produto IN (39,8,10,40,9,38,7,11)) 
 WHERE `cod_empresa`=2;

  ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `nome_empresa` varchar(150) NULL DEFAULT NULL;

   UPDATE `vd_nota_fiscal_item` 
 SET `nome_empresa`=  
(SELECT empresa.nome_fantasia FROM cd_empresa AS empresa WHERE empresa.cod_empresa = vd_nota_fiscal_item.cod_empresa) ;

ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `cod_vendedor` int(11) NULL DEFAULT NULL;

ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `nome_vendedor` varchar(255) NULL DEFAULT NULL;

  ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `dt_emissao` date NULL DEFAULT NULL;

   UPDATE `vd_nota_fiscal_item` 
 SET `cod_vendedor`=  
(SELECT vendedor.cod_colaborador FROM vd_nota_fiscal AS vendedor WHERE vendedor.cod_nota_fiscal = vd_nota_fiscal_item.cod_nota_fiscal) ;


 UPDATE `vd_nota_fiscal_item` 
 SET `nome_vendedor`=  
(SELECT vendedor.nome_colaborador FROM sg_colaborador AS vendedor WHERE vendedor.cod_colaborador = vd_nota_fiscal_item.cod_vendedor) ;

 UPDATE `vd_nota_fiscal_item` 
 SET `dt_emissao`=  
(SELECT nf.dt_emissao FROM vd_nota_fiscal AS nf WHERE nf.cod_nota_fiscal = vd_nota_fiscal_item.cod_nota_fiscal) ;

ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `nome_cliente` varchar(255) NULL DEFAULT NULL;
ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `cod_cliente` int(11) NULL DEFAULT NULL;


 UPDATE `vd_nota_fiscal_item` 
 SET `nome_cliente`=  
(SELECT nf.nome_cliente FROM vd_nota_fiscal AS nf WHERE nf.cod_nota_fiscal = vd_nota_fiscal_item.cod_nota_fiscal) ;

 UPDATE `vd_nota_fiscal_item` 
 SET `cod_cliente`=  
(SELECT nf.cod_cliente FROM vd_nota_fiscal AS nf WHERE nf.cod_nota_fiscal = vd_nota_fiscal_item.cod_nota_fiscal) ;

ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `tipo_cliente` varchar(255) NULL DEFAULT NULL;
ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `cod_ramo_atividade` int(11) NULL DEFAULT NULL;


 UPDATE `vd_nota_fiscal_item` 
 SET `cod_ramo_atividade`=  
(SELECT max(ramo.cod_ramo_atividade) FROM cd_cliente_atividade AS ramo WHERE ramo.cod_cliente = vd_nota_fiscal_item.cod_cliente) ;
 UPDATE `vd_nota_fiscal_item` 
 SET `tipo_cliente`=  
(SELECT ramo.desc_abrev FROM cd_ramo_atividade AS ramo WHERE ramo.cod_ramo_atividade = vd_nota_fiscal_item.cod_ramo_atividade) ;


ALTER TABLE `vd_nota_fiscal_item`
  ADD COLUMN `situacao` int(11) NULL DEFAULT NULL;

 UPDATE `vd_nota_fiscal_item` 
 SET `situacao`=  
(SELECT nf.situacao FROM vd_nota_fiscal AS nf WHERE nf.cod_nota_fiscal = vd_nota_fiscal_item.cod_nota_fiscal);