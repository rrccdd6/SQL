-- CARTEIRA PGA INVESTIMENTO NO EXTERIOR ERRO ACHADO NO DIA 22/11/2021 
-- OPERAÇÃO DE 55 MIL DO FUNDO ACESS USA COMPANIES 
-- DIFERENÇA DE PATRIMONIO O PATRIMONIO NA MESTRA ESTA MENOR

SELECT B.IDOPEQUOFUN, C.DTOPE, B.DTLIQOPE, A.IDFUNIVE, A.NMEMI, C.IDCTI, D.NMCTI, B.VROPE
  FROM inv_funive A INNER JOIN inv_ope_quofun B    ON A.IDFUNIVE = B.IDFUNIVE
                    INNER JOIN inv_ope_ctiquofun C ON B.IDOPECTIQUOFUN = C.IDOPECTIQUOFUN
                    INNER JOIN INV_CARTEIRAS D     ON C.IDCTI = D.IDCTI
                    WHERE C.DTOPE BETWEEN '29/10/2021' AND '27/12/2021'
                    AND D.NMCTI = 'PGA INVESTIMENTO NO EXTERIOR';
                    
---------------------------------------------------------------------------------------------------------

-- CARTEIRA PRV INVESTIMENTO NO EXTERIOR ERRO ACHADO NO DIA 22/11/2021
-- OPERAÇÃO DE 1.400.000 DO FUNDO ACESS USA ACOMPANIES 
-- DIFERENÇÃ NO PATRIMONIO O PATRIMONIO NA MESTRA ESTA MENOR

SELECT B.IDOPEQUOFUN, C.DTOPE, B.DTLIQOPE, A.IDFUNIVE, A.NMEMI, C.IDCTI, D.NMCTI, B.VROPE
  FROM inv_funive A INNER JOIN inv_ope_quofun B    ON A.IDFUNIVE = B.IDFUNIVE
                    INNER JOIN inv_ope_ctiquofun C ON B.IDOPECTIQUOFUN = C.IDOPECTIQUOFUN
                    INNER JOIN INV_CARTEIRAS D     ON C.IDCTI = D.IDCTI
                    WHERE C.DTOPE BETWEEN '29/10/2021' AND '27/12/2021'
                    AND D.NMCTI = 'PRV INVESTIMENTO NO EXTERIOR';
                    
                    
----------------------------------------------------------------------------------------------------------
-- CARTEIRA CV INVESTIMENTOS NO EXTERIOR ERRO NA OPERAÇÃO DO DIA 22/11/2021  
-- OPERAÇÃO DO DIA 22/11/2021 
-- FUNDO ACESS USA COMPANIES 
-- NOSSO RELATORIO APRESENTA UM PATRIMONIO MAIOR QUE O DA INTECH

SELECT B.IDOPEQUOFUN, C.DTOPE, B.DTLIQOPE, A.IDFUNIVE, A.NMEMI, C.IDCTI, D.NMCTI, B.VROPE
  FROM inv_funive A INNER JOIN inv_ope_quofun B    ON A.IDFUNIVE = B.IDFUNIVE
                    INNER JOIN inv_ope_ctiquofun C ON B.IDOPECTIQUOFUN = C.IDOPECTIQUOFUN
                    INNER JOIN INV_CARTEIRAS D     ON C.IDCTI = D.IDCTI
                    WHERE C.DTOPE BETWEEN '29/10/2021' AND '12/11/2021'
                    AND D.NMCTI LIKE 'CV INVESTIMENTO NO EXTERIOR';
                    
 
                    
----------------------------------------------------------------------------------------------------------- 
--  CARTEIRA RENDA FIXA PGA OU PREVDATA ADM 
-- OPERAÇÃO DO DIA 12/11 E 16/11 
-- NO NOSSO RELATORIO A OPERAÇÃO DO DIA 12/11 SÓ CONSTA EM 16/11
-- FUNDO AZ QUEST LUCE FIC RENDA FIXA 

SELECT B.IDOPEQUOFUN, C.DTOPE, B.DTLIQOPE, A.IDFUNIVE, A.NMEMI, C.IDCTI, D.NMCTI, B.VROPE
  FROM inv_funive A INNER JOIN inv_ope_quofun B    ON A.IDFUNIVE = B.IDFUNIVE
                    INNER JOIN inv_ope_ctiquofun C ON B.IDOPECTIQUOFUN = C.IDOPECTIQUOFUN
                    INNER JOIN INV_CARTEIRAS D     ON C.IDCTI = D.IDCTI
                    WHERE C.DTOPE BETWEEN '29/10/2021' AND '31/12/2021'
                    AND D.NMCTI LIKE '%PREVDATA%';  
                    
                    
------------------------------------------------------------------------------------------------------------
-- CARTEIRA EMPRESTIMOS CV 
-- SEM CARGA 

SELECT B.IDOPEQUOFUN, C.DTOPE, B.DTLIQOPE, A.IDFUNIVE, A.NMEMI, C.IDCTI, D.NMCTI, B.VROPE
  FROM inv_funive A INNER JOIN inv_ope_quofun B    ON A.IDFUNIVE = B.IDFUNIVE
                    INNER JOIN inv_ope_ctiquofun C ON B.IDOPECTIQUOFUN = C.IDOPECTIQUOFUN
                    INNER JOIN INV_CARTEIRAS D     ON C.IDCTI = D.IDCTI
                    WHERE C.DTOPE BETWEEN '29/10/2021' AND '31/12/2021'
                    AND C.IDCTI = 83;
                    
------------------------------------------------------------------------------------------------------------
-- CARTEIRA EMPRESTIMOS BD 
-- SEM CARGA 

SELECT B.IDOPEQUOFUN, C.DTOPE, B.DTLIQOPE, A.IDFUNIVE, A.NMEMI, C.IDCTI, D.NMCTI, B.VROPE
  FROM inv_funive A INNER JOIN inv_ope_quofun B    ON A.IDFUNIVE = B.IDFUNIVE
                    INNER JOIN inv_ope_ctiquofun C ON B.IDOPECTIQUOFUN = C.IDOPECTIQUOFUN
                    INNER JOIN INV_CARTEIRAS D     ON C.IDCTI = D.IDCTI
                    WHERE C.DTOPE BETWEEN '29/10/2021' AND '31/12/2021'
                    AND C.IDCTI = 82;

------------------------------------------------------------------------------------------------------------
-- CARTEIRA IMOVEIS BD 
-- SEM CARGA 

SELECT B.IDOPEQUOFUN, C.DTOPE, B.DTLIQOPE, A.IDFUNIVE, A.NMEMI, C.IDCTI, D.NMCTI, B.VROPE
  FROM inv_funive A INNER JOIN inv_ope_quofun B    ON A.IDFUNIVE = B.IDFUNIVE
                    INNER JOIN inv_ope_ctiquofun C ON B.IDOPECTIQUOFUN = C.IDOPECTIQUOFUN
                    INNER JOIN INV_CARTEIRAS D     ON C.IDCTI = D.IDCTI
                    WHERE C.DTOPE BETWEEN '29/10/2021' AND '31/12/2021'
                    AND C.IDCTI = 101;

------------------------------------------------------------------------------------------------------------

                    
                               
