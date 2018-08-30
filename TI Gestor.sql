Select
    nf.numero_nf NF,
    'Matriz' Filial,
    c.estado Estado,
    substring(cid.nome_cidade from 1 for 30) Cidade,
    coalesce(rc.descricao, 'ND') Regiao,
    '' Gerente,
    substring(vd.nome from 1 for 30) Representante,
    '' Canal,
    '' Segmento,
    '' Marca,
    substring(fl.descricao from 1 for 20) Linha,
    '' Grupo,
    '' Subgrupo,
    substring(vi.descricao from 1 for 50) Produto,
    c.nome Cliente,
    '' CampoAdicional,
    extract(day from nf.data_emissao) Dia,
    extract(month from nf.data_emissao) Mes,
    cast(extract(year from nf.data_emissao) as varchar(4)) Ano,
    (vi.vr_total_item + vi.vr_frete + vi.vr_seguro + vi.vr_outras - vi.vr_desconto) Valor,
    (vi.vr_total_item + vi.vr_frete + vi.vr_seguro + vi.vr_outras - vi.vr_desconto) Rentabilidade,
    vi.quantidade Quantidade,
    0 litros,
    0 quilos,
    0 metros,
    case c.classificacao
    when 0 then substring(c.cnpj_cpf from 1 for 8)
    else c.cod_cliente
    end CnpjInicial,
    case c.classificacao
    when 0 then substring(c.cnpj_cpf from 9 for 4)
    else c.cod_cliente
    end CnpjFinal,
    coalesce(c.endereco || ' ' || c.end_numero, c.endereco) Endereco,
    substring(c.cep from 1 for 5) || '-' || substring(c.cep from 6 for 3) CEP,
    iif(coalesce(c.telefone, '') <> '', c.telefone, 'ND') Telefone,
    iif(coalesce(c.e_mail, '') <> '', c.e_mail, 'ND') Email,
    iif(coalesce(c.observacao, '') <> '', c.observacao, 'ND') ObservacoesCliente
From vendas_nf nf
Left Outer Join vendas_nf_itens vi on
    (nf.cod_empresa = vi.cod_empresa and
    nf.numero_nf   = vi.numero_nf)
Left Outer Join ft_linha fl on
    (vi.cod_linha = fl.cod_linha)
Left Outer Join clientes c on
    (nf.id_cod_cliente = c.cod_cliente)
Left Outer Join cidades cid on
    (c.cod_cidade = cid.cod_cidade)
Left Outer Join vendedores vd on
    (nf.cod_vendedor = vd.cod_vendedor)
Left Outer Join regiao_comercial rc on
    (vd.cod_regiaocom = rc.cod_regiaocom)
Left Outer Join cfop_seq cs on
    (vi.cfop_cod = cs.cod_cfop and
    vi.cfop_seq = cs.seq_cfop)
Where nf.cod_empresa = 2 and
    nf.data_emissao between '01.01.2015' and '31.12.2015' and
    nf.data_cancelamento is null and
    cs.flag_vendas = 1
Order By
    nf.cod_empresa,
    nf.numero_nf,
    vi.cod_item