#
#   data
#
.data
hello_msg: .asciz "Hello, World!"

#
# code
#

.global main
.text
main: 
    la a0, hello_msg      # Load address of the message into a0
    li a7, 4              # load imm, 4 is a syscall for print_string
    ecall                 # make the syscall to print the message