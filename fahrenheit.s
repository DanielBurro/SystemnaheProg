#
# data declarations
#
.data
const5: .float 5.0
const9: .float 9.0
const32: .float 32.0
constm273: .float -273.15

newline: .asciz "\n"
str_inp: .asciz "Geben sie eine Gleitkommazahl ein: "
str_out: .asciz "Celsius-Wert: "


#
# code
#
.globl main
.text

main:
    li a7, 4                # Systemcall-Code 4 (print_string) in a7 laden
    la a0, str_inp          
    ecall

    li a7, 6                # Systemcall-Code 6 (read_float) in a7 laden
    ecall                   # Eingabe wird in fa0 gelegt

    jal f2c                 # f2c aufrufen. Rückgabewert wird in fa0 stehen

    li a7, 2                # Systemcall-Code 2 (print_float) in a7 laden. fa0 ist bereits gegeben
    ecall                   # Wert in fa0 auf der Konsole ausgeben

    la a0, newline # print the new line character to put the screen cursor to a newline
    li a7, 4
    ecall

    li a7, 10               # Systemcall-Code 10 (exit)
    ecall

# --- Unterprogramm
f2c:
    la t0, const5           # Adresse von const5 in t0 laden
    flw ft0, 0(t0)          # Wert von const5 in ft0 laden
    la t0, const9           # Adresse von const9 in t0 laden
    flw ft1, 0(t0)          # Wert von const9 in ft
    fdiv.s ft2, ft0, ft1    # ft2 = 5.0 / 9.0
    la t0, const32          # Adresse von const32 in t0 laden
    flw ft3, 0(t0)          # Wert von const32 in ft3 laden

    fsub.s fa0, fa0, ft3    # fa0 = fa0 - ft3
    fmul.s fa0, fa0, ft2    # fa0 = fa0 * ft2

# --- Bedingung
    la t0, constm273        # Adresse von constm273 in t0 laden
    flw ft0, 0(t0)          # Wert von const5 in ft0 laden

    flt.s t1, fa0, ft0      # Ist die Ausgabe (fa0) < -273.15?
    bne t1, zero, end       # Wenn die Bedingung in Zeile 58 wahr (t1 = 1) ist, führe 61 aus, sonst springe zum Ende

    fmv.s fa0, ft0          # Minimaler Wert ist -273.15

end:
    jr ra                   # jump to ra
    