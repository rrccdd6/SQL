-- id de opera��o de cotas de fundo, data de opera��o, data de liquida��o da opera��o, id do fundo de investimento, nome do emissor, id de carteira e o nome da carteira, valor da opera�ao
-- onde a data de oepra��o esteja entre a data desejada e o nome da carteira tamb�m 

-- resumindo esse select confere pelo nome de carteira os fundos que tem nela. 

SELECT B.IDOPEQUOFUN, C.DTOPE, B.DTLIQOPE, A.IDFUNIVE, A.NMEMI, C.IDCTI, D.NMCTI, B.VROPE
  FROM inv_funive A INNER JOIN inv_ope_quofun B    ON A.IDFUNIVE = B.IDFUNIVE
                    INNER JOIN inv_ope_ctiquofun C ON B.IDOPECTIQUOFUN = C.IDOPECTIQUOFUN
                    INNER JOIN INV_CARTEIRAS D     ON C.IDCTI = D.IDCTI
                    WHERE C.DTOPE BETWEEN '29/10/2021' AND '27/12/2021'
                    AND D.NMCTI = 'PGA INVESTIMENTO NO EXTERIOR';
