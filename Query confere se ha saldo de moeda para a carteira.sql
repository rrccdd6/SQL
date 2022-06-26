--Confere se há saldo para a carteira especifica na data escolhida


 SELECT SUM(VRSDOMOE)
              FROM INV_SALDO_DIA
             WHERE DTREF = '29/10/2021'
               AND IDCTI = 141
