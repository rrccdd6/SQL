
 -- select busca o codigo de carteira, o id do emissor e o id da conta 
 -- fazendo um join da tabela de titulos publicos com a de operações com os mesmos titulos 
 -- ligando tudo por id.

SELECT A.CDTIT, A.IDEMI, A.IDCTA
  FROM INV_OPE_PUBPRIV A
  JOIN INV_TIT_PUBPRIV B
  ON A.IDPUBPVO = B.IDPUBPVO
  
  
