!FIPU!* 16-09-2011 PCALDAS - FILIPETA PROUNI - NADA A FAZER            *
!2012!* 20-12-2010 PCALDAS - ENTRADA DA SBE-FILIPETA NO SISTEMA        *
      *----------------------------------------------------------------*
       81000-LER-HFS.
      *----------------------------------------------------------------*

           MOVE PA61-OPC-DIS                    TO W81-DISPLAY

           IF W81-IS < W81-ISMAX

            MOVE SPACES                         TO W81-REG

            IF W81-IS = 1
               MOVE ZEROS                       TO W81-VETOR-T99
            END-IF

            IF W81-IS = 1
               MOVE W81-STR (W81-IS:02)         TO W81-TIP
               MOVE 2                           TO C2EBCDIC-LEN
               MOVE W81-TIP                     TO C2EBCDIC-CAMPO
               CALL C2EBCDIC USING C2EBCDIC-PARM
               MOVE C2EBCDIC-CAMPO (01:02)      TO W81-TIP
            ELSE
               MOVE LOW-VALUES                  TO W81-TCX
               MOVE W81-STR (W81-IS:01)         TO W81-TCX(02:01)
               MOVE W81-TCN                     TO W81-TIN
            END-IF

            MOVE ZEROS                          TO W81-TLE

            PERFORM
            VARYING W81-IT FROM 1 BY 1
              UNTIL W81-IT  > W81-ITMAX

              IF W81-TIP = W81-VTIP (W81-IT)
                 MOVE W81-VTLE (W81-IT)         TO W81-TLE
                 MOVE W81-ITMAX                 TO W81-IT
              END-IF

            END-PERFORM

            IF W81-TLE = ZEROS
               DISPLAY ' ERRO DE ESTRUTURA DO ARQUIVO !!!'
               DISPLAY ' TIPO ' W81-TIP ' NAO EXISTE NO PROGRAMA'
!1110!
!1110!         MOVE '01-ESTRUTURA DE ARQUIVO'        TO W01-MSG
!1110!         MOVE SPACES                           TO W01-TXT
!1110!         MOVE 10                               TO W59-RC
!1110!
!1110!         PERFORM 50100-TRATAR-ERRO-ARQUIVO-READ
            END-IF

            COMPUTE W81-ISP = W81-IS + W81-TLE

            IF W81-ISP > W81-ISMAX + 1
               DISPLAY 'ERRO NA ESTRUTURA DO ARQUIVO !!!'
               DISPLAY 'TIPO ' W81-TIP ' COM O TAMANHO = ' W81-TLE
               DISPLAY 'SUPLANTA O TAMANHO DA TABELA  = ' W81-ISMAX
!1110!
!1110!         MOVE '01-ESTRUTURA DE ARQUIVO'        TO W01-MSG
!1110!         MOVE SPACES                           TO W01-TXT
!1110!         MOVE 10                               TO W59-RC
!1110!
!1110!         PERFORM 50100-TRATAR-ERRO-ARQUIVO-READ
            END-IF

            MOVE W81-TIN                     TO W81-TIP-ANT

            MOVE W81-STR (W81-IS:W81-TLE)    TO W81-REG

            MOVE W81-ISP                     TO W81-IS

            MOVE LOW-VALUES                  TO AS032-REGISTRO
            MOVE W81-REG                     TO AS032-REGISTRO

            ADD  1                           TO W81-SBEA3000-R
            MOVE W81-SBEA3000-R              TO W81-SBEA3000-R-F

            EVALUATE TRUE

              WHEN W81-DISPLAY-COLUNA-OK
                PERFORM 81100-MOVER-REG

              WHEN W81-DISPLAY-LINHA-OK
                PERFORM 81101-MOVER-REG

              WHEN W81-DISPLAY-OFF
                PERFORM 81102-MOVER-REG

            END-EVALUATE
!0203!*----------------------------------------------------------------*
!0203!*------------------------------------------- DESPREZAR APL=100 --*
!0203!*----------------------------------------------------------------*
!0203!      IF  (W81-TIN               = 011
!0203!      AND  AS030-11-CD-APLICACAO = 100)
!0203!      OR  (W81-TIN               = 012
!0203!      AND  AS030-12-CD-APLICACAO = 100)
!0203!      OR  (W81-TIN               = 013
!0203!      AND  AS030-13-CD-APLICACAO = 100)
!0203!      OR  (W81-TIN               = 014
!0203!      AND  AS030-14-CD-APLICACAO = 100)
!0203!      OR  (W81-TIN               = 021
!0203!      AND  AS030-21-CD-APLICACAO = 100)
!0203!
!0203!      OR  (W81-TIN               = 031
!0203!      AND  AS030-31-CD-APLICACAO = 100)
!0203!      OR  (W81-TIN               = 032
!0203!      AND  AS030-32-CD-APLICACAO = 100)
!0203!      OR  (W81-TIN               = 033
!0203!      AND  AS030-33-CD-APLICACAO = 100)
!0203!      OR  (W81-TIN               = 034
!0203!      AND  AS030-34-CD-APLICACAO = 100)
!0203!      OR  (W81-TIN               = 041
!0203!      AND  AS030-41-CD-APLICACAO = 100)
!0203!
!0203!           GO TO 81000-LER-HFS
!0203!
!0203!      END-IF
!0203!*----------------------------------------------------------------*
!0203!*----------------------------------------------------------------*
!2511!*
!2511!*----------------------------------------------------------------*
!2511!*------------------------------------------- DESPREZAR APL=430 --*
!2511!*----------------------------------------------------------------*
!2511!      IF  (W81-TIN               = 011
!2511!      AND  AS030-11-CD-APLICACAO = 430)
!2511!      OR  (W81-TIN               = 012
!2511!      AND  AS030-12-CD-APLICACAO = 430)
!2511!      OR  (W81-TIN               = 013
!2511!      AND  AS030-13-CD-APLICACAO = 430)
!2511!      OR  (W81-TIN               = 014
!2511!      AND  AS030-14-CD-APLICACAO = 430)
!2511!      OR  (W81-TIN               = 021
!2511!      AND  AS030-21-CD-APLICACAO = 430)
!2511!
!2511!      OR  (W81-TIN               = 031
!2511!      AND  AS030-31-CD-APLICACAO = 430)
!2511!      OR  (W81-TIN               = 032
!2511!      AND  AS030-32-CD-APLICACAO = 430)
!2511!      OR  (W81-TIN               = 033
!2511!      AND  AS030-33-CD-APLICACAO = 430)
!2511!      OR  (W81-TIN               = 034
!2511!      AND  AS030-34-CD-APLICACAO = 430)
!2511!      OR  (W81-TIN               = 041
!2511!      AND  AS030-41-CD-APLICACAO = 430)
!2511!
!2511!           GO TO 81000-LER-HFS
!2511!
!2511!      END-IF
!2511!*----------------------------------------------------------------*
!2511!*----------------------------------------------------------------*
!2506!*
!2506!*----------------------------------------------------------------*
!2506!*- PCALDAS --------------------------------- DESPREZAR APL=431 --*
!2506!*----------------------------------------------------------------*
!2506!      IF  (W81-TIN               = 011
!2506!      AND  AS030-11-CD-APLICACAO = 431)
!2506!      OR  (W81-TIN               = 012
!2506!      AND  AS030-12-CD-APLICACAO = 431)
!2506!      OR  (W81-TIN               = 013
!2506!      AND  AS030-13-CD-APLICACAO = 431)
!2506!      OR  (W81-TIN               = 014
!2506!      AND  AS030-14-CD-APLICACAO = 431)
!2506!      OR  (W81-TIN               = 021
!2506!      AND  AS030-21-CD-APLICACAO = 431)
!2506!
!2506!      OR  (W81-TIN               = 031
!2506!      AND  AS030-31-CD-APLICACAO = 431)
!2506!      OR  (W81-TIN               = 032
!2506!      AND  AS030-32-CD-APLICACAO = 431)
!2506!      OR  (W81-TIN               = 033
!2506!      AND  AS030-33-CD-APLICACAO = 431)
!2506!      OR  (W81-TIN               = 034
!2506!      AND  AS030-34-CD-APLICACAO = 431)
!2506!      OR  (W81-TIN               = 041
!2506!      AND  AS030-41-CD-APLICACAO = 431)
!2506!
!2506!           GO TO 81000-LER-HFS
!2506!
!2506!      END-IF
!2506!*----------------------------------------------------------------*
!2506!*----------------------------------------------------------------*
           ELSE
            SET  W81-STR-FIM-OK              TO TRUE

           END-IF
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG.
      *----------------------------------------------------------------*

      *----------------------------------------------------------------*
      * 1) Mover os Campos da Prodata (binario)         (AS032) ->
      *     para os campos texto (redefinicao de campos em comp) (AS033)
      *
      * 2) Mover os Campos Comp (redefinicao do AS033)  (AS031) ->
      *          para os campos com a picture correta            (AS030)
      *----------------------------------------------------------------*

           EVALUATE  W81-TIN
             WHEN 01
              PERFORM 81100-MOVER-REG-01
              PERFORM 82000-DISPLAY-REG-01
             WHEN 02
              PERFORM 81100-MOVER-REG-02
              PERFORM 82000-DISPLAY-REG-02
             WHEN 03
              PERFORM 81100-MOVER-REG-03
              PERFORM 82000-DISPLAY-REG-03
             WHEN 04
              PERFORM 81100-MOVER-REG-04
              PERFORM 82000-DISPLAY-REG-04
             WHEN 05
              PERFORM 81100-MOVER-REG-05
              PERFORM 82000-DISPLAY-REG-05
             WHEN 06
              PERFORM 81100-MOVER-REG-06
              PERFORM 82000-DISPLAY-REG-06
             WHEN 11
              PERFORM 81100-MOVER-REG-11
              PERFORM 82000-DISPLAY-REG-11
             WHEN 12
              PERFORM 81100-MOVER-REG-12
              PERFORM 82000-DISPLAY-REG-12
             WHEN 13
              PERFORM 81100-MOVER-REG-13
              PERFORM 82000-DISPLAY-REG-13
             WHEN 14
              PERFORM 81100-MOVER-REG-14
              PERFORM 82000-DISPLAY-REG-14
             WHEN 21
              PERFORM 81100-MOVER-REG-21
              PERFORM 82000-DISPLAY-REG-21
!0504!       WHEN 31
!0504!        PERFORM 81100-MOVER-REG-31
!0504!        PERFORM 82000-DISPLAY-REG-31
!0504!       WHEN 32
!0504!        PERFORM 81100-MOVER-REG-32
!0504!        PERFORM 82000-DISPLAY-REG-32
!0504!       WHEN 33
!0504!        PERFORM 81100-MOVER-REG-33
!0504!        PERFORM 82000-DISPLAY-REG-33
!0504!       WHEN 34
!0504!        PERFORM 81100-MOVER-REG-34
!0504!        PERFORM 82000-DISPLAY-REG-34
!0504!       WHEN 41
!0504!        PERFORM 81100-MOVER-REG-41
!0504!        PERFORM 82000-DISPLAY-REG-41
!1508!       WHEN 50
!1508!        PERFORM 81100-MOVER-REG-50
!1508!        PERFORM 82000-DISPLAY-REG-50
!1508!       WHEN 51
!1508!        PERFORM 81100-MOVER-REG-51
!1508!        PERFORM 82000-DISPLAY-REG-51
             WHEN 97
              PERFORM 81100-MOVER-REG-97
              PERFORM 82000-DISPLAY-REG-97
             WHEN 98
              PERFORM 81100-MOVER-REG-98
              PERFORM 82000-DISPLAY-REG-98
             WHEN 99
              PERFORM 81100-MOVER-REG-99
              PERFORM 82000-DISPLAY-REG-99
           END-EVALUATE
!3011!
!3011!     PERFORM 81030-PREENCHER-VETOR-03
           .
      *----------------------------------------------------------------*
       81101-MOVER-REG.
      *----------------------------------------------------------------*

      *----------------------------------------------------------------*
      * 1) Mover os Campos da Prodata (binario)         (AS032) ->
      *     para os campos texto (redefinicao de campos em comp) (AS033)
      *
      * 2) Mover os Campos Comp (redefinicao do AS033)  (AS031) ->
      *          para os campos com a picture correta            (AS030)
      *----------------------------------------------------------------*

           EVALUATE  W81-TIN
             WHEN 01
              PERFORM 81100-MOVER-REG-01
              PERFORM 83000-DISPLAY-REG-01
             WHEN 02
              PERFORM 81100-MOVER-REG-02
              PERFORM 83000-DISPLAY-REG-02
             WHEN 03
              PERFORM 81100-MOVER-REG-03
              PERFORM 83000-DISPLAY-REG-03
             WHEN 04
              PERFORM 81100-MOVER-REG-04
              PERFORM 83000-DISPLAY-REG-04
             WHEN 05
              PERFORM 81100-MOVER-REG-05
              PERFORM 83000-DISPLAY-REG-05
             WHEN 06
              PERFORM 81100-MOVER-REG-06
              PERFORM 83000-DISPLAY-REG-06
             WHEN 11
              PERFORM 81100-MOVER-REG-11
              PERFORM 83000-DISPLAY-REG-11
             WHEN 12
              PERFORM 81100-MOVER-REG-12
              PERFORM 83000-DISPLAY-REG-12
             WHEN 13
              PERFORM 81100-MOVER-REG-13
              PERFORM 83000-DISPLAY-REG-13
             WHEN 14
              PERFORM 81100-MOVER-REG-14
              PERFORM 83000-DISPLAY-REG-14
             WHEN 21
              PERFORM 81100-MOVER-REG-21
              PERFORM 83000-DISPLAY-REG-21
!0504!       WHEN 31
!0504!        PERFORM 81100-MOVER-REG-31
!0504!        PERFORM 83000-DISPLAY-REG-31
!0504!       WHEN 32
!0504!        PERFORM 81100-MOVER-REG-32
!0504!        PERFORM 83000-DISPLAY-REG-32
!0504!       WHEN 33
!0504!        PERFORM 81100-MOVER-REG-33
!0504!        PERFORM 83000-DISPLAY-REG-33
!0504!       WHEN 34
!0504!        PERFORM 81100-MOVER-REG-34
!0504!        PERFORM 83000-DISPLAY-REG-34
!0504!       WHEN 41
!0504!        PERFORM 81100-MOVER-REG-41
!0504!        PERFORM 83000-DISPLAY-REG-41
!1508!       WHEN 50
!1508!        PERFORM 81100-MOVER-REG-50
!1508!        PERFORM 83000-DISPLAY-REG-50
!1508!       WHEN 51
!1508!        PERFORM 81100-MOVER-REG-51
!1508!        PERFORM 83000-DISPLAY-REG-51
             WHEN 97
              PERFORM 81100-MOVER-REG-97
              PERFORM 83000-DISPLAY-REG-97
             WHEN 98
              PERFORM 81100-MOVER-REG-98
              PERFORM 83000-DISPLAY-REG-98
             WHEN 99
              PERFORM 81100-MOVER-REG-99
              PERFORM 83000-DISPLAY-REG-99
           END-EVALUATE
!3011!
!3011!     PERFORM 81030-PREENCHER-VETOR-03
           .
      *----------------------------------------------------------------*
       81102-MOVER-REG.
      *----------------------------------------------------------------*

      *----------------------------------------------------------------*
      * 1) Mover os Campos da Prodata (binario)         (AS032) ->
      *     para os campos texto (redefinicao de campos em comp) (AS033)
      *
      * 2) Mover os Campos Comp (redefinicao do AS033)  (AS031) ->
      *          para os campos com a picture correta            (AS030)
      *----------------------------------------------------------------*

           EVALUATE  W81-TIN
             WHEN 01
              PERFORM 81100-MOVER-REG-01
             WHEN 02
              PERFORM 81100-MOVER-REG-02
             WHEN 03
              PERFORM 81100-MOVER-REG-03
             WHEN 04
              PERFORM 81100-MOVER-REG-04
             WHEN 05
              PERFORM 81100-MOVER-REG-05
             WHEN 06
              PERFORM 81100-MOVER-REG-06
             WHEN 11
              PERFORM 81100-MOVER-REG-11
             WHEN 12
              PERFORM 81100-MOVER-REG-12
             WHEN 13
              PERFORM 81100-MOVER-REG-13
             WHEN 14
              PERFORM 81100-MOVER-REG-14
             WHEN 21
              PERFORM 81100-MOVER-REG-21
!0504!       WHEN 31
!0504!        PERFORM 81100-MOVER-REG-31
!0504!       WHEN 32
!0504!        PERFORM 81100-MOVER-REG-32
!0504!       WHEN 33
!0504!        PERFORM 81100-MOVER-REG-33
!0504!       WHEN 34
!0504!        PERFORM 81100-MOVER-REG-34
!0504!       WHEN 41
!0504!        PERFORM 81100-MOVER-REG-41
!1805!       WHEN 50
!1805!        PERFORM 81100-MOVER-REG-50
!1805!       WHEN 51
!1805!        PERFORM 81100-MOVER-REG-51
             WHEN 97
              PERFORM 81100-MOVER-REG-97
             WHEN 98
              PERFORM 81100-MOVER-REG-98
             WHEN 99
              PERFORM 81100-MOVER-REG-99
           END-EVALUATE
!3011!
!3011!     PERFORM 81030-PREENCHER-VETOR-03
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-01.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO               TO AS030-HEADER-01

           MOVE 62                           TO C2EBCDIC-LEN
           MOVE AS030-HEADER-01  (01:62)     TO C2EBCDIC-CAMPO
           CALL C2EBCDIC USING C2EBCDIC-PARM
           MOVE C2EBCDIC-CAMPO (01:62)       TO AS030-HEADER-01 (01:62)

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-01-DT-GERACAO-ARQ          TO W55-DDDD
           MOVE AS030-01-HM-GERACAO-ARQ          TO W55-HHMM-FT

           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD                     TO
                AS030-01C-DT-GERACAO-ARQ
           MOVE W55-HHMMSS                       TO
                AS030-01C-HM-GERACAO-ARQ
      *----------------------------------------------------------------*

!0803!     MOVE 1                            TO AS030-01-CD-MOEDA

           MOVE AS030-HEADER-01              TO AS030-REGISTRO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (01)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-02.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO           TO AS032-DETALHE-02

           MOVE LOW-VALUES               TO AS033-DETALHE-02

           MOVE AS032-02-TP-REGISTRO     TO AS033-02-TP-REGISTRO(02:01)
           MOVE AS032-02-NR-TRAN-SAM     TO AS033-02-NR-TRAN-SAM
           MOVE AS032-02-DT-TRANS        TO AS033-02-DT-TRANS
           MOVE AS032-02-HR-TRANS        TO AS033-02-HR-TRANS

           MOVE AS032-02-NR-ARQ-LOG      TO AS033-02-NR-ARQ-LOG (03:02)

           MOVE AS033-DETALHE-02         TO AS031-DETALHE-02

           MOVE AS031-02-TP-REGISTRO     TO AS030-02-TP-REGISTRO
           MOVE AS031-02-NR-TRAN-SAM     TO AS030-02-NR-TRAN-SAM
           MOVE AS031-02-DT-TRANS        TO AS030-02-DT-TRANS
           MOVE AS031-02-HR-TRANS        TO AS030-02-HR-TRANS
           MOVE AS031-02-NR-ARQ-LOG      TO AS030-02-NR-ARQ-LOG

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-02-DT-TRANS        TO W55-DDDD
           MOVE AS030-02-HR-TRANS        TO W55-HHMM-FT

           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-02C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-02C-HR-TRANS
                                            AS030-TXC-HR-TRANS
      *----------------------------------------------------------------*

           MOVE AS030-02-TX-CONTROLE     TO AS030-TX-CONTROLE

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (02)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-03.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO           TO AS032-DETALHE-03

           MOVE LOW-VALUES               TO AS033-DETALHE-03

           MOVE AS032-03-TP-REGISTRO     TO AS033-03-TP-REGISTRO(02:01)
           MOVE AS032-03-NR-TRAN-SAM     TO AS033-03-NR-TRAN-SAM
           MOVE AS032-03-DT-TRANS        TO AS033-03-DT-TRANS
           MOVE AS032-03-HR-TRANS        TO AS033-03-HR-TRANS

           MOVE AS032-03-NR-ESTACAO-CARRO
!0109!       TO AS033-03-NR-ESTACAO-CARRO
           MOVE AS032-03-CD-LINHA        TO AS033-03-CD-LINHA    (01:02)
           MOVE AS032-03-CD-SENTIDO      TO AS033-03-CD-SENTIDO  (02:01)
           MOVE AS032-03-NR-SECAO        TO AS033-03-NR-SECAO    (02:01)
           MOVE AS032-03-VL-TARIFA-ATU
             TO AS033-03-VL-TARIFA-ATU                           (03:02)
           MOVE AS032-03-DT-INIC-TARIFA-ATU
             TO AS033-03-DT-INIC-TARIFA-ATU                      (01:02)
           MOVE AS032-03-VL-TARIFA-ANT
             TO AS033-03-VL-TARIFA-ANT                           (03:02)
!0311!     MOVE AS032-03-CD-MOTORISTA
!0311!       TO AS033-03-CD-MOTORISTA
!0311!     MOVE AS032-03-CD-COBRADOR
!0311!       TO AS033-03-CD-COBRADOR
!0311!     MOVE AS032-03-CD-TURNO
!0311!       TO AS033-03-CD-TURNO

           MOVE AS033-DETALHE-03          TO AS031-DETALHE-03

           MOVE AS031-03-TP-REGISTRO      TO AS030-03-TP-REGISTRO
           MOVE AS031-03-NR-TRAN-SAM      TO AS030-03-NR-TRAN-SAM
           MOVE AS031-03-DT-TRANS         TO AS030-03-DT-TRANS
           MOVE AS031-03-HR-TRANS         TO AS030-03-HR-TRANS

           MOVE AS031-03-NR-ESTACAO-CARRO TO AS030-03-NR-ESTACAO-CARRO
           MOVE AS031-03-CD-LINHA         TO AS030-03-CD-LINHA
TTTTTT*
TTTTTT*    IF AS030-03-CD-LINHA = 39
TTTTTT*       MOVE 24                     TO AS030-03-CD-LINHA
TTTTTT*    END-IF

           MOVE AS031-03-CD-SENTIDO       TO AS030-03-CD-SENTIDO
!0803!
!0803!     IF NOT AS030-03-CD-SENTIDO-OK
!0803!        MOVE ZERO                   TO AS030-03-CD-SENTIDO
!0803!     END-IF
!0803!
           MOVE AS031-03-NR-SECAO         TO AS030-03-NR-SECAO
           MOVE AS031-03-VL-TARIFA-ATU    TO AS030-03-VL-TARIFA-ATU
           MOVE AS031-03-DT-INIC-TARIFA-ATU
                                          TO AS030-03-DT-INIC-TARIFA-ATU
           MOVE AS031-03-VL-TARIFA-ANT    TO AS030-03-VL-TARIFA-ANT
!0311!
!0311!     MOVE AS031-03-CD-MOTORISTA     TO AS030-03-CD-MOTORISTA
!0311!     MOVE AS031-03-CD-COBRADOR      TO AS030-03-CD-COBRADOR
!0311!     MOVE AS031-03-CD-TURNO         TO AS030-03-CD-TURNO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-03-DT-TRANS       TO W55-DDDD
           MOVE AS030-03-HR-TRANS       TO W55-HHMM-FT

           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD            TO AS030-03C-DT-TRANS
                                           AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS              TO AS030-03C-HR-TRANS
                                           AS030-TXC-HR-TRANS

           MOVE AS030-03-DT-INIC-TARIFA-ATU
                                        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE W55-AAAAMMDD            TO AS030-03C-DT-INIC-TARIFA-ATU

           MOVE AS030-03-VL-TARIFA-ATU  TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                 TO AS030-03C-VL-TARIFA-ATU

           MOVE AS030-03-VL-TARIFA-ANT  TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                 TO AS030-03C-VL-TARIFA-ANT

      *----------------------------------------------------------------*

           MOVE AS030-03-TX-CONTROLE     TO AS030-TX-CONTROLE

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (03)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-04.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO           TO AS032-DETALHE-04

           MOVE LOW-VALUES               TO AS033-DETALHE-04

           MOVE AS032-04-TP-REGISTRO     TO AS033-04-TP-REGISTRO(02:01)
           MOVE AS032-04-NR-TRAN-SAM     TO AS033-04-NR-TRAN-SAM
           MOVE AS032-04-DT-TRANS        TO AS033-04-DT-TRANS
           MOVE AS032-04-HR-TRANS        TO AS033-04-HR-TRANS

           MOVE AS032-04-NR-CHIP-CARTAO
             TO AS033-04-NR-CHIP-CARTAO                         (05:04)

           MOVE AS033-DETALHE-04         TO AS031-DETALHE-04

           MOVE AS031-04-TP-REGISTRO     TO AS030-04-TP-REGISTRO
           MOVE AS031-04-NR-TRAN-SAM     TO AS030-04-NR-TRAN-SAM
           MOVE AS031-04-DT-TRANS        TO AS030-04-DT-TRANS
           MOVE AS031-04-HR-TRANS        TO AS030-04-HR-TRANS

           MOVE AS031-04-NR-CHIP-CARTAO  TO AS030-04-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-04-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-04-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-04C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-04C-HR-TRANS
                                            AS030-TXC-HR-TRANS

      *----------------------------------------------------------------*

           MOVE AS030-04-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-04-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (04)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-05.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO           TO AS032-DETALHE-05

           MOVE LOW-VALUES               TO AS033-DETALHE-05

           MOVE AS032-05-TP-REGISTRO     TO AS033-05-TP-REGISTRO(02:01)
           MOVE AS032-05-NR-TRAN-SAM     TO AS033-05-NR-TRAN-SAM
           MOVE AS032-05-DT-TRANS        TO AS033-05-DT-TRANS
           MOVE AS032-05-HR-TRANS        TO AS033-05-HR-TRANS

           MOVE AS032-05-NR-CHIP-CARTAO
             TO AS033-05-NR-CHIP-CARTAO                         (05:04)

           MOVE AS033-DETALHE-05         TO AS031-DETALHE-05

           MOVE AS031-05-TP-REGISTRO     TO AS030-05-TP-REGISTRO
           MOVE AS031-05-NR-TRAN-SAM     TO AS030-05-NR-TRAN-SAM
           MOVE AS031-05-DT-TRANS        TO AS030-05-DT-TRANS
           MOVE AS031-05-HR-TRANS        TO AS030-05-HR-TRANS

           MOVE AS031-05-NR-CHIP-CARTAO  TO AS030-05-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-05-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-05-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-05C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-05C-HR-TRANS
                                            AS030-TXC-HR-TRANS

      *----------------------------------------------------------------*

           MOVE AS030-05-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-05-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (05)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-06.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO           TO AS032-DETALHE-06

           MOVE LOW-VALUES               TO AS033-DETALHE-06

           MOVE AS032-06-TP-REGISTRO     TO AS033-06-TP-REGISTRO(02:01)
           MOVE AS032-06-NR-TRAN-SAM     TO AS033-06-NR-TRAN-SAM
           MOVE AS032-06-DT-TRANS        TO AS033-06-DT-TRANS
           MOVE AS032-06-HR-TRANS        TO AS033-06-HR-TRANS

           MOVE AS032-06-NR-CHIP-CARTAO
             TO AS033-06-NR-CHIP-CARTAO                         (05:04)

           MOVE AS033-DETALHE-06         TO AS031-DETALHE-06

           MOVE AS031-06-TP-REGISTRO     TO AS030-06-TP-REGISTRO
           MOVE AS031-06-NR-TRAN-SAM     TO AS030-06-NR-TRAN-SAM
           MOVE AS031-06-DT-TRANS        TO AS030-06-DT-TRANS
           MOVE AS031-06-HR-TRANS        TO AS030-06-HR-TRANS

           MOVE AS031-06-NR-CHIP-CARTAO  TO AS030-06-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-06-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-06-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-06C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-06C-HR-TRANS
                                            AS030-TXC-HR-TRANS

      *----------------------------------------------------------------*

           MOVE AS030-06-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-06-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (06)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-11.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO          TO AS032-DETALHE-11

           MOVE LOW-VALUES              TO AS033-DETALHE-11

           MOVE AS032-11-TP-REGISTRO    TO AS033-11-TP-REGISTRO (02:01)
           MOVE AS032-11-NR-TRAN-SAM    TO AS033-11-NR-TRAN-SAM
           MOVE AS032-11-DT-TRANS       TO AS033-11-DT-TRANS
           MOVE AS032-11-HR-TRANS       TO AS033-11-HR-TRANS

           MOVE AS032-11-NR-CHIP-CARTAO
             TO AS033-11-NR-CHIP-CARTAO                         (05:04)

           MOVE AS032-11-CD-APLICACAO   TO AS033-11-CD-APLICACAO(03:02)
           MOVE AS032-11-NR-TRANSACAO   TO AS033-11-NR-TRANSACAO(03:02)
           MOVE AS032-11-NR-CARGA       TO AS033-11-NR-CARGA    (03:02)

           MOVE AS032-11-VL-TRANS       TO AS033-11-VL-TRANS    (03:02)

           MOVE AS032-11-VL-SALDO       TO AS033-11-VL-SALDO

           MOVE AS033-DETALHE-11        TO AS031-DETALHE-11

           MOVE AS031-11-TP-REGISTRO    TO AS030-11-TP-REGISTRO
           MOVE AS031-11-NR-TRAN-SAM    TO AS030-11-NR-TRAN-SAM
           MOVE AS031-11-DT-TRANS       TO AS030-11-DT-TRANS
           MOVE AS031-11-HR-TRANS       TO AS030-11-HR-TRANS

           MOVE AS031-11-NR-CHIP-CARTAO TO AS030-11-NR-CHIP-CARTAO
           MOVE AS031-11-CD-APLICACAO   TO AS030-11-CD-APLICACAO
           MOVE AS031-11-NR-TRANSACAO   TO AS030-11-NR-TRANSACAO
           MOVE AS031-11-NR-CARGA       TO AS030-11-NR-CARGA

           MOVE AS031-11-VL-TRANS       TO AS030-11-VL-TRANS

           MOVE AS031-11-VL-SALDO       TO AS030-11-VL-SALDO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-11-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-11-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-11C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-11C-HR-TRANS
                                            AS030-TXC-HR-TRANS

           MOVE AS030-11-VL-TRANS        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-11C-VL-TRANS

           MOVE AS030-11-VL-SALDO        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-11C-VL-SALDO

      *----------------------------------------------------------------*

           MOVE AS030-11-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-11-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (11)
           ADD  AS030-11C-VL-TRANS           TO W81-VT99-VAL (11)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-12.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO          TO AS032-DETALHE-12

           MOVE LOW-VALUES              TO AS033-DETALHE-12

           MOVE AS032-12-TP-REGISTRO    TO AS033-12-TP-REGISTRO (02:01)
           MOVE AS032-12-NR-TRAN-SAM    TO AS033-12-NR-TRAN-SAM
           MOVE AS032-12-DT-TRANS       TO AS033-12-DT-TRANS
           MOVE AS032-12-HR-TRANS       TO AS033-12-HR-TRANS

           MOVE AS032-12-NR-CHIP-CARTAO
             TO AS033-12-NR-CHIP-CARTAO                         (05:04)

           MOVE AS032-12-CD-APLICACAO   TO AS033-12-CD-APLICACAO(03:02)
           MOVE AS032-12-NR-TRANSACAO   TO AS033-12-NR-TRANSACAO(03:02)
           MOVE AS032-12-NR-CARGA       TO AS033-12-NR-CARGA    (03:02)

           MOVE AS032-12-VL-TRANS       TO AS033-12-VL-TRANS    (03:02)

           MOVE AS032-12-VL-SALDO       TO AS033-12-VL-SALDO

           MOVE AS033-DETALHE-12        TO AS031-DETALHE-12

           MOVE AS031-12-TP-REGISTRO    TO AS030-12-TP-REGISTRO
           MOVE AS031-12-NR-TRAN-SAM    TO AS030-12-NR-TRAN-SAM
           MOVE AS031-12-DT-TRANS       TO AS030-12-DT-TRANS
           MOVE AS031-12-HR-TRANS       TO AS030-12-HR-TRANS

           MOVE AS031-12-NR-CHIP-CARTAO TO AS030-12-NR-CHIP-CARTAO
           MOVE AS031-12-CD-APLICACAO   TO AS030-12-CD-APLICACAO
           MOVE AS031-12-NR-TRANSACAO   TO AS030-12-NR-TRANSACAO
           MOVE AS031-12-NR-CARGA       TO AS030-12-NR-CARGA

           MOVE AS031-12-VL-TRANS       TO AS030-12-VL-TRANS

           MOVE AS031-12-VL-SALDO       TO AS030-12-VL-SALDO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-12-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-12-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-12C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-12C-HR-TRANS
                                            AS030-TXC-HR-TRANS

           MOVE AS030-12-VL-TRANS        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-12C-VL-TRANS

           MOVE AS030-12-VL-SALDO        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-12C-VL-SALDO

      *----------------------------------------------------------------*

           MOVE AS030-12-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-12-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (12)
           ADD  AS030-12C-VL-TRANS           TO W81-VT99-VAL (12)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-13.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO          TO AS032-DETALHE-13

           MOVE LOW-VALUES              TO AS033-DETALHE-13

           MOVE AS032-13-TP-REGISTRO    TO AS033-13-TP-REGISTRO (02:01)
           MOVE AS032-13-NR-TRAN-SAM    TO AS033-13-NR-TRAN-SAM
           MOVE AS032-13-DT-TRANS       TO AS033-13-DT-TRANS
           MOVE AS032-13-HR-TRANS       TO AS033-13-HR-TRANS

           MOVE AS032-13-NR-CHIP-CARTAO
             TO AS033-13-NR-CHIP-CARTAO                         (05:04)

           MOVE AS032-13-CD-APLICACAO   TO AS033-13-CD-APLICACAO(03:02)
           MOVE AS032-13-NR-TRANSACAO   TO AS033-13-NR-TRANSACAO(03:02)
           MOVE AS032-13-NR-CARGA       TO AS033-13-NR-CARGA    (03:02)

           MOVE AS032-13-VL-TRANS       TO AS033-13-VL-TRANS    (03:02)

           MOVE AS032-13-VL-SALDO       TO AS033-13-VL-SALDO

           MOVE AS033-DETALHE-13        TO AS031-DETALHE-13

           MOVE AS031-13-TP-REGISTRO    TO AS030-13-TP-REGISTRO
           MOVE AS031-13-NR-TRAN-SAM    TO AS030-13-NR-TRAN-SAM
           MOVE AS031-13-DT-TRANS       TO AS030-13-DT-TRANS
           MOVE AS031-13-HR-TRANS       TO AS030-13-HR-TRANS

           MOVE AS031-13-NR-CHIP-CARTAO TO AS030-13-NR-CHIP-CARTAO
           MOVE AS031-13-CD-APLICACAO   TO AS030-13-CD-APLICACAO
           MOVE AS031-13-NR-TRANSACAO   TO AS030-13-NR-TRANSACAO
           MOVE AS031-13-NR-CARGA       TO AS030-13-NR-CARGA

           MOVE AS031-13-VL-TRANS       TO AS030-13-VL-TRANS

           MOVE AS031-13-VL-SALDO       TO AS030-13-VL-SALDO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-13-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-13-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-13C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-13C-HR-TRANS
                                            AS030-TXC-HR-TRANS

           MOVE AS030-13-VL-TRANS        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-13C-VL-TRANS

           MOVE AS030-13-VL-SALDO        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-13C-VL-SALDO

      *----------------------------------------------------------------*

           MOVE AS030-13-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-13-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (13)
           ADD  AS030-13C-VL-TRANS           TO W81-VT99-VAL (13)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-14.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO          TO AS032-DETALHE-14

           MOVE LOW-VALUES              TO AS033-DETALHE-14

           MOVE AS032-14-TP-REGISTRO    TO AS033-14-TP-REGISTRO (02:01)
           MOVE AS032-14-NR-TRAN-SAM    TO AS033-14-NR-TRAN-SAM
           MOVE AS032-14-DT-TRANS       TO AS033-14-DT-TRANS
           MOVE AS032-14-HR-TRANS       TO AS033-14-HR-TRANS

           MOVE AS032-14-NR-CHIP-CARTAO
             TO AS033-14-NR-CHIP-CARTAO                         (05:04)

           MOVE AS032-14-CD-APLICACAO   TO AS033-14-CD-APLICACAO(03:02)
           MOVE AS032-14-NR-TRANSACAO   TO AS033-14-NR-TRANSACAO(03:02)

           MOVE AS032-14-CD-APLICACAO-ANT
             TO AS033-14-CD-APLICACAO-ANT                       (03:02)

           MOVE AS032-14-NR-TRANSACAO-ANT
             TO AS033-14-NR-TRANSACAO-ANT                       (03:02)

           MOVE AS032-14-CT-INTEGRACOES TO AS033-14-CT-INTEGRACOES
                                                                (02:01)
           MOVE AS032-14-CD-INTEGRACAO  TO AS033-14-CD-INTEGRACAO
!3110!                                                          (03:02)
           MOVE AS032-14-NR-CARGA       TO AS033-14-NR-CARGA    (03:02)

           MOVE AS032-14-VL-TARIFA-INTEGRACAO
             TO AS033-14-VL-TARIFA-INTEGRACAO                   (03:02)

           MOVE AS032-14-VL-SALDO       TO AS033-14-VL-SALDO

           MOVE AS033-DETALHE-14          TO AS031-DETALHE-14

           MOVE AS031-14-TP-REGISTRO      TO AS030-14-TP-REGISTRO
           MOVE AS031-14-NR-TRAN-SAM      TO AS030-14-NR-TRAN-SAM
           MOVE AS031-14-DT-TRANS         TO AS030-14-DT-TRANS
           MOVE AS031-14-HR-TRANS         TO AS030-14-HR-TRANS

           MOVE AS031-14-NR-CHIP-CARTAO   TO AS030-14-NR-CHIP-CARTAO
           MOVE AS031-14-CD-APLICACAO     TO AS030-14-CD-APLICACAO
           MOVE AS031-14-NR-TRANSACAO     TO AS030-14-NR-TRANSACAO
           MOVE AS031-14-CD-APLICACAO-ANT TO AS030-14-CD-APLICACAO-ANT
           MOVE AS031-14-NR-TRANSACAO-ANT TO AS030-14-NR-TRANSACAO-ANT
           MOVE AS031-14-CT-INTEGRACOES   TO AS030-14-CT-INTEGRACOES
           MOVE AS031-14-CD-INTEGRACAO    TO AS030-14-CD-INTEGRACAO
           MOVE AS031-14-NR-CARGA         TO AS030-14-NR-CARGA
           MOVE AS031-14-VL-TARIFA-INTEGRACAO
             TO AS030-14-VL-TARIFA-INTEGRACAO
           MOVE AS031-14-VL-SALDO         TO AS030-14-VL-SALDO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-14-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-14-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-14C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-14C-HR-TRANS
                                            AS030-TXC-HR-TRANS

           MOVE AS030-14-VL-TARIFA-INTEGRACAO
                                         TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO
                AS030-14C-VL-TARIFA-INTEGRACAO

           MOVE AS030-14-VL-SALDO        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-14C-VL-SALDO

      *----------------------------------------------------------------*

           MOVE AS030-14-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-14-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                              TO W81-VT99-QTD (14)
           ADD  AS030-14C-VL-TARIFA-INTEGRACAO tO W81-VT99-VAL (14)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-21.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO          TO AS032-DETALHE-21

           MOVE LOW-VALUES              TO AS033-DETALHE-21

           MOVE AS032-21-TP-REGISTRO    TO AS033-21-TP-REGISTRO (02:01)
           MOVE AS032-21-NR-TRAN-SAM    TO AS033-21-NR-TRAN-SAM
           MOVE AS032-21-DT-TRANS       TO AS033-21-DT-TRANS
           MOVE AS032-21-HR-TRANS       TO AS033-21-HR-TRANS

           MOVE AS032-21-NR-CHIP-CARTAO
             TO AS033-21-NR-CHIP-CARTAO                         (05:04)

           MOVE AS032-21-CD-APLICACAO   TO AS033-21-CD-APLICACAO(03:02)
           MOVE AS032-21-NR-TRANSACAO   TO AS033-21-NR-TRANSACAO(03:02)
           MOVE AS032-21-CD-OPERACAO    TO AS033-21-CD-OPERACAO (02:01)
           MOVE AS032-21-NR-CARGA       TO AS033-21-NR-CARGA    (03:02)
           MOVE AS032-21-VL-CARGA       TO AS033-21-VL-CARGA    (03:02)
           MOVE AS032-21-VL-SALDO       TO AS033-21-VL-SALDO

           MOVE AS033-DETALHE-21        TO AS031-DETALHE-21

           MOVE AS031-21-TP-REGISTRO    TO AS030-21-TP-REGISTRO
           MOVE AS031-21-NR-TRAN-SAM    TO AS030-21-NR-TRAN-SAM
           MOVE AS031-21-DT-TRANS       TO AS030-21-DT-TRANS
           MOVE AS031-21-HR-TRANS       TO AS030-21-HR-TRANS

           MOVE AS031-21-NR-CHIP-CARTAO TO AS030-21-NR-CHIP-CARTAO
           MOVE AS031-21-CD-APLICACAO   TO AS030-21-CD-APLICACAO
           MOVE AS031-21-NR-TRANSACAO   TO AS030-21-NR-TRANSACAO
           MOVE AS031-21-CD-OPERACAO    TO AS030-21-CD-OPERACAO
           MOVE AS031-21-NR-CARGA       TO AS030-21-NR-CARGA
           MOVE AS031-21-VL-CARGA       TO AS030-21-VL-CARGA
           MOVE AS031-21-VL-SALDO       TO AS030-21-VL-SALDO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-21-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-21-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-21C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-21C-HR-TRANS
                                            AS030-TXC-HR-TRANS

           MOVE AS030-21-VL-CARGA        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-21C-VL-CARGA

           MOVE AS030-21-VL-SALDO        TO W55-VAL-FT

!!!!  *    COMPUTE W55-VAL-FT = W55-VAL-FT - 4096

           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-21C-VL-SALDO

      *----------------------------------------------------------------*

           MOVE AS030-21-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-21-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (21)
           ADD  AS030-21C-VL-SALDO           TO W81-VT99-VAL (21)
           .
!0504!*----------------------------------------------------------------*
!0504! 81100-MOVER-REG-31.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS032-REGISTRO          TO AS032-DETALHE-31
!0504!
!0504!     MOVE LOW-VALUES              TO AS033-DETALHE-31
!0504!
!0504!     MOVE AS032-31-TP-REGISTRO    TO AS033-31-TP-REGISTRO (02:01)
!0504!     MOVE AS032-31-NR-TRAN-SAM    TO AS033-31-NR-TRAN-SAM
!0504!     MOVE AS032-31-DT-TRANS       TO AS033-31-DT-TRANS
!0504!     MOVE AS032-31-HR-TRANS       TO AS033-31-HR-TRANS
!0504!
!0504!     MOVE AS032-31-NR-CHIP-CARTAO
!0504!       TO AS033-31-NR-CHIP-CARTAO                         (05:04)
!0504!
!0504!     MOVE AS032-31-CD-APLICACAO   TO AS033-31-CD-APLICACAO(03:02)
!0504!     MOVE AS032-31-NR-TRANSACAO   TO AS033-31-NR-TRANSACAO(03:02)
!0504!     MOVE AS032-31-NR-CARGA       TO AS033-31-NR-CARGA    (03:02)
!0504!
!0504!     MOVE AS032-31-VL-TRANS       TO AS033-31-VL-TRANS    (03:02)
!0504!
!0504!     MOVE AS032-31-VL-SALDO       TO AS033-31-VL-SALDO
!0504!
!0504!     MOVE AS032-31-CD-LINHA       TO AS033-31-CD-LINHA
!0504!     MOVE AS032-31-TX-ASSINATURA  TO AS033-31-TX-ASSINATURA
!0504!
!0504!     MOVE AS033-DETALHE-31        TO AS031-DETALHE-31
!0504!
!0504!     MOVE AS031-31-TP-REGISTRO    TO AS030-31-TP-REGISTRO
!0504!     MOVE AS031-31-NR-TRAN-SAM    TO AS030-31-NR-TRAN-SAM
!0504!     MOVE AS031-31-DT-TRANS       TO AS030-31-DT-TRANS
!0504!     MOVE AS031-31-HR-TRANS       TO AS030-31-HR-TRANS
!0504!
!0504!     MOVE AS031-31-NR-CHIP-CARTAO TO AS030-31-NR-CHIP-CARTAO
!0504!     MOVE AS031-31-CD-APLICACAO   TO AS030-31-CD-APLICACAO
!0504!     MOVE AS031-31-NR-TRANSACAO   TO AS030-31-NR-TRANSACAO
!0504!     MOVE AS031-31-NR-CARGA       TO AS030-31-NR-CARGA
!0504!
!0504!     MOVE AS031-31-VL-TRANS       TO AS030-31-VL-TRANS
!0504!
!0504!     MOVE AS031-31-VL-SALDO       TO AS030-31-VL-SALDO
!0504!
!0504!     MOVE AS031-31-CD-LINHA       TO AS030-31-CD-LINHA
!0504!     MOVE AS031-31-TX-ASSINATURA  TO AS030-31-TX-ASSINATURA
!0504!
!0504!*----------------------------------------------------------------*
!0504!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-31-DT-TRANS        TO W55-DDDD
!0504!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!0504!
!0504!     MOVE AS030-31-HR-TRANS        TO W55-HHMM-FT
!0504!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!0504!
!0504!     MOVE W55-AAAAMMDD             TO AS030-31C-DT-TRANS
!0504!                                      AS030-TXC-DT-TRANS
!0504!     MOVE W55-HHMMSS               TO AS030-31C-HR-TRANS
!0504!                                      AS030-TXC-HR-TRANS
!0504!
!0504!     MOVE AS030-31-VL-TRANS        TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-31C-VL-TRANS
!0504!
!0504!     MOVE AS030-31-VL-SALDO        TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-31C-VL-SALDO
!0504!
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-31-TX-CONTROLE     TO AS030-TX-CONTROLE
!0504!     MOVE AS030-31-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!0504!
!0504!*----------------------------------------------------------------*
!0504!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     ADD  1                            TO W81-VT99-QTD (31)
!0504!     ADD  AS030-31C-VL-TRANS           TO W81-VT99-VAL (31)
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 81100-MOVER-REG-32.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS032-REGISTRO          TO AS032-DETALHE-32
!0504!
!0504!     MOVE LOW-VALUES              TO AS033-DETALHE-32
!0504!
!0504!     MOVE AS032-32-TP-REGISTRO    TO AS033-32-TP-REGISTRO (02:01)
!0504!     MOVE AS032-32-NR-TRAN-SAM    TO AS033-32-NR-TRAN-SAM
!0504!     MOVE AS032-32-DT-TRANS       TO AS033-32-DT-TRANS
!0504!     MOVE AS032-32-HR-TRANS       TO AS033-32-HR-TRANS
!0504!
!0504!     MOVE AS032-32-NR-CHIP-CARTAO
!0504!       TO AS033-32-NR-CHIP-CARTAO                         (05:04)
!0504!
!0504!     MOVE AS032-32-CD-APLICACAO   TO AS033-32-CD-APLICACAO(03:02)
!0504!     MOVE AS032-32-NR-TRANSACAO   TO AS033-32-NR-TRANSACAO(03:02)
!0504!     MOVE AS032-32-NR-CARGA       TO AS033-32-NR-CARGA    (03:02)
!0504!
!0504!     MOVE AS032-32-VL-TRANS       TO AS033-32-VL-TRANS    (03:02)
!0504!
!0504!     MOVE AS032-32-VL-SALDO       TO AS033-32-VL-SALDO
!0504!
!0504!     MOVE AS032-32-CD-LINHA       TO AS033-32-CD-LINHA
!0504!     MOVE AS032-32-TX-ASSINATURA  TO AS033-32-TX-ASSINATURA
!0504!
!0504!     MOVE AS033-DETALHE-32        TO AS031-DETALHE-32
!0504!
!0504!     MOVE AS031-32-TP-REGISTRO    TO AS030-32-TP-REGISTRO
!0504!     MOVE AS031-32-NR-TRAN-SAM    TO AS030-32-NR-TRAN-SAM
!0504!     MOVE AS031-32-DT-TRANS       TO AS030-32-DT-TRANS
!0504!     MOVE AS031-32-HR-TRANS       TO AS030-32-HR-TRANS
!0504!
!0504!     MOVE AS031-32-NR-CHIP-CARTAO TO AS030-32-NR-CHIP-CARTAO
!0504!     MOVE AS031-32-CD-APLICACAO   TO AS030-32-CD-APLICACAO
!0504!     MOVE AS031-32-NR-TRANSACAO   TO AS030-32-NR-TRANSACAO
!0504!     MOVE AS031-32-NR-CARGA       TO AS030-32-NR-CARGA
!0504!
!0504!     MOVE AS031-32-VL-TRANS       TO AS030-32-VL-TRANS
!0504!
!0504!     MOVE AS031-32-VL-SALDO       TO AS030-32-VL-SALDO
!0504!
!0504!     MOVE AS031-32-CD-LINHA       TO AS030-32-CD-LINHA
!0504!     MOVE AS031-32-TX-ASSINATURA  TO AS030-32-TX-ASSINATURA
!0504!
!0504!*----------------------------------------------------------------*
!0504!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-32-DT-TRANS        TO W55-DDDD
!0504!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!0504!
!0504!     MOVE AS030-32-HR-TRANS        TO W55-HHMM-FT
!0504!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!0504!
!0504!     MOVE W55-AAAAMMDD             TO AS030-32C-DT-TRANS
!0504!                                      AS030-TXC-DT-TRANS
!0504!     MOVE W55-HHMMSS               TO AS030-32C-HR-TRANS
!0504!                                      AS030-TXC-HR-TRANS
!0504!
!0504!     MOVE AS030-32-VL-TRANS        TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-32C-VL-TRANS
!0504!
!0504!     MOVE AS030-32-VL-SALDO        TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-32C-VL-SALDO
!0504!
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-32-TX-CONTROLE     TO AS030-TX-CONTROLE
!0504!     MOVE AS030-32-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!0504!
!0504!*----------------------------------------------------------------*
!0504!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     ADD  1                            TO W81-VT99-QTD (32)
!0504!     ADD  AS030-32C-VL-TRANS           TO W81-VT99-VAL (32)
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 81100-MOVER-REG-33.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS032-REGISTRO          TO AS032-DETALHE-33
!0504!
!0504!     MOVE LOW-VALUES              TO AS033-DETALHE-33
!0504!
!0504!     MOVE AS032-33-TP-REGISTRO    TO AS033-33-TP-REGISTRO (02:01)
!0504!     MOVE AS032-33-NR-TRAN-SAM    TO AS033-33-NR-TRAN-SAM
!0504!     MOVE AS032-33-DT-TRANS       TO AS033-33-DT-TRANS
!0504!     MOVE AS032-33-HR-TRANS       TO AS033-33-HR-TRANS
!0504!
!0504!     MOVE AS032-33-NR-CHIP-CARTAO
!0504!       TO AS033-33-NR-CHIP-CARTAO                         (05:04)
!0504!
!0504!     MOVE AS032-33-CD-APLICACAO   TO AS033-33-CD-APLICACAO(03:02)
!0504!     MOVE AS032-33-NR-TRANSACAO   TO AS033-33-NR-TRANSACAO(03:02)
!0504!     MOVE AS032-33-NR-CARGA       TO AS033-33-NR-CARGA    (03:02)
!0504!
!0504!     MOVE AS032-33-VL-TRANS       TO AS033-33-VL-TRANS    (03:02)
!0504!
!0504!     MOVE AS032-33-VL-SALDO       TO AS033-33-VL-SALDO
!0504!
!0504!     MOVE AS032-33-CD-LINHA       TO AS033-33-CD-LINHA
!0504!     MOVE AS032-33-TX-ASSINATURA  TO AS033-33-TX-ASSINATURA
!0504!
!0504!     MOVE AS033-DETALHE-33        TO AS031-DETALHE-33
!0504!
!0504!     MOVE AS031-33-TP-REGISTRO    TO AS030-33-TP-REGISTRO
!0504!     MOVE AS031-33-NR-TRAN-SAM    TO AS030-33-NR-TRAN-SAM
!0504!     MOVE AS031-33-DT-TRANS       TO AS030-33-DT-TRANS
!0504!     MOVE AS031-33-HR-TRANS       TO AS030-33-HR-TRANS
!0504!
!0504!     MOVE AS031-33-NR-CHIP-CARTAO TO AS030-33-NR-CHIP-CARTAO
!0504!     MOVE AS031-33-CD-APLICACAO   TO AS030-33-CD-APLICACAO
!0504!     MOVE AS031-33-NR-TRANSACAO   TO AS030-33-NR-TRANSACAO
!0504!     MOVE AS031-33-NR-CARGA       TO AS030-33-NR-CARGA
!0504!
!0504!     MOVE AS031-33-VL-TRANS       TO AS030-33-VL-TRANS
!0504!
!0504!     MOVE AS031-33-VL-SALDO       TO AS030-33-VL-SALDO
!0504!
!0504!     MOVE AS031-33-CD-LINHA       TO AS030-33-CD-LINHA
!0504!     MOVE AS031-33-TX-ASSINATURA  TO AS030-33-TX-ASSINATURA
!0504!
!0504!*----------------------------------------------------------------*
!0504!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-33-DT-TRANS        TO W55-DDDD
!0504!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!0504!
!0504!     MOVE AS030-33-HR-TRANS        TO W55-HHMM-FT
!0504!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!0504!
!0504!     MOVE W55-AAAAMMDD             TO AS030-33C-DT-TRANS
!0504!                                      AS030-TXC-DT-TRANS
!0504!     MOVE W55-HHMMSS               TO AS030-33C-HR-TRANS
!0504!                                      AS030-TXC-HR-TRANS
!0504!
!0504!     MOVE AS030-33-VL-TRANS        TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-33C-VL-TRANS
!0504!
!0504!     MOVE AS030-33-VL-SALDO        TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-33C-VL-SALDO
!0504!
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-33-TX-CONTROLE     TO AS030-TX-CONTROLE
!0504!     MOVE AS030-33-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!0504!
!0504!*----------------------------------------------------------------*
!0504!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     ADD  1                            TO W81-VT99-QTD (33)
!0504!     ADD  AS030-33C-VL-TRANS           TO W81-VT99-VAL (33)
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 81100-MOVER-REG-34.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS032-REGISTRO          TO AS032-DETALHE-34
!0504!
!0504!     MOVE LOW-VALUES              TO AS033-DETALHE-34
!0504!
!0504!     MOVE AS032-34-TP-REGISTRO    TO AS033-34-TP-REGISTRO (02:01)
!0504!     MOVE AS032-34-NR-TRAN-SAM    TO AS033-34-NR-TRAN-SAM
!0504!     MOVE AS032-34-DT-TRANS       TO AS033-34-DT-TRANS
!0504!     MOVE AS032-34-HR-TRANS       TO AS033-34-HR-TRANS
!0504!
!0504!     MOVE AS032-34-NR-CHIP-CARTAO
!0504!       TO AS033-34-NR-CHIP-CARTAO                         (05:04)
!0504!
!0504!     MOVE AS032-34-CD-APLICACAO   TO AS033-34-CD-APLICACAO(03:02)
!0504!     MOVE AS032-34-NR-TRANSACAO   TO AS033-34-NR-TRANSACAO(03:02)
!0504!
!0504!     MOVE AS032-34-CD-APLICACAO-ANT
!0504!       TO AS033-34-CD-APLICACAO-ANT                       (03:02)
!0504!
!0504!     MOVE AS032-34-NR-TRANSACAO-ANT
!0504!       TO AS033-34-NR-TRANSACAO-ANT                       (03:02)
!0504!
!0504!     MOVE AS032-34-CT-INTEGRACOES TO AS033-34-CT-INTEGRACOES
!0504!                                                          (02:01)
!0504!     MOVE AS032-34-CD-INTEGRACAO  TO AS033-34-CD-INTEGRACAO
!3110!                                                          (03:02)
!0504!     MOVE AS032-34-NR-CARGA       TO AS033-34-NR-CARGA    (03:02)
!0504!
!0504!     MOVE AS032-34-VL-TARIFA-INTEGRACAO
!0504!       TO AS033-34-VL-TARIFA-INTEGRACAO                   (03:02)
!0504!
!0504!     MOVE AS032-34-VL-SALDO       TO AS033-34-VL-SALDO
!0504!
!0504!     MOVE AS032-34-CD-LINHA       TO AS033-34-CD-LINHA
!0504!     MOVE AS032-34-TX-ASSINATURA  TO AS033-34-TX-ASSINATURA
!0504!
!0504!     MOVE AS033-DETALHE-34          TO AS031-DETALHE-34
!0504!
!0504!     MOVE AS031-34-TP-REGISTRO      TO AS030-34-TP-REGISTRO
!0504!     MOVE AS031-34-NR-TRAN-SAM      TO AS030-34-NR-TRAN-SAM
!0504!     MOVE AS031-34-DT-TRANS         TO AS030-34-DT-TRANS
!0504!     MOVE AS031-34-HR-TRANS         TO AS030-34-HR-TRANS
!0504!
!0504!     MOVE AS031-34-NR-CHIP-CARTAO   TO AS030-34-NR-CHIP-CARTAO
!0504!     MOVE AS031-34-CD-APLICACAO     TO AS030-34-CD-APLICACAO
!0504!     MOVE AS031-34-NR-TRANSACAO     TO AS030-34-NR-TRANSACAO
!0504!     MOVE AS031-34-CD-APLICACAO-ANT TO AS030-34-CD-APLICACAO-ANT
!0504!     MOVE AS031-34-NR-TRANSACAO-ANT TO AS030-34-NR-TRANSACAO-ANT
!0504!     MOVE AS031-34-CT-INTEGRACOES   TO AS030-34-CT-INTEGRACOES
!0504!     MOVE AS031-34-CD-INTEGRACAO    TO AS030-34-CD-INTEGRACAO
!0504!     MOVE AS031-34-NR-CARGA         TO AS030-34-NR-CARGA
!0504!     MOVE AS031-34-VL-TARIFA-INTEGRACAO
!0504!       TO AS030-34-VL-TARIFA-INTEGRACAO
!0504!     MOVE AS031-34-VL-SALDO         TO AS030-34-VL-SALDO
!0504!
!0504!     MOVE AS031-34-CD-LINHA       TO AS030-34-CD-LINHA
!0504!     MOVE AS031-34-TX-ASSINATURA  TO AS030-34-TX-ASSINATURA
!0504!
!0504!*----------------------------------------------------------------*
!0504!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-34-DT-TRANS        TO W55-DDDD
!0504!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!0504!
!0504!     MOVE AS030-34-HR-TRANS        TO W55-HHMM-FT
!0504!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!0504!
!0504!     MOVE W55-AAAAMMDD             TO AS030-34C-DT-TRANS
!0504!                                      AS030-TXC-DT-TRANS
!0504!     MOVE W55-HHMMSS               TO AS030-34C-HR-TRANS
!0504!                                      AS030-TXC-HR-TRANS
!0504!
!0504!     MOVE AS030-34-VL-TARIFA-INTEGRACAO
!0504!                                   TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO
!0504!          AS030-34C-VL-TARIFA-INTEGRACAO
!0504!
!0504!     MOVE AS030-34-VL-SALDO        TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-34C-VL-SALDO
!0504!
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-34-TX-CONTROLE     TO AS030-TX-CONTROLE
!0504!     MOVE AS030-34-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!0504!
!0504!*----------------------------------------------------------------*
!0504!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     ADD  1                              TO W81-VT99-QTD (34)
!0504!     ADD  AS030-34C-VL-TARIFA-INTEGRACAO tO W81-VT99-VAL (34)
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 81100-MOVER-REG-41.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS032-REGISTRO          TO AS032-DETALHE-41
!0504!
!0504!     MOVE LOW-VALUES              TO AS033-DETALHE-41
!0504!
!0504!     MOVE AS032-41-TP-REGISTRO    TO AS033-41-TP-REGISTRO (02:01)
!0504!     MOVE AS032-41-NR-TRAN-SAM    TO AS033-41-NR-TRAN-SAM
!0504!     MOVE AS032-41-DT-TRANS       TO AS033-41-DT-TRANS
!0504!     MOVE AS032-41-HR-TRANS       TO AS033-41-HR-TRANS
!0504!
!0504!     MOVE AS032-41-NR-CHIP-CARTAO
!0504!       TO AS033-41-NR-CHIP-CARTAO                         (05:04)
!0504!
!0504!     MOVE AS032-41-CD-APLICACAO   TO AS033-41-CD-APLICACAO(03:02)
!0504!     MOVE AS032-41-NR-TRANSACAO   TO AS033-41-NR-TRANSACAO(03:02)
!0504!     MOVE AS032-41-CD-OPERACAO    TO AS033-41-CD-OPERACAO (02:01)
!0504!     MOVE AS032-41-NR-CARGA       TO AS033-41-NR-CARGA    (03:02)
!0504!     MOVE AS032-41-VL-CARGA       TO AS033-41-VL-CARGA    (03:02)
!0504!     MOVE AS032-41-VL-SALDO       TO AS033-41-VL-SALDO
!0504!
!0504!     MOVE AS032-41-CD-LINHA       TO AS033-41-CD-LINHA
!0504!     MOVE AS032-41-TX-ASSINATURA  TO AS033-41-TX-ASSINATURA
!0504!
!0504!     MOVE AS033-DETALHE-41        TO AS031-DETALHE-41
!0504!
!0504!     MOVE AS031-41-TP-REGISTRO    TO AS030-41-TP-REGISTRO
!0504!     MOVE AS031-41-NR-TRAN-SAM    TO AS030-41-NR-TRAN-SAM
!0504!     MOVE AS031-41-DT-TRANS       TO AS030-41-DT-TRANS
!0504!     MOVE AS031-41-HR-TRANS       TO AS030-41-HR-TRANS
!0504!
!0504!     MOVE AS031-41-NR-CHIP-CARTAO TO AS030-41-NR-CHIP-CARTAO
!0504!     MOVE AS031-41-CD-APLICACAO   TO AS030-41-CD-APLICACAO
!0504!     MOVE AS031-41-NR-TRANSACAO   TO AS030-41-NR-TRANSACAO
!0504!     MOVE AS031-41-CD-OPERACAO    TO AS030-41-CD-OPERACAO
!0504!     MOVE AS031-41-NR-CARGA       TO AS030-41-NR-CARGA
!0504!     MOVE AS031-41-VL-CARGA       TO AS030-41-VL-CARGA
!0504!     MOVE AS031-41-VL-SALDO       TO AS030-41-VL-SALDO
!0504!
!0504!     MOVE AS031-41-CD-LINHA       TO AS030-41-CD-LINHA
!0504!     MOVE AS031-41-TX-ASSINATURA  TO AS030-41-TX-ASSINATURA
!0504!
!0504!*----------------------------------------------------------------*
!0504!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-41-DT-TRANS        TO W55-DDDD
!0504!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!0504!
!0504!     MOVE AS030-41-HR-TRANS        TO W55-HHMM-FT
!0504!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!0504!
!0504!     MOVE W55-AAAAMMDD             TO AS030-41C-DT-TRANS
!0504!                                      AS030-TXC-DT-TRANS
!0504!     MOVE W55-HHMMSS               TO AS030-41C-HR-TRANS
!0504!                                      AS030-TXC-HR-TRANS
!0504!
!0504!     MOVE AS030-41-VL-CARGA        TO W55-VAL-FT
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-41C-VL-CARGA
!0504!
!0504!     MOVE AS030-41-VL-SALDO        TO W55-VAL-FT
!0504!
!!!!4!*    COMPUTE W55-VAL-FT = W55-VAL-FT - 4096
!0504!
!0504!     PERFORM 55500-CONVVL-VALFT-VAL
!0504!     MOVE W55-VAL                  TO AS030-41C-VL-SALDO
!0504!
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-41-TX-CONTROLE     TO AS030-TX-CONTROLE
!0504!     MOVE AS030-41-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!0504!
!0504!*----------------------------------------------------------------*
!0504!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     ADD  1                            TO W81-VT99-QTD (41)
!0504!     ADD  AS030-41C-VL-SALDO           TO W81-VT99-VAL (41)
!0504!     .
!1508!*----------------------------------------------------------------*
!1508! 81100-MOVER-REG-50.
!1508!*----------------------------------------------------------------*
!1508!
!1508!     MOVE AS032-REGISTRO           TO AS032-DETALHE-50
!1508!
!1508!     MOVE LOW-VALUES               TO AS033-DETALHE-50
!1508!
!1508!     MOVE AS032-50-TP-REGISTRO     TO AS033-50-TP-REGISTRO(02:01)
!1508!     MOVE AS032-50-NR-TRAN-SAM     TO AS033-50-NR-TRAN-SAM
!1508!     MOVE AS032-50-DT-TRANS        TO AS033-50-DT-TRANS
!1508!     MOVE AS032-50-HR-TRANS        TO AS033-50-HR-TRANS
!1508!
!1508!     MOVE AS032-50-NR-CHIP-CARTAO
!1508!       TO AS033-50-NR-CHIP-CARTAO                         (05:04)
!1508!
!1508!     MOVE AS032-50-TX-ASSINATURA   TO AS033-50-TX-ASSINATURA
!1508!
!1508!     MOVE AS033-DETALHE-50         TO AS031-DETALHE-50
!1508!
!1508!     MOVE AS031-50-TP-REGISTRO     TO AS030-50-TP-REGISTRO
!1508!     MOVE AS031-50-NR-TRAN-SAM     TO AS030-50-NR-TRAN-SAM
!1508!     MOVE AS031-50-DT-TRANS        TO AS030-50-DT-TRANS
!1508!     MOVE AS031-50-HR-TRANS        TO AS030-50-HR-TRANS
!1508!
!1508!     MOVE AS031-50-NR-CHIP-CARTAO  TO AS030-50-NR-CHIP-CARTAO
!1508!     MOVE AS031-50-TX-ASSINATURA   TO AS030-50-TX-ASSINATURA
!1508!
!1508!*----------------------------------------------------------------*
!1508!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!1508!*----------------------------------------------------------------*
!1508!
!1508!     MOVE AS030-50-DT-TRANS        TO W55-DDDD
!1508!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!1508!
!1508!     MOVE AS030-50-HR-TRANS        TO W55-HHMM-FT
!1508!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!1508!
!1508!     MOVE W55-AAAAMMDD             TO AS030-50C-DT-TRANS
!1508!                                      AS030-TXC-DT-TRANS
!1508!     MOVE W55-HHMMSS               TO AS030-50C-HR-TRANS
!1508!                                      AS030-TXC-HR-TRANS
!1508!
!1508!*----------------------------------------------------------------*
!1508!
!1508!     MOVE AS030-50-TX-CONTROLE     TO AS030-TX-CONTROLE
!1508!     MOVE AS030-50-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!1508!
!1508!*----------------------------------------------------------------*
!1508!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!1508!*----------------------------------------------------------------*
!1508!
!1508!     ADD  1                            TO W81-VT99-QTD (50)
!1508!     .
!1508!*----------------------------------------------------------------*
!1508! 81100-MOVER-REG-51.
!1508!*----------------------------------------------------------------*
!1508!
!1508!     MOVE AS032-REGISTRO           TO AS032-DETALHE-51
!1508!
!1508!     MOVE LOW-VALUES               TO AS033-DETALHE-51
!1508!
!1508!     MOVE AS032-51-TP-REGISTRO     TO AS033-51-TP-REGISTRO(02:01)
!1508!     MOVE AS032-51-NR-TRAN-SAM     TO AS033-51-NR-TRAN-SAM
!1508!     MOVE AS032-51-DT-TRANS        TO AS033-51-DT-TRANS
!1508!     MOVE AS032-51-HR-TRANS        TO AS033-51-HR-TRANS
!1508!
!1508!     MOVE AS032-51-NR-CHIP-CARTAO
!1508!       TO AS033-51-NR-CHIP-CARTAO                         (05:04)
!1508!
!1508!     MOVE AS033-DETALHE-51         TO AS031-DETALHE-51
!1508!
!1508!     MOVE AS031-51-TP-REGISTRO     TO AS030-51-TP-REGISTRO
!1508!     MOVE AS031-51-NR-TRAN-SAM     TO AS030-51-NR-TRAN-SAM
!1508!     MOVE AS031-51-DT-TRANS        TO AS030-51-DT-TRANS
!1508!     MOVE AS031-51-HR-TRANS        TO AS030-51-HR-TRANS
!1508!
!1508!     MOVE AS031-51-NR-CHIP-CARTAO  TO AS030-51-NR-CHIP-CARTAO
!1508!
!1508!*----------------------------------------------------------------*
!1508!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!1508!*----------------------------------------------------------------*
!1508!
!1508!     MOVE AS030-51-DT-TRANS        TO W55-DDDD
!1508!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!1508!
!1508!     MOVE AS030-51-HR-TRANS        TO W55-HHMM-FT
!1508!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!1508!
!1508!     MOVE W55-AAAAMMDD             TO AS030-51C-DT-TRANS
!1508!                                      AS030-TXC-DT-TRANS
!1508!     MOVE W55-HHMMSS               TO AS030-51C-HR-TRANS
!1508!                                      AS030-TXC-HR-TRANS
!1508!
!1508!*----------------------------------------------------------------*
!1508!
!1508!     MOVE AS030-51-TX-CONTROLE     TO AS030-TX-CONTROLE
!1508!     MOVE AS030-51-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!1508!
!1508!*----------------------------------------------------------------*
!1508!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!1508!*----------------------------------------------------------------*
!1508!
!1508!     ADD  1                            TO W81-VT99-QTD (51)
!1508!     .
      *----------------------------------------------------------------*
       81100-MOVER-REG-97.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO          TO AS032-TRAILER-97

           MOVE LOW-VALUES              TO AS033-TRAILER-97

           MOVE AS032-97-TP-REGISTRO    TO AS033-97-TP-REGISTRO (02:01)
           MOVE AS032-97-NR-TRAN-SAM    TO AS033-97-NR-TRAN-SAM
           MOVE AS032-97-DT-TRANS       TO AS033-97-DT-TRANS
           MOVE AS032-97-HR-TRANS       TO AS033-97-HR-TRANS

           MOVE AS033-TRAILER-97        TO AS031-TRAILER-97

           MOVE AS031-97-TP-REGISTRO    TO AS030-97-TP-REGISTRO
           MOVE AS031-97-NR-TRAN-SAM    TO AS030-97-NR-TRAN-SAM
           MOVE AS031-97-DT-TRANS       TO AS030-97-DT-TRANS
           MOVE AS031-97-HR-TRANS       TO AS030-97-HR-TRANS

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-97-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-97-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-97C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-97C-HR-TRANS
                                            AS030-TXC-HR-TRANS

      *----------------------------------------------------------------*

           MOVE AS030-97-TX-CONTROLE     TO AS030-TX-CONTROLE

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (97)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-98.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO          TO AS032-TRAILER-98

           MOVE LOW-VALUES              TO AS033-TRAILER-98

           MOVE AS032-98-TP-REGISTRO    TO AS033-98-TP-REGISTRO (02:01)
           MOVE AS032-98-NR-TRAN-SAM    TO AS033-98-NR-TRAN-SAM
           MOVE AS032-98-DT-TRANS       TO AS033-98-DT-TRANS
           MOVE AS032-98-HR-TRANS       TO AS033-98-HR-TRANS

           MOVE AS033-TRAILER-98        TO AS031-TRAILER-98

           MOVE AS031-98-TP-REGISTRO    TO AS030-98-TP-REGISTRO
           MOVE AS031-98-NR-TRAN-SAM    TO AS030-98-NR-TRAN-SAM
           MOVE AS031-98-DT-TRANS       TO AS030-98-DT-TRANS
           MOVE AS031-98-HR-TRANS       TO AS030-98-HR-TRANS

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-98-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-98-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-98C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-98C-HR-TRANS
                                            AS030-TXC-HR-TRANS

      *----------------------------------------------------------------*

           MOVE AS030-98-TX-CONTROLE     TO AS030-TX-CONTROLE

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (98)
           .
      *----------------------------------------------------------------*
       81100-MOVER-REG-99.
      *----------------------------------------------------------------*

           MOVE AS032-REGISTRO          TO AS032-TRAILER-99

           MOVE LOW-VALUES              TO AS033-TRAILER-99

           MOVE AS032-99-TP-REGISTRO    TO AS033-99-TP-REGISTRO (02:01)
           MOVE AS032-99-NR-TRAN-SAM    TO AS033-99-NR-TRAN-SAM
           MOVE AS032-99-DT-TRANS       TO AS033-99-DT-TRANS
           MOVE AS032-99-HR-TRANS       TO AS033-99-HR-TRANS

           MOVE AS032-99-TX-DADOS       TO AS033-99-TX-DADOS

           MOVE AS033-TRAILER-99        TO AS031-TRAILER-99

           MOVE AS031-99-TP-REGISTRO    TO AS030-99-TP-REGISTRO
           MOVE AS031-99-NR-TRAN-SAM    TO AS030-99-NR-TRAN-SAM
           MOVE AS031-99-DT-TRANS       TO AS030-99-DT-TRANS
           MOVE AS031-99-HR-TRANS       TO AS030-99-HR-TRANS

           MOVE AS031-99-TX-DADOS       TO AS030-99-TX-DADOS

           MOVE 60                       TO C2EBCDIC-LEN
           MOVE AS030-99-TX-DADOS (1:60) TO C2EBCDIC-CAMPO
           CALL C2EBCDIC USING C2EBCDIC-PARM
           MOVE C2EBCDIC-CAMPO    (1:60) TO AS030-99-TX-DADOS (1:60)

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-99-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-99-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-99C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-99C-HR-TRANS
                                            AS030-TXC-HR-TRANS

           MOVE AS030-99-VL-TRANS-DEB    TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-99C-VL-TRANS-DEB

           MOVE AS030-99-VL-TRANS-CRED   TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-99C-VL-TRANS-CRED

           MOVE AS030-99-VL-TOT-CR-FSAM  TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-99C-VL-TOT-CR-FSAM

      *----------------------------------------------------------------*

           MOVE AS030-99-TX-CONTROLE    TO AS030-TX-CONTROLE

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (99)
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-CONTROLE.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '-------------------- '
           DISPLAY 'REGISTRO de CONTROLE '
           DISPLAY '-------------------- '
           DISPLAY ' '

           DISPLAY 'AS030-TX-TP-REGISTRO    =' AS030-TX-TP-REGISTRO
           DISPLAY 'AS030-TX-NR-TRAN-SAM    =' AS030-TX-NR-TRAN-SAM
           DISPLAY 'AS030-TX-DT-TRANS       =' AS030-TX-DT-TRANS
           DISPLAY 'AS030-TX-HR-TRANS       =' AS030-TX-HR-TRANS
           DISPLAY 'AS030-TX-NR-CHIP-CARTAO =' AS030-TX-NR-CHIP-CARTAO
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-01.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '-------------------------'
           DISPLAY 'REGISTRO TIPO 01 - HEADER'
           DISPLAY '-------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-01-TP-REGISTRO    =' AS030-01-TP-REGISTRO
           DISPLAY 'AS030-01-NM-ARQUIVO     =' AS030-01-NM-ARQUIVO
           DISPLAY 'AS030-01-NR-VERSAO      =' AS030-01-NR-VERSAO
           DISPLAY 'AS030-01-CD-SINDICATO   =' AS030-01-CD-SINDICATO
           DISPLAY 'AS030-01-CD-OPERADOR    =' AS030-01-CD-OPERADOR
           DISPLAY 'AS030-01-CD-FORNECEDOR  =' AS030-01-CD-FORNECEDOR
           DISPLAY 'AS030-01-NR-VALIDADOR   =' AS030-01-NR-VALIDADOR
           DISPLAY 'AS030-01-NR-CHIP-SAM    =' AS030-01-NR-CHIP-SAM
           DISPLAY 'AS030-01-NR-SEQ-ARQUIVO =' AS030-01-NR-SEQ-ARQUIVO
           DISPLAY 'AS030-01-DT-GERACAO-ARQ =' AS030-01-DT-GERACAO-ARQ
                   ' CONVERTIDA ---> '         AS030-01c-DT-GERACAO-ARQ
           DISPLAY 'AS030-01-HM-GERACAO-ARQ =' AS030-01-HM-GERACAO-ARQ
           DISPLAY 'AS030-01-CD-MOEDA       =' AS030-01-CD-MOEDA
           DISPLAY 'AS030-01-IN-CRIPTOGRAFIA=' AS030-01-IN-CRIPTOGRAFIA
           DISPLAY 'AS030-01-TX-CHAVE-DES   =' AS030-01-TX-CHAVE-DES
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-02.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '--------------------------------------'
           DISPLAY 'REGISTRO TIPO 02 - ABERTURA ARQ.LOGICO'
           DISPLAY '--------------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-02-TP-REGISTRO    =' AS030-02-TP-REGISTRO
           DISPLAY 'AS030-02-NR-TRAN-SAM    =' AS030-02-NR-TRAN-SAM
           DISPLAY 'AS030-02-DT-TRANS       =' AS030-02-DT-TRANS
                   ' CONVERTIDA ---> '         AS030-02C-DT-TRANS
           DISPLAY 'AS030-02-HR-TRANS       =' AS030-02-HR-TRANS
                   ' CONVERTIDA ---> '         AS030-02C-HR-TRANS
           DISPLAY 'AS030-02-NR-ARQ-LOG     =' AS030-02-NR-ARQ-LOG
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-03.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '-------------------------'
           DISPLAY 'REGISTRO TIPO 03 - LINHA'
           DISPLAY '-------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-03-TP-REGISTRO =' AS030-03-TP-REGISTRO
           DISPLAY 'AS030-03-NR-TRAN-SAM =' AS030-03-NR-TRAN-SAM
           DISPLAY 'AS030-03-DT-TRANS    =' AS030-03-DT-TRANS
                   ' CONVERTIDA ---> '      AS030-03C-DT-TRANS
           DISPLAY 'AS030-03-HR-TRANS    =' AS030-03-HR-TRANS
                   ' CONVERTIDA ---> '      AS030-03C-HR-TRANS
           DISPLAY 'AS030-03-NR-ESTACAO-C=' AS030-03-NR-ESTACAO-CARRO
           DISPLAY 'AS030-03-CD-LINHA    =' AS030-03-CD-LINHA
           DISPLAY 'AS030-03-CD-SENTIDO  =' AS030-03-CD-SENTIDO
           DISPLAY 'AS030-03-NR-SECAO    =' AS030-03-NR-SECAO
           DISPLAY 'AS030-03-VL-TARIFA-AT=' AS030-03-VL-TARIFA-ATU
                   ' CONVERTIDO ---> '      AS030-03C-VL-TARIFA-ATU
           DISPLAY 'AS030-03-DT-INIC-TARI=' AS030-03-DT-INIC-TARIFA-ATU
                   ' CONVERTIDA ---> '      AS030-03C-DT-INIC-TARIFA-ATU
           DISPLAY 'AS030-03-VL-TARIFA-AN=' AS030-03-VL-TARIFA-ANT
                   ' CONVERTIDO ---> '      AS030-03C-VL-TARIFA-ANT
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-04.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '--------------------------------'
           DISPLAY 'REGISTRO TIPO 04 - CANCELAMENTO'
           DISPLAY '--------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-04-TP-REGISTRO      =' AS030-04-TP-REGISTRO
           DISPLAY 'AS030-04-NR-TRAN-SAM      =' AS030-04-NR-TRAN-SAM
           DISPLAY 'AS030-04-DT-TRANS         =' AS030-04-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-04C-DT-TRANS
           DISPLAY 'AS030-04-HR-TRANS         =' AS030-04-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-04C-HR-TRANS
           DISPLAY 'AS030-04-NR-CHIP-CARTAO   =' AS030-04-NR-CHIP-CARTAO
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-05.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '---------------------------'
           DISPLAY 'REGISTRO TIPO 05 - BLOQUEIO'
           DISPLAY '---------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-05-TP-REGISTRO      =' AS030-05-TP-REGISTRO
           DISPLAY 'AS030-05-NR-TRAN-SAM      =' AS030-05-NR-TRAN-SAM
           DISPLAY 'AS030-05-DT-TRANS         =' AS030-05-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-05C-DT-TRANS
           DISPLAY 'AS030-05-HR-TRANS         =' AS030-05-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-05C-HR-TRANS
           DISPLAY 'AS030-05-NR-CHIP-CARTAO   =' AS030-05-NR-CHIP-CARTAO
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-06.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '------------------------------'
           DISPLAY 'REGISTRO TIPO 06 - DESBLOQUEIO'
           DISPLAY '------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-06-TP-REGISTRO      =' AS030-06-TP-REGISTRO
           DISPLAY 'AS030-06-NR-TRAN-SAM      =' AS030-06-NR-TRAN-SAM
           DISPLAY 'AS030-06-DT-TRANS         =' AS030-06-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-06C-DT-TRANS
           DISPLAY 'AS030-06-HR-TRANS         =' AS030-06-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-06C-HR-TRANS
           DISPLAY 'AS030-06-NR-CHIP-CARTAO   =' AS030-06-NR-CHIP-CARTAO
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-11.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '--------------------------------------'
           DISPLAY 'REGISTRO TIPO 11 - DEBITO TARIFA ATUAL'
           DISPLAY '--------------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-11-TP-REGISTRO      =' AS030-11-TP-REGISTRO
           DISPLAY 'AS030-11-NR-TRAN-SAM      =' AS030-11-NR-TRAN-SAM
           DISPLAY 'AS030-11-DT-TRANS         =' AS030-11-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-11C-DT-TRANS
           DISPLAY 'AS030-11-HR-TRANS         =' AS030-11-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-11C-HR-TRANS
           DISPLAY 'AS030-11-NR-CHIP-CARTAO   =' AS030-11-NR-CHIP-CARTAO
           DISPLAY 'AS030-11-CD-APLICACAO     =' AS030-11-CD-APLICACAO
           DISPLAY 'AS030-11-NR-TRANSACAO     =' AS030-11-NR-TRANSACAO
           DISPLAY 'AS030-11-NR-CARGA         =' AS030-11-NR-CARGA
           DISPLAY 'AS030-11-VL-TRANS         =' AS030-11-VL-TRANS
                   ' CONVERTIDO ---> '           AS030-11C-VL-TRANS
           DISPLAY 'AS030-11-VL-SALDO         =' AS030-11-VL-SALDO
                   ' CONVERTIDO ---> '           AS030-11C-VL-SALDO
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-12.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '-----------------------------------------'
           DISPLAY 'REGISTRO TIPO 12 - DEBITO TARIFA ANTERIOR'
           DISPLAY '-----------------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-12-TP-REGISTRO      =' AS030-12-TP-REGISTRO
           DISPLAY 'AS030-12-NR-TRAN-SAM      =' AS030-12-NR-TRAN-SAM
           DISPLAY 'AS030-12-DT-TRANS         =' AS030-12-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-12C-DT-TRANS
           DISPLAY 'AS030-12-HR-TRANS         =' AS030-12-HR-TRANS
                   ' CONVERTIDO ---> '           AS030-12C-HR-TRANS
           DISPLAY 'AS030-12-NR-CHIP-CARTAO   =' AS030-12-NR-CHIP-CARTAO
           DISPLAY 'AS030-12-CD-APLICACAO     =' AS030-12-CD-APLICACAO
           DISPLAY 'AS030-12-NR-TRANSACAO     =' AS030-12-NR-TRANSACAO
           DISPLAY 'AS030-12-NR-CARGA         =' AS030-12-NR-CARGA
           DISPLAY 'AS030-12-VL-TRANS         =' AS030-12-VL-TRANS
                   ' CONVERTIDO ---> '           AS030-12C-VL-TRANS
           DISPLAY 'AS030-12-VL-SALDO         =' AS030-12-VL-SALDO
                   ' CONVERTIDO ---> '           AS030-12C-VL-SALDO
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-13.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '--------------------------------------------'
           DISPLAY 'REGISTRO TIPO 13 - DEBITO TARIFA PROMOCIONAL'
           DISPLAY '--------------------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-13-TP-REGIST=' AS030-13-TP-REGISTRO
           DISPLAY 'AS030-13-NR-TRAN-S=' AS030-13-NR-TRAN-SAM
           DISPLAY 'AS030-13-DT-TRANS =' AS030-13-DT-TRANS
                   ' CONVERTIDA ---> '   AS030-13C-DT-TRANS
           DISPLAY 'AS030-13-HR-TRANS =' AS030-13-HR-TRANS
                   ' CONVERTIDA ---> '   AS030-13C-HR-TRANS
           DISPLAY 'AS030-13-NR-CHIP-C=' AS030-13-NR-CHIP-CARTAO
           DISPLAY 'AS030-13-CD-APLICA=' AS030-13-CD-APLICACAO
           DISPLAY 'AS030-13-NR-TRANSA=' AS030-13-NR-TRANSACAO
           DISPLAY 'AS030-13-NR-CARGA =' AS030-13-NR-CARGA
           DISPLAY 'AS030-13-VL-TRANS =' AS030-13-VL-TRANS
                   ' CONVERTIDO ---> '   AS030-13C-VL-TRANS
           DISPLAY 'AS030-13-VL-SALDO =' AS030-13-VL-SALDO
                   ' CONVERTIDO ---> '   AS030-13C-VL-SALDO
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-14.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '-----------------------------'
           DISPLAY 'REGISTRO TIPO 14 - INTEGRACAO'
           DISPLAY '-----------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-14-TP-REGISTR=' AS030-14-TP-REGISTRO
           DISPLAY 'AS030-14-NR-TRAN-SA=' AS030-14-NR-TRAN-SAM
           DISPLAY 'AS030-14-DT-TRANS  =' AS030-14-DT-TRANS
                   ' CONVERTIDA ---> '    AS030-14C-DT-TRANS
           DISPLAY 'AS030-14-HR-TRANS  =' AS030-14-HR-TRANS
                   ' CONVERTIDA ---> '    AS030-14C-HR-TRANS
           DISPLAY 'AS030-14-NR-CHIP-CA=' AS030-14-NR-CHIP-CARTAO
           DISPLAY 'AS030-14-CD-APLICAC=' AS030-14-CD-APLICACAO
           DISPLAY 'AS030-14-NR-TRANSAC=' AS030-14-NR-TRANSACAO
           DISPLAY 'AS030-14-CD-APLI-AN=' AS030-14-CD-APLICACAO-ANT
           DISPLAY 'AS030-14-NR-TRAN-AN=' AS030-14-NR-TRANSACAO-ANT
           DISPLAY 'AS030-14-CT-INTEGRA=' AS030-14-CT-INTEGRACOES
           DISPLAY 'AS030-14-CD-INTEGRA=' AS030-14-CD-INTEGRACAO
           DISPLAY 'AS030-14-NR-CARGA  =' AS030-14-NR-CARGA
           DISPLAY 'AS030-14-VL-INTEGRA=' AS030-14-VL-TARIFA-INTEGRACAO
                   ' CONVERTIDO ---> '    AS030-14C-VL-TARIFA-INTEGRACAO
           DISPLAY 'AS030-14-VL-SALDO  =' AS030-14-VL-SALDO
                   ' CONVERTIDO ---> '    AS030-14C-VL-SALDO
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-21.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '------------------------'
           DISPLAY 'REGISTRO TIPO 21 - CARGA     '
           DISPLAY '------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-21-TP-REGISTRO      =' AS030-21-TP-REGISTRO
           DISPLAY 'AS030-21-NR-TRAN-SAM      =' AS030-21-NR-TRAN-SAM
           DISPLAY 'AS030-21-DT-TRANS         =' AS030-21-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-21C-DT-TRANS
           DISPLAY 'AS030-21-HR-TRANS         =' AS030-21-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-21C-HR-TRANS
           DISPLAY 'AS030-21-NR-CHIP-CARTAO   =' AS030-21-NR-CHIP-CARTAO
           DISPLAY 'AS030-21-CD-APLICACAO     =' AS030-21-CD-APLICACAO
           DISPLAY 'AS030-21-NR-TRANSACAO     =' AS030-21-NR-TRANSACAO
           DISPLAY 'AS030-21-CD-OPERACAO      =' AS030-21-CD-OPERACAO
           DISPLAY 'AS030-21-NR-CARGA         =' AS030-21-NR-CARGA
           DISPLAY 'AS030-21-VL-CARGA         =' AS030-21-VL-CARGA
                   ' CONVERTIDO ---> '           AS030-21C-VL-CARGA
           DISPLAY 'AS030-21-VL-SALDO         =' AS030-21-VL-SALDO
                   ' CONVERTIDO ---> '           AS030-21C-VL-SALDO
           .
!0504!*----------------------------------------------------------------*
!0504! 82000-DISPLAY-REG-31.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     DISPLAY ' '
!0504!     DISPLAY '--------------------------------------'
!0504!     DISPLAY 'REGISTRO TIPO 31 - DEBITO TARIFA ATUAL'
!0504!     DISPLAY '--------------------------------------'
!0504!     DISPLAY ' '
!0504!
!0504!     DISPLAY 'AS030-31-TP-REGISTRO      =' AS030-31-TP-REGISTRO
!0504!     DISPLAY 'AS030-31-NR-TRAN-SAM      =' AS030-31-NR-TRAN-SAM
!0504!     DISPLAY 'AS030-31-DT-TRANS         =' AS030-31-DT-TRANS
!0504!             ' CONVERTIDA ---> '           AS030-31C-DT-TRANS
!0504!     DISPLAY 'AS030-31-HR-TRANS         =' AS030-31-HR-TRANS
!0504!             ' CONVERTIDA ---> '           AS030-31C-HR-TRANS
!0504!     DISPLAY 'AS030-31-NR-CHIP-CARTAO   =' AS030-31-NR-CHIP-CARTAO
!0504!     DISPLAY 'AS030-31-CD-APLICACAO     =' AS030-31-CD-APLICACAO
!0504!     DISPLAY 'AS030-31-NR-TRANSACAO     =' AS030-31-NR-TRANSACAO
!0504!     DISPLAY 'AS030-31-NR-CARGA         =' AS030-31-NR-CARGA
!0504!     DISPLAY 'AS030-31-VL-TRANS         =' AS030-31-VL-TRANS
!0504!             ' CONVERTIDO ---> '           AS030-31C-VL-TRANS
!0504!     DISPLAY 'AS030-31-VL-SALDO         =' AS030-31-VL-SALDO
!0504!             ' CONVERTIDO ---> '           AS030-31C-VL-SALDO
!0504!     DISPLAY 'AS030-31-CD-LINHA         =' AS030-31-CD-LINHA
!0504!     DISPLAY 'AS030-31-TX-ASSINATURA    =' AS030-31-TX-ASSINATURA
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 82000-DISPLAY-REG-32.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     DISPLAY ' '
!0504!     DISPLAY '-----------------------------------------'
!0504!     DISPLAY 'REGISTRO TIPO 32 - DEBITO TARIFA ANTERIOR'
!0504!     DISPLAY '-----------------------------------------'
!0504!     DISPLAY ' '
!0504!
!0504!     DISPLAY 'AS030-32-TP-REGISTRO      =' AS030-32-TP-REGISTRO
!0504!     DISPLAY 'AS030-32-NR-TRAN-SAM      =' AS030-32-NR-TRAN-SAM
!0504!     DISPLAY 'AS030-32-DT-TRANS         =' AS030-32-DT-TRANS
!0504!             ' CONVERTIDA ---> '           AS030-32C-DT-TRANS
!0504!     DISPLAY 'AS030-32-HR-TRANS         =' AS030-32-HR-TRANS
!0504!             ' CONVERTIDO ---> '           AS030-32C-HR-TRANS
!0504!     DISPLAY 'AS030-32-NR-CHIP-CARTAO   =' AS030-32-NR-CHIP-CARTAO
!0504!     DISPLAY 'AS030-32-CD-APLICACAO     =' AS030-32-CD-APLICACAO
!0504!     DISPLAY 'AS030-32-NR-TRANSACAO     =' AS030-32-NR-TRANSACAO
!0504!     DISPLAY 'AS030-32-NR-CARGA         =' AS030-32-NR-CARGA
!0504!     DISPLAY 'AS030-32-VL-TRANS         =' AS030-32-VL-TRANS
!0504!             ' CONVERTIDO ---> '           AS030-32C-VL-TRANS
!0504!     DISPLAY 'AS030-32-VL-SALDO         =' AS030-32-VL-SALDO
!0504!             ' CONVERTIDO ---> '           AS030-32C-VL-SALDO
!0504!     DISPLAY 'AS030-32-CD-LINHA         =' AS030-32-CD-LINHA
!0504!     DISPLAY 'AS030-32-TX-ASSINATURA    =' AS030-32-TX-ASSINATURA
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 82000-DISPLAY-REG-33.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     DISPLAY ' '
!0504!     DISPLAY '--------------------------------------------'
!0504!     DISPLAY 'REGISTRO TIPO 33 - DEBITO TARIFA PROMOCIONAL'
!0504!     DISPLAY '--------------------------------------------'
!0504!     DISPLAY ' '
!0504!
!0504!     DISPLAY 'AS030-33-TP-REGIST=' AS030-33-TP-REGISTRO
!0504!     DISPLAY 'AS030-33-NR-TRAN-S=' AS030-33-NR-TRAN-SAM
!0504!     DISPLAY 'AS030-33-DT-TRANS =' AS030-33-DT-TRANS
!0504!             ' CONVERTIDA ---> '   AS030-33C-DT-TRANS
!0504!     DISPLAY 'AS030-33-HR-TRANS =' AS030-33-HR-TRANS
!0504!             ' CONVERTIDA ---> '   AS030-33C-HR-TRANS
!0504!     DISPLAY 'AS030-33-NR-CHIP-C=' AS030-33-NR-CHIP-CARTAO
!0504!     DISPLAY 'AS030-33-CD-APLICA=' AS030-33-CD-APLICACAO
!0504!     DISPLAY 'AS030-33-NR-TRANSA=' AS030-33-NR-TRANSACAO
!0504!     DISPLAY 'AS030-33-NR-CARGA =' AS030-33-NR-CARGA
!0504!     DISPLAY 'AS030-33-VL-TRANS =' AS030-33-VL-TRANS
!0504!             ' CONVERTIDO ---> '   AS030-33C-VL-TRANS
!0504!     DISPLAY 'AS030-33-VL-SALDO =' AS030-33-VL-SALDO
!0504!             ' CONVERTIDO ---> '   AS030-33C-VL-SALDO
!0504!     DISPLAY 'AS030-33-CD-LINHA         =' AS030-33-CD-LINHA
!0504!     DISPLAY 'AS030-33-TX-ASSINATURA    =' AS030-33-TX-ASSINATURA
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 82000-DISPLAY-REG-34.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     DISPLAY ' '
!0504!     DISPLAY '-----------------------------'
!0504!     DISPLAY 'REGISTRO TIPO 34 - INTEGRACAO'
!0504!     DISPLAY '-----------------------------'
!0504!     DISPLAY ' '
!0504!
!0504!     DISPLAY 'AS030-34-TP-REGISTR=' AS030-34-TP-REGISTRO
!0504!     DISPLAY 'AS030-34-NR-TRAN-SA=' AS030-34-NR-TRAN-SAM
!0504!     DISPLAY 'AS030-34-DT-TRANS  =' AS030-34-DT-TRANS
!0504!             ' CONVERTIDA ---> '    AS030-34C-DT-TRANS
!0504!     DISPLAY 'AS030-34-HR-TRANS  =' AS030-34-HR-TRANS
!0504!             ' CONVERTIDA ---> '    AS030-34C-HR-TRANS
!0504!     DISPLAY 'AS030-34-NR-CHIP-CA=' AS030-34-NR-CHIP-CARTAO
!0504!     DISPLAY 'AS030-34-CD-APLICAC=' AS030-34-CD-APLICACAO
!0504!     DISPLAY 'AS030-34-NR-TRANSAC=' AS030-34-NR-TRANSACAO
!0504!     DISPLAY 'AS030-34-CD-APLI-AN=' AS030-34-CD-APLICACAO-ANT
!0504!     DISPLAY 'AS030-34-NR-TRAN-AN=' AS030-34-NR-TRANSACAO-ANT
!0504!     DISPLAY 'AS030-34-CT-INTEGRA=' AS030-34-CT-INTEGRACOES
!0504!     DISPLAY 'AS030-34-CD-INTEGRA=' AS030-34-CD-INTEGRACAO
!0504!     DISPLAY 'AS030-34-NR-CARGA  =' AS030-34-NR-CARGA
!0504!     DISPLAY 'AS030-34-VL-INTEGRA=' AS030-34-VL-TARIFA-INTEGRACAO
!0504!             ' CONVERTIDO ---> '    AS030-34C-VL-TARIFA-INTEGRACAO
!0504!     DISPLAY 'AS030-34-VL-SALDO  =' AS030-34-VL-SALDO
!0504!             ' CONVERTIDO ---> '    AS030-34C-VL-SALDO
!0504!     DISPLAY 'AS030-34-CD-LINHA  =' AS030-34-CD-LINHA
!0504!     DISPLAY 'AS030-34-TX-ASSINAT=' AS030-34-TX-ASSINATURA
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 82000-DISPLAY-REG-41.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     DISPLAY ' '
!0504!     DISPLAY '------------------------'
!0504!     DISPLAY 'REGISTRO TIPO 41 - CARGA     '
!0504!     DISPLAY '------------------------'
!0504!     DISPLAY ' '
!0504!
!0504!     DISPLAY 'AS030-41-TP-REGISTRO      =' AS030-41-TP-REGISTRO
!0504!     DISPLAY 'AS030-41-NR-TRAN-SAM      =' AS030-41-NR-TRAN-SAM
!0504!     DISPLAY 'AS030-41-DT-TRANS         =' AS030-41-DT-TRANS
!0504!             ' CONVERTIDA ---> '           AS030-41C-DT-TRANS
!0504!     DISPLAY 'AS030-41-HR-TRANS         =' AS030-41-HR-TRANS
!0504!             ' CONVERTIDA ---> '           AS030-41C-HR-TRANS
!0504!     DISPLAY 'AS030-41-NR-CHIP-CARTAO   =' AS030-41-NR-CHIP-CARTAO
!0504!     DISPLAY 'AS030-41-CD-APLICACAO     =' AS030-41-CD-APLICACAO
!0504!     DISPLAY 'AS030-41-NR-TRANSACAO     =' AS030-41-NR-TRANSACAO
!0504!     DISPLAY 'AS030-41-CD-OPERACAO      =' AS030-41-CD-OPERACAO
!0504!     DISPLAY 'AS030-41-NR-CARGA         =' AS030-41-NR-CARGA
!0504!     DISPLAY 'AS030-41-VL-CARGA         =' AS030-41-VL-CARGA
!0504!             ' CONVERTIDO ---> '           AS030-41C-VL-CARGA
!0504!     DISPLAY 'AS030-41-VL-SALDO         =' AS030-41-VL-SALDO
!0504!             ' CONVERTIDO ---> '           AS030-41C-VL-SALDO
!0504!     DISPLAY 'AS030-41-CD-LINHA         =' AS030-41-CD-LINHA
!0504!     DISPLAY 'AS030-41-TX-ASSINATURA    =' AS030-41-TX-ASSINATURA
!0504!     .
!1508!*----------------------------------------------------------------*
!1508! 82000-DISPLAY-REG-50.
!1508!*----------------------------------------------------------------*
!1508!
!1508!     DISPLAY ' '
!1508!     DISPLAY '---------------------------'
!1508!     DISPLAY 'REGISTRO TIPO 50 - ASSINATU'
!1508!     DISPLAY '---------------------------'
!1508!     DISPLAY ' '
!1508!
!1508!     DISPLAY 'AS030-50-TP-REGISTRO      =' AS030-50-TP-REGISTRO
!1508!     DISPLAY 'AS030-50-NR-TRAN-SAM      =' AS030-50-NR-TRAN-SAM
!1508!     DISPLAY 'AS030-50-DT-TRANS         =' AS030-50-DT-TRANS
!1508!             ' CONVERTIDA ---> '           AS030-50C-DT-TRANS
!1508!     DISPLAY 'AS030-50-HR-TRANS         =' AS030-50-HR-TRANS
!1508!             ' CONVERTIDA ---> '           AS030-50C-HR-TRANS
!1508!     DISPLAY 'AS030-50-NR-CHIP-CARTAO   =' AS030-50-NR-CHIP-CARTAO
!1508!     DISPLAY 'AS030-50-TX-ASSINATURA    =' AS030-50-TX-ASSINATURA
!1508!     .
!1508!*----------------------------------------------------------------*
!1508! 82000-DISPLAY-REG-51.
!1508!*----------------------------------------------------------------*
!1508!
!1508!     DISPLAY ' '
!1508!     DISPLAY '---------------------------'
!1508!     DISPLAY 'REGISTRO TIPO 51 - ASSINATU'
!1508!     DISPLAY '---------------------------'
!1508!     DISPLAY ' '
!1508!
!1508!     DISPLAY 'AS030-51-TP-REGISTRO      =' AS030-51-TP-REGISTRO
!1508!     DISPLAY 'AS030-51-NR-TRAN-SAM      =' AS030-51-NR-TRAN-SAM
!1508!     DISPLAY 'AS030-51-DT-TRANS         =' AS030-51-DT-TRANS
!1508!             ' CONVERTIDA ---> '           AS030-51C-DT-TRANS
!1508!     DISPLAY 'AS030-51-HR-TRANS         =' AS030-51-HR-TRANS
!1508!             ' CONVERTIDA ---> '           AS030-51C-HR-TRANS
!1508!     DISPLAY 'AS030-51-NR-CHIP-CARTAO   =' AS030-51-NR-CHIP-CARTAO
!1508!     .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-97.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '------------------------------'
           DISPLAY 'REGISTRO TIPO 97 - FECHA LINHA'
           DISPLAY '------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-97-TP-REGISTRO      =' AS030-97-TP-REGISTRO
           DISPLAY 'AS030-97-NR-TRAN-SAM      =' AS030-97-NR-TRAN-SAM
           DISPLAY 'AS030-97-DT-TRANS         =' AS030-97-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-97C-DT-TRANS
           DISPLAY 'AS030-97-HR-TRANS         =' AS030-97-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-97C-HR-TRANS
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-98.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '-----------------------------------'
           DISPLAY 'REGISTRO TIPO 98 - FECHA ARQ.LOGICO'
           DISPLAY '-----------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-98-TP-REGISTRO      =' AS030-98-TP-REGISTRO
           DISPLAY 'AS030-98-NR-TRAN-SAM      =' AS030-98-NR-TRAN-SAM
           DISPLAY 'AS030-98-DT-TRANS         =' AS030-98-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-98C-DT-TRANS
           DISPLAY 'AS030-98-HR-TRANS         =' AS030-98-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-98C-HR-TRANS
           .
      *----------------------------------------------------------------*
       82000-DISPLAY-REG-99.
      *----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '--------------------------'
           DISPLAY 'REGISTRO TIPO 99 - TRAILER   '
           DISPLAY '--------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-99-TP-REGISTRO     =' AS030-99-TP-REGISTRO
           DISPLAY 'AS030-99-NR-TRAN-SAM     =' AS030-99-NR-TRAN-SAM
           DISPLAY 'AS030-99-DT-TRANS        =' AS030-99-DT-TRANS
                   ' CONVERTIDA ---> '          AS030-99C-DT-TRANS
           DISPLAY 'AS030-99-HR-TRANS        =' AS030-99-HR-TRANS
                   ' CONVERTIDA ---> '          AS030-99C-HR-TRANS
           DISPLAY 'AS030-99-QTD-REG-DEB     =' AS030-99-QTD-REG-DEB
           DISPLAY 'AS030-99-VL-TRANS-DEB    =' AS030-99-VL-TRANS-DEB
           DISPLAY ' CONVERTIDA ---> '          AS030-99C-VL-TRANS-DEB
           DISPLAY 'AS030-99-QTD-REG-CRED    =' AS030-99-QTD-REG-CRED
           DISPLAY 'AS030-99-VL-TRANS-CRED   =' AS030-99-VL-TRANS-CRED
           DISPLAY ' CONVERTIDA ---> '          AS030-99C-VL-TRANS-CRED
           DISPLAY 'AS030-99-QTD-REG-TOTAL   =' AS030-99-QTD-REG-TOTAL
           DISPLAY 'AS030-99-VL-TOT-CR-FSAM  =' AS030-99-VL-TOT-CR-FSAM
           DISPLAY ' CONVERTIDA ---> '          AS030-99C-VL-TOT-CR-FSAM
           DISPLAY 'AS030-99-TX-ASSINATURA   =' AS030-99-TX-ASSINATURA
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-01.
      *----------------------------------------------------------------*

           MOVE AS030-01-TP-REGISTRO       TO AS035-01-TP-REGISTRO
           MOVE AS030-01-NM-ARQUIVO        TO AS035-01-NM-ARQUIVO
           MOVE AS030-01-NR-VERSAO         TO AS035-01-NR-VERSAO
           MOVE AS030-01-CD-SINDICATO      TO AS035-01-CD-SINDICATO
           MOVE AS030-01-CD-OPERADOR       TO AS035-01-CD-OPERADOR
           MOVE AS030-01-NR-VALIDADOR-IG   TO AS035-01-NR-VALIDADOR-IG
           MOVE AS030-01-NR-CHIP-SAM       TO AS035-01-NR-CHIP-SAM
           MOVE AS030-01-NR-SEQ-ARQUIVO    TO AS035-01-NR-SEQ-ARQUIVO
           MOVE AS030-01-DT-GERACAO-ARQ    TO AS035-01-DT-GERACAO-ARQ
           MOVE AS030-01-HM-GERACAO-ARQ    TO AS035-01-HM-GERACAO-ARQ
           MOVE AS030-01-CD-MOEDA          TO AS035-01-CD-MOEDA
           MOVE AS030-01-IN-CRIPTOGRAFIA   TO AS035-01-IN-CRIPTOGRAFIA
           MOVE AS030-01C-DT-GERACAO-ARQ   TO AS035-01C-DT-GERACAO-ARQ
           MOVE AS030-01C-HM-GERACAO-ARQ   TO AS035-01C-HM-GERACAO-ARQ

           DISPLAY ' '
           DISPLAY AS035-HEADER-01
           DISPLAY ' '
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-02.
      *----------------------------------------------------------------*

           MOVE AS030-02-TP-REGISTRO       TO AS035-02-TP-REGISTRO
           MOVE AS030-02-NR-TRAN-SAM       TO AS035-02-NR-TRAN-SAM
           MOVE AS030-02-DT-TRANS          TO AS035-02-DT-TRANS
           MOVE AS030-02-HR-TRANS          TO AS035-02-HR-TRANS
           MOVE AS030-02-NR-ARQ-LOG        TO AS035-02-NR-ARQ-LOG
           MOVE AS030-02C-DT-TRANS         TO AS035-02C-DT-TRANS
           MOVE AS030-02C-HR-TRANS         TO AS035-02C-HR-TRANS

           DISPLAY AS035-DETALHE-02
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-03.
      *----------------------------------------------------------------*

           MOVE AS030-03-TP-REGISTRO       TO AS035-03-TP-REGISTRO
           MOVE AS030-03-NR-TRAN-SAM       TO AS035-03-NR-TRAN-SAM
           MOVE AS030-03-DT-TRANS          TO AS035-03-DT-TRANS
           MOVE AS030-03-HR-TRANS          TO AS035-03-HR-TRANS
           MOVE AS030-03-NR-ESTACAO-CARRO  TO AS035-03-NR-ESTACAO-CARRO
           MOVE AS030-03-CD-LINHA          TO AS035-03-CD-LINHA
           MOVE AS030-03-CD-SENTIDO        TO AS035-03-CD-SENTIDO
           MOVE AS030-03-NR-SECAO          TO AS035-03-NR-SECAO
           MOVE AS030-03-VL-TARIFA-ATU     TO AS035-03-VL-TARIFA-ATU
           MOVE AS030-03-DT-INIC-TARIFA-ATU
             TO AS035-03-DT-INIC-TARIFA-ATU
           MOVE AS030-03-VL-TARIFA-ANT     TO AS035-03-VL-TARIFA-ANT
           MOVE AS030-03C-DT-TRANS         TO AS035-03C-DT-TRANS
           MOVE AS030-03C-HR-TRANS         TO AS035-03C-HR-TRANS
           MOVE AS030-03C-VL-TARIFA-ATU    TO AS035-03C-VL-TARIFA-ATU
           MOVE AS030-03C-DT-INIC-TARIFA-ATU
             TO AS035-03C-DT-INIC-TARIFA-ATU
           MOVE AS030-03C-VL-TARIFA-ANT    TO AS035-03C-VL-TARIFA-ANT

           DISPLAY AS035-DETALHE-03
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-04.
      *----------------------------------------------------------------*

           MOVE AS030-04-TP-REGISTRO       TO AS035-04-TP-REGISTRO
           MOVE AS030-04-NR-TRAN-SAM       TO AS035-04-NR-TRAN-SAM
           MOVE AS030-04-DT-TRANS          TO AS035-04-DT-TRANS
           MOVE AS030-04-HR-TRANS          TO AS035-04-HR-TRANS
           MOVE AS030-04-NR-CHIP-CARTAO    TO AS035-04-NR-CHIP-CARTAO
           MOVE AS030-04C-DT-TRANS         TO AS035-04C-DT-TRANS
           MOVE AS030-04C-HR-TRANS         TO AS035-04C-HR-TRANS

           DISPLAY AS035-DETALHE-04
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-05.
      *----------------------------------------------------------------*

           MOVE AS030-05-TP-REGISTRO       TO AS035-05-TP-REGISTRO
           MOVE AS030-05-NR-TRAN-SAM       TO AS035-05-NR-TRAN-SAM
           MOVE AS030-05-DT-TRANS          TO AS035-05-DT-TRANS
           MOVE AS030-05-HR-TRANS          TO AS035-05-HR-TRANS
           MOVE AS030-05-NR-CHIP-CARTAO    TO AS035-05-NR-CHIP-CARTAO
           MOVE AS030-05C-DT-TRANS         TO AS035-05C-DT-TRANS
           MOVE AS030-05C-HR-TRANS         TO AS035-05C-HR-TRANS

           DISPLAY AS035-DETALHE-05
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-06.
      *----------------------------------------------------------------*

           MOVE AS030-06-TP-REGISTRO       TO AS035-06-TP-REGISTRO
           MOVE AS030-06-NR-TRAN-SAM       TO AS035-06-NR-TRAN-SAM
           MOVE AS030-06-DT-TRANS          TO AS035-06-DT-TRANS
           MOVE AS030-06-HR-TRANS          TO AS035-06-HR-TRANS
           MOVE AS030-06-NR-CHIP-CARTAO    TO AS035-06-NR-CHIP-CARTAO
           MOVE AS030-06C-DT-TRANS         TO AS035-06C-DT-TRANS
           MOVE AS030-06C-HR-TRANS         TO AS035-06C-HR-TRANS

           DISPLAY AS035-DETALHE-06
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-11.
      *----------------------------------------------------------------*

           MOVE AS030-11-TP-REGISTRO       TO AS035-11-TP-REGISTRO
           MOVE AS030-11-NR-TRAN-SAM       TO AS035-11-NR-TRAN-SAM
           MOVE AS030-11-DT-TRANS          TO AS035-11-DT-TRANS
           MOVE AS030-11-HR-TRANS          TO AS035-11-HR-TRANS
           MOVE AS030-11-NR-CHIP-CARTAO    TO AS035-11-NR-CHIP-CARTAO
           MOVE AS030-11-CD-APLICACAO      TO AS035-11-CD-APLICACAO
           MOVE AS030-11-NR-TRANSACAO      TO AS035-11-NR-TRANSACAO
           MOVE AS030-11-NR-CARGA          TO AS035-11-NR-CARGA
           MOVE AS030-11-VL-TRANS          TO AS035-11-VL-TRANS
           MOVE AS030-11-VL-SALDO          TO AS035-11-VL-SALDO
           MOVE AS030-11C-DT-TRANS         TO AS035-11C-DT-TRANS
           MOVE AS030-11C-HR-TRANS         TO AS035-11C-HR-TRANS
           MOVE AS030-11C-VL-SALDO         TO AS035-11C-VL-SALDO

           DISPLAY AS035-DETALHE-11
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-12.
      *----------------------------------------------------------------*

           MOVE AS030-12-TP-REGISTRO       TO AS035-12-TP-REGISTRO
           MOVE AS030-12-NR-TRAN-SAM       TO AS035-12-NR-TRAN-SAM
           MOVE AS030-12-DT-TRANS          TO AS035-12-DT-TRANS
           MOVE AS030-12-HR-TRANS          TO AS035-12-HR-TRANS
           MOVE AS030-12-NR-CHIP-CARTAO    TO AS035-12-NR-CHIP-CARTAO
           MOVE AS030-12-CD-APLICACAO      TO AS035-12-CD-APLICACAO
           MOVE AS030-12-NR-TRANSACAO      TO AS035-12-NR-TRANSACAO
           MOVE AS030-12-NR-CARGA          TO AS035-12-NR-CARGA
           MOVE AS030-12-VL-TRANS          TO AS035-12-VL-TRANS
           MOVE AS030-12-VL-SALDO          TO AS035-12-VL-SALDO
           MOVE AS030-12C-DT-TRANS         TO AS035-12C-DT-TRANS
           MOVE AS030-12C-HR-TRANS         TO AS035-12C-HR-TRANS
           MOVE AS030-12C-VL-SALDO         TO AS035-12C-VL-SALDO

           DISPLAY AS035-DETALHE-12
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-13.
      *----------------------------------------------------------------*

           MOVE AS030-13-TP-REGISTRO       TO AS035-13-TP-REGISTRO
           MOVE AS030-13-NR-TRAN-SAM       TO AS035-13-NR-TRAN-SAM
           MOVE AS030-13-DT-TRANS          TO AS035-13-DT-TRANS
           MOVE AS030-13-HR-TRANS          TO AS035-13-HR-TRANS
           MOVE AS030-13-NR-CHIP-CARTAO    TO AS035-13-NR-CHIP-CARTAO
           MOVE AS030-13-CD-APLICACAO      TO AS035-13-CD-APLICACAO
           MOVE AS030-13-NR-TRANSACAO      TO AS035-13-NR-TRANSACAO
           MOVE AS030-13-NR-CARGA          TO AS035-13-NR-CARGA
           MOVE AS030-13-VL-TRANS          TO AS035-13-VL-TRANS
           MOVE AS030-13-VL-SALDO          TO AS035-13-VL-SALDO
           MOVE AS030-13C-DT-TRANS         TO AS035-13C-DT-TRANS
           MOVE AS030-13C-HR-TRANS         TO AS035-13C-HR-TRANS
           MOVE AS030-13C-VL-TRANS         TO AS035-13C-VL-TRANS
           MOVE AS030-13C-VL-SALDO         TO AS035-13C-VL-SALDO

           DISPLAY AS035-DETALHE-13
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-14.
      *----------------------------------------------------------------*

           MOVE AS030-14-TP-REGISTRO       TO AS035-14-TP-REGISTRO
           MOVE AS030-14-NR-TRAN-SAM       TO AS035-14-NR-TRAN-SAM
           MOVE AS030-14-DT-TRANS          TO AS035-14-DT-TRANS
           MOVE AS030-14-HR-TRANS          TO AS035-14-HR-TRANS
           MOVE AS030-14-NR-CHIP-CARTAO    TO AS035-14-NR-CHIP-CARTAO
           MOVE AS030-14-CD-APLICACAO      TO AS035-14-CD-APLICACAO
           MOVE AS030-14-NR-TRANSACAO      TO AS035-14-NR-TRANSACAO
           MOVE AS030-14-CD-APLICACAO-ANT  TO AS035-14-CD-APLICACAO-ANT
           MOVE AS030-14-NR-TRANSACAO-ANT  TO AS035-14-NR-TRANSACAO-ANT
           MOVE AS030-14-CT-INTEGRACOES    TO AS035-14-CT-INTEGRACOES
           MOVE AS030-14-CD-INTEGRACAO     TO AS035-14-CD-INTEGRACAO
           MOVE AS030-14-NR-CARGA          TO AS035-14-NR-CARGA
           MOVE AS030-14-VL-TARIFA-INTEGRACAO
             TO AS035-14-VL-TARIFA-INTEGRACAO
           MOVE AS030-14-VL-SALDO          TO AS035-14-VL-SALDO
           MOVE AS030-14C-DT-TRANS         TO AS035-14C-DT-TRANS
           MOVE AS030-14C-HR-TRANS         TO AS035-14C-HR-TRANS
           MOVE AS030-14C-VL-TARIFA-INTEGRACAO
             TO AS035-14C-VL-TARIFA-INTEGRACAO
           MOVE AS030-14C-VL-SALDO         TO AS035-14C-VL-SALDO

           DISPLAY AS035-DETALHE-14
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-21.
      *----------------------------------------------------------------*

           MOVE AS030-21-TP-REGISTRO       TO AS035-21-TP-REGISTRO
           MOVE AS030-21-NR-TRAN-SAM       TO AS035-21-NR-TRAN-SAM
           MOVE AS030-21-DT-TRANS          TO AS035-21-DT-TRANS
           MOVE AS030-21-HR-TRANS          TO AS035-21-HR-TRANS
           MOVE AS030-21-NR-CHIP-CARTAO    TO AS035-21-NR-CHIP-CARTAO
           MOVE AS030-21-CD-APLICACAO      TO AS035-21-CD-APLICACAO
           MOVE AS030-21-NR-TRANSACAO      TO AS035-21-NR-TRANSACAO
           MOVE AS030-21-CD-OPERACAO       TO AS035-21-CD-OPERACAO
           MOVE AS030-21-NR-CARGA          TO AS035-21-NR-CARGA
           MOVE AS030-21-VL-CARGA          TO AS035-21-VL-CARGA
           MOVE AS030-21-VL-SALDO          TO AS035-21-VL-SALDO
           MOVE AS030-21C-DT-TRANS         TO AS035-21C-DT-TRANS
           MOVE AS030-21C-HR-TRANS         TO AS035-21C-HR-TRANS
           MOVE AS030-21C-VL-CARGA         TO AS035-21C-VL-CARGA
           MOVE AS030-21C-VL-SALDO         TO AS035-21C-VL-SALDO

           DISPLAY AS035-DETALHE-21
           .
!0504!*----------------------------------------------------------------*
!0504! 83000-DISPLAY-REG-31.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-31-TP-REGISTRO       TO AS035-31-TP-REGISTRO
!0504!     MOVE AS030-31-NR-TRAN-SAM       TO AS035-31-NR-TRAN-SAM
!0504!     MOVE AS030-31-DT-TRANS          TO AS035-31-DT-TRANS
!0504!     MOVE AS030-31-HR-TRANS          TO AS035-31-HR-TRANS
!0504!     MOVE AS030-31-NR-CHIP-CARTAO    TO AS035-31-NR-CHIP-CARTAO
!0504!     MOVE AS030-31-CD-APLICACAO      TO AS035-31-CD-APLICACAO
!0504!     MOVE AS030-31-NR-TRANSACAO      TO AS035-31-NR-TRANSACAO
!0504!     MOVE AS030-31-NR-CARGA          TO AS035-31-NR-CARGA
!0504!     MOVE AS030-31-VL-TRANS          TO AS035-31-VL-TRANS
!0504!     MOVE AS030-31-VL-SALDO          TO AS035-31-VL-SALDO
!0504!     MOVE AS030-31-CD-LINHA          TO AS035-31-CD-LINHA
!0504!     MOVE AS030-31-TX-ASSINATURA     TO AS035-31-TX-ASSINATURA
!0504!     MOVE AS030-31C-DT-TRANS         TO AS035-31C-DT-TRANS
!0504!     MOVE AS030-31C-HR-TRANS         TO AS035-31C-HR-TRANS
!0504!     MOVE AS030-31C-VL-SALDO         TO AS035-31C-VL-SALDO
!0504!
!0504!     DISPLAY AS035-DETALHE-31
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 83000-DISPLAY-REG-32.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-32-TP-REGISTRO       TO AS035-32-TP-REGISTRO
!0504!     MOVE AS030-32-NR-TRAN-SAM       TO AS035-32-NR-TRAN-SAM
!0504!     MOVE AS030-32-DT-TRANS          TO AS035-32-DT-TRANS
!0504!     MOVE AS030-32-HR-TRANS          TO AS035-32-HR-TRANS
!0504!     MOVE AS030-32-NR-CHIP-CARTAO    TO AS035-32-NR-CHIP-CARTAO
!0504!     MOVE AS030-32-CD-APLICACAO      TO AS035-32-CD-APLICACAO
!0504!     MOVE AS030-32-NR-TRANSACAO      TO AS035-32-NR-TRANSACAO
!0504!     MOVE AS030-32-NR-CARGA          TO AS035-32-NR-CARGA
!0504!     MOVE AS030-32-VL-TRANS          TO AS035-32-VL-TRANS
!0504!     MOVE AS030-32-VL-SALDO          TO AS035-32-VL-SALDO
!0504!     MOVE AS030-32-CD-LINHA          TO AS035-32-CD-LINHA
!0504!     MOVE AS030-32-TX-ASSINATURA     TO AS035-32-TX-ASSINATURA
!0504!     MOVE AS030-32C-DT-TRANS         TO AS035-32C-DT-TRANS
!0504!     MOVE AS030-32C-HR-TRANS         TO AS035-32C-HR-TRANS
!0504!     MOVE AS030-32C-VL-SALDO         TO AS035-32C-VL-SALDO
!0504!
!0504!     DISPLAY AS035-DETALHE-32
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 83000-DISPLAY-REG-33.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-33-TP-REGISTRO       TO AS035-33-TP-REGISTRO
!0504!     MOVE AS030-33-NR-TRAN-SAM       TO AS035-33-NR-TRAN-SAM
!0504!     MOVE AS030-33-DT-TRANS          TO AS035-33-DT-TRANS
!0504!     MOVE AS030-33-HR-TRANS          TO AS035-33-HR-TRANS
!0504!     MOVE AS030-33-NR-CHIP-CARTAO    TO AS035-33-NR-CHIP-CARTAO
!0504!     MOVE AS030-33-CD-APLICACAO      TO AS035-33-CD-APLICACAO
!0504!     MOVE AS030-33-NR-TRANSACAO      TO AS035-33-NR-TRANSACAO
!0504!     MOVE AS030-33-NR-CARGA          TO AS035-33-NR-CARGA
!0504!     MOVE AS030-33-VL-TRANS          TO AS035-33-VL-TRANS
!0504!     MOVE AS030-33-VL-SALDO          TO AS035-33-VL-SALDO
!0504!     MOVE AS030-33-CD-LINHA          TO AS035-33-CD-LINHA
!0504!     MOVE AS030-33-TX-ASSINATURA     TO AS035-33-TX-ASSINATURA
!0504!     MOVE AS030-33C-DT-TRANS         TO AS035-33C-DT-TRANS
!0504!     MOVE AS030-33C-HR-TRANS         TO AS035-33C-HR-TRANS
!0504!     MOVE AS030-33C-VL-TRANS         TO AS035-33C-VL-TRANS
!0504!     MOVE AS030-33C-VL-SALDO         TO AS035-33C-VL-SALDO
!0504!
!0504!     DISPLAY AS035-DETALHE-33
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 83000-DISPLAY-REG-34.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-34-TP-REGISTRO       TO AS035-34-TP-REGISTRO
!0504!     MOVE AS030-34-NR-TRAN-SAM       TO AS035-34-NR-TRAN-SAM
!0504!     MOVE AS030-34-DT-TRANS          TO AS035-34-DT-TRANS
!0504!     MOVE AS030-34-HR-TRANS          TO AS035-34-HR-TRANS
!0504!     MOVE AS030-34-NR-CHIP-CARTAO    TO AS035-34-NR-CHIP-CARTAO
!0504!     MOVE AS030-34-CD-APLICACAO      TO AS035-34-CD-APLICACAO
!0504!     MOVE AS030-34-NR-TRANSACAO      TO AS035-34-NR-TRANSACAO
!0504!     MOVE AS030-34-CD-APLICACAO-ANT  TO AS035-34-CD-APLICACAO-ANT
!0504!     MOVE AS030-34-NR-TRANSACAO-ANT  TO AS035-34-NR-TRANSACAO-ANT
!0504!     MOVE AS030-34-CT-INTEGRACOES    TO AS035-34-CT-INTEGRACOES
!0504!     MOVE AS030-34-CD-INTEGRACAO     TO AS035-34-CD-INTEGRACAO
!0504!     MOVE AS030-34-NR-CARGA          TO AS035-34-NR-CARGA
!0504!     MOVE AS030-34-VL-TARIFA-INTEGRACAO
!0504!       TO AS035-34-VL-TARIFA-INTEGRACAO
!0504!     MOVE AS030-34-VL-SALDO          TO AS035-34-VL-SALDO
!0504!     MOVE AS030-34-CD-LINHA          TO AS035-34-CD-LINHA
!0504!     MOVE AS030-34-TX-ASSINATURA     TO AS035-34-TX-ASSINATURA
!0504!     MOVE AS030-34C-DT-TRANS         TO AS035-34C-DT-TRANS
!0504!     MOVE AS030-34C-HR-TRANS         TO AS035-34C-HR-TRANS
!0504!     MOVE AS030-34C-VL-TARIFA-INTEGRACAO
!0504!       TO AS035-34C-VL-TARIFA-INTEGRACAO
!0504!     MOVE AS030-34C-VL-SALDO         TO AS035-34C-VL-SALDO
!0504!
!0504!     DISPLAY AS035-DETALHE-34
!0504!     .
!0504!*----------------------------------------------------------------*
!0504! 83000-DISPLAY-REG-41.
!0504!*----------------------------------------------------------------*
!0504!
!0504!     MOVE AS030-41-TP-REGISTRO       TO AS035-41-TP-REGISTRO
!0504!     MOVE AS030-41-NR-TRAN-SAM       TO AS035-41-NR-TRAN-SAM
!0504!     MOVE AS030-41-DT-TRANS          TO AS035-41-DT-TRANS
!0504!     MOVE AS030-41-HR-TRANS          TO AS035-41-HR-TRANS
!0504!     MOVE AS030-41-NR-CHIP-CARTAO    TO AS035-41-NR-CHIP-CARTAO
!0504!     MOVE AS030-41-CD-APLICACAO      TO AS035-41-CD-APLICACAO
!0504!     MOVE AS030-41-NR-TRANSACAO      TO AS035-41-NR-TRANSACAO
!0504!     MOVE AS030-41-CD-OPERACAO       TO AS035-41-CD-OPERACAO
!0504!     MOVE AS030-41-NR-CARGA          TO AS035-41-NR-CARGA
!0504!     MOVE AS030-41-VL-CARGA          TO AS035-41-VL-CARGA
!0504!     MOVE AS030-41-VL-SALDO          TO AS035-41-VL-SALDO
!0504!     MOVE AS030-41-CD-LINHA          TO AS035-41-CD-LINHA
!0504!     MOVE AS030-41-TX-ASSINATURA     TO AS035-41-TX-ASSINATURA
!0504!     MOVE AS030-41C-DT-TRANS         TO AS035-41C-DT-TRANS
!0504!     MOVE AS030-41C-HR-TRANS         TO AS035-41C-HR-TRANS
!0504!     MOVE AS030-41C-VL-CARGA         TO AS035-41C-VL-CARGA
!0504!     MOVE AS030-41C-VL-SALDO         TO AS035-41C-VL-SALDO
!0504!
!0504!     DISPLAY AS035-DETALHE-41
!0504!     .
!1508!*----------------------------------------------------------------*
!1508! 83000-DISPLAY-REG-50.
!1508!*----------------------------------------------------------------*
!1508!
!1508!     MOVE AS030-50-TP-REGISTRO       TO AS035-50-TP-REGISTRO
!1508!     MOVE AS030-50-NR-TRAN-SAM       TO AS035-50-NR-TRAN-SAM
!1508!     MOVE AS030-50-DT-TRANS          TO AS035-50-DT-TRANS
!1508!     MOVE AS030-50-HR-TRANS          TO AS035-50-HR-TRANS
!1508!     MOVE AS030-50-NR-CHIP-CARTAO    TO AS035-50-NR-CHIP-CARTAO
!1508!     MOVE AS030-50-TX-ASSINATURA     TO AS035-50-TX-ASSINATURA
!1508!     MOVE AS030-50C-DT-TRANS         TO AS035-50C-DT-TRANS
!1508!     MOVE AS030-50C-HR-TRANS         TO AS035-50C-HR-TRANS
!1508!
!1508!     DISPLAY AS035-DETALHE-50
!1508!     .
!1508!*----------------------------------------------------------------*
!1508! 83000-DISPLAY-REG-51.
!1508!*----------------------------------------------------------------*
!1508!
!1508!     MOVE AS030-51-TP-REGISTRO       TO AS035-51-TP-REGISTRO
!1508!     MOVE AS030-51-NR-TRAN-SAM       TO AS035-51-NR-TRAN-SAM
!1508!     MOVE AS030-51-DT-TRANS          TO AS035-51-DT-TRANS
!1508!     MOVE AS030-51-HR-TRANS          TO AS035-51-HR-TRANS
!1508!     MOVE AS030-51-NR-CHIP-CARTAO    TO AS035-51-NR-CHIP-CARTAO
!1508!     MOVE AS030-51C-DT-TRANS         TO AS035-51C-DT-TRANS
!1508!     MOVE AS030-51C-HR-TRANS         TO AS035-51C-HR-TRANS
!1508!
!1508!     DISPLAY AS035-DETALHE-51
!1508!     .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-97.
      *----------------------------------------------------------------*

           MOVE AS030-97-TP-REGISTRO       TO AS035-97-TP-REGISTRO
           MOVE AS030-97-NR-TRAN-SAM       TO AS035-97-NR-TRAN-SAM
           MOVE AS030-97-DT-TRANS          TO AS035-97-DT-TRANS
           MOVE AS030-97-HR-TRANS          TO AS035-97-HR-TRANS
           MOVE AS030-97C-DT-TRANS         TO AS035-97C-DT-TRANS
           MOVE AS030-97C-HR-TRANS         TO AS035-97C-HR-TRANS

           DISPLAY AS035-TRAILER-97
           DISPLAY ' '
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-98.
      *----------------------------------------------------------------*

           MOVE AS030-98-TP-REGISTRO       TO AS035-98-TP-REGISTRO
           MOVE AS030-98-NR-TRAN-SAM       TO AS035-98-NR-TRAN-SAM
           MOVE AS030-98-DT-TRANS          TO AS035-98-DT-TRANS
           MOVE AS030-98-HR-TRANS          TO AS035-98-HR-TRANS
           MOVE AS030-98C-DT-TRANS         TO AS035-98C-DT-TRANS
           MOVE AS030-98C-HR-TRANS         TO AS035-98C-HR-TRANS

           DISPLAY AS035-TRAILER-98
           DISPLAY ' '
           .
      *----------------------------------------------------------------*
       83000-DISPLAY-REG-99.
      *----------------------------------------------------------------*

           MOVE AS030-99-TP-REGISTRO       TO AS035-99-TP-REGISTRO
           MOVE AS030-99-NR-TRAN-SAM       TO AS035-99-NR-TRAN-SAM
           MOVE AS030-99-DT-TRANS          TO AS035-99-DT-TRANS
           MOVE AS030-99-HR-TRANS          TO AS035-99-HR-TRANS
           MOVE AS030-99-QTD-REG-DEB       TO AS035-99-QTD-REG-DEB
           MOVE AS030-99-VL-TRANS-DEB      TO AS035-99-VL-TRANS-DEB
           MOVE AS030-99-QTD-REG-CRED      TO AS035-99-QTD-REG-CRED
           MOVE AS030-99-VL-TRANS-CRED     TO AS035-99-VL-TRANS-CRED
           MOVE AS030-99-QTD-REG-TOTAL     TO AS035-99-QTD-REG-TOTAL
           MOVE AS030-99-VL-TOT-CR-FSAM    TO AS035-99-VL-TOT-CR-FSAM

           MOVE AS030-99C-DT-TRANS         TO AS035-99C-DT-TRANS
           MOVE AS030-99C-HR-TRANS         TO AS035-99C-HR-TRANS
           MOVE AS030-99C-VL-TRANS-DEB     TO AS035-99C-VL-TRANS-DEB
           MOVE AS030-99C-VL-TRANS-CRED    TO AS035-99C-VL-TRANS-CRED
           MOVE AS030-99C-VL-TOT-CR-FSAM   TO AS035-99C-VL-TOT-CR-FSAM

           DISPLAY AS035-TRAILER-99
           DISPLAY ' '
           .
!3011!*----------------------------------------------------------------*
!3011!  81030-PREENCHER-VETOR-03.
!3011!*----------------------------------------------------------------*
!3011!
!3011!     EVALUATE TRUE
!3011!     WHEN W81-TIN = 03
!3011!       PERFORM 81031-FORMATAR-DT-INIC
!3011!       PERFORM 81032-FORMATAR-DT-TRANS
!3011!       ADD  1               TO W81-I03
!3011!       INITIALIZE              W81-V03                   (W81-I03)
!3011!       MOVE 999999999       TO W81-NR-TRANS-CART-ANT
!3011!       MOVE AS030-TX-NR-TRAN-SAM
!3011!                            TO W81-V03-NR-TRANS-CART-INI (W81-I03)
!3011!                               W81-V03-NR-TRANS-CART-FIM (W81-I03)
!3011!       MOVE W81-DT-TRANS    TO W81-V03-DT-TRANS-INI      (W81-I03)
!3011!                               W81-V03-DT-TRANS-FIM      (W81-I03)
!3011!       MOVE AS030-03-CD-MOTORISTA
!3011!                            TO W81-V03-CD-MOTORISTA      (W81-I03)
!3011!       MOVE AS030-03-CD-COBRADOR
!3011!                            TO W81-V03-CD-COBRADOR       (W81-I03)
!3011!       MOVE AS030-03-CD-TURNO
!3011!                            TO W81-V03-CD-TURNO          (W81-I03)
!3011!       MOVE AS030-03-CD-LINHA
!3011!                            TO W81-V03-CD-LINHA          (W81-I03)
!3011!       MOVE AS030-03-NR-ESTACAO-CARRO
!3011!                            TO W81-V03-NR-ESTACAO-CARRO  (W81-I03)
!3011!       MOVE AS030-03-CD-SENTIDO
!3011!                            TO W81-V03-CD-SENTIDO        (W81-I03)
!3011!       MOVE AS030-03-NR-SECAO
!3011!                            TO W81-V03-NR-SECAO-LINHA    (W81-I03)
!3011!       MOVE AS030-03C-VL-TARIFA-ATU
!3011!                            TO W81-V03-VL-TARIFA-ATU     (W81-I03)
!3011!       MOVE W81-DT-INIC     TO W81-V03-DT-INIC-TARIFA-ATU(W81-I03)
!3011!       MOVE AS030-03C-VL-TARIFA-ANT
!3011!                            TO W81-V03-VL-TARIFA-ANT     (W81-I03)
!3011!
!2012!*->>   ENTRADA DA TABELA SBE-FILIPETA NO SISTEMA
!2012!       ADD  1               TO W81-IFILI
!2012!       INITIALIZE              W81-VFILI  (W81-IFILI)
!2012!
!2012!       MOVE AS030-03-CD-LINHA
!2012!         TO W81-VFILI-CD-LINHA            (W81-IFILI)
!2012!       MOVE AS030-03-NR-ESTACAO-CARRO
!2012!         TO W81-VFILI-NR-ESTACAO-CARRO    (W81-IFILI)
!2012!       MOVE AS030-03-CD-TURNO
!2012!         TO W81-VFILI-CD-TURNO            (W81-IFILI)
!2012!       MOVE W81-DT-TRANS
!2012!         TO W81-VFILI-DT-TRANS-INI        (W81-IFILI)
!2012!       MOVE AS030-TX-NR-TRAN-SAM
!2012!         TO W81-VFILI-NR-TRANS-CART-INI   (W81-IFILI)
!2012!       MOVE CD-OPERAD OF SBE-OPERAD
!2012!         TO W81-VFILI-CD-OPERAD           (W81-IFILI)
!2012!       MOVE PA66-DT-MALOTE
!2012!         TO W81-VFILI-DT-MALOTE           (W81-IFILI)
!2012!
!3011!     WHEN (W81-TIN = 11
!0504!       OR  W81-TIN = 31)
!3011!      AND (W81-I03 >  0)
!3011!      PERFORM 81032-FORMATAR-DT-TRANS
!3011!      IF AS030-TX-NR-TRAN-SAM < W81-NR-TRANS-CART-ANT
!3011!       MOVE AS030-TX-NR-TRAN-SAM
!3011!                      TO W81-V03-NR-TRANS-CART-INI     (W81-I03)
!2012!                         W81-VFILI-NR-TRANS-CART-INI   (W81-IFILI)
!3011!                         W81-NR-TRANS-CART-ANT
!3011!      END-IF
!3011!      MOVE AS030-TX-NR-TRAN-SAM
!3011!                            TO W81-V03-NR-TRANS-CART-FIM (W81-I03)
!3011!      MOVE W81-DT-TRANS     TO W81-V03-DT-TRANS-FIM      (W81-I03)
!3011!      ADD  1                TO W81-V03-QT-TRANS-DEB      (W81-I03)
!0504!      IF W81-TIN = 11
!3011!       ADD  AS030-11C-VL-TRANS
!3011!                          TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!                             W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!       ADD 1              TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!2012!
!0504!      ELSE
!0504!       ADD  AS030-31C-VL-TRANS
!0504!                          TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!                             W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!       ADD 1              TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!2012!
!0504!      END-IF
!3011!
!3011!     WHEN (W81-TIN = 12
!0504!       OR  W81-TIN = 32)
!3011!      AND (W81-I03 >  0)
!3011!      PERFORM 81032-FORMATAR-DT-TRANS
!3011!      IF AS030-TX-NR-TRAN-SAM < W81-NR-TRANS-CART-ANT
!3011!       MOVE AS030-TX-NR-TRAN-SAM
!3011!                      TO W81-V03-NR-TRANS-CART-INI     (W81-I03)
!2012!                         W81-VFILI-NR-TRANS-CART-INI   (W81-IFILI)
!3011!                         W81-NR-TRANS-CART-ANT
!3011!      END-IF
!3011!      MOVE AS030-TX-NR-TRAN-SAM
!3011!                            TO W81-V03-NR-TRANS-CART-FIM (W81-I03)
!3011!      MOVE W81-DT-TRANS     TO W81-V03-DT-TRANS-FIM      (W81-I03)
!3011!      ADD  1                TO W81-V03-QT-TRANS-DEB      (W81-I03)
!0504!      IF W81-TIN = 12
!3011!       ADD  AS030-12C-VL-TRANS
!3011!                          TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!                             W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!       ADD 1              TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!2012!
!0504!      ELSE
!0504!       ADD  AS030-32C-VL-TRANS
!0504!                          TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!                             W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!       ADD 1              TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!2012!
!0504!      END-IF
!3011!
!3011!     WHEN (W81-TIN = 13
!0504!       OR  W81-TIN = 33)
!3011!      AND (W81-I03 >  0)
!3011!      PERFORM 81032-FORMATAR-DT-TRANS
!3011!      IF AS030-TX-NR-TRAN-SAM < W81-NR-TRANS-CART-ANT
!3011!       MOVE AS030-TX-NR-TRAN-SAM
!3011!                      TO W81-V03-NR-TRANS-CART-INI     (W81-I03)
!2012!                         W81-VFILI-NR-TRANS-CART-INI   (W81-IFILI)
!3011!                         W81-NR-TRANS-CART-ANT
!3011!      END-IF
!3011!      MOVE AS030-TX-NR-TRAN-SAM
!3011!                            TO W81-V03-NR-TRANS-CART-FIM (W81-I03)
!3011!      MOVE W81-DT-TRANS     TO W81-V03-DT-TRANS-FIM      (W81-I03)
!3011!      ADD  1                TO W81-V03-QT-TRANS-DEB      (W81-I03)
!0504!      IF W81-TIN = 13
!3011!       ADD  AS030-13C-VL-TRANS
!3011!                          TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!                             W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!       ADD 1              TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!2012!
!0504!      ELSE
!0504!       ADD  AS030-33C-VL-TRANS
!0504!                          TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!                             W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!       ADD 1              TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!2012!
!0504!      END-IF
!3011!
!3011!     WHEN (W81-TIN = 14
!0504!       OR  W81-TIN = 34)
!3011!      AND (W81-I03 >  0)
!3011!      PERFORM 81032-FORMATAR-DT-TRANS
!3011!      IF AS030-TX-NR-TRAN-SAM < W81-NR-TRANS-CART-ANT
!3011!       MOVE AS030-TX-NR-TRAN-SAM
!3011!                      TO W81-V03-NR-TRANS-CART-INI     (W81-I03)
!2012!                         W81-VFILI-NR-TRANS-CART-INI   (W81-IFILI)
!3011!                         W81-NR-TRANS-CART-ANT
!3011!      END-IF
!3011!      MOVE AS030-TX-NR-TRAN-SAM
!3011!                            TO W81-V03-NR-TRANS-CART-FIM (W81-I03)
!3011!      MOVE W81-DT-TRANS     TO W81-V03-DT-TRANS-FIM      (W81-I03)
!3011!      ADD  1                TO W81-V03-QT-TRANS-DEB      (W81-I03)
!0504!      IF W81-TIN = 14
!3011!       ADD  AS030-14C-VL-TARIFA-INTEGRACAO
!3011!                         TO W81-V03-VL-TRANS-DEB       (W81-I03)
!2012!                            W81-VFILI-VL-INT-REALIZADO (W81-IFILI)
!2012!       ADD 1             TO W81-VFILI-QT-INT-REALIZADO (W81-IFILI)
!2012!
!0504!      ELSE
!0504!       ADD  AS030-34C-VL-TARIFA-INTEGRACAO
!0504!                         TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!                            W81-VFILI-VL-INT-REALIZADO (W81-IFILI)
!2012!       ADD 1             TO W81-VFILI-QT-INT-REALIZADO (W81-IFILI)
!2012!
!0504!      END-IF
!3011!
!3011!     WHEN (W81-TIN = 21
!0504!       OR  W81-TIN = 41)
!3011!      AND (W81-I03 >  0)
!3011!      PERFORM 81032-FORMATAR-DT-TRANS
!3011!      IF AS030-TX-NR-TRAN-SAM < W81-NR-TRANS-CART-ANT
!3011!       MOVE AS030-TX-NR-TRAN-SAM
!3011!                      TO W81-V03-NR-TRANS-CART-INI     (W81-I03)
!2012!                         W81-VFILI-NR-TRANS-CART-INI   (W81-IFILI)
!3011!                         W81-NR-TRANS-CART-ANT
!3011!      END-IF
!3011!      MOVE AS030-TX-NR-TRAN-SAM
!3011!                            TO W81-V03-NR-TRANS-CART-FIM (W81-I03)
!3011!      MOVE W81-DT-TRANS     TO W81-V03-DT-TRANS-FIM      (W81-I03)
!3011!      ADD  1                TO W81-V03-QT-TRANS-CRED     (W81-I03)
!0504!      IF W81-TIN = 21
!3011!       ADD  AS030-21C-VL-CARGA
!3011!                            TO W81-V03-VL-TRANS-CRED     (W81-I03)
!0504!      ELSE
!0504!       ADD  AS030-41C-VL-CARGA
!0504!                            TO W81-V03-VL-TRANS-CRED     (W81-I03)
!0504!      END-IF
!3011!     WHEN  W81-TIN = 97
!3011!      AND (W81-I03 >  0)
!3011!       PERFORM 81032-FORMATAR-DT-TRANS
!3011!       MOVE W81-DT-TRANS    TO W81-V03-DT-TRANS-FIM      (W81-I03)
!3011!     END-EVALUATE
!3011!     .
!3011!*----------------------------------------------------------------*
!3011!  81031-FORMATAR-DT-INIC.
!3011!*----------------------------------------------------------------*
!3011!
!3011!     MOVE AS030-03-DT-INIC-TARIFA-ATU  TO  W55-DDDD
!3011!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!3011!     MOVE W55-AAAA-MM-DD               TO  W81-DT-INIC
!3011!     .
!3011!*----------------------------------------------------------------*
!3011!  81032-FORMATAR-DT-TRANS.
!3011!*----------------------------------------------------------------*
!3011!
!3011!     MOVE AS030-TX-DT-TRANS            TO  W55-DDDD
!3011!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!3011!
!3011!     MOVE AS030-TXC-HR-TRANS           TO  W55-HHMMSS
!3011!
!3011!     PERFORM 55300-FORMATAR-TIMESTAMP
!3011!     MOVE W55-TIMESTAMP                TO  W81-DT-TRANS
!3011!     .
