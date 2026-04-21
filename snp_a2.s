#
# data declerations
#
.data
str1: .asciz "Erster Mittelwert > 5 ist "
str2: .asciz " an der Position "
newline: .asciz "\n"

.align 2
a: .word 5, 2, 1, 1, 2, 2, 4, 3, 9, 1

#
# code
#
.text
.global main

main:
    # --- 1. Variablen initialisieren
    li s0, 0    # s0 (tmp) = 0 (load immediate)
    li s1, 0    # s1 (i) = 0 (load immediate)
    la s2, a    # s2 = Basisadresse vom Array 'a' laden

while_cond:
    #--- 2. While-Schleifen Bdeingung prüfen

    # Bedingung: tmp <= 5
    li t0, 5    # Konstante 5 in temporäres Register laden
    bgt s0, t0, end # wenn tmp > 5, springe zum Ende

    # Bedingung: i < 9
    li t1, 9    # Konstante 9 in tempräres Register laden
    bge s1, t1, end # wenn i >= 9, springe zum Ende

while_loop:
    # --- 3. Schleife ausführen

    # Berechnung der Speicheradresse für a[i]
    slli t2, s1, 2  # t2 = i * 4 (Shift left logical um 2 entspricht * 4 Byte pro .word)
    add t2, t2, s2  # t2 = Basisadresse + Offset = a[i]

    # Array-Werte laden
    lw t3, 0(t2)    # Lade a[i] in t3
    lw t4, 4(t2)    # Lade a[i+1] in t4 (4 Byte Offset für das nächste Wort)

    # tmp = (a[i] + a[i+1]) / 2
    add t5, t3, t4  # t5 = a[i] + a[i+1]
    li t6, 2        # t6 = 2 (load immediate)
    div s0, t5, t6  # s0 (tmp) = t5 / 2

    # i Inkrement
    addi s1, s1, 1  # s1 = s1 + 1 

    # Rücksprung zur Bedingung der Schleife
    j while_cond    # Unbedingter Sprung zum Start der Schleife

end:
    # --- 4. Konsolausgabe

    # print str1
    li a7, 4    # Code 4 für print_string laden
    la a0, str1 # Adresse des Strings in a0 laden
    ecall       # syscall

    # print tmp
    li a7, 1    # Code 1 für print_int laden
    mv a0, s0   # tmp (s0) nach a0 kopieren
    ecall

    # print str2
    li a7, 4    # Code 4 für print_string laden
    la a0, str2 # Adresse des Strings in a0 laden
    ecall

    # print i
    li a7, 1    # Code 1 für print_int laden
    mv a0, s1   # i (s1) nach a0 kopieren
    ecall

    # newline
    li a7, 4    # Code 5 für print_string laden
    la a0, newline
    ecall

    # --- 5. Programm beenden
    li a7, 10   # Code 10 für exit laden
    ecall
