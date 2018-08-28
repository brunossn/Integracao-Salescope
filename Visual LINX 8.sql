/*
    A query contempla apenas vendas de atacado.

    Aguns campos como Região, Gerente e Rentabilidade podem
    ser customizados de acordo com cada empresa e não foram implentados.
*/

SELECT A.NF_SAIDA 'Nota fiscal',
A.FILIAL 'Filial',
B.UF 'Estado',
B.CIDADE 'Cidade',
'' 'Região',
'' 'Gerente',
A.AGENTE 'Representante',
'' 'Canal de vendas',
'' 'Segmento de vendas',
C.GRIFFE 'Marca',
C.LINHA 'Linha de produto',
C.GRUPO 'Grupo de produto',
C.SUBGRUPO 'Subgrupo de produto',
A.referencia 'Código do produto',
A.NOME_CLIFOR 'Cliente',
'' 'Complementar',
DAY(A.EMISSAO) 'Dia',
MONTH(A.EMISSAO) 'Mês',
YEAR(A.EMISSAO) 'Ano',
A.VALOR_ITEM 'Valor total',
A.VALOR_ITEM 'Rentabilidade total',
A.QTDE_ITEM 'Quantidade',
0 'Quilos',
0 'Litros',
0 'Metros',
LEFT(B.CGC_CPF, 9) 'CNPJ Inicial',
RIGHT(LEFT(B.CGC_CPF, 13), 4) 'CNPJ Final',
LEFT(RTRIM(B.ENDERECO), 150) + ', ' + LEFT(RTRIM(B.NUMERO), 30) 'Endereço',
LEFT(RTRIM(B.CEP), 9) 'CEP',
LEFT(RTRIM(B.DDD1) + RTRIM(B.TELEFONE1), 100) 'Telefone',
LEFT(RTRIM(B.EMAIL), 100) 'Email',
'' 'OBS'
FROM FATURAMENTO A
INNER JOIN CADASTRO_CLI_FOR B ON A.CLIFOR = B.CLIFOR
INNER JOIN PRODUTO C ON A.referencia = C.PRODUTO
WHERE a.qtde_item <> 0
ORDER BY
A.EMISSAO, A.NF_SAIDA