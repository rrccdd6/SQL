USE [faeces_producao]
GO
/****** Object:  StoredProcedure [dbo].[PR_INV_APURNDFUN] Script Date: 
12/05/2022 15:40:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE  [dbo].[PR_INV_APURNDFUN]
     @PCDUSU            VARCHAR(35),
     @PIDLST            INT,
     @PIDCTI         INT,
     @PDTMESREF        CHAR(6),
     @PRSDCERR        VARCHAR(255)  OUT

AS
BEGIN

     DECLARE @SERRO          VARCHAR(255)
     DECLARE @VDTPRIDIA      DATETIME
     DECLARE @VDTULTDIA      DATETIME
     DECLARE @VDTPRIRSG      DATETIME
     DECLARE @VDTOPE         DATETIME
     DECLARE @VIDFUNIVE      INT
     DECLARE @vIDOPERSGQUO   INT
     DECLARE @VNMEMI         VARCHAR(100)
     DECLARE @VVRAPLPOSANT   DECIMAL(15,2)
     DECLARE @VVRRNDMESANT   DECIMAL(15,2)
     DECLARE @VVRRNDANOANT   DECIMAL(15,2)
     DECLARE @VPRRNDANOANT   DECIMAL(10,6)
     DECLARE @VVRCTT         DECIMAL(19,10)
     DECLARE @VVRQUO         DECIMAL(19,10)
     DECLARE @VVRCTTANT      DECIMAL(19,10)
     DECLARE @VVRQUODIAANT   DECIMAL(19,10)
     DECLARE @VVRQUOANT      DECIMAL(19,10)
     DECLARE @PRVARQUODIA    DECIMAL(19,10)
     DECLARE @VQTQUO         DECIMAL(21,9)
     DECLARE @VQTQUOOPE      DECIMAL(21,9)
     DECLARE @VQTQUORSG      DECIMAL(21,9)
     DECLARE @VVROPCFDO      DECIMAL(15,2)

     DECLARE @VDTSDOANT      DATETIME
     DECLARE @VDTAUXANT      DATETIME
     DECLARE @VDTAPL         DATETIME
     DECLARE @VDTULTPOSMES   DATETIME

     DECLARE @VVRRSGMES      DECIMAL(15,2)
     DECLARE @VVRAPLMES      DECIMAL(15,2)
     DECLARE @VVRAPLPOSATU   DECIMAL(15,2)
     DECLARE @VVRAPLDIAANT   DECIMAL(15,2)
     DECLARE @VVRRNDMES      DECIMAL(15,2)
     DECLARE @VPRRNDMES      DECIMAL(10,6)
     DECLARE @VVRRNDANO      DECIMAL(15,2)
     DECLARE @VPRRNDANO      DECIMAL(10,6)


     DECLARE @VDTANTRSG        DATETIME
     DECLARE @NCOUNT            INT
     DECLARE @vIDOPEQUOFUN    INT
     DECLARE @VFLIDNRSGTOT   CHAR(1)

     DECLARE @C_FUNDOS        CURSOR
     DECLARE @C_DIAS_UTEIS   CURSOR


-----------------------  DAQUI PARA BAIXO ELE FORMATA A DATA INSERIDA PELO USUÁRIO --------------------------------------


     SET @SERRO = ''

     SET @VDTPRIDIA = SUBSTRING(@PDTMESREF,1,4) + SUBSTRING(@PDTMESREF,5,2) + '01'

     SET @VDTULTDIA = @VDTPRIDIA

     SET @VDTULTDIA = DATEADD(MONTH,1,@VDTULTDIA)

     SET @VDTULTDIA = DATEADD(DAY,-1,@VDTULTDIA)

     WHILE dbo.FN_INV_VALIDA_DIA_UTIL(@VDTULTDIA) = 0 -- enquanto não for dia útil
     BEGIN
         SET @VDTULTDIA = DATEADD(DAY,-1,@VDTULTDIA)
     END

     PRINT @VDTPRIDIA     -- data do primeiro dia 
     PRINT @VDTULTDIA     -- data do ultimo dia


     -----------------------  FIM DA FORMATAÇÃO DE DATA -------------------------------------


     -----------------------  AQUI ELE VALIDA A DATA PARA DIA ÚTIL -------------------------------------



     --========= Apurar do último dia do mês anterior ============
     
     SET @VDTSDOANT = dbo.FN_INV_PROXIMO_DIA_UTIL(@VDTPRIDIA, -1)

     PRINT @VDTSDOANT   -- data de saldo anterior 


     -----------------------  FIM CONFERENCIA DE DIA UTIL -------------------------------------


     -----------------------  CURSOR 1 -------------------------------------


     SET @C_FUNDOS = CURSOR FOR
      SELECT A.IDFUNIVE, A.IDOPEQUOFUN, A.NMEMI, A.DTOPE, A.VRAPLPOS, A.VRRNDMES, A.VRRNDANO, A.PRRNDANO
       FROM
         (SELECT F.IDFUNIVE, NULL AS IDOPEQUOFUN, C.NMEMI, dbo.FN_INV_MINAPLFDO(F.IDCTI, F.IDFUNIVE) AS DTOPE, SUM(F.VRAPLPOS) AS VRAPLPOS, SUM(F.VRRNDMES) AS VRRNDMES, SUM(F.VRRNDANO) AS VRRNDANO, SUM(F.PRRNDANO) AS PRRNDANO
            FROM INV_POSFUN_FCH F, INV_FUNIVE C
           WHERE F.IDFUNIVE = C.IDFUNIVE
             AND F.DTPOS = @VDTSDOANT       --data de saldo anterior 
             AND F.IDCTI = @PIDCTI          -- id de carteira
             --AND F.IDOPEQUOFUN IS NULL
             --AND C.IDFUNIVE = 27   ---------- TESTE
             AND NOT EXISTS (SELECT 1
                               FROM INV_OPE_CTIQUOFUN O, INV_OPE_QUOFUN T
                              WHERE O.IDOPECTIQUOFUN = T.IDOPECTIQUOFUN
                                AND T.IDFUNIVE = C.IDFUNIVE
                                AND O.DTOPE >= @VDTPRIDIA
                                AND O.DTOPE <= @VDTULTDIA
                                AND O.IDCTI = @PIDCTI
                                AND T.TPOPE = 'R'
                                AND T.TPRSG = 'T')
              GROUP BY F.IDFUNIVE, C.NMEMI, dbo.FN_INV_MINAPLFDO(F.IDCTI, F.IDFUNIVE)
           --UNION
          -- SELECT V.IDFUNIVE, NULL AS IDOPEQUOFUN, V.NMEMI, dbo.FN_INV_MINAPLFDO(F.IDCTI, F.IDFUNIVE) AS DTOPE, SUM(F.VRAPLPOS) AS VRAPLPOS, SUM(F.VRRNDMES) AS VRRNDMES, SUM(F.VRRNDANO) AS VRRNDANO, SUM(F.PRRNDANO) AS PRRNDANO
          --  FROM INV_POSFUN_FCH F, INV_OPE_CTIQUOFUN O, INV_OPE_QUOFUN T, INV_FUNIVE V
          -- WHERE F.IDOPEQUOFUN = T.IDOPEQUOFUN
          --   AND O.IDOPECTIQUOFUN = T.IDOPECTIQUOFUN
             --AND T.IDFUNIVE = V.IDFUNIVE
             --AND F.IDOPEQUOFUN IS NOT NULL
             --AND F.DTPOS = @VDTSDOANT
             --AND O.IDCTI = @PIDCTI
             ----AND V.IDFUNIVE = 27   ---------- TESTE
          -- GROUP BY V.IDFUNIVE, V.NMEMI, dbo.FN_INV_MINAPLFDO(F.IDCTI, F.IDFUNIVE)
           UNION
          SELECT V.IDFUNIVE, T.IDOPEQUOFUN, V.NMEMI, O.DTOPE, T.VROPE, 0.00, 0.00, 0.00
            FROM INV_OPE_CTIQUOFUN O, INV_OPE_QUOFUN T, INV_FUNIVE V
           WHERE O.IDOPECTIQUOFUN = T.IDOPECTIQUOFUN
             AND T.IDFUNIVE = V.IDFUNIVE
             AND O.DTOPE >= @VDTPRIDIA
             AND O.DTOPE <= @VDTULTDIA
             AND T.TPOPE = 'A'
             --AND T.IDFUNIVE = 27   ---------- TESTE
             AND O.IDCTI = @PIDCTI) A
      ORDER BY A.IDFUNIVE, A.NMEMI



-----------------------  FIM DO CURSOR -------------------------------------



      OPEN @C_FUNDOS
         FETCH NEXT FROM @C_FUNDOS INTO @VIDFUNIVE, @VIDOPEQUOFUN, @VNMEMI, @VDTOPE, @VVRAPLPOSANT, @VVRRNDMESANT, @VVRRNDANOANT, @VPRRNDANOANT

         WHILE (@@FETCH_STATUS = 0)
         BEGIN

------------------------- AQUI SETA AS DATAS ------------------------------------------

             SET @VDTULTPOSMES = @VDTULTDIA      -- TRANSFORMA A DATA DA ULTIMA POSIÇÃO DO MES >>>> DATA DO ULTIMO DIA
             SET @VDTAPL= @VDTOPE                -- TRANSFORMA A DATA DA APLICAÇÃO >>>>> DATA DA OPERAÇÃO
             SET @VVROPCFDO = 0                  -- VALOR DE OPÇÃO DO FUNDO EM 0 
             SET @VFLIDNRSGTOT = ''              -- FLAG DE IDENTIFICAÇÃO DO RESGATE TOTAL  >>>> ''

-------------- SOMA TODOS OS VALORES DE RESGATES DO MES E QUANTIDADE DE COTAS RESGATADAS -------------------------------------


             SELECT @VVRRSGMES = SUM(T.VROPE), @VQTQUORSG = SUM(T.QTQUOOPE)
                 FROM INV_OPE_CTIQUOFUN O, INV_OPE_QUOFUN T
                 WHERE O.IDOPECTIQUOFUN = T.IDOPECTIQUOFUN
                 AND T.IDFUNIVE = @VIDFUNIVE
                 AND O.DTOPE >= @VDTPRIDIA
                 AND O.DTOPE <= @VDTULTDIA
                 AND O.IDCTI = @PIDCTI
                 AND T.TPOPE = 'R'

-------------- SOMA TODOS OS VALORES DE APORTES DO MES -------------------------------------


             SELECT @VVRAPLMES = SUM(T.VROPE)
                 FROM INV_OPE_CTIQUOFUN O, INV_OPE_QUOFUN T
                 WHERE O.IDOPECTIQUOFUN = T.IDOPECTIQUOFUN
                 AND T.IDFUNIVE = @VIDFUNIVE
                 AND O.DTOPE >= @VDTPRIDIA
                 AND O.DTOPE <= @VDTULTDIA
                 AND O.IDCTI = @PIDCTI
                 AND T.TPOPE = 'A'

             IF @VVRAPLMES IS NULL     --- CASO O VALOR DE APORTE NO MES SEJA NULO ELE DEFINE COMO 0
                 SET @VVRAPLMES = 0

             IF @VVRRSGMES IS NULL     --- CASO O VALOR DE RESGATE NO MES SEJA NULO ELE DEFINE COMO 0
             BEGIN
                 SET @VVRRSGMES = 0
             END
             ELSE
             BEGIN                     -- CASO TENHA APORTE OU RESGATE ELE ATRIBUI A DATA DA ULTIMA POSIÇÃO DO MES >>>> A MAIOR DATA DE POSIÇÃO
                 SELECT @VDTULTPOSMES = MAX(A.DTPOS)
                    FROM INV_CTL_ARQPOSCTD A, INV_POSFUN_CTD B, INV_FUNIVE C
                  WHERE A.IDCTLARQPOSCTD = B.IDCTLARQPOSCTD
                    AND B.NRCNP = C.NRCNP
                    AND C.IDFUNIVE = @VIDFUNIVE
                    AND A.IDCTI = @PIDCTI
                    AND DTPOS   <= @VDTULTDIA

------------------------===== Verifica se houve resgate total

                 IF @VDTULTPOSMES < @VDTULTDIA
                     SET @VFLIDNRSGTOT = 'S' -- CASO HAJA RESGATE TOTAL ELE MUDA A FLAG PARA 'S'

             END

------------------------====== Se não foi identificado resgate total no mês anterior
             IF @VVRAPLPOSANT <> 0
             BEGIN               -- CASO NAO TENHA RESGATE TOTAL ELE PRINTA O FUNDO E O IDOPEQUOFUN
                 PRINT 'FUNDO: '
                 print @VIDFUNIVE
                 PRINT 'OPERACAO: '
                 PRINT @VIDOPEQUOFUN



                 -- Só gravar se Total do Resgate no mês, for inferior ao saldo no mês anterior e não for uma nova aplicação ou se trata de uma nova aplicação
                 IF (((@VVRRSGMES < @VVRAPLPOSANT) and (@VIDOPEQUOFUN IS NULL)) OR (@VIDOPEQUOFUN IS NOT NULL))
                 BEGIN

                     --IF @VDTOPE IS NULL
                         --SET @VDTOPE = '1900-01-01'

----------------------========= AQUI ELE DEFINE O VALOR DE CONTRATO ----------------------------------------

                     SET @VVRCTT = dbo.FN_INV_TRAZVLRCOTFUNCTI(@VIDFUNIVE, @VDTSDOANT, @PIDCTI)

                     ----========= Apurar o PL no último dia do mês anterior ============

------------------------ CASO HAJA UM ID DE OPERAÇÃO PARA O FUNDO ----------------------------------------
                     
                     IF @VIDOPEQUOFUN IS NOT NULL
                     BEGIN              
------------------------------ ELE RECUPERA A QUANTIDADE DE COTAS ----------------------------------------

                         SELECT @VQTQUO = T.QTQUOOPE
                           FROM INV_OPE_CTIQUOFUN O, INV_OPE_QUOFUN T
                          WHERE O.IDOPECTIQUOFUN = T.IDOPECTIQUOFUN
                            AND T.IDOPEQUOFUN = @VIDOPEQUOFUN

----------------------========= AQUI ELE REDEFINE O VALOR DE CONTRATO ----------------------------------------

                          SET @VVRCTT = dbo.FN_INV_TRAZVLRCOTFUNCTI(@VIDFUNIVE, @VDTOPE , @PIDCTI)

                     END
                     ELSE   -- CASO CONTRARIO (O IDOPEQUOFUN SEJA NULO)

                     BEGIN

                            -- ELE SETA A QUANTIDADE DE QUOTAS PARA A FUNÇÃO 

                         SET @VQTQUO = dbo.FN_INV_TRAZQTDCOTFUNCTI(@VIDFUNIVE, @VDTSDOANT, @PIDCTI)


                         SELECT @VVROPCFDO = ROUND(B.VRCOTFCH,2) -- ELE SELECIONA O VALOR DE OPÇÃO COMO O VALOR DE COTA DE FECHAENTO ARREDONDADO POR 2
                          FROM INV_OPCOES A, INV_PRECO_UNIT B, INV_FUNIVE C 
                         WHERE A.IDOPC = B.IDOPC -- ID DA OPÇÃO 
                           AND A.IDATVOBJ = C.IDFUNIVE  -- E O ID DE ATIVO DE OBJETO SEJA(E) IGUAL A IDFUNIVE
                           AND A.IDCTI = @PIDCTI
                           AND A.IDATVOBJ = @VIDFUNIVE  --  E  O ID DE ATIVO DE OBJETO SEJA IGUAL  AO IDFUNIVE QUE O USUARIO INSERIU
                             AND B.DTCOT = @VDTSDOANT   -- E A DATA DE COTAÇÃO SEJA A DATA DE SALDO ANTERIOR 

                        -- CASO O VALOR DE OPÇÃO SEJA NULO 

                         IF @VVROPCFDO is null
                             SET @VVROPCFDO = 0

                        -- ELE FAZ UMA CONFERENCIA SE HÁ MOVIMENTAÇÃO ARQUIVADA 

                         SELECT @NCOUNT = COUNT(*)
                           FROM INV_CTL_ARQPOSCTD A, INV_POSFUN_CTD B, INV_FUNIVE C
                          WHERE A.IDCTLARQPOSCTD = B.IDCTLARQPOSCTD
                            AND B.NRCNP = C.NRCNP
                            AND C.IDFUNIVE = @VIDFUNIVE
                            AND A.IDCTI = @PIDCTI
                            AND DTPOS   = @VDTSDOANT

                        -- CASO ELE ENCONTRE ALGUMA COISA

                         IF @NCOUNT = 1

                        -- ELE ALTERA O VALOR DE APLICA;'ÃO DA POSIÇÃO ANTERIOR EM VALOR DA COTA X VALOR DO CONTRARO ARREDONDADO
                             
                             SET @VVRAPLPOSANT = ROUND(@VQTQUO * @VVRCTT,2)
                         ELSE

                        -- OU ENTAO ELE BUSCA O VALOR DE APLICAÇÃO DA POSIÇÃO ANTERIOR 

                             SELECT @VVRAPLPOSANT = ROUND(SUM((B.QTQUOPOS * VRQUOPOS)),2)
                               FROM INV_CTL_ARQPOSCTD A, INV_POSFUN_CTD B, INV_FUNIVE C
                              WHERE A.IDCTLARQPOSCTD = B.IDCTLARQPOSCTD
                                AND B.NRCNP = C.NRCNP
                                AND C.IDFUNIVE = @VIDFUNIVE
                                AND A.IDCTI = @PIDCTI
                                AND DTPOS   = @VDTSDOANT

                        -- E DEFINE O VALOR DE APLICAÇÃO DA POSIÇÃO ANTERIOR COMO ELA MESMO MAIS O VALOR DE OPÇAO DO FUNDO

                         SET @VVRAPLPOSANT = @VVRAPLPOSANT + @VVROPCFDO

                         --IF @VIDFUNIVE = 42
                         --BEGIN
                             PRINT 'VALOR ANTERIOR:'
                             PRINT @VVRAPLPOSANT
                             PRINT 'OPERACAO:'
                             PRINT @VIDOPEQUOFUN

                         --END

                     END 

                     SET @VVRCTTANT = @VVRCTT  -- AQUI ELE SETA O VALOR DE CONTRATO ANTERIOR PARA O VALOR DE CONTRATO 
                     SET @VVROPCFDO = 0        -- AQUI ELE SETA O VALOR VALOR DE OPEAÇÃO DO FUNDO 


-----------------------========= Apurar o PL no último dia do mês atual ===============---------------------------------------------------------------

                     SET @VVRCTT = dbo.FN_INV_TRAZVLRCOTFUNCTI(@VIDFUNIVE, @VDTULTPOSMES, @PIDCTI)     -- SETA O VALOR DE CONTRATO COM A FUNÇÃO 

                    -- CASO  O VALOR DE RESGATE DO MES SEJA DIFERENTE DE 0 E A FLAG DE RESGATE TOTAL SEJA SIM

                     IF @VVRRSGMES <> 0 AND @VFLIDNRSGTOT = 'S'                                         
                         SET @VQTQUO = dbo.FN_INV_TRAZQTDCOTFUNCTI(@VIDFUNIVE, @VDTULTPOSMES, @PIDCTI)
                     END

                    -- CASO O VALOR DE RESGATE DO MES SEJA 0 E A FLAG NAO SEJA SIM 

                     ELSE
                     BEGIN
                         IF @VIDOPEQUOFUN IS NULL   -- CASO O ID DE OPERAÇÃO DO FUNDO SEJA NULO
                         BEGIN

                    -- SETA A QUANTIDADE DE COTAS PELA FUNÇÃO 

                             SET @VQTQUO = dbo.FN_INV_TRAZQTDCOTFUNCTI(@VIDFUNIVE, @VDTSDOANT, @PIDCTI)
                         END
                     END

                    -- APÓS ELE BUSCA O  VALOR DE OPERAÇÃO DE FUNDO

                     SELECT @VVROPCFDO = ROUND(B.VRCOTFCH,2)
                       FROM INV_OPCOES A, INV_PRECO_UNIT B, INV_FUNIVE C
                      WHERE A.IDOPC = B.IDOPC
                        AND A.IDATVOBJ = C.IDFUNIVE
                        AND A.IDCTI = @PIDCTI
                        AND A.IDATVOBJ = @VIDFUNIVE
                        AND B.DTCOT = @VDTULTPOSMES

                    -- FAZ A CONFERENCIA DE MOVIMENTAÇAO 

                     SELECT @NCOUNT = COUNT(*)
                       FROM INV_CTL_ARQPOSCTD A, INV_POSFUN_CTD B, INV_FUNIVE C
                      WHERE A.IDCTLARQPOSCTD = B.IDCTLARQPOSCTD
                        AND B.NRCNP = C.NRCNP
                        AND C.IDFUNIVE = @VIDFUNIVE
                        AND A.IDCTI = @PIDCTI
                        AND DTPOS   = @VDTULTPOSMES

                    -- CASO HAJA MOVIMENTAÇÃO 

                     IF @NCOUNT = 1
                         SET @VVRAPLPOSATU = ROUND(@VQTQUO * @VVRCTT,2)   -- ELE SETA OVALOR DE POSIÇÃO ATUAL PARA A QUANTIDADE DE COTAS X VALOR DE CONTRATO ARREDONDADO 

                    -- CASO CONTRARIO ELE 

                     ELSE
                         SELECT @VVRAPLPOSATU = ROUND(SUM((B.QTQUOPOS * VRQUOPOS)),2)
                           FROM INV_CTL_ARQPOSCTD A, INV_POSFUN_CTD B, INV_FUNIVE C
                          WHERE A.IDCTLARQPOSCTD = B.IDCTLARQPOSCTD
                            AND B.NRCNP = C.NRCNP
                            AND C.IDFUNIVE = @VIDFUNIVE
                            AND A.IDCTI = @PIDCTI
                            AND DTPOS   = @VDTULTPOSMES

                     IF @VVROPCFDO IS NULL
                         SET @VVROPCFDO = 0


                 PRINT 'FUNDO: '
                 print @VIDFUNIVE


                     --========= Apurar o Rendimento no mês ===============
                     IF @VIDOPEQUOFUN IS NULL AND @VVRRSGMES <> 0 AND (@VFLIDNRSGTOT <> 'S')
                     BEGIN

                         SET @VQTQUO = @VQTQUO - @VQTQUORSG

                         SET @VVRAPLPOSATU = ROUND((@VVRCTT * @VQTQUO),2) + @VVROPCFDO
                         SET @VVRRNDMES = dbo.FN_INV_CLC_RNDPRDFUN(@PIDCTI, @VIDFUNIVE, @VDTPRIDIA, @VDTULTDIA, @VVRAPLPOSANT, @VVRCTTANT)
                         SET @VPRRNDMES = ROUND((@VVRRNDMES/@VVRAPLPOSANT) * 100,3)
                     END
                     ELSE
                     BEGIN
                         SET @VVRAPLPOSATU = @VVRAPLPOSATU + @VVROPCFDO

                         IF @VIDOPEQUOFUN IS NULL
                             SET @VVRRNDMES = @VVRAPLPOSATU - (@VVRAPLPOSANT - @VVRRSGMES)
                         ELSE
                             SET @VVRRNDMES = @VVRAPLPOSATU - (@VVRAPLPOSANT)

                         SET @VPRRNDMES = ROUND((@VVRRNDMES/@VVRAPLPOSANT) * 100,3)
                     END

                     --IF @VIDFUNIVE = 10
                     --BEGIN
                         PRINT 'VALOR ATUAL:'
                         PRINT @NCOUNT
                         PRINT @VDTULTPOSMES
                         PRINT @VQTQUO
                         PRINT @VVRCTT
                         PRINT @VVRAPLPOSATU
                     --END


                     PRINT 'VALOR DO RENDIMENTO NO MÊS  ' + CONVERT(VARCHAR(30), @VVRRNDMES)
                     PRINT 'RESGATE   ' + CONVERT(VARCHAR(30), @VVRRSGMES)
                     PRINT 'VALOR APLICADO MÊS ANTERIOR   ' + CONVERT(VARCHAR(30), @VVRAPLPOSANT)
                     PRINT 'VALOR APLICADO MÊS ATUAL   ' + CONVERT(VARCHAR(30), @VVRAPLPOSATU)


                     IF SUBSTRING(@PDTMESREF,5,2) = '01'
                     BEGIN
                         SET @VVRRNDANO = @VVRRNDMES
                         SET @VPRRNDANO = @VPRRNDMES
                     END
                     ELSE
                     BEGIN
                         SET @VVRRNDANO = @VVRRNDANOANT + @VVRRNDMES
                         SET @VPRRNDANO = ROUND((((((@VPRRNDMES/100) + 1) * ((@VPRRNDANOANT/100) + 1)) - 1) *100),3)
                     END


                 INSERT INTO INV_POSFUN_FCH
                            (IDCTI, IDFUNIVE, IDOPEQUOFUN, DTPOS, DTAPL, VRAPLPOS, VRRNDMES, VRRNDANO,PRRNDMES,PRRNDANO,AUUSUULTALT,AUDATULTALT,AUVRSREGATU)
                     VALUES (@PIDCTI, @VIDFUNIVE, @VIDOPEQUOFUN,@VDTULTDIA, @VDTAPL, @VVRAPLPOSATU, @VVRRNDMES, @VVRRNDANO,
                             @VPRRNDMES, @VPRRNDANO, @PCDUSU, GETDATE(), 1)



                 END
             END
             ELSE
             BEGIN

                 IF SUBSTRING(@PDTMESREF,5,2) <> '01'
                 BEGIN

                     INSERT INTO INV_POSFUN_FCH
                            (IDCTI, IDFUNIVE, IDOPEQUOFUN, DTPOS, DTAPL, VRAPLPOS, VRRNDMES, VRRNDANO,PRRNDMES,PRRNDANO,AUUSUULTALT,AUDATULTALT,AUVRSREGATU)
                     VALUES (@PIDCTI, @VIDFUNIVE, @VIDOPEQUOFUN, @VDTULTDIA, @VDTAPL, 0, 0, @VVRRNDANOANT,
                             0, @VPRRNDANOANT, @PCDUSU, GETDATE(), 1)

                 END

             END

             FETCH NEXT FROM @C_FUNDOS INTO @VIDFUNIVE, @VIDOPEQUOFUN, @VNMEMI, @VDTOPE, @VVRAPLPOSANT, @VVRRNDMESANT, @VVRRNDANOANT, @VPRRNDANOANT

         END

     CLOSE @C_FUNDOS
     DEALLOCATE @C_FUNDOS

     SET @SERRO = ''

SAIDA:

   SET @PRSDCERR = @SERRO

END