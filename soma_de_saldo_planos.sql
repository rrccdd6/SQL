SELECT L.IDLSTCTI, L.NMLST, L.CDLST, SUM(S.VRSDOMOE)
 FROM INV_LISTACTI L, INV_LSTCTIDET D , INV_CARTEIRAS C, PAR_PLANOS P, INV_SALDO_DIA S
 WHERE L.IDLSTCTI = D.IDLSTCTI
   AND C.IDPLA = P.IDPLA
   AND S.DTREF = '03/03/2022'
   GROUP BY L.IDLSTCTI, L.NMLST, L.CDLST;
   
   
   AND S.VRSDOMOE IN ( SELECT SUM(VRSDOMOE)
                         FROM INV_SALDO_DIA S
                        WHERE S.DTREF = '03/03/2022'
                          AND L.IDLSTCTI = 1); 
--------------------------------------------------------------------------------------------------------------   
SELECT * FROM INV_SALDO_DIA   
----------------------------------------------------------------------------------------------------------------   
SELECT * 
  FROM INV_LSTCTIDET A 
 WHERE A.IDLSTCTI = 11
 AND (SELECT 1 
             FROM INV_SALDO_DIA B
             WHERE 
-----------------------------------------------------------------------------------------------------------------

 SELECT SUM(VRSDOMOE)
              FROM INV_SALDO_DIA
             WHERE DTREF = '29/10/2021'
               AND IDCTI = 141      
   
   
   
