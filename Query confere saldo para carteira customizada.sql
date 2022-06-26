SELECT SUM(VRSDOMOE)
  FROM INV_SALDO_DIA S
 WHERE S.DTREF = TO_DATE('31/12/2021','DD/MM/YYYY')
   AND S.IDCTI IN (SELECT IDCTI FROM INV_RENCMZ_CTI WHERE IDRENCMZ = 1)
   AND EXISTS (SELECT 1          
                 FROM INV_OPE_PUBPRIV B, INV_TIT_PUBPRIV P, INV_RENCMZ_CLSATV C         
                WHERE S.IDOPE    = 3           
                  AND S.IDOPEATV = B.IDOPEPUBPVO           
                  AND B.IDPUBPVO = P.IDPUBPVO           
                  AND P.DCPUBPVO = C.TPATV           
                  AND C.IDRENCMZ = 1         
               UNION         
               SELECT 1           
                 FROM INV_OPE_QUOFUN Q, INV_FUNIVE F, INV_FUNIVE_VIGTIP T, INV_RENCMZ_CLSATV C          
                WHERE S.IDOPE       = 2            
                AND S.IDOPEATV    = Q.IDOPEQUOFUN            
                AND Q.IDFUNIVE    = F.IDFUNIVE            
                AND F.IDSGT      <> 2            
                AND F.IDFUNIVE    = T.IDFUNIVE            
                AND T.DTVIGTIPFUN = (SELECT MAX(DTVIGTIPFUN)                                   
                                       FROM INV_FUNIVE_VIGTIP                                  
                                      WHERE IDFUNIVE     = Q.IDFUNIVE                                  
                                       AND DTVIGTIPFUN <= TO_DATE('31/12/2021','DD/MM/YYYY')           
                                       AND T.TIPATV      = C.TPATV            
                                       AND C.IDRENCMZ = 1)         
               UNION          
               SELECT 1           
                 FROM INV_FUNIVE F, INV_FUNIVE_VIGTIP T, INV_RENCMZ_CLSATV C         
                WHERE S.IDOPE       = 2            
                AND S.IDATVCTI    = F.IDFUNIVE            
                AND F.IDSGT       = 2            
                AND F.IDFUNIVE    = T.IDFUNIVE            
                AND T.DTVIGTIPFUN = (SELECT MAX(DTVIGTIPFUN)                                   
                                       FROM INV_FUNIVE_VIGTIP                                 
                                      WHERE IDFUNIVE     = F.IDFUNIVE                                    
                                        AND DTVIGTIPFUN <= TO_DATE('31/12/2021','DD/MM/YYYY')           
                                        AND T.TIPATV      = C.TPATV             
                                        AND C.IDRENCMZ = 1));
