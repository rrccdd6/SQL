-- Update de valores de operação conferindo pelo id
-- importação de títulos da custódia

UPDATE INV_OPE_PUBPRIV
   SET VROPE = 146777.92
 WHERE IDOPEPUBPVO = 2583


UPDATE INV_OPE_PUBPRIV
   SET VROPE = 196020.17
 WHERE IDOPEPUBPVO = 2218 


UPDATE INV_OPE_PUBPRIV
   SET VROPE = 3205577.94
 WHERE IDOPEPUBPVO = 2584
 
---------------------------------------------------------------------------------------------| 

-- Update de valores de operação alterando o valor de operação atual por uma soma de valor normal + juros acumulado + corretagem acumulada + valor do agil
-- conferindo com a data e o id de carteira 

UPDATE INV_OPE_PUBPRIV A
   SET A.VROPE = (A.VRNOMATU + A.VRJURACU + A.VRCORACU + A.VRDAG)
 WHERE A.IDCTI = 7
   AND EXISTS (SELECT 1
                 FROM INV_SALDO_DIA S
                WHERE S.DTREF = '30/11/2021'
                  AND S.IDOPE = 3
                  AND S.IDOPEATV = A.IDOPEPUBPVO);
                  
----------------------------------------------------------------------------------------------|                 

-- Update de campo de valor normal atualizado para valor de operação 
-- conferindo se há saldo na data especifica. 

UPDATE INV_OPE_PUBPRIV A
   SET A.VRNOMATU = A.VROPE
 WHERE A.IDCTI = 7
   AND EXISTS (SELECT 1
                 FROM INV_SALDO_DIA S
                WHERE S.DTREF = '30/11/2021'
                  AND S.IDOPE = 3
                  AND S.IDOPEATV = A.IDOPEPUBPVO)
   AND A.VRNOMATU = 0;
-----------------------------------------------------------------------------------------------|
