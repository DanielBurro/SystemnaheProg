#
# data declarations
#
.data       # marks the start of the data to be loaded into RAM at program start
str1: .asciz "Bitte Wert fuer A eingeben: "
str2: .asciz "Bitte Wert fuer B eingeben: "
str3: .asciz "Das Ergebnis C = 2*A + 3*B ist: "
str4: .asciz " Beenden [0 = Ja, 1 = Nein]: "
newline: .asciz "\n"  # This will cause the screen cursor to move to a newline

# Speicherplatz fuer das Ergebnis reservieren (wie in der urspruenglichen Aufgabe gefordert)
.align 2      # Speicherausrichtung fuer ein 32-Bit Wort sicherstellen
c: .word 0    

#
# code
#
.globl main    # main is declared as a global marker, can be accessed from other files
.text          # marks the start of the instructions, i.e. the program

main:
   ### 1. Eingabe von A
   la a0, str1    # load string address into a0
   li a7, 4       # load print_string code into a7
   ecall          # print str1

   li a7, 5       # load read_int code into a7
   ecall
   mv t0, a0      # place the read value (A) into register t0

   ### 2. Eingabe von B
   la a0, str2    # load address of string 2 into register a0
   li a7, 4       # load print_string code into a7
   ecall          # print str2

   li a7, 5       # load read_int code into a7
   ecall
   mv t1, a0      # place the read value (B) into register t1

   ### 3. Berechnung von C = 2*A + 3*B
   # 2 * A berechnen (Shift left um 1)
   slli t2, t0, 1 # t2 = A * 2
   
   # 3 * B berechnen ((B * 2) + B)
   slli t3, t1, 1 # t3 = B * 2
   add t3, t3, t1 # t3 = 2B + B = 3 * B
   
   # C = 2A + 3B
   add t4, t2, t3 # t4 = 2*A + 3*B

   ### 4. Ergebnis im Speicher (Variable c) ablegen
   la t5, c       # Lade die Basisadresse von c in t5
   sw t4, 0(t5)   # Speichere das Ergebnis (t4) in den Speicher

   ### 5. Ergebnis ausgeben
   la a0, str3    # load address of string 3 into register a0
   li a7, 4       # load print_string code into a7
   ecall          # print str3

   li a7, 1       # print_int C to the console window
   mv a0, t4      # Wert von t4 (C) in a0 fuer die Ausgabe verschieben
   ecall

   la a0, newline # print the new line character
   li a7, 4
   ecall

   ### 6. Neustart des Programms mit anderen Eingaben?
   la a0, str4    # load address of string 4 into register a0
   li a7, 4       # load print_string code to console
   ecall          # print str4

   li a7, 5       # read an integer from the console
   ecall

   # Wenn die Eingabe nicht 0 ist, springe zurueck zu 'main'
   bne a0, zero, main 

   ### 7. Exit
   li a7, 10      # syscall code 10 for terminating the program
   ecall