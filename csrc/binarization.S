.data
test: .byte 20, 80, 128, 150, 231
result: .byte 0, 0, 0, 0, 0
threshold: .byte 0x80
mask1: .word 0x55555555
mask2: .word 0x33333333
mask4: .word 0x0f0f0f0f
str1: .string " "
str2: .string "\nThe Binarization Result:\n"

.set SYSEXIT, 93
.set SYSWRITE, 64

.text
.globl	main
.type	main, @function
main:
    # a1 = address of pixel
    # a2 = address of result
    # a3 = threshold
    la a1, test            # load address of pixel
    la a2, result          # load address of result
    la a3, threshold       # load address of threshold
    lbu a3, 0(a3)          # load value of threshold

BINARIZATION:
    li s1, 5            # count of haven't done pixel
B_LOOP:
    lbu a4, 0(a1)       # load value of pixel
    sub a0, a3, a4      # threshold - pixel
    li t0, 2147483648
    and a0, a0, t0
    bne a0, x0, FLOOR   # branch to FLOOR if CLZ = 0
CEIL:
    li a4, 0
    j STORE_MOVE        # jump to STORE_MOVE
FLOOR:
    li a4, 255
    
STORE_MOVE:
    sb a4, 0(a3)
    addi s1, s1, -1    # total count -1
    addi a1, a1, 1     # go to next address of pixel
    addi a3, a3, 1     # go to next address of result
    bne s1, x0, B_LOOP
    
    li s1, 5           # make count for RESULT_CHECK
    sub a3, a3, s1     # reset address of result
    
    li a0, 1
    la a1, str2
    li a2, 100
    # li a7, SYSWRITE
    # ecall

    # li a7, SYSEXIT
    # ecall

# PRINT_INT:
#     li a2, 1
#     addi a1, a1, 48
#     li a0, 1
#     li a7, SYSWRITE          # print the value of input a1 in int
#     ecall
#     addi sp, sp, -4
#     sw a1, 0(sp)
#     la a1, str1
#     li a2, 1
#     li a0, 1
#     li a7, SYSWRITE
#     ecall
#     lw a1, 0(sp)
#     addi sp, sp, 4
#     ret
