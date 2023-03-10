# -*- coding: utf-8 -*-

from datetime import datetime, timedelta

months = { 
  1:'Janeiro', 2:'Fevereiro',  3:'Março',  4:'Abril',  5:'Maio',  6:'Junho', 
  7:'Julho', 8:'Agosto',  9:'Setembro',  10:'Outubro',  11:'Novembro',  12:'Dezembro',
}

tags = ['', '_desconto', '_bonificado', '_ENXOVAL',]
starting_year = 2021

scope = 'https://www.googleapis.com/auth/drive'
key_file_location = 'service_account_credentials.json'
current_month = datetime.now().month
current_year = datetime.now().year
current_day = datetime.now().day
end_week = datetime.now() - timedelta(days=datetime.today().weekday())
start_week = end_week - timedelta(days=7)
current_weekday = datetime.today().weekday()
current_week_folder = f'Semana_{start_week.day}-{start_week.month}_A_{end_week.day}-{end_week.month}'
columns_names_masters = [
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
  'qtd_compras_ytd', 
]
columns_names_renato = [ 
  'ano', 'mes', 'cod_empresa', 'cod_pedido', 'cod_cliente', 'nome_cliente', 'nr_ped_compra_cli', 'situacao_pedido', 'nop', 'desc_abrev_cfop', 'desc_abreviada', 'cod_colaborador', 'nome_colaborador', 'cod_cond_pagto', 'cod_forma_pagto', 'desc_abrev', 'cod_produto', 'desc_comercial', 'qtd', 'custo_total', 'custo_kami', 'tb_preco', 'preco_unit_original', 'pr_tot_original', 'margem_bruta', 'preco_total', 'preco_desconto_rateado', 'vl_total_pedido', 'desconto_pedido', 'valor_nota', 'dt_implante_pedido', 'dt_entrega_comprometida', 'situacao_entrega', 'descricao', 'dt_faturamento', 'marca', 'empresa_pedido', 'empresa_nf'
]
columns_names_products = [
  'empresa', 'cod_interno', 'ano', 'mes', 'data_completa', 'cod_cliente',
  'razao_social', 'cod_colaborador', 'nome_colaborador', 'cod_produto',
  'nome_produto', 'cod_grupo', 'nome_grupo', 'cod_grupo_pai', 'nome_grupo_pai',
  'nop', 'qtd', 'tipo_Venda', 'codigo_Venda'
]
columns_names_overdue = [
  'cod_cliente', 'nome_cliente', 'tp_cliente', 'razao_social', 'classificacao', 
  'dt_ultima_compra', 'dias_sem_compra', 'dias_atraso', 'valor_devido', 'sigla_uf'
]