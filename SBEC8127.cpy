!7282!* 02-02-2018 GSOUZA  - SO PROCESSAR OS REGISTROS TIPO = 04      *
!7282!*                      PARA OS CHIPS DE VT.                     *
!2209!* 22-09-2017 RALVES  - ACATAR ARQUIVO QUANDO REGISTRO TIPO = 03 *
!2209!*                      ESTIVER FORA DE ORDEM EM RELACAO OS      *
!2209!*                      REGISTROS TIPO 04, 05, 06, 07 E 08       *
!2209!*                      REDMINE 6998                             *
!RR17!* 21-07-2017 - GSOUZA  - ROCK IN RIO 2017.                       *
!RR17!*                        REDMINE 6535                            *
!1706!* 17-06-2016 - PCALDAS - ACERTO DO IN-TRANSF DA SUPERVIA         *
!1706!*                        REDMINE - 2207.                         *
R2016!* 18-05-2016 - RALVES  - CARTAO OLIMPIADA RIO 2016               *
!SIGA2* 29-12-2014 RALVES  - RECUPERAR EMISSOR SOMENTE NAS APLICACOES  *
!SIGA2*                      QUE PODEM TER MAIS DE UM EMISSOR.         *
!SIGA!* 23-10-2014 RALVES  - PROJETO SIGA VIAGEM                       *
!TARSP* 02-05-2014 PCALDAS - PROJETO TARIFA SOCIAL                     *
!TURI!* 20-03-2014 - RALVES  - PROJETO TURISTA.                        *
!L207P* 22/01/2014 - PCALDAS - PROJETO L0 2.7                          *
!L207!* 26/12/2013 - RALVES  - PROJETO L0 VERSAO 2.7                   *
!RRIO2* 16-09-2013 RALVES  - ROCK IN RIO - 2013                        *
!JMJU!* 28-05-2013 RALVES  - PROJETO JORNADA MUNDIAL DA JUVENTUDE (JMJ)*
!0304!* 03-04-2012 BSIMON  - ACERTO QUANDO 'W81-TIN = 043'
!0304!* ESTAVA "AS030-42-CD-APLICACAO" COLOQUEI "AS030-43-CD-APLICACAO"
!METR!* 03-04-2012 BSIMON  - PROJETO METRO - CD_APLIC 210 E 220        *
!BARC!* 24-01-2012 RALVES  - TARIFA AQUAVIARIA.                        *
!MARI!* 10-01-2012 PCALDAS - ENTRADA DO BU PARCIAL  MARICA.            *
!TELE1* 29-12-2011 RALVES  - PROJETO TELEFERICO - TURISTA  CD_APLIC 180*
!FIPU!* 16-09-2011 PCALDAS - FILIPETA PROUNI                           *
!TELE!* 08-08-2011 RALVES  - PROJETO TELEFERICO                        *
!RRIO!* 04-08-2011 RALVES  - PROJETO ROCK IN RIO                       *
!PRUN!* 11-07-2011 PCALDAS - PROJETO PROUNI                            *
!0309!* 03-09-2009 INCLUSAO DO TP 52 - CARGA ENCRIPTADA. PCALDAS       *
!0701!* 07-01-2010 INCLUSAO DO B.U. PCALDAS                            *
!2009!* 20-09-2010 PCALDAS - ENTRADA DO B.U. MUNI NO SISTEMA.          *
!2012!* 20-12-2010 PCALDAS - ENTRADA DA SBE-FILIPETA NO SISTEMA        *
!2405!* 24-05-2011 PCALDAS - ENTRADA DA SBE-FILIPETA-BUCS NO SISTEMA   *
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


!L207!*----------------------------------------------------------------*
!L207!*----------------------------------------------------------------*
!L207!*-------------------------- DESPREZAR REGS 22, 25, 26, 27 E 28 --*
!L207!*----------------------------------------------------------------*
!L207!      IF   W81-TIN = 022 OR 025 OR 026
!L207P                  OR 027 OR 028
!L207!
!L207!           GO TO 81000-LER-HFS
!L207!
!L207!      END-IF
!2209!*----------------------------------------------------------------*
!2209!      IF  (W81-TIN = 004 OR 005 OR 006 OR 007 OR 008)
!2209!                           AND
!2209!                  W01-POSSUI-REG03-NOK
!2209!
!2209!           GO TO 81000-LER-HFS
!2209!
!2209!      END-IF
!7282!*----------------------------------------------------------------*
!7282!*----------------------------------------------------------------*
!7282!*--------------------------- DESPREZAR TP_REG = 04 DE EXPRESSO --*
!7282!*----------------------------------------------------------------*
!7282!      IF   W81-TIN               =  04
!7282!
!7282!           MOVE AS030-TX-NR-CHIP-CARTAO
!7282!             TO NR-CHIP-CARTAO-SC         OF SBE-CC-CARTAO-SCON
!7282!
!7282!           PERFORM 82100-SELECT-APLSCONT
!7282!
!7282!           IF IN-EXPRESSO OF SBE-APLIC-SCONT = 1
!7282!
!7282!              GO TO 81000-LER-HFS
!7282!
!7282!           END-IF
!7282!
!7282!      END-IF
!0203!*----------------------------------------------------------------*
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
!2103!      OR  (W81-TIN               = 023
!2103!      AND  AS030-23-CD-APLICACAO = 100)
!0203!
!0203!           GO TO 81000-LER-HFS
!0203!
!0203!      END-IF
!L207!*----------------------------------------------------------------*
!L207!*----------------------------------------------------------------*
!L207!*------------------------------------------- DESPREZAR APL=101 --*
!L207!*----------------------------------------------------------------*
!L207!      IF  (W81-TIN               = 011
!L207!      AND  AS030-11-CD-APLICACAO = 101)
!L207!      OR  (W81-TIN               = 012
!L207!      AND  AS030-12-CD-APLICACAO = 101)
!L207!      OR  (W81-TIN               = 013
!L207!      AND  AS030-13-CD-APLICACAO = 101)
!L207!      OR  (W81-TIN               = 014
!L207!      AND  AS030-14-CD-APLICACAO = 101)
!L207!      OR  (W81-TIN               = 021
!L207!      AND  AS030-21-CD-APLICACAO = 101)
!L207!      OR  (W81-TIN               = 023
!L207!      AND  AS030-23-CD-APLICACAO = 101)
!L207!
!L207!           GO TO 81000-LER-HFS
!L207!
!L207!      END-IF
!L207!*----------------------------------------------------------------*
!L207!*----------------------------------------------------------------*
!L207!*------------------------------------------- DESPREZAR APL=102 --*
!L207!*----------------------------------------------------------------*
!L207!      IF  (W81-TIN               = 011
!L207!      AND  AS030-11-CD-APLICACAO = 102)
!L207!      OR  (W81-TIN               = 012
!L207!      AND  AS030-12-CD-APLICACAO = 102)
!L207!      OR  (W81-TIN               = 013
!L207!      AND  AS030-13-CD-APLICACAO = 102)
!L207!      OR  (W81-TIN               = 014
!L207!      AND  AS030-14-CD-APLICACAO = 102)
!L207!      OR  (W81-TIN               = 021
!L207!      AND  AS030-21-CD-APLICACAO = 102)
!L207!      OR  (W81-TIN               = 023
!L207!      AND  AS030-23-CD-APLICACAO = 102)
!L207!
!L207!           GO TO 81000-LER-HFS
!L207!
!L207!      END-IF
!L207!*----------------------------------------------------------------*
!L207!*----------------------------------------------------------------*
!L207!*------------------------------------------- DESPREZAR APL=103 --*
!L207!*----------------------------------------------------------------*
!L207!      IF  (W81-TIN               = 011
!L207!      AND  AS030-11-CD-APLICACAO = 103)
!L207!      OR  (W81-TIN               = 012
!L207!      AND  AS030-12-CD-APLICACAO = 103)
!L207!      OR  (W81-TIN               = 013
!L207!      AND  AS030-13-CD-APLICACAO = 103)
!L207!      OR  (W81-TIN               = 014
!L207!      AND  AS030-14-CD-APLICACAO = 103)
!L207!      OR  (W81-TIN               = 021
!L207!      AND  AS030-21-CD-APLICACAO = 103)
!L207!      OR  (W81-TIN               = 023
!L207!      AND  AS030-23-CD-APLICACAO = 103)
!L207!
!L207!           GO TO 81000-LER-HFS
!L207!
!L207!      END-IF
!L207!*----------------------------------------------------------------*
!L207!*----------------------------------------------------------------*
!L207!*------------------------------------------- DESPREZAR APL=108 --*
!L207!*----------------------------------------------------------------*
!L207!      IF  (W81-TIN               = 011
!L207!      AND  AS030-11-CD-APLICACAO = 108)
!L207!      OR  (W81-TIN               = 012
!L207!      AND  AS030-12-CD-APLICACAO = 108)
!L207!      OR  (W81-TIN               = 013
!L207!      AND  AS030-13-CD-APLICACAO = 108)
!L207!      OR  (W81-TIN               = 014
!L207!      AND  AS030-14-CD-APLICACAO = 108)
!L207!      OR  (W81-TIN               = 021
!L207!      AND  AS030-21-CD-APLICACAO = 108)
!L207!      OR  (W81-TIN               = 023
!L207!      AND  AS030-23-CD-APLICACAO = 108)
!L207!
!L207!           GO TO 81000-LER-HFS
!L207!
!L207!      END-IF
!TURI!*----------------------------------------------------------------*
!TURI!*------------------------------------------- DESPREZAR APL=111 --*
!TURI!*----------------------------------------------------------------*
!TURI!      IF  (W81-TIN               = 011
!TURI!      AND  AS030-11-CD-APLICACAO = 111)
!TURI!      OR  (W81-TIN               = 012
!TURI!      AND  AS030-12-CD-APLICACAO = 111)
!TURI!      OR  (W81-TIN               = 013
!TURI!      AND  AS030-13-CD-APLICACAO = 111)
!TURI!      OR  (W81-TIN               = 014
!TURI!      AND  AS030-14-CD-APLICACAO = 111)
!TURI!
!TURI!           GO TO 81000-LER-HFS
!TURI!
!TURI!      END-IF
!SIGA!*----------------------------------------------------------------*
!SIGA!*------------------------------------------- DESPREZAR APL=114 --*
!SIGA!*----------------------------------------------------------------*
!SIGA!      IF  (W81-TIN               = 011
!SIGA!      AND  AS030-11-CD-APLICACAO = 114)
!SIGA!      OR  (W81-TIN               = 012
!SIGA!      AND  AS030-12-CD-APLICACAO = 114)
!SIGA!      OR  (W81-TIN               = 013
!SIGA!      AND  AS030-13-CD-APLICACAO = 114)
!SIGA!
!SIGA!      OR  (W81-TIN               = 023
!SIGA!      AND  AS030-23-CD-APLICACAO = 114)
!SIGA!
!SIGA!
!SIGA!           GO TO 81000-LER-HFS
!SIGA!
!SIGA!      END-IF
!SIGA!*----------------------------------------------------------------*
!SIGA!*------------------------------------------- DESPREZAR APL=115 --*
!SIGA!*----------------------------------------------------------------*
!SIGA!      IF  (W81-TIN               = 011
!SIGA!      AND  AS030-11-CD-APLICACAO = 115)
!SIGA!      OR  (W81-TIN               = 012
!SIGA!      AND  AS030-12-CD-APLICACAO = 115)
!SIGA!      OR  (W81-TIN               = 013
!SIGA!      AND  AS030-13-CD-APLICACAO = 115)
!SIGA!
!SIGA!      OR  (W81-TIN               = 023
!SIGA!      AND  AS030-23-CD-APLICACAO = 115)
!SIGA!
!SIGA!
!SIGA!           GO TO 81000-LER-HFS
!SIGA!
!SIGA!      END-IF
!SIGA!*----------------------------------------------------------------*
!SIGA!*------------------------------------------- DESPREZAR APL=116 --*
!SIGA!*----------------------------------------------------------------*
!SIGA!      IF  (W81-TIN               = 011
!SIGA!      AND  AS030-11-CD-APLICACAO = 116)
!SIGA!      OR  (W81-TIN               = 012
!SIGA!      AND  AS030-12-CD-APLICACAO = 116)
!SIGA!      OR  (W81-TIN               = 013
!SIGA!      AND  AS030-13-CD-APLICACAO = 116)
!SIGA!
!SIGA!      OR  (W81-TIN               = 023
!SIGA!      AND  AS030-23-CD-APLICACAO = 116)
!SIGA!
!SIGA!
!SIGA!           GO TO 81000-LER-HFS
!SIGA!
!SIGA!      END-IF
!A120!*----------------------------------------------------------------*
!A120!*------------------------------------------- DESPREZAR APL=120 --*
!A120!*----------------------------------------------------------------*
!A120!      IF  (W81-TIN               = 011
!A120!      AND  AS030-11-CD-APLICACAO = 120)
!A120!      OR  (W81-TIN               = 012
!A120!      AND  AS030-12-CD-APLICACAO = 120)
!A120!      OR  (W81-TIN               = 013
!A120!      AND  AS030-13-CD-APLICACAO = 120)
!A120!      OR  (W81-TIN               = 014
!A120!      AND  AS030-14-CD-APLICACAO = 120)
!A120!      OR  (W81-TIN               = 021
!A120!      AND  AS030-21-CD-APLICACAO = 120)
!A120!
!2103!      OR  (W81-TIN               = 023
!2103!      AND  AS030-23-CD-APLICACAO = 120)
!A120!
!A120!           GO TO 81000-LER-HFS
!A120!
!A120!      END-IF
!PRUN!*----------------------------------------------------------------*
!PRUN!*- PROUNI ---------------------------------- DESPREZAR APL=130 --*
!PRUN!*----------------------------------------------------------------*
!PRUN!      IF  (W81-TIN               = 011
!PRUN!      AND  AS030-11-CD-APLICACAO = 130)
!PRUN!      OR  (W81-TIN               = 012
!PRUN!      AND  AS030-12-CD-APLICACAO = 130)
!PRUN!      OR  (W81-TIN               = 013
!PRUN!      AND  AS030-13-CD-APLICACAO = 130)
!PRUN!      OR  (W81-TIN               = 014
!PRUN!      AND  AS030-14-CD-APLICACAO = 130)
!PRUN!      OR  (W81-TIN               = 021
!PRUN!      AND  AS030-21-CD-APLICACAO = 130)
!PRUN!
!PRUN!      OR  (W81-TIN               = 023
!PRUN!      AND  AS030-23-CD-APLICACAO = 130)
!PRUN!
!PRUN!           GO TO 81000-LER-HFS
!PRUN!
!PRUN!      END-IF
!RRIO!*----------------------------------------------------------------*
!RRIO!*- RRIO   ---------------------------------- DESPREZAR APL=140 --*
!RRIO!*----------------------------------------------------------------*
!RRIO!      IF  (W81-TIN               = 011
!RRIO!      AND  AS030-11-CD-APLICACAO = 140)
!RRIO!      OR  (W81-TIN               = 012
!RRIO!      AND  AS030-12-CD-APLICACAO = 140)
!RRIO!      OR  (W81-TIN               = 013
!RRIO!      AND  AS030-13-CD-APLICACAO = 140)
!RRIO!      OR  (W81-TIN               = 014
!RRIO!      AND  AS030-14-CD-APLICACAO = 140)
!RRIO!      OR  (W81-TIN               = 021
!RRIO!      AND  AS030-21-CD-APLICACAO = 140)
!RRIO!
!RRIO!      OR  (W81-TIN               = 023
!RRIO!      AND  AS030-23-CD-APLICACAO = 140)
!RRIO!
!RRIO!           GO TO 81000-LER-HFS
!RRIO!
!RRIO!      END-IF
!RRIO2*----------------------------------------------------------------*
!RRIO2*- RRIO2  -------------------------- DESPREZAR APL=141 ----------*
!RRIO2*----------------------------------------------------------------*
!RRIO2      IF  (W81-TIN               = 011
!RRIO2      AND  AS030-11-CD-APLICACAO = 141)

!RRIO2      OR  (W81-TIN               = 012
!RRIO2      AND  AS030-12-CD-APLICACAO = 141)

!RRIO2      OR  (W81-TIN               = 013
!RRIO2      AND  AS030-13-CD-APLICACAO = 141)

!RRIO2      OR  (W81-TIN               = 014
!RRIO2      AND  AS030-14-CD-APLICACAO = 141)

!RRIO2      OR  (W81-TIN               = 021
!RRIO2      AND  AS030-21-CD-APLICACAO = 141)
!RRIO2
!RRIO2      OR  (W81-TIN               = 023
!RRIO2      AND  AS030-23-CD-APLICACAO = 141)
!RRIO2
!RRIO2           GO TO 81000-LER-HFS
!RRIO2
!RRIO2      END-IF
!JMJU!*----------------------------------------------------------------*
!JMJU!*- JMJ    -------------------------- DESPREZAR APL=142 143 144 --*
!JMJU!*----------------------------------------------------------------*
!JMJU!      IF  (W81-TIN               = 011
!JMJU!      AND  AS030-11-CD-APLICACAO = 142)
!JMJU!      OR  (W81-TIN               = 011
!JMJU!      AND  AS030-11-CD-APLICACAO = 143)
!JMJU!      OR  (W81-TIN               = 011
!JMJU!      AND  AS030-11-CD-APLICACAO = 144)

!JMJU!      OR  (W81-TIN               = 012
!JMJU!      AND  AS030-12-CD-APLICACAO = 142)
!JMJU!      OR  (W81-TIN               = 012
!JMJU!      AND  AS030-12-CD-APLICACAO = 143)
!JMJU!      OR  (W81-TIN               = 012
!JMJU!      AND  AS030-12-CD-APLICACAO = 144)

!JMJU!      OR  (W81-TIN               = 013
!JMJU!      AND  AS030-13-CD-APLICACAO = 142)
!JMJU!      OR  (W81-TIN               = 013
!JMJU!      AND  AS030-13-CD-APLICACAO = 143)
!JMJU!      OR  (W81-TIN               = 013
!JMJU!      AND  AS030-13-CD-APLICACAO = 144)

!JMJU!      OR  (W81-TIN               = 014
!JMJU!      AND  AS030-14-CD-APLICACAO = 142)
!JMJU!      OR  (W81-TIN               = 014
!JMJU!      AND  AS030-14-CD-APLICACAO = 143)
!JMJU!      OR  (W81-TIN               = 014
!JMJU!      AND  AS030-14-CD-APLICACAO = 144)

!JMJU!      OR  (W81-TIN               = 021
!JMJU!      AND  AS030-21-CD-APLICACAO = 142)
!JMJU!      OR  (W81-TIN               = 021
!JMJU!      AND  AS030-21-CD-APLICACAO = 143)
!JMJU!      OR  (W81-TIN               = 021
!JMJU!      AND  AS030-21-CD-APLICACAO = 144)
!JMJU!
!JMJU!
!JMJU!      OR  (W81-TIN               = 023
!JMJU!      AND  AS030-23-CD-APLICACAO = 142)
!JMJU!      OR  (W81-TIN               = 023
!JMJU!      AND  AS030-23-CD-APLICACAO = 143)
!JMJU!      OR  (W81-TIN               = 023
!JMJU!      AND  AS030-23-CD-APLICACAO = 144)
!JMJU!
!JMJU!           GO TO 81000-LER-HFS
!JMJU!
!JMJU!      END-IF
R2016!*----------------------------------------------------------------*
R2016!*------------------------------------------- DESPREZAR APL=145 --*
R2016!*----------------------------------------------------------------*
R2016!      IF  (W81-TIN               = 011
R2016!      AND  AS030-11-CD-APLICACAO = 145)
R2016!      OR  (W81-TIN               = 012
R2016!      AND  AS030-12-CD-APLICACAO = 145)
R2016!      OR  (W81-TIN               = 013
R2016!      AND  AS030-13-CD-APLICACAO = 145)
R2016!      OR  (W81-TIN               = 014
R2016!      AND  AS030-14-CD-APLICACAO = 145)
R2016!
R2016!      OR  (W81-TIN               = 021
R2016!      AND  AS030-21-CD-APLICACAO = 145)
R2016!      OR  (W81-TIN               = 023
R2016!      AND  AS030-23-CD-APLICACAO = 145)
R2016!
R2016!
R2016!           GO TO 81000-LER-HFS
R2016!
R2016!      END-IF
R2016!*----------------------------------------------------------------*
R2016!*------------------------------------------- DESPREZAR APL=146 --*
R2016!*----------------------------------------------------------------*
R2016!      IF  (W81-TIN               = 011
R2016!      AND  AS030-11-CD-APLICACAO = 146)
R2016!      OR  (W81-TIN               = 012
R2016!      AND  AS030-12-CD-APLICACAO = 146)
R2016!      OR  (W81-TIN               = 013
R2016!      AND  AS030-13-CD-APLICACAO = 146)
R2016!      OR  (W81-TIN               = 014
R2016!      AND  AS030-14-CD-APLICACAO = 146)
R2016!      OR  (W81-TIN               = 021
R2016!      AND  AS030-21-CD-APLICACAO = 146)
R2016!      OR  (W81-TIN               = 023
R2016!      AND  AS030-23-CD-APLICACAO = 146)
R2016!
R2016!
R2016!           GO TO 81000-LER-HFS
R2016!
R2016!      END-IF
!TELE!*----------------------------------------------------------------*
!TELE!*- TELEFERICO -- UNITARIO ------------------ DESPREZAR APL=150 --*
!TELE!*----------------------------------------------------------------*
!TELE!      IF  (W81-TIN               = 011
!TELE!      AND  AS030-11-CD-APLICACAO = 150)
!TELE!      OR  (W81-TIN               = 012
!TELE!      AND  AS030-12-CD-APLICACAO = 150)
!TELE!      OR  (W81-TIN               = 013
!TELE!      AND  AS030-13-CD-APLICACAO = 150)
!TELE!      OR  (W81-TIN               = 014
!TELE!      AND  AS030-14-CD-APLICACAO = 150)
!TELE!      OR  (W81-TIN               = 021
!TELE!      AND  AS030-21-CD-APLICACAO = 150)
!TELE!
!TELE!
!TELE!      OR  (W81-TIN               = 023
!TELE!      AND  AS030-23-CD-APLICACAO = 150)
!TELE!
!TELE!           GO TO 81000-LER-HFS
!TELE!
!TELE!      END-IF
!TELE!*----------------------------------------------------------------*
!TELE!*- TELEFERICO -- UNITARIO/INTEGRACAO ------- DESPREZAR APL=160 --*
!TELE!*----------------------------------------------------------------*
!TELE!      IF  (W81-TIN               = 011
!TELE!      AND  AS030-11-CD-APLICACAO = 160)
!TELE!      OR  (W81-TIN               = 012
!TELE!      AND  AS030-12-CD-APLICACAO = 160)
!TELE!      OR  (W81-TIN               = 013
!TELE!      AND  AS030-13-CD-APLICACAO = 160)
!TELE!      OR  (W81-TIN               = 014
!TELE!      AND  AS030-14-CD-APLICACAO = 160)
!TELE!      OR  (W81-TIN               = 021
!TELE!      AND  AS030-21-CD-APLICACAO = 160)
!TELE!
!TELE!      OR  (W81-TIN               = 023
!TELE!      AND  AS030-23-CD-APLICACAO = 160)
!TELE!
!TELE!           GO TO 81000-LER-HFS
!TELE!
!TELE!      END-IF
!TELE!*----------------------------------------------------------------*
!TELE!*- TELEFERICO -- UNITARIO/GRATUIDADE ------- DESPREZAR APL=170---*
!TELE!*----------------------------------------------------------------*
!TELE!      IF  (W81-TIN               = 011
!TELE!      AND  AS030-11-CD-APLICACAO = 170)
!TELE!      OR  (W81-TIN               = 012
!TELE!      AND  AS030-12-CD-APLICACAO = 170)
!TELE!      OR  (W81-TIN               = 013
!TELE!      AND  AS030-13-CD-APLICACAO = 170)
!TELE!      OR  (W81-TIN               = 014
!TELE!      AND  AS030-14-CD-APLICACAO = 170)
!TELE!      OR  (W81-TIN               = 021
!TELE!      AND  AS030-21-CD-APLICACAO = 170)
!TELE!
!TELE!      OR  (W81-TIN               = 023
!TELE!      AND  AS030-23-CD-APLICACAO = 170)
!TELE!
!TELE!           GO TO 81000-LER-HFS
!TELE!
!TELE!      END-IF
!TELE1*----------------------------------------------------------------*
!TELE1*- TELEFERICO -- T U R I S T A  ------------ DESPREZAR APL=180---*
!TELE1*----------------------------------------------------------------*
!TELE1      IF  (W81-TIN               = 011
!TELE1      AND  AS030-11-CD-APLICACAO = 180)
!TELE1      OR  (W81-TIN               = 012
!TELE1      AND  AS030-12-CD-APLICACAO = 180)
!TELE1      OR  (W81-TIN               = 013
!TELE1      AND  AS030-13-CD-APLICACAO = 180)
!TELE1      OR  (W81-TIN               = 014
!TELE1      AND  AS030-14-CD-APLICACAO = 180)
!TELE1      OR  (W81-TIN               = 021
!TELE1      AND  AS030-21-CD-APLICACAO = 180)
!TELE1
!TELE1      OR  (W81-TIN               = 023
!TELE1      AND  AS030-23-CD-APLICACAO = 180)
!TELE1
!TELE1           GO TO 81000-LER-HFS
!TELE1
!TELE1      END-IF
!RR17!*----------------------------------------------------------------*
!RR17!*- ROCK IN RIO 2017 - DESPREZAR APL=201 202 203 204 205 206 207 -*
!RR17!*-                                  208                         -*
!RR17!*----------------------------------------------------------------*
!RR17!      IF  (W81-TIN               = 011
!RR17!      AND  AS030-11-CD-APLICACAO = 201)
!RR17!      OR  (W81-TIN               = 011
!RR17!      AND  AS030-11-CD-APLICACAO = 202)
!RR17!      OR  (W81-TIN               = 011
!RR17!      AND  AS030-11-CD-APLICACAO = 203)
!RR17!      OR  (W81-TIN               = 011
!RR17!      AND  AS030-11-CD-APLICACAO = 204)
!RR17!      OR  (W81-TIN               = 011
!RR17!      AND  AS030-11-CD-APLICACAO = 205)
!RR17!      OR  (W81-TIN               = 011
!RR17!      AND  AS030-11-CD-APLICACAO = 206)
!RR17!      OR  (W81-TIN               = 011
!RR17!      AND  AS030-11-CD-APLICACAO = 207)
!RR17!      OR  (W81-TIN               = 011
!RR17!      AND  AS030-11-CD-APLICACAO = 208)

!RR17!      OR  (W81-TIN               = 012
!RR17!      AND  AS030-12-CD-APLICACAO = 201)
!RR17!      OR  (W81-TIN               = 012
!RR17!      AND  AS030-12-CD-APLICACAO = 202)
!RR17!      OR  (W81-TIN               = 012
!RR17!      AND  AS030-12-CD-APLICACAO = 203)
!RR17!      OR  (W81-TIN               = 012
!RR17!      AND  AS030-12-CD-APLICACAO = 204)
!RR17!      OR  (W81-TIN               = 012
!RR17!      AND  AS030-12-CD-APLICACAO = 205)
!RR17!      OR  (W81-TIN               = 012
!RR17!      AND  AS030-12-CD-APLICACAO = 206)
!RR17!      OR  (W81-TIN               = 012
!RR17!      AND  AS030-12-CD-APLICACAO = 207)
!RR17!      OR  (W81-TIN               = 012
!RR17!      AND  AS030-12-CD-APLICACAO = 208)

!RR17!      OR  (W81-TIN               = 013
!RR17!      AND  AS030-13-CD-APLICACAO = 201)
!RR17!      OR  (W81-TIN               = 013
!RR17!      AND  AS030-13-CD-APLICACAO = 202)
!RR17!      OR  (W81-TIN               = 013
!RR17!      AND  AS030-13-CD-APLICACAO = 203)
!RR17!      OR  (W81-TIN               = 013
!RR17!      AND  AS030-13-CD-APLICACAO = 204)
!RR17!      OR  (W81-TIN               = 013
!RR17!      AND  AS030-13-CD-APLICACAO = 205)
!RR17!      OR  (W81-TIN               = 013
!RR17!      AND  AS030-13-CD-APLICACAO = 206)
!RR17!      OR  (W81-TIN               = 013
!RR17!      AND  AS030-13-CD-APLICACAO = 207)
!RR17!      OR  (W81-TIN               = 013
!RR17!      AND  AS030-13-CD-APLICACAO = 208)

!RR17!      OR  (W81-TIN               = 014
!RR17!      AND  AS030-14-CD-APLICACAO = 201)
!RR17!      OR  (W81-TIN               = 014
!RR17!      AND  AS030-14-CD-APLICACAO = 202)
!RR17!      OR  (W81-TIN               = 014
!RR17!      AND  AS030-14-CD-APLICACAO = 203)
!RR17!      OR  (W81-TIN               = 014
!RR17!      AND  AS030-14-CD-APLICACAO = 204)
!RR17!      OR  (W81-TIN               = 014
!RR17!      AND  AS030-14-CD-APLICACAO = 205)
!RR17!      OR  (W81-TIN               = 014
!RR17!      AND  AS030-14-CD-APLICACAO = 206)
!RR17!      OR  (W81-TIN               = 014
!RR17!      AND  AS030-14-CD-APLICACAO = 207)
!RR17!      OR  (W81-TIN               = 014
!RR17!      AND  AS030-14-CD-APLICACAO = 208)

!RR17!      OR  (W81-TIN               = 021
!RR17!      AND  AS030-21-CD-APLICACAO = 201)
!RR17!      OR  (W81-TIN               = 021
!RR17!      AND  AS030-21-CD-APLICACAO = 202)
!RR17!      OR  (W81-TIN               = 021
!RR17!      AND  AS030-21-CD-APLICACAO = 203)
!RR17!      OR  (W81-TIN               = 021
!RR17!      AND  AS030-21-CD-APLICACAO = 204)
!RR17!      OR  (W81-TIN               = 021
!RR17!      AND  AS030-21-CD-APLICACAO = 205)
!RR17!      OR  (W81-TIN               = 021
!RR17!      AND  AS030-21-CD-APLICACAO = 206)
!RR17!      OR  (W81-TIN               = 021
!RR17!      AND  AS030-21-CD-APLICACAO = 207)
!RR17!      OR  (W81-TIN               = 021
!RR17!      AND  AS030-21-CD-APLICACAO = 208)
!RR17!
!RR17!      OR  (W81-TIN               = 023
!RR17!      AND  AS030-23-CD-APLICACAO = 201)
!RR17!      OR  (W81-TIN               = 023
!RR17!      AND  AS030-23-CD-APLICACAO = 202)
!RR17!      OR  (W81-TIN               = 023
!RR17!      AND  AS030-23-CD-APLICACAO = 203)
!RR17!      OR  (W81-TIN               = 023
!RR17!      AND  AS030-23-CD-APLICACAO = 204)
!RR17!      OR  (W81-TIN               = 023
!RR17!      AND  AS030-23-CD-APLICACAO = 205)
!RR17!      OR  (W81-TIN               = 023
!RR17!      AND  AS030-23-CD-APLICACAO = 206)
!RR17!      OR  (W81-TIN               = 023
!RR17!      AND  AS030-23-CD-APLICACAO = 207)
!RR17!      OR  (W81-TIN               = 023
!RR17!      AND  AS030-23-CD-APLICACAO = 208)
!RR17!
!RR17!           GO TO 81000-LER-HFS
!RR17!
!RR17!      END-IF
!TELE!*----------------------------------------------------------------*
!TELE!*- TELEFERICO -- -- MORADOR ---------------- DESPREZAR APL=810 --*
!TELE!*----------------------------------------------------------------*
!TELE!      IF  (W81-TIN               = 011
!TELE!      AND  AS030-11-CD-APLICACAO = 810)
!TELE!      OR  (W81-TIN               = 012
!TELE!      AND  AS030-12-CD-APLICACAO = 810)
!TELE!      OR  (W81-TIN               = 013
!TELE!      AND  AS030-13-CD-APLICACAO = 810)
!TELE!      OR  (W81-TIN               = 014
!TELE!      AND  AS030-14-CD-APLICACAO = 810)
!TELE!      OR  (W81-TIN               = 021
!TELE!      AND  AS030-21-CD-APLICACAO = 810)
!TELE!
!TELE!      OR  (W81-TIN               = 023
!TELE!      AND  AS030-23-CD-APLICACAO = 810)
!TELE!
!TELE!           GO TO 81000-LER-HFS
!TELE!
!TELE!      END-IF
!BARC!*----------------------------------------------------------------*
!BARC!*- AQUAVIARIO -- -- MORADOR ---------------- DESPREZAR APL=820 --*
!BARC!*----------------------------------------------------------------*
!BARC!      IF  (W81-TIN               = 011
!BARC!      AND  AS030-11-CD-APLICACAO = 820)
!BARC!      OR  (W81-TIN               = 012
!BARC!      AND  AS030-12-CD-APLICACAO = 820)
!BARC!      OR  (W81-TIN               = 013
!BARC!      AND  AS030-13-CD-APLICACAO = 820)
!BARC!      OR  (W81-TIN               = 014
!BARC!      AND  AS030-14-CD-APLICACAO = 820)
!BARC!      OR  (W81-TIN               = 021
!BARC!      AND  AS030-21-CD-APLICACAO = 820)
!BARC!
!BARC!      OR  (W81-TIN               = 023
!BARC!      AND  AS030-23-CD-APLICACAO = 820)
!BARC!
!BARC!           GO TO 81000-LER-HFS
!BARC!
!BARC!      END-IF
!METR!*----------------------------------------------------------------*
!METR!*-   METRO    ------------------------------ DESPREZAR APL=210 --*
!METR!*----------------------------------------------------------------*
!METR!      IF  (W81-TIN               = 011
!METR!      AND  AS030-11-CD-APLICACAO = 210)
!METR!      OR  (W81-TIN               = 012
!METR!      AND  AS030-12-CD-APLICACAO = 210)
!METR!      OR  (W81-TIN               = 013
!METR!      AND  AS030-13-CD-APLICACAO = 210)
!METR!      OR  (W81-TIN               = 014
!METR!      AND  AS030-14-CD-APLICACAO = 210)
!METR!      OR  (W81-TIN               = 021
!METR!      AND  AS030-21-CD-APLICACAO = 210)
!METR!
!METR!      OR  (W81-TIN               = 023
!METR!      AND  AS030-23-CD-APLICACAO = 210)
!METR!
!METR!           GO TO 81000-LER-HFS
!METR!
!METR!      END-IF
!METR!*----------------------------------------------------------------*
!METR!*-   METRO    ------------------------------ DESPREZAR APL=220 --*
!METR!*----------------------------------------------------------------*
!METR!      IF  (W81-TIN               = 011
!METR!      AND  AS030-11-CD-APLICACAO = 220)
!METR!      OR  (W81-TIN               = 012
!METR!      AND  AS030-12-CD-APLICACAO = 220)
!METR!      OR  (W81-TIN               = 013
!METR!      AND  AS030-13-CD-APLICACAO = 220)
!METR!      OR  (W81-TIN               = 014
!METR!      AND  AS030-14-CD-APLICACAO = 220)
!METR!      OR  (W81-TIN               = 021
!METR!      AND  AS030-21-CD-APLICACAO = 220)
!METR!
!METR!      OR  (W81-TIN               = 023
!METR!      AND  AS030-23-CD-APLICACAO = 220)
!METR!
!METR!           GO TO 81000-LER-HFS
!METR!
!METR!      END-IF
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
!2511!      OR  (W81-TIN               = 023
!2511!      AND  AS030-23-CD-APLICACAO = 430)
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
!2506!      OR  (W81-TIN               = 023
!2506!      AND  AS030-23-CD-APLICACAO = 431)
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
      * 1) MOVER OS CAMPOS DA PRODATA (BINARIO)         (AS032) ->
      *     PARA OS CAMPOS TEXTO (REDEFINICAO DE CAMPOS EM COMP) (AS033)
      *
      * 2) MOVER OS CAMPOS COMP (REDEFINICAO DO AS033)  (AS031) ->
      *          PARA OS CAMPOS COM A PICTURE CORRETA            (AS030)
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
!0701!       WHEN 07
!0701!        PERFORM 81100-MOVER-REG-07
!0701!        PERFORM 82000-DISPLAY-REG-07
!0701!       WHEN 08
!0701!        PERFORM 81100-MOVER-REG-08
!0701!        PERFORM 82000-DISPLAY-REG-08
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
!2103!       WHEN 23
!2103!        PERFORM 81100-MOVER-REG-23
!2103!        PERFORM 82000-DISPLAY-REG-23
!1508!       WHEN 50
!1508!        PERFORM 81100-MOVER-REG-50
!1508!        PERFORM 82000-DISPLAY-REG-50
!1508!       WHEN 51
!1508!        PERFORM 81100-MOVER-REG-51
!1508!        PERFORM 82000-DISPLAY-REG-51
!0309!       WHEN 52
!0309!        PERFORM 81100-MOVER-REG-52
!0309!        PERFORM 82000-DISPLAY-REG-52
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
      * 1) MOVER OS CAMPOS DA PRODATA (BINARIO)         (AS032) ->
      *     PARA OS CAMPOS TEXTO (REDEFINICAO DE CAMPOS EM COMP) (AS033)
      *
      * 2) MOVER OS CAMPOS COMP (REDEFINICAO DO AS033)  (AS031) ->
      *          PARA OS CAMPOS COM A PICTURE CORRETA            (AS030)
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
!0701!       WHEN 07
!0701!        PERFORM 81100-MOVER-REG-07
!0701!        PERFORM 83000-DISPLAY-REG-07
!0701!       WHEN 08
!0701!        PERFORM 81100-MOVER-REG-08
!0701!        PERFORM 83000-DISPLAY-REG-08
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
!2103!       WHEN 23
!2103!        PERFORM 81100-MOVER-REG-23
!2103!        PERFORM 83000-DISPLAY-REG-23
!1508!       WHEN 50
!1508!        PERFORM 81100-MOVER-REG-50
!1508!        PERFORM 83000-DISPLAY-REG-50
!1508!       WHEN 51
!1508!        PERFORM 81100-MOVER-REG-51
!1508!        PERFORM 83000-DISPLAY-REG-51
!0309!       WHEN 52
!0309!        PERFORM 81100-MOVER-REG-52
!0309!        PERFORM 83000-DISPLAY-REG-52
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
      * 1) MOVER OS CAMPOS DA PRODATA (BINARIO)         (AS032) ->
      *     PARA OS CAMPOS TEXTO (REDEFINICAO DE CAMPOS EM COMP) (AS033)
      *
      * 2) MOVER OS CAMPOS COMP (REDEFINICAO DO AS033)  (AS031) ->
      *          PARA OS CAMPOS COM A PICTURE CORRETA            (AS030)
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
!0701!       WHEN 07
!0701!        PERFORM 81100-MOVER-REG-07
!0701!       WHEN 08
!0701!        PERFORM 81100-MOVER-REG-08
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
!2103!       WHEN 23
!2103!        PERFORM 81100-MOVER-REG-23
!1805!       WHEN 50
!1805!        PERFORM 81100-MOVER-REG-50
!1805!       WHEN 51
!1805!        PERFORM 81100-MOVER-REG-51
!0309!       WHEN 52
!0309!        PERFORM 81100-MOVER-REG-52
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

!L207P     MOVE 88                           TO C2EBCDIC-LEN
!L207P     MOVE AS030-HEADER-01  (01:88)     TO C2EBCDIC-CAMPO
!L207P     CALL C2EBCDIC USING C2EBCDIC-PARM
!L207P     MOVE C2EBCDIC-CAMPO (01:88)       TO AS030-HEADER-01 (01:88)

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

!2009!*-----------------------------------------------------------------
!2009!     MOVE AS032-02-NR-VERS-VALID
!2009!       TO AS033-02-NR-VERS-VALID     (03:02)
!2009!     MOVE AS032-02-NR-VERS-ARQ-EOD
!2009!       TO AS033-02-NR-VERS-ARQ-EOD   (03:02)
!2009!     MOVE AS032-02-NR-VERS-ARQ-HOTL
!2009!       TO AS033-02-NR-VERS-ARQ-HOTL  (03:02)
!2009!     MOVE AS032-02-NR-VERS-ARQ-HOTBU
!2009!       TO AS033-02-NR-VERS-ARQ-HOTBU (03:02)
!2009!     MOVE AS032-02-NR-VERS-ARQ-RECAR
!2009!       TO AS033-02-NR-VERS-ARQ-RECAR (03:02)
!2009!     MOVE AS032-02-NR-VERS-ARQ-LINHA
!2009!       TO AS033-02-NR-VERS-ARQ-LINHA (03:02)
!2009!     MOVE AS032-02-NR-VERS-ARQ-GLINHA
!2009!       TO AS033-02-NR-VERS-ARQ-GLINHA(03:02)
!2009!     MOVE AS032-02-NR-VERS-ARQ-MINTEG
!2009!       TO AS033-02-NR-VERS-ARQ-MINTEG(03:02)
!2009!*-----------------------------------------------------------------

           MOVE AS033-DETALHE-02         TO AS031-DETALHE-02

           MOVE AS031-02-TP-REGISTRO     TO AS030-02-TP-REGISTRO
           MOVE AS031-02-NR-TRAN-SAM     TO AS030-02-NR-TRAN-SAM
           MOVE AS031-02-DT-TRANS        TO AS030-02-DT-TRANS
           MOVE AS031-02-HR-TRANS        TO AS030-02-HR-TRANS
           MOVE AS031-02-NR-ARQ-LOG      TO AS030-02-NR-ARQ-LOG

!2009!*-----------------------------------------------------------------
!2009!     MOVE AS031-02-NR-VERS-VALID     TO AS030-02-NR-VERS-VALID
!2009!     MOVE AS031-02-NR-VERS-ARQ-EOD   TO AS030-02-NR-VERS-ARQ-EOD
!2009!     MOVE AS031-02-NR-VERS-ARQ-HOTL  TO AS030-02-NR-VERS-ARQ-HOTL
!2009!     MOVE AS031-02-NR-VERS-ARQ-HOTBU TO AS030-02-NR-VERS-ARQ-HOTBU
!2009!     MOVE AS031-02-NR-VERS-ARQ-RECAR TO AS030-02-NR-VERS-ARQ-RECAR
!2009!     MOVE AS031-02-NR-VERS-ARQ-LINHA TO AS030-02-NR-VERS-ARQ-LINHA
!2009!     MOVE AS031-02-NR-VERS-ARQ-GLINHA
!2009!       TO AS030-02-NR-VERS-ARQ-GLINHA
!2009!     MOVE AS031-02-NR-VERS-ARQ-MINTEG
!2009!       TO AS030-02-NR-VERS-ARQ-MINTEG
!2009!*-----------------------------------------------------------------

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
!0701!*----------------------------------------------------------------*
!0701! 81100-MOVER-REG-07.
!0701!*----------------------------------------------------------------*

           MOVE AS032-REGISTRO           TO AS032-DETALHE-07

           MOVE LOW-VALUES               TO AS033-DETALHE-07

           MOVE AS032-07-TP-REGISTRO     TO AS033-07-TP-REGISTRO(02:01)
           MOVE AS032-07-NR-TRAN-SAM     TO AS033-07-NR-TRAN-SAM
           MOVE AS032-07-DT-TRANS        TO AS033-07-DT-TRANS
           MOVE AS032-07-HR-TRANS        TO AS033-07-HR-TRANS

           MOVE AS032-07-NR-CHIP-CARTAO
             TO AS033-07-NR-CHIP-CARTAO                         (05:04)

           MOVE AS033-DETALHE-07         TO AS031-DETALHE-07

           MOVE AS031-07-TP-REGISTRO     TO AS030-07-TP-REGISTRO
           MOVE AS031-07-NR-TRAN-SAM     TO AS030-07-NR-TRAN-SAM
           MOVE AS031-07-DT-TRANS        TO AS030-07-DT-TRANS
           MOVE AS031-07-HR-TRANS        TO AS030-07-HR-TRANS

           MOVE AS031-07-NR-CHIP-CARTAO  TO AS030-07-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-07-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-07-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-07C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-07C-HR-TRANS
                                            AS030-TXC-HR-TRANS

      *----------------------------------------------------------------*

           MOVE AS030-07-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-07-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (07)
           .
!0701!*----------------------------------------------------------------*
!0701! 81100-MOVER-REG-08.
!0701!*----------------------------------------------------------------*

           MOVE AS032-REGISTRO           TO AS032-DETALHE-08

           MOVE LOW-VALUES               TO AS033-DETALHE-08

           MOVE AS032-08-TP-REGISTRO     TO AS033-08-TP-REGISTRO(02:01)
           MOVE AS032-08-NR-TRAN-SAM     TO AS033-08-NR-TRAN-SAM
           MOVE AS032-08-DT-TRANS        TO AS033-08-DT-TRANS
           MOVE AS032-08-HR-TRANS        TO AS033-08-HR-TRANS

           MOVE AS032-08-NR-CHIP-CARTAO
             TO AS033-08-NR-CHIP-CARTAO                         (05:04)

           MOVE AS033-DETALHE-08         TO AS031-DETALHE-08

           MOVE AS031-08-TP-REGISTRO     TO AS030-08-TP-REGISTRO
           MOVE AS031-08-NR-TRAN-SAM     TO AS030-08-NR-TRAN-SAM
           MOVE AS031-08-DT-TRANS        TO AS030-08-DT-TRANS
           MOVE AS031-08-HR-TRANS        TO AS030-08-HR-TRANS

           MOVE AS031-08-NR-CHIP-CARTAO  TO AS030-08-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      *---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
      *----------------------------------------------------------------*

           MOVE AS030-08-DT-TRANS        TO W55-DDDD
           PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD

           MOVE AS030-08-HR-TRANS        TO W55-HHMM-FT
           PERFORM 55400-CONVHM-HHMMFT-HHMMSS

           MOVE W55-AAAAMMDD             TO AS030-08C-DT-TRANS
                                            AS030-TXC-DT-TRANS
           MOVE W55-HHMMSS               TO AS030-08C-HR-TRANS
                                            AS030-TXC-HR-TRANS

      *----------------------------------------------------------------*

           MOVE AS030-08-TX-CONTROLE     TO AS030-TX-CONTROLE
           MOVE AS030-08-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO

      *----------------------------------------------------------------*
      * ATUALIZAR TOTALIZADORES DO ARQUIVO.
      *----------------------------------------------------------------*

           ADD  1                            TO W81-VT99-QTD (08)
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
!L207!     MOVE AS032-11-IN-ORIG-CARGA TO AS033-11-IN-ORIG-CARGA (02:01))
!0701!     MOVE AS032-11-TP-BU          TO AS033-11-TP-BU       (02:01)

!2103!     MOVE AS032-11-VL-TRANS       TO AS033-11-VL-TRANS    (02:03)

           MOVE AS032-11-VL-SALDO       TO AS033-11-VL-SALDO
!0701!     MOVE AS032-11-TP-DEBITO      TO AS033-11-TP-DEBITO   (02:01)
!0701!     MOVE AS032-11-VL-LINHA       TO AS033-11-VL-LINHA    (02:03)
!2009!     MOVE AS032-11-MT-DEBITO      TO AS033-11-MT-DEBITO   (02:01)

           MOVE AS033-DETALHE-11        TO AS031-DETALHE-11

           MOVE AS031-11-TP-REGISTRO    TO AS030-11-TP-REGISTRO
           MOVE AS031-11-NR-TRAN-SAM    TO AS030-11-NR-TRAN-SAM
           MOVE AS031-11-DT-TRANS       TO AS030-11-DT-TRANS
           MOVE AS031-11-HR-TRANS       TO AS030-11-HR-TRANS

           MOVE AS031-11-NR-CHIP-CARTAO TO AS030-11-NR-CHIP-CARTAO
           MOVE AS031-11-CD-APLICACAO   TO AS030-11-CD-APLICACAO
           MOVE AS031-11-NR-TRANSACAO   TO AS030-11-NR-TRANSACAO
           MOVE AS031-11-NR-CARGA       TO AS030-11-NR-CARGA
!L207!     MOVE AS031-11-IN-ORIG-CARGA  TO AS030-11-IN-ORIG-CARGA
!0701!     MOVE AS031-11-TP-BU          TO AS030-11-TP-BU

           MOVE AS031-11-VL-TRANS       TO AS030-11-VL-TRANS

           MOVE AS031-11-VL-SALDO       TO AS030-11-VL-SALDO

!0701!     MOVE AS031-11-TP-DEBITO      TO AS030-11-TP-DEBITO
!0701!     MOVE AS031-11-VL-LINHA       TO AS030-11-VL-LINHA
!2009!     MOVE AS031-11-MT-DEBITO      TO AS030-11-MT-DEBITO

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

!0701!     MOVE AS030-11-VL-LINHA        TO W55-VAL-FT
!0701!     PERFORM 55500-CONVVL-VALFT-VAL
!0701!     MOVE W55-VAL                  TO AS030-11C-VL-LINHA

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
!L207!     MOVE AS032-12-IN-ORIG-CARGA TO AS033-12-IN-ORIG-CARGA (02:01))
!0701!     MOVE AS032-12-TP-BU          TO AS033-12-TP-BU       (02:01)

!2103!     MOVE AS032-12-VL-TRANS       TO AS033-12-VL-TRANS    (02:03)

           MOVE AS032-12-VL-SALDO       TO AS033-12-VL-SALDO

!0701!     MOVE AS032-12-TP-DEBITO      TO AS033-12-TP-DEBITO   (02:01)
!0701!     MOVE AS032-12-VL-LINHA       TO AS033-12-VL-LINHA    (02:03)
!2009!     MOVE AS032-12-MT-DEBITO      TO AS033-12-MT-DEBITO   (02:01)

           MOVE AS033-DETALHE-12        TO AS031-DETALHE-12

           MOVE AS031-12-TP-REGISTRO    TO AS030-12-TP-REGISTRO
           MOVE AS031-12-NR-TRAN-SAM    TO AS030-12-NR-TRAN-SAM
           MOVE AS031-12-DT-TRANS       TO AS030-12-DT-TRANS
           MOVE AS031-12-HR-TRANS       TO AS030-12-HR-TRANS

           MOVE AS031-12-NR-CHIP-CARTAO TO AS030-12-NR-CHIP-CARTAO
           MOVE AS031-12-CD-APLICACAO   TO AS030-12-CD-APLICACAO
           MOVE AS031-12-NR-TRANSACAO   TO AS030-12-NR-TRANSACAO
           MOVE AS031-12-NR-CARGA       TO AS030-12-NR-CARGA
!L207!     MOVE AS031-12-IN-ORIG-CARGA  TO AS030-12-IN-ORIG-CARGA
!0701!     MOVE AS031-12-TP-BU          TO AS030-12-TP-BU

           MOVE AS031-12-VL-TRANS       TO AS030-12-VL-TRANS

           MOVE AS031-12-VL-SALDO       TO AS030-12-VL-SALDO

!0701!     MOVE AS031-12-TP-DEBITO      TO AS030-12-TP-DEBITO
!0701!     MOVE AS031-12-VL-LINHA       TO AS030-12-VL-LINHA
!2009!     MOVE AS031-12-MT-DEBITO      TO AS030-12-MT-DEBITO

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

!0701!     MOVE AS030-12-VL-LINHA        TO W55-VAL-FT
!0701!     PERFORM 55500-CONVVL-VALFT-VAL
!0701!     MOVE W55-VAL                  TO AS030-12C-VL-LINHA

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
!L207!     MOVE AS032-13-IN-ORIG-CARGA TO AS033-13-IN-ORIG-CARGA (02:01))
!0701!     MOVE AS032-13-TP-BU          TO AS033-13-TP-BU       (02:01)

!2103!     MOVE AS032-13-VL-TRANS       TO AS033-13-VL-TRANS    (02:03)

           MOVE AS032-13-VL-SALDO       TO AS033-13-VL-SALDO

!0701!     MOVE AS032-13-TP-DEBITO      TO AS033-13-TP-DEBITO   (02:01)
!0701!     MOVE AS032-13-VL-LINHA       TO AS033-13-VL-LINHA    (02:03)
!2009!     MOVE AS032-13-MT-DEBITO      TO AS033-13-MT-DEBITO   (02:01)

           MOVE AS033-DETALHE-13        TO AS031-DETALHE-13

           MOVE AS031-13-TP-REGISTRO    TO AS030-13-TP-REGISTRO
           MOVE AS031-13-NR-TRAN-SAM    TO AS030-13-NR-TRAN-SAM
           MOVE AS031-13-DT-TRANS       TO AS030-13-DT-TRANS
           MOVE AS031-13-HR-TRANS       TO AS030-13-HR-TRANS

           MOVE AS031-13-NR-CHIP-CARTAO TO AS030-13-NR-CHIP-CARTAO
           MOVE AS031-13-CD-APLICACAO   TO AS030-13-CD-APLICACAO
           MOVE AS031-13-NR-TRANSACAO   TO AS030-13-NR-TRANSACAO
           MOVE AS031-13-NR-CARGA       TO AS030-13-NR-CARGA
!L207!     MOVE AS031-13-IN-ORIG-CARGA  TO AS030-13-IN-ORIG-CARGA
!0701!     MOVE AS031-13-TP-BU          TO AS030-13-TP-BU

           MOVE AS031-13-VL-TRANS       TO AS030-13-VL-TRANS

           MOVE AS031-13-VL-SALDO       TO AS030-13-VL-SALDO

!0701!     MOVE AS031-13-TP-DEBITO      TO AS030-13-TP-DEBITO
!0701!     MOVE AS031-13-VL-LINHA       TO AS030-13-VL-LINHA
!2009!     MOVE AS031-13-MT-DEBITO      TO AS030-13-MT-DEBITO

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

!0701!     MOVE AS030-13-VL-LINHA        TO W55-VAL-FT
!0701!     PERFORM 55500-CONVVL-VALFT-VAL
!0701!     MOVE W55-VAL                  TO AS030-13C-VL-LINHA

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

!2009!     MOVE AS032-14-IN-TRANSF      TO AS033-14-IN-TRANSF   (02:01)

           MOVE AS032-14-CD-INTEGRACAO  TO AS033-14-CD-INTEGRACAO
!3110!                                                          (03:02)
           MOVE AS032-14-NR-CARGA       TO AS033-14-NR-CARGA    (03:02)
!L207!     MOVE AS032-14-IN-ORIG-CARGA TO AS033-14-IN-ORIG-CARGA (02:01))
!0701!     MOVE AS032-14-TP-BU          TO AS033-14-TP-BU       (02:01)

           MOVE AS032-14-VL-TARIFA-INTEGRACAO
!2103!       TO AS033-14-VL-TARIFA-INTEGRACAO                   (02:03)

           MOVE AS032-14-VL-SALDO       TO AS033-14-VL-SALDO

!0701!     MOVE AS032-14-TP-DEBITO      TO AS033-14-TP-DEBITO   (02:01)
!0701!     MOVE AS032-14-VL-LINHA       TO AS033-14-VL-LINHA    (02:03)

!2009!*----AQUIX1-------------------------------------------------------
!2009!     MOVE AS032-14-DT-TRANS-ANT   TO AS033-14-DT-TRANS-ANT
!2009!     MOVE AS032-14-HR-TRANS-ANT   TO AS033-14-HR-TRANS-ANT
!2009!     MOVE AS032-14-CD-LINHA-ANT   TO AS033-14-CD-LINHA-ANT
!2009!     MOVE AS032-14-CD-INTEG-ANT   TO AS033-14-CD-INTEG-ANT (03:02)
!2009!     MOVE AS032-14-IN-TRANSF-ANT  TO AS033-14-IN-TRANSF-ANT(02:01)
!2009!     MOVE AS032-14-CD-SENTIDO-ANT
!2009!       TO AS033-14-CD-SENTIDO-ANT (02:01)
!2009!     MOVE AS032-14-VL-DEB-ACUM    TO AS033-14-VL-DEB-ACUM  (02:03)
!2009!*-----------------------------------------------------------------

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
!2009!     MOVE AS031-14-IN-TRANSF        TO AS030-14-IN-TRANSF
           MOVE AS031-14-CD-INTEGRACAO    TO AS030-14-CD-INTEGRACAO
           MOVE AS031-14-NR-CARGA         TO AS030-14-NR-CARGA
!L207!     MOVE AS031-14-IN-ORIG-CARGA    TO AS030-14-IN-ORIG-CARGA
!0701!     MOVE AS031-14-TP-BU            TO AS030-14-TP-BU
           MOVE AS031-14-VL-TARIFA-INTEGRACAO
             TO AS030-14-VL-TARIFA-INTEGRACAO
           MOVE AS031-14-VL-SALDO         TO AS030-14-VL-SALDO
!0701!     MOVE AS031-14-TP-DEBITO        TO AS030-14-TP-DEBITO
!0701!     MOVE AS031-14-VL-LINHA         TO AS030-14-VL-LINHA

!2009!*----AQUIX2-------------------------------------------------------
!2009!     MOVE AS031-14-DT-TRANS-ANT     TO AS030-14-DT-TRANS-ANT
!2009!     MOVE AS031-14-HR-TRANS-ANT     TO AS030-14-HR-TRANS-ANT
!2009!     MOVE AS031-14-CD-LINHA-ANT     TO AS030-14-CD-LINHA-ANT
!2009!     MOVE AS031-14-CD-INTEG-ANT     TO AS030-14-CD-INTEG-ANT
!2009!     MOVE AS031-14-IN-TRANSF-ANT    TO AS030-14-IN-TRANSF-ANT
!2009!     MOVE AS031-14-CD-SENTIDO-ANT   TO AS030-14-CD-SENTIDO-ANT
!2009!     MOVE AS031-14-VL-DEB-ACUM      TO AS030-14-VL-DEB-ACUM
!2009!*-----------------------------------------------------------------
!1706!*    IF AS030-01-CD-SINDICATO = 12
!1706!*       IF  AS030-01-CD-FORNECEDOR = 4
!1706!*           IF AS030-14-IN-TRANSF = 1
!1706!*              MOVE 0 TO AS030-14-IN-TRANSF
!1706!*           END-IF
!1706!*           IF AS030-14-IN-TRANSF = 2
!1706!*              MOVE 1 TO AS030-14-IN-TRANSF
!1706!*           END-IF
!1706!*           IF AS030-14-IN-TRANSF-ANT     = 1
!1706!*              MOVE 0 TO AS030-14-IN-TRANSF-ANT
!1706!*           END-IF
!1706!*           IF AS030-14-IN-TRANSF-ANT    = 2
!1706!*              MOVE 1 TO AS030-14-IN-TRANSF-ANT
!1706!*           END-IF
!1706!*        END-IF
!1706!*    END-IF
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
!2009!*----AQUIX3-------------------------------------------------------
!2009!     MOVE AS030-14-DT-TRANS-ANT    TO W55-DDDD
!2009!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!2009!
!2009!     MOVE AS030-14-HR-TRANS-ANT    TO W55-HHMM-FT
!2009!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!2009!
!2009!     MOVE W55-AAAAMMDD             TO AS030-14C-DT-TRANS-ANT
!2009!     MOVE W55-HHMMSS               TO AS030-14C-HR-TRANS-ANT
!2009!
!2009!     MOVE AS030-14-VL-DEB-ACUM     TO W55-VAL-FT
!2009!
!2009!     PERFORM 55500-CONVVL-VALFT-VAL
!2009!     MOVE W55-VAL                  TO AS030-14C-VL-DEB-ACUM
!2009!*-----------------------------------------------------------------

           MOVE AS030-14-VL-TARIFA-INTEGRACAO
                                         TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO
                AS030-14C-VL-TARIFA-INTEGRACAO

           MOVE AS030-14-VL-SALDO        TO W55-VAL-FT
           PERFORM 55500-CONVVL-VALFT-VAL
           MOVE W55-VAL                  TO AS030-14C-VL-SALDO

!0701!     MOVE AS030-14-VL-LINHA        TO W55-VAL-FT
!0701!     PERFORM 55500-CONVVL-VALFT-VAL
!0701!     MOVE W55-VAL                  TO AS030-14C-VL-LINHA

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
!0701!     MOVE AS032-21-TP-BU          TO AS033-21-TP-BU       (02:01)
!2103!     MOVE AS032-21-VL-CARGA       TO AS033-21-VL-CARGA    (02:03)
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
!0701!     MOVE AS031-21-TP-BU          TO AS030-21-TP-BU
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
!2103!*----------------------------------------------------------------*
!2103! 81100-MOVER-REG-23.
!2103!*----------------------------------------------------------------*
!2103!
!2103!     MOVE AS032-REGISTRO          TO AS032-DETALHE-23
!2103!
!2103!     MOVE LOW-VALUES              TO AS033-DETALHE-23
!2103!
!2103!     MOVE AS032-23-TP-REGISTRO    TO AS033-23-TP-REGISTRO (02:01)
!2103!     MOVE AS032-23-NR-TRAN-SAM    TO AS033-23-NR-TRAN-SAM
!2103!     MOVE AS032-23-DT-TRANS       TO AS033-23-DT-TRANS
!2103!     MOVE AS032-23-HR-TRANS       TO AS033-23-HR-TRANS
!2103!
!2103!     MOVE AS032-23-NR-CHIP-CARTAO
!2103!       TO AS033-23-NR-CHIP-CARTAO                         (05:04)
!2103!
!2103!     MOVE AS032-23-CD-APLICACAO   TO AS033-23-CD-APLICACAO(03:02)
!2103!     MOVE AS032-23-NR-TRANSACAO   TO AS033-23-NR-TRANSACAO(03:02)
!2103!     MOVE AS032-23-NR-CARGA       TO AS033-23-NR-CARGA    (03:02)
!0701!     MOVE AS032-23-TP-BU          TO AS033-23-TP-BU       (02:01)
!2103!     MOVE AS032-23-VL-CARGA       TO AS033-23-VL-CARGA    (02:03)
!2103!     MOVE AS032-23-VL-SALDO       TO AS033-23-VL-SALDO
!2103!     MOVE AS032-23-CD-LINHA       TO AS033-23-CD-LINHA
!2103!
!2103!     MOVE AS033-DETALHE-23        TO AS031-DETALHE-23
!2103!
!2103!     MOVE AS031-23-TP-REGISTRO    TO AS030-23-TP-REGISTRO
!2103!     MOVE AS031-23-NR-TRAN-SAM    TO AS030-23-NR-TRAN-SAM
!2103!     MOVE AS031-23-DT-TRANS       TO AS030-23-DT-TRANS
!2103!     MOVE AS031-23-HR-TRANS       TO AS030-23-HR-TRANS
!2103!
!2103!     MOVE AS031-23-NR-CHIP-CARTAO TO AS030-23-NR-CHIP-CARTAO
!2103!     MOVE AS031-23-CD-APLICACAO   TO AS030-23-CD-APLICACAO
!2103!     MOVE AS031-23-NR-TRANSACAO   TO AS030-23-NR-TRANSACAO
!2103!     MOVE AS031-23-NR-CARGA       TO AS030-23-NR-CARGA
!0701!     MOVE AS031-23-TP-BU          TO AS030-23-TP-BU
!2103!     MOVE AS031-23-VL-CARGA       TO AS030-23-VL-CARGA
!2103!     MOVE AS031-23-VL-SALDO       TO AS030-23-VL-SALDO
!2103!     MOVE AS031-23-CD-LINHA       TO AS030-23-CD-LINHA
!2103!
!2103!*----------------------------------------------------------------*
!2103!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!2103!*----------------------------------------------------------------*
!2103!
!2103!     MOVE AS030-23-DT-TRANS        TO W55-DDDD
!2103!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!2103!
!2103!     MOVE AS030-23-HR-TRANS        TO W55-HHMM-FT
!2103!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!2103!
!2103!     MOVE W55-AAAAMMDD             TO AS030-23C-DT-TRANS
!2103!                                      AS030-TXC-DT-TRANS
!2103!     MOVE W55-HHMMSS               TO AS030-23C-HR-TRANS
!2103!                                      AS030-TXC-HR-TRANS
!2103!
!2103!     MOVE AS030-23-VL-CARGA        TO W55-VAL-FT
!2103!     PERFORM 55500-CONVVL-VALFT-VAL
!2103!     MOVE W55-VAL                  TO AS030-23C-VL-CARGA
!2103!
!2103!     MOVE AS030-23-VL-SALDO        TO W55-VAL-FT
!2103!
!2103!*    COMPUTE W55-VAL-FT = W55-VAL-FT - 4096
!2103!
!2103!     PERFORM 55500-CONVVL-VALFT-VAL
!2103!     MOVE W55-VAL                  TO AS030-23C-VL-SALDO
!2103!
!2103!*----------------------------------------------------------------*
!2103!
!2103!     MOVE AS030-23-TX-CONTROLE     TO AS030-TX-CONTROLE
!2103!     MOVE AS030-23-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!2103!
!2103!*----------------------------------------------------------------*
!2103!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!2103!*----------------------------------------------------------------*
!2103!
!2103!     ADD  1                            TO W81-VT99-QTD (23)
!2103!     ADD  AS030-23C-VL-SALDO           TO W81-VT99-VAL (23)
!2103!     .
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
!0309!*----------------------------------------------------------------*
!0309! 81100-MOVER-REG-52.
!0309!*----------------------------------------------------------------*
!0309!
!0309!     MOVE AS032-REGISTRO           TO AS032-DETALHE-52
!0309!
!0309!     MOVE LOW-VALUES               TO AS033-DETALHE-52
!0309!
!0309!     MOVE AS032-52-TP-REGISTRO     TO AS033-52-TP-REGISTRO(02:01)
!0309!     MOVE AS032-52-NR-TRAN-SAM     TO AS033-52-NR-TRAN-SAM
!0309!     MOVE AS032-52-DT-TRANS        TO AS033-52-DT-TRANS
!0309!     MOVE AS032-52-HR-TRANS        TO AS033-52-HR-TRANS
!0309!
!0309!     MOVE AS032-52-NR-CHIP-CARTAO
!0309!       TO AS033-52-NR-CHIP-CARTAO                         (05:04)
!0309!
!0309!     MOVE AS032-52-CARGA-ENCRIPT
!0309!       TO AS033-52-CARGA-ENCRIPT
!0309!
!0309!     MOVE AS033-DETALHE-52         TO AS031-DETALHE-52
!0309!
!0309!     MOVE AS031-52-TP-REGISTRO     TO AS030-52-TP-REGISTRO
!0309!     MOVE AS031-52-NR-TRAN-SAM     TO AS030-52-NR-TRAN-SAM
!0309!     MOVE AS031-52-DT-TRANS        TO AS030-52-DT-TRANS
!0309!     MOVE AS031-52-HR-TRANS        TO AS030-52-HR-TRANS
!0309!
!0309!     MOVE AS031-52-NR-CHIP-CARTAO  TO AS030-52-NR-CHIP-CARTAO
!0309!
!0309!     MOVE AS031-52-CARGA-ENCRIPT   TO AS030-52-CARGA-ENCRIPT
!0309!
!0309!*----------------------------------------------------------------*
!0309!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!0309!*----------------------------------------------------------------*
!0309!
!0309!     MOVE AS030-52-DT-TRANS        TO W55-DDDD
!0309!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!0309!
!0309!     MOVE AS030-52-HR-TRANS        TO W55-HHMM-FT
!0309!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!0309!
!0309!     MOVE W55-AAAAMMDD             TO AS030-52C-DT-TRANS
!0309!                                      AS030-TXC-DT-TRANS
!0309!     MOVE W55-HHMMSS               TO AS030-52C-HR-TRANS
!0309!                                      AS030-TXC-HR-TRANS
!0309!
!0309!*----------------------------------------------------------------*
!0309!
!0309!     MOVE AS030-52-TX-CONTROLE     TO AS030-TX-CONTROLE
!0309!     MOVE AS030-52-NR-CHIP-CARTAO  TO AS030-TX-NR-CHIP-CARTAO
!0309!
!0309!*----------------------------------------------------------------*
!0309!* ATUALIZAR TOTALIZADORES DO ARQUIVO.
!0309!*----------------------------------------------------------------*
!0309!
!0309!     ADD  1                            TO W81-VT99-QTD (52)
!0309!     .
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

!L207P     MOVE 64                       TO C2EBCDIC-LEN
!L207P     MOVE AS030-99-TX-DADOS (1:64) TO C2EBCDIC-CAMPO
!L207P     CALL C2EBCDIC USING C2EBCDIC-PARM
!L207P     MOVE C2EBCDIC-CAMPO    (1:64) TO AS030-99-TX-DADOS (1:64)

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
!0505!
!0505!*----------------------------------------------------------------*
!0505!*---- CONVERTER OS CAMPOS DATA, HORA, VALORES NUMERICOS ---------*
!0505!*----------------------------------------------------------------*
!0505!
!0505!     MOVE AS030-99-DT-GERACAO-ARQ          TO W55-DDDD
!0505!     MOVE AS030-99-HM-GERACAO-ARQ          TO W55-HHMM-FT
!0505!
!0505!     PERFORM 55200-CONVDT-DDDD-TO-AAAAMMDD
!0505!     PERFORM 55400-CONVHM-HHMMFT-HHMMSS
!0505!
!0505!     MOVE W55-AAAAMMDD                     TO
!0505!          AS030-99C-DT-GERACAO-ARQ
!0505!     MOVE W55-HHMMSS                       TO
!0505!          AS030-99C-HM-GERACAO-ARQ

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
           DISPLAY 'REGISTRO DE CONTROLE '
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
!L207P     DISPLAY 'AS030-01-IN-SLAVE       =' AS030-01-IN-SLAVE
!L207P     DISPLAY 'AS030-01-NR-CHIP-SAM-ASSOC='
!L207P              AS030-01-NR-CHIP-SAM-ASSOC
!L207P     DISPLAY 'AS030-01-NR-SEQ-ARQUIVO-ASSOC='
!L207P              AS030-01-NR-SEQ-ARQUIVO-ASSOC
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
!2009!     DISPLAY 'AS030-02-NR-VERS-VALID      ='
!2009!              AS030-02-NR-VERS-VALID
!2009!     DISPLAY 'AS030-02-NR-VERS-ARQ-EOD    ='
!2009!              AS030-02-NR-VERS-ARQ-EOD
!2009!     DISPLAY 'AS030-02-NR-VERS-ARQ-HOTL   ='
!2009!              AS030-02-NR-VERS-ARQ-HOTL
!2009!     DISPLAY 'AS030-02-NR-VERS-ARQ-HOTBU  ='
!2009!              AS030-02-NR-VERS-ARQ-HOTBU
!2009!     DISPLAY 'AS030-02-NR-VERS-ARQ-RECAR  ='
!2009!              AS030-02-NR-VERS-ARQ-RECAR
!2009!     DISPLAY 'AS030-02-NR-VERS-ARQ-LINHA  ='
!2009!              AS030-02-NR-VERS-ARQ-LINHA
!2009!     DISPLAY 'AS030-02-NR-VERS-ARQ-GLINHA ='
!2009!              AS030-02-NR-VERS-ARQ-GLINHA
!2009!     DISPLAY 'AS030-02-NR-VERS-ARQ-MINTEG ='
!2009!              AS030-02-NR-VERS-ARQ-MINTEG
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
!0701!*----------------------------------------------------------------*
!0701! 82000-DISPLAY-REG-07.
!0701!*----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '------------------------------'
           DISPLAY 'REGISTRO TIPO 07 - DESBLOQUEIO'
           DISPLAY '------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-07-TP-REGISTRO      =' AS030-07-TP-REGISTRO
           DISPLAY 'AS030-07-NR-TRAN-SAM      =' AS030-07-NR-TRAN-SAM
           DISPLAY 'AS030-07-DT-TRANS         =' AS030-07-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-07C-DT-TRANS
           DISPLAY 'AS030-07-HR-TRANS         =' AS030-07-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-07C-HR-TRANS
           DISPLAY 'AS030-07-NR-CHIP-CARTAO   =' AS030-07-NR-CHIP-CARTAO
           .
!0701!*----------------------------------------------------------------*
!0701! 82000-DISPLAY-REG-08.
!0701!*----------------------------------------------------------------*

           DISPLAY ' '
           DISPLAY '------------------------------'
           DISPLAY 'REGISTRO TIPO 08 - DESBLOQUEIO'
           DISPLAY '------------------------------'
           DISPLAY ' '

           DISPLAY 'AS030-08-TP-REGISTRO      =' AS030-08-TP-REGISTRO
           DISPLAY 'AS030-08-NR-TRAN-SAM      =' AS030-08-NR-TRAN-SAM
           DISPLAY 'AS030-08-DT-TRANS         =' AS030-08-DT-TRANS
                   ' CONVERTIDA ---> '           AS030-08C-DT-TRANS
           DISPLAY 'AS030-08-HR-TRANS         =' AS030-08-HR-TRANS
                   ' CONVERTIDA ---> '           AS030-08C-HR-TRANS
           DISPLAY 'AS030-08-NR-CHIP-CARTAO   =' AS030-08-NR-CHIP-CARTAO
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
!L207P     DISPLAY 'AS030-11-IN-ORIG-CARGA    =' AS030-11-IN-ORIG-CARGA
!0701!     DISPLAY 'AS030-11-TP-BU            =' AS030-11-TP-BU
           DISPLAY 'AS030-11-VL-TRANS         =' AS030-11-VL-TRANS
                   ' CONVERTIDO ---> '           AS030-11C-VL-TRANS
           DISPLAY 'AS030-11-VL-SALDO         =' AS030-11-VL-SALDO
                   ' CONVERTIDO ---> '           AS030-11C-VL-SALDO
!0701!     DISPLAY 'AS030-11-TP-DEBITO        =' AS030-11-TP-DEBITO
!0701!     DISPLAY 'AS030-11-VL-LINHA         =' AS030-11-VL-LINHA
!0701!             ' CONVERTIDO ---> '           AS030-11C-VL-LINHA
!2009!     DISPLAY 'AS030-11-MT-DEBITO        =' AS030-11-MT-DEBITO
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
!L207P     DISPLAY 'AS030-12-IN-ORIG-CARGA    =' AS030-12-IN-ORIG-CARGA
!0701!     DISPLAY 'AS030-12-TP-BU            =' AS030-12-TP-BU
           DISPLAY 'AS030-12-VL-TRANS         =' AS030-12-VL-TRANS
                   ' CONVERTIDO ---> '           AS030-12C-VL-TRANS
           DISPLAY 'AS030-12-VL-SALDO         =' AS030-12-VL-SALDO
                   ' CONVERTIDO ---> '           AS030-12C-VL-SALDO
!0701!     DISPLAY 'AS030-12-TP-DEBITO        =' AS030-12-TP-DEBITO
!0701!     DISPLAY 'AS030-12-VL-LINHA         =' AS030-12-VL-LINHA
!0701!             ' CONVERTIDO ---> '           AS030-12C-VL-LINHA
!2009!     DISPLAY 'AS030-12-MT-DEBITO        =' AS030-12-MT-DEBITO
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
!L207P     DISPLAY 'AS030-13-IN-ORIG-CARGA=' AS030-13-IN-ORIG-CARGA
!0701!     DISPLAY 'AS030-13-TP-BU    =' AS030-13-TP-BU
           DISPLAY 'AS030-13-VL-TRANS =' AS030-13-VL-TRANS
                   ' CONVERTIDO ---> '   AS030-13C-VL-TRANS
           DISPLAY 'AS030-13-VL-SALDO =' AS030-13-VL-SALDO
                   ' CONVERTIDO ---> '   AS030-13C-VL-SALDO
!0701!     DISPLAY 'AS030-13-TP-DEBITO=' AS030-13-TP-DEBITO
!0701!     DISPLAY 'AS030-13-VL-LINHA =' AS030-13-VL-LINHA
!0701!             ' CONVERTIDO ---> '   AS030-13C-VL-LINHA
!2009!     DISPLAY 'AS030-13-MT-DEBITO=' AS030-13-MT-DEBITO
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
!2009!     DISPLAY 'AS030-14-IN-TRANSF =' AS030-14-IN-TRANSF
           DISPLAY 'AS030-14-CD-INTEGRA=' AS030-14-CD-INTEGRACAO
           DISPLAY 'AS030-14-NR-CARGA  =' AS030-14-NR-CARGA
!L207P     DISPLAY 'AS030-14-IN-ORIG-CARGA    =' AS030-14-IN-ORIG-CARGA
!0701!     DISPLAY 'AS030-14-TP-BU     =' AS030-14-TP-BU
           DISPLAY 'AS030-14-VL-INTEGRA=' AS030-14-VL-TARIFA-INTEGRACAO
                   ' CONVERTIDO ---> '    AS030-14C-VL-TARIFA-INTEGRACAO
           DISPLAY 'AS030-14-VL-SALDO  =' AS030-14-VL-SALDO
                   ' CONVERTIDO ---> '    AS030-14C-VL-SALDO
!0701!     DISPLAY 'AS030-14-TP-DEBITO =' AS030-14-TP-DEBITO
!0701!     DISPLAY 'AS030-14-VL-LINHA  =' AS030-14-VL-LINHA
!0701!             ' CONVERTIDO ---> '    AS030-14C-VL-LINHA
!2009!     DISPLAY 'AS030-14-DT-TRANS-ANT  =' AS030-14-DT-TRANS-ANT
!2009!             ' CONVERTIDA ---> '        AS030-14C-DT-TRANS-ANT
!2009!     DISPLAY 'AS030-14-HR-TRANS-ANT  =' AS030-14-HR-TRANS-ANT
!2009!             ' CONVERTIDA ---> '        AS030-14C-HR-TRANS-ANT
!2009!     DISPLAY 'AS030-14-CD-LINHA-ANT  =' AS030-14-CD-LINHA-ANT
!2009!     DISPLAY 'AS030-14-CD-INTEG-ANT  =' AS030-14-CD-INTEG-ANT
!2009!     DISPLAY 'AS030-14-IN-TRANSF-ANT =' AS030-14-IN-TRANSF-ANT
!2009!     DISPLAY 'AS030-14-CD-SENTIDO-ANT=' AS030-14-CD-SENTIDO-ANT
!2009!     DISPLAY 'AS030-14-VL-DEB-ACUM   =' AS030-14-VL-DEB-ACUM
!2009!             ' CONVERTIDO ---> '        AS030-14C-VL-DEB-ACUM
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
!0701!     DISPLAY 'AS030-21-TP-BU            =' AS030-21-TP-BU
           DISPLAY 'AS030-21-VL-CARGA         =' AS030-21-VL-CARGA
                   ' CONVERTIDO ---> '           AS030-21C-VL-CARGA
           DISPLAY 'AS030-21-VL-SALDO         =' AS030-21-VL-SALDO
                   ' CONVERTIDO ---> '           AS030-21C-VL-SALDO
           .
!2103!*----------------------------------------------------------------*
!2103! 82000-DISPLAY-REG-23.
!2103!*----------------------------------------------------------------*
!2103!
!2103!     DISPLAY ' '
!2103!     DISPLAY '---------------------------------------'
!2103!     DISPLAY 'REGISTRO TIPO 23 - DESBLOQUEIO DE CARGA'
!2103!     DISPLAY '---------------------------------------'
!2103!     DISPLAY ' '
!2103!
!2103!     DISPLAY 'AS030-23-TP-REGISTRO      =' AS030-23-TP-REGISTRO
!2103!     DISPLAY 'AS030-23-NR-TRAN-SAM      =' AS030-23-NR-TRAN-SAM
!2103!     DISPLAY 'AS030-23-DT-TRANS         =' AS030-23-DT-TRANS
!2103!             ' CONVERTIDA ---> '           AS030-23C-DT-TRANS
!2103!     DISPLAY 'AS030-23-HR-TRANS         =' AS030-23-HR-TRANS
!2103!             ' CONVERTIDA ---> '           AS030-23C-HR-TRANS
!2103!     DISPLAY 'AS030-23-NR-CHIP-CARTAO   =' AS030-23-NR-CHIP-CARTAO
!2103!     DISPLAY 'AS030-23-NR-TRANSACAO     =' AS030-23-NR-TRANSACAO
!2103!     DISPLAY 'AS030-23-CD-LINHA         =' AS030-23-CD-LINHA
!2103!     DISPLAY 'AS030-23-NR-CARGA         =' AS030-23-NR-CARGA
!0701!     DISPLAY 'AS030-23-TP-BU            =' AS030-23-TP-BU
!2103!     DISPLAY 'AS030-23-VL-CARGA         =' AS030-23-VL-CARGA
!2103!             ' CONVERTIDO ---> '           AS030-23C-VL-CARGA
!2103!     DISPLAY 'AS030-23-VL-SALDO         =' AS030-23-VL-SALDO
!2103!             ' CONVERTIDO ---> '           AS030-23C-VL-SALDO
!2103!     DISPLAY 'AS030-23-CD-APLICACAO     =' AS030-23-CD-APLICACAO
!2103!     .
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
!0309!*----------------------------------------------------------------*
!0309! 82000-DISPLAY-REG-52.
!0309!*----------------------------------------------------------------*
!0309!
!0309!     DISPLAY ' '
!0309!     DISPLAY '------------------------------'
!0309!     DISPLAY 'REGISTRO TIPO 52 - CARGA CRIPT'
!0309!     DISPLAY '------------------------------'
!0309!     DISPLAY ' '
!0309!
!0309!     DISPLAY 'AS030-52-TP-REGISTRO      =' AS030-52-TP-REGISTRO
!0309!     DISPLAY 'AS030-52-NR-TRAN-SAM      =' AS030-52-NR-TRAN-SAM
!0309!     DISPLAY 'AS030-52-DT-TRANS         =' AS030-52-DT-TRANS
!0309!             ' CONVERTIDA ---> '           AS030-52C-DT-TRANS
!0309!     DISPLAY 'AS030-52-HR-TRANS         =' AS030-52-HR-TRANS
!0309!             ' CONVERTIDA ---> '           AS030-52C-HR-TRANS
!0309!     DISPLAY 'AS030-52-NR-CHIP-CARTAO   =' AS030-52-NR-CHIP-CARTAO
!0309!     DISPLAY 'AS030-52-CARGA-ENCRIPT    =' AS030-52-CARGA-ENCRIPT
!0309!     .
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
!L207P     DISPLAY 'AS030-99-QTD-TOT-CART-RECOL ='
!L207P              AS030-99-QTD-TOT-CART-RECOL
!0505!     DISPLAY 'AS030-99-DT-GERACAO-ARQ =' AS030-99-DT-GERACAO-ARQ
!0505!             ' CONVERTIDA ---> '         AS030-99C-DT-GERACAO-ARQ
!0505!     DISPLAY 'AS030-99-HM-GERACAO-ARQ =' AS030-99-HM-GERACAO-ARQ
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
!L207P     MOVE AS030-01-IN-SLAVE          TO AS035-01-IN-SLAVE
!L207P     MOVE AS030-01-NR-CHIP-SAM-ASSOC TO AS035-01-NR-CHIP-SAM-ASSOC
!L207P     MOVE AS030-01-NR-SEQ-ARQUIVO-ASSOC
!L207P       TO AS035-01-NR-SEQ-ARQUIVO-ASSOC
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
!2009!     MOVE AS030-02-NR-VERS-VALID
!2009!       TO AS035-02-NR-VERS-VALID
!2009!     MOVE AS030-02-NR-VERS-ARQ-EOD
!2009!       TO AS035-02-NR-VERS-ARQ-EOD
!2009!     MOVE AS030-02-NR-VERS-ARQ-HOTL
!2009!       TO AS035-02-NR-VERS-ARQ-HOTL
!2009!     MOVE AS030-02-NR-VERS-ARQ-HOTBU
!2009!       TO AS035-02-NR-VERS-ARQ-HOTBU
!2009!     MOVE AS030-02-NR-VERS-ARQ-RECAR
!2009!       TO AS035-02-NR-VERS-ARQ-RECAR
!2009!     MOVE AS030-02-NR-VERS-ARQ-LINHA
!2009!       TO AS035-02-NR-VERS-ARQ-LINHA
!2009!     MOVE AS030-02-NR-VERS-ARQ-GLINHA
!2009!       TO AS035-02-NR-VERS-ARQ-GLINHA
!2009!     MOVE AS030-02-NR-VERS-ARQ-MINTEG
!2009!       TO AS035-02-NR-VERS-ARQ-MINTEG
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
!0701!*----------------------------------------------------------------*
!0701! 83000-DISPLAY-REG-07.
!0701!*----------------------------------------------------------------*

           MOVE AS030-07-TP-REGISTRO       TO AS035-07-TP-REGISTRO
           MOVE AS030-07-NR-TRAN-SAM       TO AS035-07-NR-TRAN-SAM
           MOVE AS030-07-DT-TRANS          TO AS035-07-DT-TRANS
           MOVE AS030-07-HR-TRANS          TO AS035-07-HR-TRANS
           MOVE AS030-07-NR-CHIP-CARTAO    TO AS035-07-NR-CHIP-CARTAO
           MOVE AS030-07C-DT-TRANS         TO AS035-07C-DT-TRANS
           MOVE AS030-07C-HR-TRANS         TO AS035-07C-HR-TRANS

           DISPLAY AS035-DETALHE-07
           .
!0701!*----------------------------------------------------------------*
!0701! 83000-DISPLAY-REG-08.
!0701!*----------------------------------------------------------------*

           MOVE AS030-08-TP-REGISTRO       TO AS035-08-TP-REGISTRO
           MOVE AS030-08-NR-TRAN-SAM       TO AS035-08-NR-TRAN-SAM
           MOVE AS030-08-DT-TRANS          TO AS035-08-DT-TRANS
           MOVE AS030-08-HR-TRANS          TO AS035-08-HR-TRANS
           MOVE AS030-08-NR-CHIP-CARTAO    TO AS035-08-NR-CHIP-CARTAO
           MOVE AS030-08C-DT-TRANS         TO AS035-08C-DT-TRANS
           MOVE AS030-08C-HR-TRANS         TO AS035-08C-HR-TRANS

           DISPLAY AS035-DETALHE-08
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
!L207P     MOVE AS030-11-IN-ORIG-CARGA     TO AS035-11-IN-ORIG-CARGA
!0701!     MOVE AS030-11-TP-BU             TO AS035-11-TP-BU
           MOVE AS030-11-VL-TRANS          TO AS035-11-VL-TRANS
           MOVE AS030-11-VL-SALDO          TO AS035-11-VL-SALDO
           MOVE AS030-11C-DT-TRANS         TO AS035-11C-DT-TRANS
           MOVE AS030-11C-HR-TRANS         TO AS035-11C-HR-TRANS
           MOVE AS030-11C-VL-SALDO         TO AS035-11C-VL-SALDO
!0701!     MOVE AS030-11-TP-DEBITO         TO AS035-11-TP-DEBITO
!0701!     MOVE AS030-11-VL-LINHA          TO AS035-11-VL-LINHA
!0701!     MOVE AS030-11C-VL-LINHA         TO AS035-11C-VL-LINHA
!2009!     MOVE AS030-11-MT-DEBITO         TO AS035-11-MT-DEBITO

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
!L207P     MOVE AS030-12-IN-ORIG-CARGA     TO AS035-12-IN-ORIG-CARGA
!0701!     MOVE AS030-12-TP-BU             TO AS035-12-TP-BU
           MOVE AS030-12-VL-TRANS          TO AS035-12-VL-TRANS
           MOVE AS030-12-VL-SALDO          TO AS035-12-VL-SALDO
           MOVE AS030-12C-DT-TRANS         TO AS035-12C-DT-TRANS
           MOVE AS030-12C-HR-TRANS         TO AS035-12C-HR-TRANS
           MOVE AS030-12C-VL-SALDO         TO AS035-12C-VL-SALDO
!0701!     MOVE AS030-12-TP-DEBITO         TO AS035-12-TP-DEBITO
!0701!     MOVE AS030-12-VL-LINHA          TO AS035-12-VL-LINHA
!0701!     MOVE AS030-12C-VL-LINHA         TO AS035-12C-VL-LINHA
!2009!     MOVE AS030-12-MT-DEBITO         TO AS035-12-MT-DEBITO

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
!L207P     MOVE AS030-13-IN-ORIG-CARGA     TO AS035-13-IN-ORIG-CARGA
!0701!     MOVE AS030-13-TP-BU             TO AS035-13-TP-BU
           MOVE AS030-13-VL-TRANS          TO AS035-13-VL-TRANS
           MOVE AS030-13-VL-SALDO          TO AS035-13-VL-SALDO
           MOVE AS030-13C-DT-TRANS         TO AS035-13C-DT-TRANS
           MOVE AS030-13C-HR-TRANS         TO AS035-13C-HR-TRANS
           MOVE AS030-13C-VL-TRANS         TO AS035-13C-VL-TRANS
           MOVE AS030-13C-VL-SALDO         TO AS035-13C-VL-SALDO
!0701!     MOVE AS030-13-TP-DEBITO         TO AS035-13-TP-DEBITO
!0701!     MOVE AS030-13-VL-LINHA          TO AS035-13-VL-LINHA
!0701!     MOVE AS030-13C-VL-LINHA         TO AS035-13C-VL-LINHA
!2009!     MOVE AS030-13-MT-DEBITO         TO AS035-13-MT-DEBITO

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
!2009!     MOVE AS030-14-IN-TRANSF         TO AS035-14-IN-TRANSF
           MOVE AS030-14-CD-INTEGRACAO     TO AS035-14-CD-INTEGRACAO
           MOVE AS030-14-NR-CARGA          TO AS035-14-NR-CARGA
!L207P     MOVE AS030-14-IN-ORIG-CARGA     TO AS035-14-IN-ORIG-CARGA
!0701!     MOVE AS030-14-TP-BU             TO AS035-14-TP-BU
           MOVE AS030-14-VL-TARIFA-INTEGRACAO
             TO AS035-14-VL-TARIFA-INTEGRACAO
           MOVE AS030-14-VL-SALDO          TO AS035-14-VL-SALDO
           MOVE AS030-14C-DT-TRANS         TO AS035-14C-DT-TRANS
           MOVE AS030-14C-HR-TRANS         TO AS035-14C-HR-TRANS
           MOVE AS030-14C-VL-TARIFA-INTEGRACAO
             TO AS035-14C-VL-TARIFA-INTEGRACAO
           MOVE AS030-14C-VL-SALDO         TO AS035-14C-VL-SALDO
!0701!     MOVE AS030-14-TP-DEBITO         TO AS035-14-TP-DEBITO
!0701!     MOVE AS030-14-VL-LINHA          TO AS035-14-VL-LINHA
!0701!     MOVE AS030-14C-VL-LINHA         TO AS035-14C-VL-LINHA
!2009!     MOVE AS030-14-DT-TRANS-ANT      TO AS035-14-DT-TRANS-ANT
!2009!     MOVE AS030-14-HR-TRANS-ANT      TO AS035-14-HR-TRANS-ANT
!2009!     MOVE AS030-14C-DT-TRANS-ANT     TO AS035-14C-DT-TRANS-ANT
!2009!     MOVE AS030-14C-HR-TRANS-ANT     TO AS035-14C-HR-TRANS-ANT
!2009!     MOVE AS030-14-CD-LINHA-ANT      TO AS035-14-CD-LINHA-ANT
!2009!     MOVE AS030-14-CD-INTEG-ANT      TO AS035-14-CD-INTEG-ANT
!2009!     MOVE AS030-14-IN-TRANSF-ANT     TO AS035-14-IN-TRANSF-ANT
!2009!     MOVE AS030-14-CD-SENTIDO-ANT    TO AS035-14-CD-SENTIDO-ANT
!2009!     MOVE AS030-14-VL-DEB-ACUM       TO AS035-14-VL-DEB-ACUM
!2009!     MOVE AS030-14C-VL-DEB-ACUM      TO AS035-14C-VL-DEB-ACUM

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
!0701!     MOVE AS030-21-TP-BU             TO AS035-21-TP-BU
           MOVE AS030-21-VL-CARGA          TO AS035-21-VL-CARGA
           MOVE AS030-21-VL-SALDO          TO AS035-21-VL-SALDO
           MOVE AS030-21C-DT-TRANS         TO AS035-21C-DT-TRANS
           MOVE AS030-21C-HR-TRANS         TO AS035-21C-HR-TRANS
           MOVE AS030-21C-VL-CARGA         TO AS035-21C-VL-CARGA
           MOVE AS030-21C-VL-SALDO         TO AS035-21C-VL-SALDO

           DISPLAY AS035-DETALHE-21
           .
!2103!*----------------------------------------------------------------*
!2103! 83000-DISPLAY-REG-23.
!2103!*----------------------------------------------------------------*
!2103!
!2103!     MOVE AS030-23-TP-REGISTRO       TO AS035-23-TP-REGISTRO
!2103!     MOVE AS030-23-NR-TRAN-SAM       TO AS035-23-NR-TRAN-SAM
!2103!     MOVE AS030-23-DT-TRANS          TO AS035-23-DT-TRANS
!2103!     MOVE AS030-23-HR-TRANS          TO AS035-23-HR-TRANS
!2103!     MOVE AS030-23-NR-CHIP-CARTAO    TO AS035-23-NR-CHIP-CARTAO
!2103!     MOVE AS030-23-CD-APLICACAO      TO AS035-23-CD-APLICACAO
!2103!     MOVE AS030-23-NR-TRANSACAO      TO AS035-23-NR-TRANSACAO
!2103!     MOVE AS030-23-NR-CARGA          TO AS035-23-NR-CARGA
!0701!     MOVE AS030-23-TP-BU             TO AS035-23-TP-BU
!2103!     MOVE AS030-23-VL-CARGA          TO AS035-23-VL-CARGA
!2103!     MOVE AS030-23-VL-SALDO          TO AS035-23-VL-SALDO
!2103!     MOVE AS030-23-CD-LINHA          TO AS035-23-CD-LINHA
!2103!     MOVE AS030-23C-DT-TRANS         TO AS035-23C-DT-TRANS
!2103!     MOVE AS030-23C-HR-TRANS         TO AS035-23C-HR-TRANS
!2103!     MOVE AS030-23C-VL-CARGA         TO AS035-23C-VL-CARGA
!2103!     MOVE AS030-23C-VL-SALDO         TO AS035-23C-VL-SALDO
!2103!
!2103!     DISPLAY AS035-DETALHE-23
!2103!     .
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
!0309!*----------------------------------------------------------------*
!0309! 83000-DISPLAY-REG-52.
!0309!*----------------------------------------------------------------*
!0309!
!0309!     MOVE AS030-52-TP-REGISTRO       TO AS035-52-TP-REGISTRO
!0309!     MOVE AS030-52-NR-TRAN-SAM       TO AS035-52-NR-TRAN-SAM
!0309!     MOVE AS030-52-DT-TRANS          TO AS035-52-DT-TRANS
!0309!     MOVE AS030-52-HR-TRANS          TO AS035-52-HR-TRANS
!0309!     MOVE AS030-52-NR-CHIP-CARTAO    TO AS035-52-NR-CHIP-CARTAO
!0309!     MOVE AS030-52-CARGA-ENCRIPT     TO AS035-52-CARGA-ENCRIPT
!0309!     MOVE AS030-52C-DT-TRANS         TO AS035-52C-DT-TRANS
!0309!     MOVE AS030-52C-HR-TRANS         TO AS035-52C-HR-TRANS
!0309!
!0309!     DISPLAY AS035-DETALHE-52
!0309!     .
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
!L207P     MOVE AS030-99-QTD-TOT-CART-RECOL
!L207P       TO AS035-99-QTD-TOT-CART-RECOL
!0505!
!0505!     MOVE AS030-99-DT-GERACAO-ARQ    TO AS035-99-DT-GERACAO-ARQ
!0505!     MOVE AS030-99-HM-GERACAO-ARQ    TO AS035-99-HM-GERACAO-ARQ

           MOVE AS030-99C-DT-TRANS         TO AS035-99C-DT-TRANS
           MOVE AS030-99C-HR-TRANS         TO AS035-99C-HR-TRANS
           MOVE AS030-99C-VL-TRANS-DEB     TO AS035-99C-VL-TRANS-DEB
           MOVE AS030-99C-VL-TRANS-CRED    TO AS035-99C-VL-TRANS-CRED
           MOVE AS030-99C-VL-TOT-CR-FSAM   TO AS035-99C-VL-TOT-CR-FSAM
!0505!     MOVE AS030-99C-DT-GERACAO-ARQ   TO AS035-99C-DT-GERACAO-ARQ
!0505!     MOVE AS030-99C-HM-GERACAO-ARQ   TO AS035-99C-HM-GERACAO-ARQ

           DISPLAY AS035-TRAILER-99
           DISPLAY ' '
           .
!3011!*----------------------------------------------------------------*
!3011!  81030-PREENCHER-VETOR-03.
!3011!*----------------------------------------------------------------*

!SIGA!*SIGA2 IF W81-TIN = 11 OR 12 OR 13
!SIGA!*SIGA2
!SIGA!*SIGA2    INITIALIZE SBE-CC-CARTAO-SCON
!SIGA!*SIGA2
!SIGA!*SIGA2    MOVE AS030-TX-NR-CHIP-CARTAO
!SIGA!*SIGA2      TO NR-CHIP-CARTAO-SC         OF SBE-CC-CARTAO-SCON
!SIGA!*SIGA2
!SIGA!*SIGA2    PERFORM   82000-SELECT-CCCARSCO
!SIGA!*SIGA2 END-IF
!3011!
!3011!     EVALUATE TRUE
!3011!     WHEN W81-TIN = 03
!2209!       SET   W01-POSSUI-REG03-OK TO TRUE
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
!0907!     WHEN W81-TIN = 11
!3011!      AND (W81-I03 >  0)

            MOVE AS030-11-CD-APLICACAO        TO WS-APLIC-SCONT

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
!0504!*     IF W81-TIN = 11
!3011!       ADD  AS030-11C-VL-TRANS
!3011!                            TO W81-V03-VL-TRANS-DEB      (W81-I03)

!2012!       IF AS030-11-TP-DEBITO = 0
R2016!          IF  W81-APLIC-SCONT-SV-OK
!SIGA!              IF  AS030-11-CD-APLICACAO EQUAL 114
!SIGA!                  ADD AS030-11C-VL-LINHA
!SIGA!                   TO W81-VFILI-VL-SIG-SV-REALIZ(W81-IFILI)
!SIGA!                  ADD 1
!SIGA!                   TO W81-VFILI-QT-SIG-SV-REALIZ(W81-IFILI)
!SIGA!              ELSE
!SIGA!                IF  AS030-11-CD-APLICACAO EQUAL 115
!SIGA!                    ADD AS030-11C-VL-LINHA
!SIGA!                     TO W81-VFILI-VL-SIG-MT-REALIZ(W81-IFILI)
!SIGA!                    ADD 1
!SIGA!                     TO W81-VFILI-QT-SIG-MT-REALIZ(W81-IFILI)
!SIGA!                ELSE
!SIGA!                    ADD AS030-11C-VL-LINHA
!SIGA!                     TO W81-VFILI-VL-SIG-BA-REALIZ(W81-IFILI)
!SIGA!                    ADD 1
!SIGA!                     TO W81-VFILI-QT-SIG-BA-REALIZ(W81-IFILI)
!SIGA!                END-IF
!SIGA!             END-IF
R2016!          ELSE
R2016!             IF  W81-APLIC-SCONT-R2016-OK
R2016!                 ADD 1  TO W81-VFILI-QT-EVENTO-REALIZ(W81-IFILI)
R2016!                 IF  AS030-11-CD-APLICACAO EQUAL 145
R2016!                     ADD AS030-11C-VL-LINHA
R2016!                      TO W81-VFILI-VL-EVENTO-REALIZ(W81-IFILI)
R2016!                 ELSE
R2016!                     ADD AS030-11C-VL-TRANS
R2016!                      TO W81-VFILI-VL-EVENTO-REALIZ(W81-IFILI)
R2016!                 END-IF
!SIGA!             ELSE
!2012!                 ADD AS030-11C-VL-TRANS
!2012!                       TO W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!                 ADD 1 TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!SIGA!             END-IF
!SIGA!          END-IF
!2012!       ELSE
!2012!          IF AS030-11-TP-DEBITO = 2
!MARI!                               OR 6
!2012!             ADD AS030-11C-VL-TRANS
!2012!                        TO W81-VFILI-VL-BUE-REALIZADO (W81-IFILI)
!2012!             ADD 1      TO W81-VFILI-QT-BUE-REALIZADO (W81-IFILI)
!FIPU!          ELSE
!FIPU!             IF AS030-11-TP-DEBITO = 5
!FIPU!                ADD AS030-11C-VL-TRANS
!FIPU!                        TO W81-VFILI-VL-PU-REALIZADO  (W81-IFILI)
!FIPU!                ADD 1   TO W81-VFILI-QT-PU-REALIZADO  (W81-IFILI)
!BARC!             ELSE
!BARC!                IF AS030-11-TP-DEBITO = 7
!BARC!                   IF AS030-11-CD-APLICACAO = 820
!BARC!                      ADD AS030-11C-VL-TRANS
!BARC!                       TO W81-VFILI-VL-BUAG-REALIZADO (W81-IFILI)
!BARC!                      ADD 1
!BARC!                       TO W81-VFILI-QT-BUAG-REALIZADO (W81-IFILI)
!BARC!                   ELSE
!BARC!                      ADD AS030-11C-VL-TRANS
!BARC!                       TO W81-VFILI-VL-BUA-REALIZADO (W81-IFILI)
!BARC!                      ADD 1
!BARC!                       TO W81-VFILI-QT-BUA-REALIZADO (W81-IFILI)
!BARC!                   END-IF
!BARC!                END-IF
!FIPU!             END-IF
!2012!          END-IF
!2012!       END-IF
!0504!*     END-IF
!3011!
!0907!     WHEN  W81-TIN = 12
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
!0504!*     IF W81-TIN = 12
!3011!       ADD  AS030-12C-VL-TRANS
!3011!                            TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!
!2012!       IF AS030-12-TP-DEBITO = 0
R2016!          IF  W81-APLIC-SCONT-SV-OK
!SIGA!              IF  AS030-12-CD-APLICACAO EQUAL 114
!SIGA!                  ADD AS030-12C-VL-LINHA
!SIGA!                   TO W81-VFILI-VL-SIG-SV-REALIZ(W81-IFILI)
!SIGA!                  ADD 1
!SIGA!                   TO W81-VFILI-QT-SIG-SV-REALIZ(W81-IFILI)
!SIGA!              ELSE
!SIGA!                IF  AS030-12-CD-APLICACAO EQUAL 115
!SIGA!                    ADD AS030-12C-VL-LINHA
!SIGA!                     TO W81-VFILI-VL-SIG-MT-REALIZ(W81-IFILI)
!SIGA!                    ADD 1
!SIGA!                     TO W81-VFILI-QT-SIG-MT-REALIZ(W81-IFILI)
!SIGA!                ELSE
!SIGA!                    ADD AS030-12C-VL-LINHA
!SIGA!                     TO W81-VFILI-VL-SIG-BA-REALIZ(W81-IFILI)
!SIGA!                    ADD 1
!SIGA!                     TO W81-VFILI-QT-SIG-BA-REALIZ(W81-IFILI)
!SIGA!                END-IF
!SIGA!             END-IF
R2016!          ELSE
R2016!             IF  W81-APLIC-SCONT-R2016-OK
R2016!                 ADD 1  TO W81-VFILI-QT-EVENTO-REALIZ(W81-IFILI)
R2016!                 IF  AS030-12-CD-APLICACAO EQUAL 145
R2016!                     ADD AS030-12C-VL-LINHA
R2016!                      TO W81-VFILI-VL-EVENTO-REALIZ(W81-IFILI)
R2016!                 ELSE
R2016!                     ADD AS030-12C-VL-TRANS
R2016!                      TO W81-VFILI-VL-EVENTO-REALIZ(W81-IFILI)
R2016!                 END-IF
!SIGA!             ELSE
!2012!                 ADD AS030-12C-VL-TRANS
!2012!                       TO W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!                 ADD 1 TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!SIGA!             END-IF
!SIGA!          END-IF
!2012!       ELSE
!2012!          IF AS030-12-TP-DEBITO = 2
!MARI!                               OR 6
!2012!             ADD AS030-12C-VL-TRANS
!2012!                        TO W81-VFILI-VL-BUE-REALIZADO (W81-IFILI)
!2012!             ADD 1      TO W81-VFILI-QT-BUE-REALIZADO (W81-IFILI)
!FIPU!          ELSE
!FIPU!             IF AS030-12-TP-DEBITO = 5
!FIPU!                ADD AS030-12C-VL-TRANS
!FIPU!                        TO W81-VFILI-VL-PU-REALIZADO  (W81-IFILI)
!FIPU!                ADD 1   TO W81-VFILI-QT-PU-REALIZADO  (W81-IFILI)
!BARC!             ELSE
!BARC!                IF AS030-12-TP-DEBITO = 7
!BARC!                   IF AS030-12-CD-APLICACAO = 820
!BARC!                      ADD AS030-12C-VL-TRANS
!BARC!                       TO W81-VFILI-VL-BUAG-REALIZADO (W81-IFILI)
!BARC!                      ADD 1
!BARC!                       TO W81-VFILI-QT-BUAG-REALIZADO (W81-IFILI)
!BARC!                   ELSE
!BARC!                      ADD AS030-12C-VL-TRANS
!BARC!                       TO W81-VFILI-VL-BUA-REALIZADO (W81-IFILI)
!BARC!                      ADD 1
!BARC!                       TO W81-VFILI-QT-BUA-REALIZADO (W81-IFILI)
!BARC!                   END-IF
!BARC!                END-IF
!FIPU!             END-IF
!2012!          END-IF
!2012!       END-IF
!0504!*     END-IF
!3011!
!0907!     WHEN  W81-TIN = 13
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
!0504!*     IF W81-TIN = 13
!3011!       ADD  AS030-13C-VL-TRANS
!3011!                            TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!
!2012!       IF AS030-13-TP-DEBITO = 0
R2016!          IF  W81-APLIC-SCONT-SV-OK
!SIGA!              IF  AS030-13-CD-APLICACAO EQUAL 114
!SIGA!                  ADD AS030-13C-VL-LINHA
!SIGA!                   TO W81-VFILI-VL-SIG-SV-REALIZ(W81-IFILI)
!SIGA!                  ADD 1
!SIGA!                   TO W81-VFILI-QT-SIG-SV-REALIZ(W81-IFILI)
!SIGA!              ELSE
!SIGA!                IF  AS030-13-CD-APLICACAO EQUAL 115
!SIGA!                    ADD AS030-13C-VL-LINHA
!SIGA!                     TO W81-VFILI-VL-SIG-MT-REALIZ(W81-IFILI)
!SIGA!                    ADD 1
!SIGA!                     TO W81-VFILI-QT-SIG-MT-REALIZ(W81-IFILI)
!SIGA!                ELSE
!SIGA!                    ADD AS030-13C-VL-LINHA
!SIGA!                     TO W81-VFILI-VL-SIG-BA-REALIZ(W81-IFILI)
!SIGA!                    ADD 1
!SIGA!                     TO W81-VFILI-QT-SIG-BA-REALIZ(W81-IFILI)
!SIGA!                END-IF
!SIGA!             END-IF
R2016!          ELSE
R2016!             IF  W81-APLIC-SCONT-R2016-OK
R2016!                 ADD 1  TO W81-VFILI-QT-EVENTO-REALIZ(W81-IFILI)
R2016!                 IF  AS030-13-CD-APLICACAO EQUAL 145
R2016!                     ADD AS030-13C-VL-LINHA
R2016!                      TO W81-VFILI-VL-EVENTO-REALIZ(W81-IFILI)
R2016!                 ELSE
R2016!                     ADD AS030-13C-VL-TRANS
R2016!                      TO W81-VFILI-VL-EVENTO-REALIZ(W81-IFILI)
R2016!                 END-IF
!SIGA!             ELSE
!2012!                 ADD AS030-13C-VL-TRANS
!2012!                       TO W81-VFILI-VL-VT-REALIZADO (W81-IFILI)
!2012!                 ADD 1 TO W81-VFILI-QT-VT-REALIZADO (W81-IFILI)
!SIGA!             END-IF
!SIGA!          END-IF
!2012!       ELSE
!2012!          IF AS030-13-TP-DEBITO = 2
!MARI!                               OR 6
!2012!             ADD AS030-13C-VL-TRANS
!2012!                        TO W81-VFILI-VL-BUE-REALIZADO (W81-IFILI)
!2012!             ADD 1      TO W81-VFILI-QT-BUE-REALIZADO (W81-IFILI)
!FIPU!          ELSE
!FIPU!             IF AS030-13-TP-DEBITO = 5
!FIPU!                ADD AS030-13C-VL-TRANS
!FIPU!                        TO W81-VFILI-VL-PU-REALIZADO  (W81-IFILI)
!FIPU!                ADD 1   TO W81-VFILI-QT-PU-REALIZADO  (W81-IFILI)
!BARC!             ELSE
!BARC!                IF AS030-13-TP-DEBITO = 7
!BARC!                   IF AS030-13-CD-APLICACAO = 820
!BARC!                      ADD AS030-13C-VL-TRANS
!BARC!                       TO W81-VFILI-VL-BUAG-REALIZADO (W81-IFILI)
!BARC!                      ADD 1
!BARC!                       TO W81-VFILI-QT-BUAG-REALIZADO (W81-IFILI)
!BARC!                   ELSE
!BARC!                      ADD AS030-13C-VL-TRANS
!BARC!                       TO W81-VFILI-VL-BUA-REALIZADO (W81-IFILI)
!BARC!                      ADD 1
!BARC!                       TO W81-VFILI-QT-BUA-REALIZADO (W81-IFILI)
!BARC!                   END-IF
!BARC!                END-IF
!FIPU!             END-IF
!2012!          END-IF
!2012!       END-IF
!0504!*     END-IF
!3011!
!0907!     WHEN  W81-TIN = 14
!3011!      AND (W81-I03 >  0)

            MOVE AS030-14-CD-APLICACAO        TO WS-APLIC-SCONT

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
!0504!*     IF W81-TIN = 14
!3011!       ADD  AS030-14C-VL-TARIFA-INTEGRACAO
!3011!                            TO W81-V03-VL-TRANS-DEB      (W81-I03)
!2012!
!2012!       IF AS030-14-IN-TRANSF = 1
!2012!          ADD 1         TO W81-VFILI-QT-TRANSF        (W81-IFILI)
!2012!       ELSE
!2012!          IF AS030-14-TP-DEBITO = 1
R2016!             IF  W81-APLIC-SCONT-R2016-OK
R2016!                 ADD AS030-14C-VL-TARIFA-INTEGRACAO TO
R2016!                     W81-VFILI-VL-EVENTO-REALIZ(W81-IFILI)
R2016!                 ADD 1                        TO
R2016!                     W81-VFILI-QT-EVENTO-REALIZ(W81-IFILI)
R2016!             ELSE
!2012!                 ADD AS030-14C-VL-TARIFA-INTEGRACAO
!2012!                  TO W81-VFILI-VL-INT-REALIZADO (W81-IFILI)
!2012!                 ADD 1  TO W81-VFILI-QT-INT-REALIZADO (W81-IFILI)
R2016!             END-IF
!2012!          ELSE
!2012!             IF AS030-14-TP-DEBITO = 2
!MARI!                                  OR 6
!2012!                ADD AS030-14C-VL-TARIFA-INTEGRACAO
!2012!                         TO W81-VFILI-VL-BUE-REALIZADO (W81-IFILI)
!2012!                ADD 1    TO W81-VFILI-QT-BUE-REALIZADO (W81-IFILI)
!2012!             ELSE
!2012!                IF AS030-14-TP-DEBITO = 3
!2012!                   ADD AS030-14C-VL-TARIFA-INTEGRACAO
!2012!                         TO W81-VFILI-VL-BUC-REALIZADO (W81-IFILI)
!2012!                   ADD 1 TO W81-VFILI-QT-BUC-REALIZADO (W81-IFILI)
!2405!                ELSE
!2405!                   IF AS030-14-TP-DEBITO = 4
!2405!                     ADD AS030-14C-VL-TARIFA-INTEGRACAO
!2405!                        TO W81-VFILI-VL-BUCS-REALIZADO (W81-IFILI)
!2405!                     ADD 1
!2405!                        TO W81-VFILI-QT-BUCS-REALIZADO (W81-IFILI)
!FIPU!                   ELSE
!FIPU!                      IF AS030-14-TP-DEBITO = 5
!FIPU!                         ADD AS030-14C-VL-TARIFA-INTEGRACAO
!FIPU!                          TO W81-VFILI-VL-PU-REALIZADO (W81-IFILI)
!FIPU!                         ADD 1
!FIPU!                          TO W81-VFILI-QT-PU-REALIZADO (W81-IFILI)
!TARSP                      ELSE
!TARSP                         IF AS030-14-TP-DEBITO = 7
!TARSP                            ADD AS030-14C-VL-TARIFA-INTEGRACAO TO
!TARSP                             W81-VFILI-VL-BUA-REALIZADO(W81-IFILI)
!TARSP                            ADD 1 TO
!TARSP                             W81-VFILI-QT-BUA-REALIZADO(W81-IFILI)
!TARSP                         END-IF
!FIPU!                      END-IF
!2405!                   END-IF
!2012!                END-IF
!2012!             END-IF
!2012!          END-IF
!2012!       END-IF
!0504!*     END-IF
!3011!
!0907!     WHEN  W81-TIN = 21
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
!3011!      ADD  AS030-21C-VL-CARGA
!3011!                            TO W81-V03-VL-TRANS-CRED     (W81-I03)
!1912!
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
!SIGA!*----------------------------------------------------------------*
!SIGA! 82000-SELECT-CCCARSCO.
!SIGA!*----------------------------------------------------------------*
!SIGA!
!SIGA!     EXEC SQL
!SIGA!
!SIGA!          SELECT CD_EMISS_CARTAO
!SIGA!
!SIGA!            INTO :SBE-CC-CARTAO-SCON.CD-EMISS-CARTAO
!SIGA!
!SIGA!            FROM  SBE_CC_CARTAO_SCON
!SIGA!
!SIGA!           WHERE  NR_CHIP_CARTAO_SC  =
!SIGA!                 :SBE-CC-CARTAO-SCON.NR-CHIP-CARTAO-SC
!SIGA!
!SIGA!     END-EXEC
!SIGA!
!SIGA!     MOVE SQLCODE TO W01-SQLCODE
!SIGA!                     W01-SQLCODE-F
!SIGA!
!SIGA!     EVALUATE TRUE
!SIGA!
!SIGA!      WHEN W01-SQLCODE-OK
!SIGA!        ADD 1 TO WS-CCCARSCO-S
!SIGA!        MOVE CD-EMISS-CARTAO    OF SBE-CC-CARTAO-SCON
!SIGA!          TO WS-EMISS-CARTAO
!SIGA!
!SIGA!        IF WS-EMISS-CARTAO = 0
!SIGA!           MOVE 1   TO WS-EMISS-CARTAO
!SIGA!                       CD-EMISS-CARTAO OF SBE-CC-CARTAO-SCON
!SIGA!        END-IF

TIRARX*->>  NOS TESTE EM DESENV NEM TODO CHIP-SC ESTAVA NA TABELA, E AIH
TIRARX*->>  ABENDAVA.
TIRARX*     WHEN W01-SQLCODE-NOT-FOUND
TIRARX*       MOVE 1 TO WS-EMISS-CARTAO

!SIGA!      WHEN OTHER
!SIGA!        DISPLAY '*->> SELECT INVALIDO SBE-CC-CARTAO-SCON *->>'
!SIGA!        DISPLAY '*->> SQLCODE *->> ' W01-SQLCODE-F
!SIGA!        PERFORM 82001-DISPLAY
!SIGA!        MOVE 55  TO W59-RC
!SIGA!
!SIGA!        PERFORM 59001-ABEND-PGM
!SIGA!
!SIGA!     END-EVALUATE
!SIGA!     .
!SIGA!*----------------------------------------------------------------*
!SIGA! 82001-DISPLAY.
!SIGA!*----------------------------------------------------------------*
!SIGA!
!SIGA!     DISPLAY '*->> 82000-SELECT-CCCARSCO *->>'
!SIGA!     DISPLAY '*->> NR-CHIP-CARTAO-SC *->> ' NR-CHIP-CARTAO-SC
!SIGA!                                            OF SBE-CC-CARTAO-SCON
!SIGA!     .
!7282!*----------------------------------------------------------------*
!7282! 82100-SELECT-APLSCONT.
!7282!*----------------------------------------------------------------*
!7282!
!7282!     EXEC SQL
!7282!
!7282!          SELECT T3.IN_EXPRESSO
!7282!
!7282!            INTO :SBE-APLIC-SCONT.IN-EXPRESSO
!7282!
!7282!            FROM  SBE_CC_CARTAO_SCON   T1
!7282!
!7282!            INNER JOIN SBE_TP_CASCO    T2
!7282!                    ON T2.CD_EMISS_CARTAO = T1.CD_EMISS_CARTAO
!7282!                   AND T2.CD_TP_CASCO     = T1.CD_TP_CASCO
!7282!
!7282!            INNER JOIN SBE_APLIC_SCONT T3
!7282!                    ON T3.CD_EMISS_CARTAO = T2.CD_EMISS_CARTAO
!7282!                   AND T3.CD_APLIC_SCONT  = T2.CD_APLIC_SCONT
!7282!
!7282!           WHERE  T1.NR_CHIP_CARTAO_SC  =
!7282!                 :SBE-CC-CARTAO-SCON.NR-CHIP-CARTAO-SC
!7282!
!7282!     END-EXEC
!7282!
!7282!     MOVE SQLCODE TO W01-SQLCODE
!7282!                     W01-SQLCODE-F
!7282!
!7282!     EVALUATE TRUE
!7282!
!7282!      WHEN W01-SQLCODE-OK
!7282!        ADD 1 TO WS-APLSCONT-S
!7282!
!7282!      WHEN W01-SQLCODE-NOT-FOUND
!7282!
!7282!*---> O MOVE ABAIXO FOI FEITO PARA REJEITAR O REGISTRO
!7282!
!7282!        MOVE 1 TO IN-EXPRESSO OF SBE-APLIC-SCONT
!7282!
!7282!      WHEN OTHER
!7282!        DISPLAY '*->> SELECT INVALIDO SBE-APLIC_SCONT *->>'
!7282!        DISPLAY '*->> SQLCODE *->> ' W01-SQLCODE-F
!7282!        PERFORM 82101-DISPLAY
!7282!        MOVE 55  TO W59-RC
!7282!
!7282!        PERFORM 59001-ABEND-PGM
!7282!
!7282!     END-EVALUATE
!7282!     .
!7282!*----------------------------------------------------------------*
!7282! 82101-DISPLAY.
!7282!*----------------------------------------------------------------*
!7282!
!7282!     DISPLAY '*->> 82100-SELECT-APLSCONT *->>'
!7282!     DISPLAY '*->> NR-CHIP-CARTAO-SC *->> ' NR-CHIP-CARTAO-SC
!7282!                                            OF SBE-CC-CARTAO-SCON
!7282!     .
!SIGA!*----------------------------------------------------------------*
!SIGA! 84000-VERIFICA-RESSAR.
!SIGA!*----------------------------------------------------------------*
!SIGA!     SET           WS-RESSAR-OK         TO   TRUE
!SIGA!
!SIGA!     PERFORM VARYING  WS-IND     FROM  1 BY 1
!SIGA!               UNTIL  WS-IND  GREATER  WS-IMAX-APL
!SIGA!                  OR  WS-RESSAR-NOK
!SIGA!
!SIGA!        IF  TB-EMISS-CARTAO(WS-IND)   =  WS-EMISS-CARTAO
!SIGA!        AND TB-APLIC-SCONT (WS-IND)   =  WS-APLIC-SCONT
!SIGA!
!SIGA!           SET     WS-RESSAR-NOK         TO   TRUE
!SIGA!        END-IF
!SIGA!
!SIGA!     END-PERFORM
!SIGA!     .
------*---------------------------------------------------------------*
!SIGA1 10100-POPULAR-TABELA-APL.
------*---------------------------------------------------------------*
!SIGA1
!SIGA1     PERFORM  10110-OPEN-C01-APLSCONT
!SIGA1
!SIGA1     PERFORM  10120-FETCH-C01
!SIGA1
!SIGA1     IF WS-C01-EOF-OK
!SIGA1        DISPLAY ' '
!SIGA1        DISPLAY '>>>> CURSOR ESTA VAZIO.'
!SIGA1        DISPLAY '>>>> SQLCODE =' W01-SQLCODE-F
!SIGA1        MOVE 10  TO RETURN-CODE
!SIGA1
!SIGA1        STOP RUN
!SIGA1     END-IF
!SIGA1
!SIGA1     PERFORM VARYING  WS-IND     FROM  1 BY 1
!SIGA1               UNTIL  WS-IND     > 1000
!SIGA1                  OR  WS-C01-EOF-OK
!SIGA1
!SIGA1             MOVE  CD-EMISS-CARTAO OF SBE-APLIC-SCONT
!SIGA1               TO  TB-EMISS-CARTAO(WS-IND)
!SIGA1             MOVE  CD-APLIC-SCONT  OF SBE-APLIC-SCONT
!SIGA1               TO  TB-APLIC-SCONT (WS-IND)
!SIGA1
!SIGA1             PERFORM  10120-FETCH-C01
!SIGA1             MOVE     WS-IND   TO  WS-IMAX-APL
!SIGA1
!SIGA1     END-PERFORM
!SIGA1
!SIGA1     IF  W01-SQLCODE-OK
!SIGA1         DISPLAY '>>>>> ESTOURO DE TABELA NA ROTINA'
!SIGA1         DISPLAY '>>>>> 10100-POPULAR-TABELA-APL'
!SIGA1         DISPLAY '>>>>> SQLCODE = ' W01-SQLCODE-F
!SIGA1         MOVE 55  TO W59-RC
!SIGA1
!SIGA1         PERFORM 59001-ABEND-PGM
!SIGA1     END-IF
!SIGA1
!SIGA1     PERFORM 10130-CLOSE-C01-APLSCONT
!SIGA1     .
------*---------------------------------------------------------------*
!SIGA1 10110-OPEN-C01-APLSCONT.
------*---------------------------------------------------------------*
!SIGA1
!SIGA1     EXEC SQL OPEN C01-APLSCONT END-EXEC.
!SIGA1
!SIGA1     MOVE SQLCODE TO W01-SQLCODE
!SIGA1                     W01-SQLCODE-F
!SIGA1
!SIGA1     EVALUATE TRUE
!SIGA1
!SIGA1      WHEN W01-SQLCODE-OK
!SIGA1        CONTINUE
!SIGA1
!SIGA1      WHEN OTHER
!SIGA1        DISPLAY '>>>>> OPEN INVALIDO CURSOR SBE_APLIC_SCONT.'
!SIGA1        DISPLAY '>>>>> SQLCODE = ' W01-SQLCODE-F
!SIGA1        MOVE 55  TO W59-RC
!SIGA1
!SIGA1        PERFORM 59001-ABEND-PGM
!SIGA1     END-EVALUATE
!SIGA1     .
------*---------------------------------------------------------------*
!SIGA1 10120-FETCH-C01.
------*---------------------------------------------------------------*
!SIGA1     EXEC SQL
!SIGA1
!SIGA1      FETCH
!SIGA1        C01-APLSCONT
!SIGA1
!SIGA1      INTO
!SIGA1        :SBE-APLIC-SCONT.CD-EMISS-CARTAO,
!SIGA1        :SBE-APLIC-SCONT.CD-APLIC-SCONT
!SIGA1
!SIGA1     END-EXEC.
!SIGA1
!SIGA1     MOVE SQLCODE TO W01-SQLCODE
!SIGA1                     W01-SQLCODE-F
!SIGA1
!SIGA1     EVALUATE TRUE
!SIGA1
!SIGA1      WHEN W01-SQLCODE-OK
!SIGA1         ADD 1 TO WS-C01-F
!SIGA1
!SIGA1      WHEN W01-SQLCODE-EOF
!SIGA1        SET WS-C01-EOF-OK TO TRUE
!SIGA1
!SIGA1      WHEN OTHER
!SIGA1        DISPLAY '>>>>> FETCH INVALIDO AO CURSOR C01-APLSCONT'
!SIGA1        DISPLAY '>>>>> SQLCODE = ' W01-SQLCODE-F
!SIGA1        PERFORM  10121-DISPLAY
!SIGA1        MOVE 55  TO W59-RC
!SIGA1
!SIGA1        PERFORM 59001-ABEND-PGM
!SIGA1     END-EVALUATE
!SIGA1     .
------*---------------------------------------------------------------*
!SIGA1 10121-DISPLAY.
------*---------------------------------------------------------------*
!SIGA1
!SIGA1     DISPLAY '*->> 10120-FETCH-C01 *->>'
!SIGA1     DISPLAY '*->> CD_EMISS_CARTAO     *->> '
!SIGA1                   CD-EMISS-CARTAO  OF SBE-APLIC-SCONT
!SIGA1     DISPLAY '*->> CD_APLIC_SCONT      *->> '
!SIGA1                   CD-APLIC-SCONT   OF SBE-APLIC-SCONT
!SIGA1     DISPLAY '*->> IN_RESSAR           *->> '
!SIGA1                   IN-RESSAR        OF SBE-APLIC-SCONT
           .
------*---------------------------------------------------------------*
!SIGA1 10130-CLOSE-C01-APLSCONT.
------*---------------------------------------------------------------*
!SIGA1
!SIGA1     EXEC SQL
!SIGA1              CLOSE C01-APLSCONT
!SIGA1     END-EXEC.
!SIGA1
!SIGA1     MOVE SQLCODE TO W01-SQLCODE
!SIGA1                     W01-SQLCODE-F
!SIGA1
!SIGA1     EVALUATE TRUE
!SIGA1
!SIGA1      WHEN W01-SQLCODE-OK
!SIGA1        CONTINUE
!SIGA1
!SIGA1      WHEN OTHER
!SIGA1        DISPLAY '*->> CLOSE C01-APLSCONT INVALIDO'
!SIGA1        DISPLAY '*->> SQLCODE = ' W01-SQLCODE-F
!SIGA1        MOVE 55  TO W59-RC
!SIGA1
!SIGA1        PERFORM 59001-ABEND-PGM
!SIGA1     END-EVALUATE
!SIGA1     .
