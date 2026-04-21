#
# data
#
.data
consta: .float 2.0

const2: .float 2.0
str1: .asciz "Die approximierte Quadratwurzel von a ist: "
newline: .asciz "\n"

.align 2
n: .word 3

#
# code
#
.text
.globl main

main:
    # --- Daten laden ---
    la t0, consta           # Adresse von consta in t0 laden
    flw fa1, 0(t0)          # Wert von consta in fa1 laden

    la t0, n                # Basisadresse von n in t0 laden
    lw a0, 0(t0)            # (Index) Wert von n in a0 laden 

    jal heron               # return fa0

    # --- Konsolenausgabe ---
    li a7, 2                # Systemcall-Code 2 (print_floar) in a7 laden
    ecall                   # Wert in fa0 auf der Konsole ausgeben

    li a7, 4
    la a0, newline
    ecall

    # --- Programm exit ---
    li a7, 10
    ecall


### --- Unterprogramm --- ####
#   a = fa0
#   n = a0
##############################
heron:
    # --- Daten initialisieren ---
    la t0, const2           # Adresse von const2 in t0 laden
    flw ft0, 0(t0)          # Wert von const2 in ft0 laden

    # --- Initialisierung von x_0 ---
    fdiv.s fa0, fa1, ft0    # fa0 (x_n) = fa1 (a) / ft0 (const2)

loop_cond:
    beq a0, zero, end       # Wenn a0 (Index) = 0, springe zum Ende

### Schleifenrumpf
    # --- Formel anwenden ---
    # x_{n+1} = (x_n + (a / x_n)) / 2
    fdiv.s ft2, fa1, fa0    # (1.) a [fa1] / x_n [fa0]
    fadd.s ft2, fa0, ft2    # (2.) x_n [fa0] + (a / x_n) [ft2]
    fdiv.s fa0, ft2, ft0    # (3.) x_{n+1} [fa0] = (x_n + (a / x_n)) [ft2] / 2 [ft0]

    addi a0, a0, -1         # a0 = a0 - 1
    j loop_cond             # Springe zurück zum Schleifenanfang

end:
    jr ra                   # Springt zurück zum Aufruf mit fa0 als output
