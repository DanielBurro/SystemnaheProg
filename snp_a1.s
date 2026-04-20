#
# data declarations
#
.data
cmd_str: .asciz "Bitte einen Integer-Wert x eingeben: "
res_str: .asciz "Approximiertes e^-x: "
rep_str: .asciz " Done [0 = Yes, 1 = No]: "
newline: .asciz "\n"  # This will cause the screen cursor to move to a newline

#
# code
#
.text
.globl main

main: 
    # String cmd_str ausgeben
    la a0, cmd_str   # load address of cmd_str into register a0
    li a7, 4         # system call code for print_string
    ecall            # print cmd_str

    # Integer-Wert x einlesen
    li a7, 5         # system call code for read_int
    ecall            # read integer into a0
    mv s0, a0        # move the read integer into register s0

    # ---
    # Formel: ( 1 - x ) + (x^2)/2 - (x^3)/6

    # Term 0: 1
    li t0, 1         # t0 = 1

    # Term 1: -x
    mv t1, s0        # t1 = x

    # Term 2: (x^2)/2
    mul t2, s0, s0   # t2 = x^2
    li t6, 2         # t6 = 2, load immediate
    div t2, t2, t6   # t2 = (x^2)/2

    # Term 3: -(x^3)/6
    mul t3, s0, s0   # t3 = x^2
    mul t3, t3, s0   # t3 = x^3
    li t6, 6         # t6 = 6, load immediate
    div t3, t3, t6   # t3 = (x^3)/6

    # Summierung der Terme
    sub s1, t0, t1   # s1 = 1 - x
    add s1, s1, t2   # s1 = (1 - x) + (x^2)/2
    sub s1, s1, t3   # s1 = (1 - x) + (x^2)/2 - (x^3)/6

    # ---
    # Ergebnis ausgeben
    la a0, res_str   # load address of res_str into register a0
    li a7, 4         # system call code for print_int
    ecall            # print res_str

    mv a0, s1        # move the result into register a0
    li a7, 1         # system call code for print_int
    ecall            # print the result

    la a0, newline   # print the new line character to put the screen cursor to a newline
    li a7, 4         # system call code for print_string
    ecall            # print newline

    # ---
    # Programm erneut ausführen?
    la a0, rep_str   # load address of rep_str into register a0
    li a7, 4         # system call code for print_string
    ecall            # print rep_str

    li a7, 5         # system call code for read_int
    ecall            # read integer into a0

    bne a0, zero, main # if not complete (i.e., not 0 was provided) then start at the beginning

    # Programm beenden
    li a7, 10        # system call code for exit
    ecall            # exit the program