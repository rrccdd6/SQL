--Essa query verifica se existe saldo no fundo e data em questao. 
------------------------------------------------------------------------------------------------------




SELECT COUNT(*)                                              -- Faz uma contagem 
  FROM INV_COTFUNDO C, INV_SEGMENTO D, INV_FUNIVE E          -- Dentro de cotfundo seguimento e funinve 
 WHERE C.DTINI = '03/02/2022'                                -- Com a data inicial que definimos 
   AND C.IDFUNIVE = E.IDFUNIVE                               -- Onde o idfunive seja igual na funive e na cotfundo
   AND E.IDSGT = D.IDSGT                                     -- O seguimento seja o mesmo 
   AND C.IDFUNIVE = 2314                                     -- Informo qual fundo quero conferir 
   AND (EXISTS (SELECT 1                                     -- E que esse select exista tambem 
                 FROM INV_SALDO_DIA S, INV_OPE_QUOFUN O      -- Na tabela de saldo e de operações de fundos
                WHERE S.IDOPEATV = O.IDOPEQUOFUN             -- Saldo em RF ou Segmentos diferentes de RV
                  AND O.IDFUNIVE = C.IDFUNIVE                -- O funive seja o mesmo do fundo la de fora
                  AND S.DTREF = C.DTINI                      -- As datas seja a mesma da data de fora 
  --                       AND S.IDOPEATV = C.IDFUNIVE
                  AND D.IDSGT <> 2) OR                       -- E que o seja diferente de renda variável (renda fixa no caso) OU entao
       EXISTS (SELECT 1                                      -- Que exista só na tabela de saldo 
                 FROM INV_SALDO_DIA S                        
                WHERE S.IDATVCTI = C.IDFUNIVE                -- O id do ativo de carteira é igual ao id do fundo
                  AND S.DTREF = C.DTINI                      -- A data seja a mesma da data de fora 
                   AND D.IDSGT = 2 /*igual RV*/));           -- E o id de seguimento seja 2 rendavariável 
