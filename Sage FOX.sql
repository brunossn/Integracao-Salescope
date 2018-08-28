SELECT
    A.[Número] 'Pedido',
    A.Fornecedor 'Fornecedor',
    A.[Estado de Entrega] 'Estado',
    A.[Cidade de Entrega] 'Cidade',
    C.Região 'Região',
    '' 'Gerente',
    A.[Cadastrado por] 'Representante',
    B.[Tipo da Venda] 'Canal de vendas',
    C.PESSOA 'Segmento de mercado',
    B.Fornecedor 'Marca',
    D.Tipo 'Linha de produto',
    E.[Descriçãoo] 'Grupo de produto',
    '' 'Subgrupo de produto',
    D.Código + ' - ' + D.Linha01 'Produto',
    C.Razão 'Cliente',
    '' 'Complementar',
    DAY(A.Emissão) 'Dia',
    MONTH(A.Emissão) 'Mês',
    YEAR(A.Emissão) 'Ano', 
    ROUND(B.[Valor Líquido], 2, 1) 'Valor',
    ROUND(B.[Valor Líquido], 2, 1) 'Rentabilidade',
    CASE WHEN B.Unidade NOT IN('MT', 'KG') THEN B.Quantidade ELSE 1 END 'Quantidade', 
    0 'Litros',
    CASE B.Unidade WHEN 'KG' THEN B.Quantidade ELSE 0 END 'Quilos', 
    CASE B.Unidade WHEN 'MT' THEN B.Quantidade ELSE 0 END 'Metros',
    CASE WHEN C.PESSOA = 'Jurídica' THEN
        LEFT(REPLACE(REPLACE(REPLACE(C.[CNPJ/CPF], '.', ''), '-', ''), '/', ''), 8)
    ELSE
        LEFT(REPLACE(C.[CNPJ/CPF], '.', ''), 8)
    END 'CNPJ Inicial',
    CASE WHEN C.PESSOA = 'Jurídica' THEN
        SUBSTRING(C.[CNPJ/CPF], CHARINDEX('/', C.[CNPJ/CPF]) + 1, 4)
    ELSE
        '0001'
    END 'CNPJ Final',
    RTRIM(C.Endereço + ' ' + ISNULL(C.NRO_ENDERECO, '')) 'Endereço',
    '' 'Número',
    C.CEP 'CEP',
    C.Fone1 'Telefone',
    C.[e-mail] 'Email',
    C.Contato 'Observações'
FROM [Notas Fiscais de Saída] A
    INNER JOIN [Itens de Notas Fiscais de Saída] B ON
        A.[Tipo de Registro] = B.[Tipo de Registro] AND
        A.[Número] = B.[Número] AND
        A.[Fornecedor] = B.Fornecedor
LEFT JOIN Empresas C ON
    A.Empresa = C.Apel
LEFT JOIN [Produtos] D ON
    B.Produto = D.Código
LEFT JOIN [Grupos de Produtos] E ON
    D.Grupo = E.Código
WHERE B.Situação <> 'Cancelado' AND
B.Quantidade > 0 AND
C.[CNPJ/CPF] IS NOT NULL