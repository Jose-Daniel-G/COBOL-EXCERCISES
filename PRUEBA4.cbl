      *****************************************************************
      * Author:  JOSE DANIEL GRIJALBA
      * Date:    23/12/2025
      * Purpose: SIESA 8.5 - SISTEMA DE NAVEGACION
      *****************************************************************
       >>SOURCE FORMAT FREE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRUEBA4.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           CRT STATUS IS TECLA-STATUS.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01 TECLA-STATUS PIC 9(4).
          88 FLECHA-ARR  VALUE 2007.
          88 FLECHA-ABA  VALUE 2008.
          88 FLECHA-DER  VALUE 2009.
          88 FLECHA-IZQ  VALUE 2010.
          88 TECLA-ESC   VALUE 2005.
          88 TECLA-ENTER VALUE 0.

       01 OPCION-CAPTURA PIC X VALUE SPACE.
       01 MODULO-ACTUAL  PIC 9 VALUE 3.
       01 OPCION-VENTANA PIC X VALUE SPACE.
       01 FECHA-SISTEMA  PIC X(15) VALUE "DIC 23, 2025".

       SCREEN SECTION.

       01 BARRA-SUPERIOR.
          05 LINE 1 COL 1 VALUE " TEST 8.5 "
             BACKGROUND-COLOR 4 FOREGROUND-COLOR 7.
          05 LINE 1 COL 65 FROM FECHA-SISTEMA
             BACKGROUND-COLOR 4 FOREGROUND-COLOR 7.
          05 LINE 2 COL 1 PIC X(80) FROM ALL " "
             BACKGROUND-COLOR 7.

       01 MENU-COMERCIAL.
          05 LINE 03 COL 20 VALUE "+--------------------------+"
             BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
          05 LINE 04 COL 20 VALUE "| Comercial                |"
             BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
          05 LINE 05 COL 20 VALUE "+--------------------------+"
             BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.
          05 LINE 06 COL 20 VALUE "| C. Confrontacion         |"
             BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
          05 LINE 07 COL 20 VALUE "| S. Salir al Menu Sup.    |"
             BACKGROUND-COLOR 7 FOREGROUND-COLOR 1.
          05 LINE 08 COL 20 VALUE "+--------------------------+"
             BACKGROUND-COLOR 7 FOREGROUND-COLOR 0.

       *> Campo invisible de teclado
       01 CAMPO-TECLA.
          05 LINE 24 COL 1 PIC X USING OPCION-CAPTURA
             NO-ECHO.

       PROCEDURE DIVISION.
       MAIN-LOGIC.

           *> Activar soporte teclado
           SET ENVIRONMENT "COB_SCREEN_EXCEPTIONS" TO "Y".
           SET ENVIRONMENT "COB_SCREEN_ESC_TIMEOUT" TO "0".

           DISPLAY " " BLANK SCREEN BACKGROUND-COLOR 1.

           PERFORM UNTIL OPCION-CAPTURA = "X"

               DISPLAY BARRA-SUPERIOR
               PERFORM DIBUJAR-OPCIONES

               MOVE SPACE TO OPCION-CAPTURA
               MOVE 0     TO TECLA-STATUS

               ACCEPT CAMPO-TECLA

               EVALUATE TRUE
                   WHEN FLECHA-DER
                       IF MODULO-ACTUAL < 3
                           ADD 1 TO MODULO-ACTUAL
                       ELSE
                           MOVE 0 TO MODULO-ACTUAL
                       END-IF

                   WHEN FLECHA-IZQ
                       IF MODULO-ACTUAL > 0
                           SUBTRACT 1 FROM MODULO-ACTUAL
                       ELSE
                           MOVE 3 TO MODULO-ACTUAL
                       END-IF

                   WHEN TECLA-ENTER
                       PERFORM ABRIR-MENU-SELECCIONADO

                   WHEN OPCION-CAPTURA NOT = SPACE
                       PERFORM PROCESAR-LETRA-DIRECTA
               END-EVALUATE

           END-PERFORM.

           STOP RUN.

       PROCESAR-LETRA-DIRECTA.
           EVALUATE FUNCTION UPPER-CASE(OPCION-CAPTURA)
               WHEN "A"
                   MOVE 0 TO MODULO-ACTUAL
                   PERFORM ABRIR-MENU-SELECCIONADO
               WHEN "E"
                   MOVE 1 TO MODULO-ACTUAL
                   PERFORM ABRIR-MENU-SELECCIONADO
               WHEN "F"
                   MOVE 2 TO MODULO-ACTUAL
                   PERFORM ABRIR-MENU-SELECCIONADO
               WHEN "C"
                   MOVE 3 TO MODULO-ACTUAL
                   PERFORM ABRIR-MENU-SELECCIONADO
               WHEN "S"
                   MOVE "X" TO OPCION-CAPTURA
           END-EVALUATE.
           EXIT.

       ABRIR-MENU-SELECCIONADO.
           PERFORM LIMPIAR-AREA-MENU
           EVALUATE MODULO-ACTUAL
               WHEN 3
                   PERFORM DESPLEGAR-COMERCIAL
               WHEN OTHER
                   DISPLAY "MODULO EN DESARROLLO"
                           LINE 10 COL 30
                   ACCEPT CAMPO-TECLA
                   PERFORM LIMPIAR-AREA-MENU
           END-EVALUATE.
           EXIT.

       DIBUJAR-OPCIONES.
           PERFORM DIBUJAR-A
           PERFORM DIBUJAR-E
           PERFORM DIBUJAR-F
           PERFORM DIBUJAR-C.
           EXIT.

       DIBUJAR-A.
           IF MODULO-ACTUAL = 0
               DISPLAY "[A]" LINE 2 COL 2
                       BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
               DISPLAY "[A]" LINE 2 COL 2
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
           END-IF.
           EXIT.

       DIBUJAR-E.
           IF MODULO-ACTUAL = 1
               DISPLAY "[E]" LINE 2 COL 6
                       BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
               DISPLAY "[E]" LINE 2 COL 6
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 4
           END-IF.
           EXIT.

       DIBUJAR-F.
           IF MODULO-ACTUAL = 2
               DISPLAY " Financiero " LINE 2 COL 10
                       BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
               DISPLAY " Financiero " LINE 2 COL 10
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.
           EXIT.

       DIBUJAR-C.
           IF MODULO-ACTUAL = 3
               DISPLAY " Comercial " LINE 2 COL 23
                       BACKGROUND-COLOR 0 FOREGROUND-COLOR 7
           ELSE
               DISPLAY " Comercial " LINE 2 COL 23
                       BACKGROUND-COLOR 7 FOREGROUND-COLOR 1
           END-IF.
           EXIT.

       LIMPIAR-AREA-MENU.
           DISPLAY " " LINE 3 COL 1 ERASE EOS BACKGROUND-COLOR 1.
           EXIT.

       DESPLEGAR-COMERCIAL.
           MOVE SPACE TO OPCION-VENTANA
           PERFORM UNTIL FUNCTION UPPER-CASE(OPCION-VENTANA) = "S"
               DISPLAY MENU-COMERCIAL
               ACCEPT CAMPO-TECLA
               MOVE OPCION-CAPTURA TO OPCION-VENTANA
           END-PERFORM
           PERFORM LIMPIAR-AREA-MENU.
           EXIT.
