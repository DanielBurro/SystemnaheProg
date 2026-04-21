#
# data declarations
#
.data
newline: .asciz "\n"

.align 2
a: .word 0

#
# code
#
.text
.globl main

main: 
    la t0, a            # Adresse von a in t0 laden
    lw a0, 0(t0)        # Wert von a in a0 laden (Argument für fact)
    
    jal fact            # fact aufrufen. Rückgabewert wird in a0 stehen

    li a7, 1            # Systemcall-Code 1 (print_int) in a7 laden
    ecall               # Wert in a0 auf der Konsole ausgeben

    li a7, 10           # Systemcall-Code 10 (exit)
    ecall

# --- Unterprogramm
fact:
    li t0, 1            # t0 ist das Ergebnis = 1
    li t1, 1            # t1 ist i = 1

while_cond:
    bgt t1, a0, end     # Wenn i > n, springe zum Ende

while_body:
    mul t0, t0, t1      # Ergebnis = Ergebnis * i
    addi t1, t1, 1      # i = i + 1

    j while_cond        # Unbedingter Sprung zurück zur Bedingungsprüfung

end:
    mv a0, t0           # Schiebe das Endergebnis aus t0 in das Standard-Rückgaberegister a0
    jr ra               # Springe zurück zum Aufrufer