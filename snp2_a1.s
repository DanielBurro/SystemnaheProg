#
# data
#
.data
 str: .asciz "Die größte Zahl im Array ist: "
 newline: .asciz "\n"

.align 2
a: .word 1, 99, 3, 144, 5, 44, 7, 558, 9
a_end:

#
# code
#
.text
.globl main

main:
    # --- Daten laden ---
    la a1, a            # (a) Speicheradresse von Array a wird in a1 geladen
    la a2, a_end        # Speicheradresse von Array a_end wird in a2 geladen

    # --- Länge von a bestimmen ---
    # a_end ist direkt hinter a
    sub a2, a2, a1     # (length) Speicheradresse a_end - a: (Länge von a) * 4 

    # --- Unterprogrammaufruf: maximum(int[] a, int length) ---
    jal maximum        # return a0

    # --- Konsolenausgabe ---
    li a7, 1           # Systemcall-Code 1 (print_int) in a7 laden
    ecall              # Wert in a0 auf der Konsole ausgeben

    li a7, 4
    la a0, newline
    ecall

    # --- Programm exit ---
    li a7, 10
    ecall

### --- Unterprogramm --- ####
# Argumente: int[] a    = a1
#            int length = a2
##############################
maximum:
    # --- Daten initialisieren ---
    li t0, 0           # t0 = i (Offset-Counter) = 0
    lw a0, 0(a1)       # a0 = tmp (höchste Zahl) = a[i]

loop_cond:
    bgt t0, a2, end    # Wenn i > length, springe zum Ende

### Schleifenrumpf
    lw t1, 0(a1)       # Lade a[i] in t1

    bgt a0, t1, falsch # Wenn tmp > a[i], springe zu falsch
    mv a0, t1          # Wenn tmp < a[i], tmp = a[i]

falsch:
    addi t0, t0, 4     # i++ (.word ist 4 Byte lange)
    addi a1, a1, 4     # Speicheradresse von a0 wird um 4 verschoben = a[i+1]
    j loop_cond        # Unbedingter Sprung zu loop_cond

end:
    jr ra              # Springt zurück zum Aufruf mit a0 als output (return tmp)
    

