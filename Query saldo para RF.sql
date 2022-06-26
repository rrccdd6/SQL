
-- confere na carteira e no ativo de RF escolhido se há saldo para a data 

SELECT A.IDOPEPUBPVO, A.DTOPE, B.DCPUBPVO, B.DTVCT, A.VROPE, A.VRNOMATU
  FROM INV_OPE_PUBPRIV A, INV_TIT_PUBPRIV B, INV_CRG_OPE_TIT_PUBPRIV C
 WHERE A.IDPUBPVO = B.IDPUBPVO
   AND A.IDOPEPUBPVO = C.IDOPEPUBPVO
   AND A.IDCTI = 1
   AND B.DCPUBPVO = 'NTN-B'
   AND EXISTS (SELECT 1
                 FROM INV_SALDO_DIA S
                WHERE S.DTREF = '30/11/2021'
                  AND S.IDOPE = 3
                  AND S.IDOPEATV = A.IDOPEPUBPVO)
