  SELECT *
  FROM INV_SEGMENTO A, INV_FUNIVE B
 WHERE A.IDSGT = B.IDSGT
   AND (EXISTS (SELECT 1
                 FROM INV_SALDO_DIA S, INV_OPE_QUOFUN O
                WHERE S.IDOPEATV = O.IDOPEQUOFUN
                  AND O.IDFUNIVE = B.IDFUNIVE
                  AND S.DTREF = '03/03/2022'
  --                       AND S.IDOPEATV = C.IDFUNIVE
                  AND A.IDSGT <> 2) OR
               EXISTS (SELECT 1
                 FROM INV_SALDO_DIA S
                WHERE S.IDATVCTI = B.IDFUNIVE
                  AND S.DTREF = '03/03/2022'
                   AND A.IDSGT = 2 /*igual RV*/)
    AND NOT EXISTS (SELECT 1
                      FROM INV_FUNIVE_VIGCLS D
                     WHERE D.IDFUNIVE = B.IDFUNIVE));
