SELECT SUM(A.VRPTMLIQFCH), SUM(A.VRAPT), SUM(A.VRAPTCOT), SUM(A.VRRSG), SUM(A.VRRSGCOT)
  --INTO vVRSDO, vVRAPT, vVRAPTCOT, vVRRSG, vVRRSGCOT  
SELECT *  
  FROM INV_HIS_AZODIA_CTI A
 WHERE DTAZO = '03/11/2021'
   AND IDCTI IN (SELECT IDCTI FROM INV_LSTCTIDET WHERE IDLSTCTI = 11);
  
-- EXECUTANDO ESTA BUSCA NO ORACLE EU VEJO QUE FOI HOUVE UM RESGATE DE 16K NO DIA 03/11 E NO NOSSO RELATORIO NAO CONSTA COMO RESGATE.
-- CARTEIRA EMPRESTIMO BD 



SELECT L.IDLSTCTI, L.CDLST, COUNT(DISTINCT D.IDCTI) AS QTCTILST, COUNT(DISTINCT S.IDCTI) AS QTCTIFCH
          FROM INV_LISTACTI L, INV_LSTCTIDET D
               LEFT OUTER JOIN INV_HIS_AZODIA_CTI S ON S.IDCTI = D.IDCTI AND S.DTAZO = '01/10/2021'
         WHERE L.IDLSTCTI = D.IDLSTCTI
           AND (L.DTFIMVIG >= '01/10/2021' OR DTFIMVIG IS NULL)
         GROUP BY L.IDLSTCTI, L.CDLST) TAB
 WHERE TAB.QTCTILST = TAB.QTCTIFCH --=== S� fechar a Lista, quando tivermos todas as Carteiras fechadas
   AND NOT EXISTS (SELECT 1
                     FROM INV_HIS_AZODIA_CTI S
                    WHERE S.DTAZO = '01/10/2021'
                      AND S.IDLSTCTI = TAB.IDLSTCTI
                      
                      
                      
                      
SELECT SUM(VRPTMLIQFCH), SUM(VRAPT), SUM(VRAPTCOT), SUM(VRRSG), SUM(VRRSGCOT)
          --INTO vVRSDO, vVRAPT, vVRAPTCOT, vVRRSG, vVRRSGCOT
          FROM INV_HIS_AZODIA_CTI
         WHERE DTAZO = '01/10/2021'
           AND IDCTI IN (SELECT IDCTI FROM INV_LSTCTIDET WHERE IDLSTCTI = 11)
                      
                      
                      
                      
