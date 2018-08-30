
/* Pedidos Faturados */
SELECT
	Nota.nu_nf_emp_fat AS Nota_Pedido,
	LEFT(Empresa.nome_fant, 50) AS Unidade,
	LEFT(Nota.estado, 2) AS Estado,
	LEFT(Nota.municipio, 50) AS Cidade,
	LEFT(Area.descricao, 50) AS Regiao,
	LEFT(Gerente.descricao, 50) AS Gerencia,
	LEFT(Vendedor.nome, 50) AS Vendedor,
	'FATURADO' AS TipoPedido,
	LEFT(ra.descricao, 50) AS Segmento,
	LEFT(Fabricante.descricao, 50) AS FabricanteProduto,
	LEFT(Categoria.descricao, 50) AS CategoriaProduto,
	Grupo.descricao AS GrupoProduto,
	'' AS SubGrupo,
	LEFT(Produto.descricao, 50) AS Produto,
	LEFT(Nota.nome, 50) AS Cliente,
	LEFT(Nota.bairro, 50) AS Bairro,
	Day(Nota.DT_EMIS) AS Dia,
	Month(Nota.DT_EMIS) AS Mes,
	Year(Nota.DT_EMIS) AS Ano,
	ItemNota.preco_unit * (ItemNota.qtde_est - ISNULL(ItemNota.qtde_dev, 0)) - ItemNota.vl_desc_geral AS Preço1,
	ItemNota.preco_unit * (ItemNota.qtde_est - ISNULL(ItemNota.qtde_dev,0)) - ItemNota.vl_desc_geral AS Preço2,
	Convert(decimal(11),ItemNota.qtde - ISNULL(ItemNota.qtde_dev,0)) AS Quantidade,
	0 AS Litros,
	0 AS Quilos,
	0 AS Metros,
	CASE WHEN Cliente.tp_pes = 'J' THEN
		SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),1,2)+SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),3,3)+SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),6,3) 
	ELSE
		SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),1,3)+SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),4,3)+SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),7,3)
	END AS CNPJ,
	CASE WHEN Cliente.tp_pes = 'J' THEN
		SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),9,4)+SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),13,2) 
	ELSE
		SUBSTRING(CONVERT(VARCHAR(14),Nota.cgc_cpf),10,2)
	END AS Filial,
	LEFT(Nota.endereco, 150) AS Endereço,
	LEFT(Nota.cep,5) + '-' + RIGHT(Nota.cep,3) AS CEP,
	Convert(varchar(10), Telefone.ddd) + Convert(varchar(30), Telefone.numero) AS TELEFONE,
	LEFT(Cliente.e_mail, 100) AS EMAIL,
	LEFT(Nota.bairro, 60) AS ObservacoesDoCliente
FROM 
	ped_vda Pedido

	Inner Join it_pedv PedidoItem On
		Pedido.nu_ped = PedidoItem.nu_ped and
		Pedido.cd_emp = PedidoItem.cd_emp

	Inner Join produto Produto On
		Produto.cd_prod = PedidoItem.cd_prod

	Left Join linha Linha On
		Linha.cd_linha = Produto.cd_linha

	Left Join categprd Categoria On
		Categoria.cd_categprd = Linha.cd_categprd

	Left Join fabric Fabricante On
		Fabricante.cd_fabric = Produto.cd_fabric

	Left Join vendedor Vendedor On
		Vendedor.cd_vend = Pedido.cd_vend

	Left Join equipe Equipe On
		Equipe.cd_equipe = Vendedor.cd_equipe and
		Equipe.cd_emp = Vendedor.cd_emp

	Left Join gerencia Gerente On
		Gerente.cd_gerencia = Equipe.cd_gerencia

	Inner Join tp_ped tp ON
		Pedido.tp_ped = tp.tp_ped AND
		tp.estat_com = 1

	Inner Join nota Nota ON
		Nota.nu_ped = Pedido.nu_ped and
		Nota.cd_emp = Pedido.cd_emp

	Inner Join it_nota ItemNota On
		Nota.nu_nf = ItemNota.nu_nf and
		ItemNota.seq_it_pedv = PedidoItem.seq

	Inner Join cliente Cliente ON
		Cliente.cd_clien = Pedido.cd_clien

	Left Join tel_cli Telefone ON
		Telefone.cd_clien = Cliente.cd_clien AND
		Telefone.seq = 1

	Left Join empresa Empresa ON
		Empresa.cd_emp = PedidoItem.cd_emp

	Left Join ram_ativ ra ON
		ra.ram_ativ = Cliente.ram_ativ

	Left Join area Area ON
		Area.cd_area = Cliente.cd_area

	Left Join grupo_prd Grupo ON
		Produto.cd_grupo_prd = Grupo.cd_grupo_prd
WHERE 
	ISNULL(PedidoItem.bonificado, 0) = 0
	AND Nota.tipo_nf = 's' 
	AND Nota.situacao not In ('CA') 
	AND PedidoItem.situacao NOT IN ('CA','DV')
	AND ItemNota.desc_cfop NOT IN ('6910','5910') 
	AND Convert(decimal(11),ItemNota.qtde-ISNULL(ItemNota.qtde_dev,0)) <> 0
	AND ItemNota.preco_unit * (ItemNota.qtde-ISNULL(ItemNota.qtde_dev,0)) <> 0
	AND ItemNota.preco_unit <> 0
	AND ISNUMERIC(Nota.cgc_cpf) = 1

UNION ALL

/* Pedidos em aberto */
SELECT
	Pedido.nu_ped AS Nota_Pedido,
	LEFT(Empresa.nome_fant, 50) AS Unidade,
	LEFT(Endereco.estado, 2) AS Estado,
	LEFT(Endereco.municipio, 50) AS Cidade,
	LEFT(Area.descricao, 50) AS Regiao,
	'' AS Gerente,
	LEFT(Vendedor.nome , 50) AS Representante,
	'PENDENTE' AS TipoPedido,
	LEFT(Segmento.descricao, 50) AS Segmento,
	LEFT(Fabricante.descricao, 50) AS FabricanteProduto,
	LEFT(Categoria.descricao, 50) AS CategoriaProduto,
	Grupo.descricao AS Grupo,
	'' AS SubGrupo,
	LEFT(Produto.descricao, 50) AS Produto,
	LEFT(Cliente.nome, 50) AS Cliente,
	LEFT(Endereco.bairro, 50) AS Bairro,
	Day(Pedido.dt_ped) AS Dia,
	Month(Pedido.dt_ped) AS Mes,
	Year(Pedido.dt_ped) AS Ano,
	PedidoItem.preco_unit * (PedidoItem.qtde) - PedidoItem.vl_desc_geral AS Preço1,
	PedidoItem.preco_unit * (PedidoItem.qtde) - PedidoItem.vl_desc_geral AS Preço2,
	PedidoItem.qtde AS Quantidade,
	0 AS Litros,
	0 AS Quilos,
	0 AS Metros,
	CASE WHEN Cliente.tp_pes = 'J' THEN
		SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),1,2)+SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),3,3)+SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),6,3) 
	ELSE
		SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),1,3)+SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),4,3)+SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),7,3)
	END AS CNPJ,
	CASE WHEN Cliente.tp_pes = 'J' THEN
		SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),9,4)+SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),13,2) 
	ELSE
		SUBSTRING(CONVERT(VARCHAR(14),Cliente.cgc_cpf),10,2)
	END AS Filial,
	LEFT(Endereco.endereco, 150) AS Endereço,
	LEFT(Endereco.cep,5) + '-' + RIGHT(Endereco.cep,3) AS CEP,
	Convert(Varchar(10), Telefone.ddd) + Convert(Varchar(50), Telefone.numero) AS TELEFONE,
	LEFT(Cliente.e_mail, 100) AS EMAIL,
	LEFT(Endereco.bairro, 60) AS ObservacoesDoCliente
FROM 
	ped_vda Pedido

	Inner Join it_pedv PedidoItem On
		Pedido.nu_ped = PedidoItem.nu_ped

	Inner Join Produto On
		Produto.cd_prod = PedidoItem.cd_prod

	Left Join Linha On
		Linha.cd_linha = Produto.cd_linha

	Left Join categprd Categoria On
		Categoria.cd_categprd = Linha.cd_categprd

	Left Join fabric Fabricante On
		Fabricante.cd_fabric = Produto.cd_fabric

	Left Join Vendedor On
		Vendedor.cd_vend = Pedido.cd_vend

	Left Join Equipe On
		Equipe.cd_equipe = Vendedor.cd_equipe And
		Equipe.cd_emp = Vendedor.cd_emp

	Left Join gerencia Gerencia On
		Gerencia.cd_gerencia = Equipe.cd_gerencia

	Left Join tp_ped tp ON
		Pedido.tp_ped = tp.tp_ped AND
		tp.estat_com = 1

	Inner Join Cliente ON
		Cliente.cd_clien = Pedido.cd_clien

	Left Join end_cli Endereco ON
		Endereco.cd_clien = Cliente.cd_clien AND
		Endereco.tp_end = 'FA'
			
	Left Join tel_cli Telefone ON
		Telefone.cd_clien = Cliente.cd_clien AND
		Telefone.seq = 1

	Left Join empresa Empresa ON
		Empresa.cd_emp = PedidoItem.cd_emp

	Left Join ram_ativ Segmento ON
		Segmento.ram_ativ = Cliente.ram_ativ

	Left Join Area ON
		Area.cd_area = Cliente.cd_area

	Left Join grupo_prd Grupo ON
		Produto.cd_grupo_prd = Grupo.cd_grupo_prd
WHERE
	Pedido.cd_emp = PedidoItem.cd_emp AND
	ISNULL(PedidoItem.bonificado, 0) = 0 AND
	Pedido.situacao not In ('CA')  AND
	PedidoItem.situacao NOT IN ('CA','DV') AND
	PedidoItem.situacao IN ('AB') AND
	Convert(decimal(11),PedidoItem.qtde) <> 0 AND
	PedidoItem.preco_unit * (PedidoItem.qtde) <> 0 AND
	PedidoItem.preco_unit <> 0
