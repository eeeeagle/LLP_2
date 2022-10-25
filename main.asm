%include "io64_float.inc"
global CMAIN

segment .rodata
	A:      dq 1.0
        B:      dq -4.0
        C:      dq 4.0
        
        ZERO:    dq 0.0
        C_2:    dq 2.0
        C_4:    dq 4.0
        
segment .data
        X:      dq 0.0
        Y:      dq 0.0
        RES:    dq 0.0
        TEMP:   dq 0.0
        
section .text
CMAIN:
        push rbp
        mov rbp, rsp
        sub rsp, 8
    	
        READ_DOUBLE X
        READ_DOUBLE Y
        
        call PRINT_VARS
        
        call TASK_1
        call TASK_2
        call TASK_3
        
        mov rsp,rbp
	pop rbp
	ret

PRINT_VARS:
        push rbp
        mov rbp, rsp
        sub rsp, 8
        
        PRINT_STRING "PRINT VARS"
        NEWLINE
        NEWLINE
        
        PRINT_STRING "a = "
        PRINT_DOUBLE A
        NEWLINE
        
        PRINT_STRING "b = "
        PRINT_DOUBLE B
        NEWLINE
        
        PRINT_STRING "c = "
        PRINT_DOUBLE C
        NEWLINE
        NEWLINE

        PRINT_STRING "x = "
        PRINT_DOUBLE X
        NEWLINE
        
        PRINT_STRING "y = "
        PRINT_DOUBLE Y
        NEWLINE
        
        NEWLINE
        PRINT_STRING "==========="
        NEWLINE
        
        mov rsp,rbp
      	pop rbp
	ret



TASK_1:
        push rbp
        mov rbp, rsp
        sub rsp, 8
        
        PRINT_STRING "TASK 1"
        NEWLINE
        PRINT_STRING "y = (a*x+b)/c"
        NEWLINE
        NEWLINE

    TASK_1_X87:
        PRINT_STRING "X87"
        NEWLINE
        
        FINIT
        
        FLD qword[A]
        FLD qword[X]
        FMUL
        FLD qword[B]
        FADD
        FLD qword[C]
        FDIV
        FSTP qword[RES]
        
        PRINT_STRING "y = "
        PRINT_DOUBLE RES
        NEWLINE
        NEWLINE
        
    TASK_1_SSE:
        PRINT_STRING "SSE"
        NEWLINE

        movsd xmm0, qword[A]
        movsd xmm1, qword[X]
        mulsd xmm0, xmm1
        movsd xmm1, qword[B]
        addsd xmm0, xmm1
        movsd xmm1, qword[C]
        divsd xmm0, xmm1
        movsd qword[RES], xmm0
        
        PRINT_STRING "y = "
        PRINT_DOUBLE RES
        NEWLINE
        NEWLINE
        
        
        PRINT_STRING "==========="
        NEWLINE
        
        mov rsp,rbp
	pop rbp
	ret



TASK_2:
        push rbp
        mov rbp, rsp
        sub rsp, 8
        
        PRINT_STRING "TASK 2 SSE"
        NEWLINE
        PRINT_STRING "cos(ln(x+a)) = b"
        NEWLINE
        NEWLINE
        
        call TASK_2_X87
        call TASK_2_SSE
                
        PRINT_STRING "==========="
        NEWLINE
        
        mov rsp,rbp
	pop rbp
	ret
        
        

TASK_2_SSE:
        push rbp
        mov rbp, rsp
        sub rsp, 8
        
        PRINT_STRING "SSE"
        NEWLINE

        movsd xmm0, qword[A]
        movsd xmm1, qword[ZERO]
        comisd xmm0, xmm1
        je TASK_2_SSE_A
            
        movsd xmm0, qword[B]
        mulsd xmm0, xmm0
        
        movsd xmm1, qword[C_4]
        movsd xmm2, qword[A]
        mulsd xmm1, xmm2
        
        movsd xmm2, qword[C]
        mulsd xmm1, xmm2
        
        subsd xmm0, xmm1

        movsd qword[RES], xmm0
        
        PRINT_STRING "D = "
        PRINT_DOUBLE RES
        NEWLINE
        
        movsd xmm1, qword[ZERO]
        cmpeqsd xmm0, xmm1
        je TASK_2_SSE_1_root
        jb TASK_2_SSE_0_root
        
        
        
        movsd xmm0, qword[ZERO]
        movsd xmm1, qword[B]
        subsd xmm0, xmm1
        
        movsd xmm2, qword[RES]
        sqrtsd xmm1, xmm2
        
        addsd xmm0, xmm1
        
        movsd xmm1, qword[A]
        movsd xmm2, qword[C_2]
        mulsd xmm1, xmm2
        divsd xmm0, xmm1
                        
        movsd qword[TEMP], xmm0
        
        PRINT_STRING "x_1 = "
        PRINT_DOUBLE TEMP
        NEWLINE
        
        
        
        movsd xmm0, qword[ZERO]
        movsd xmm1, qword[B]
        subsd xmm0, xmm1
        
        movsd xmm2, qword[RES]
        sqrtsd xmm1, xmm2
        
        subsd xmm0, xmm1
        
        movsd xmm1, qword[A]
        movsd xmm2, qword[C_2]
        mulsd xmm1, xmm2
        divsd xmm0, xmm1
                        
        movsd qword[TEMP], xmm0
        
        PRINT_STRING "x_2 = "
        PRINT_DOUBLE TEMP
        NEWLINE
                  
        jmp TASK_2_SSE_EXIT
    
    TASK_2_SSE_1_root:        
        movsd xmm0, qword[ZERO]
        movsd xmm1, qword[B]
        subsd xmm0, xmm1
        
        movsd xmm2, qword[C_2]
        movsd xmm1, qword[A]
        mulsd xmm1, xmm2
        divsd xmm0, xmm1
        
        movsd qword[TEMP], xmm0
        
        PRINT_STRING "x = "
        PRINT_DOUBLE RES
        NEWLINE
        
        jmp TASK_2_X87_EXIT
        
    TASK_2_SSE_A:
        PRINT_STRING "A == 0"
        NEWLINE
    TASK_2_SSE_0_root:
        PRINT_STRING "NO REAL ROOTS"
        NEWLINE
        
    TASK_2_SSE_EXIT:
        NEWLINE
        PRINT_STRING "==========="
        NEWLINE
    
        mov rsp,rbp
	pop rbp
	ret

TASK_2_X87:
        push rbp
        mov rbp, rsp
        sub rsp, 8
        
        
        PRINT_STRING "X87"
        NEWLINE
        FINIT
        
        FLD qword[A]
        FLDZ
        FCOMPP
        je TASK_2_X87_A

        FINIT
            
        FLD qword[B]
        FLD qword[B]
        FMUL
        FLD qword[C_4]
        FLD qword[A]
        FMUL
        FLD qword[C]
        FMUL
        FSUB
        
        FST qword[RES]
        
        PRINT_STRING "D = "
        PRINT_DOUBLE RES
        NEWLINE
        
        FLDZ
        FCOMPP
        je TASK_2_X87_1_root
        jb TASK_2_X87_0_root
        
        FINIT
        
        FLDZ
        FLD qword[B]
        FSUB
        FLD qword[RES]
        FSQRT
        FADD
        FLD1
        FLD1
        FADD
        FLD qword[A]
        FMUL
        FDIV
        
        FST qword[TEMP]
        
        PRINT_STRING "x_1 = "
        PRINT_DOUBLE TEMP
        NEWLINE
        
        FINIT
        
        FLDZ
        FLD qword[B]
        FSUB
        FLD qword[RES]
        FSQRT
        FSUB
        FLD1
        FLD1
        FADD
        FLD qword[A]
        FMUL
        FDIV
        
        FST qword[TEMP]
        
        PRINT_STRING "x_2 = "
        PRINT_DOUBLE TEMP
        NEWLINE
                  
        jmp TASK_2_X87_EXIT
    
    TASK_2_X87_1_root:
        FINIT
        
        FLDZ
        FLD qword[B]
        FSUB
        FLD1
        FLD1
        FADD
        FLD qword[A]
        FMUL
        FDIV
        
        FST qword[RES]
        
        PRINT_STRING "x = "
        PRINT_DOUBLE RES
        NEWLINE
        
        jmp TASK_2_X87_EXIT
        
    TASK_2_X87_A:
        PRINT_STRING "A == 0"
        NEWLINE
    TASK_2_X87_0_root:
        PRINT_STRING "NO REAL ROOTS"
        NEWLINE
        
    TASK_2_X87_EXIT:
        NEWLINE
        PRINT_STRING "==========="
        NEWLINE
    
        mov rsp,rbp
	pop rbp
	ret



TASK_3:
        push rbp
        mov rbp, rsp
        sub rsp, 8
        
        PRINT_STRING "TASK 3"
        NEWLINE
        PRINT_STRING "y < ln^3(sin(x)+a)"
        NEWLINE
        NEWLINE
        
        FINIT
        
        FLD1
        FLD qword[X]
        FLD qword[A]
        FADD
        FYL2X
        
        FST qword[RES]
        
        PRINT_DOUBLE Y
        PRINT_STRING " < "
        PRINT_DOUBLE RES
        NEWLINE
        
        FLD qword[Y]
        
        FCOMI st1
        ja TASK_3_FALSE
        
        PRINT_STRING "TRUE"
        NEWLINE
        jmp TASK_3_EXIT
        
    TASK_3_FALSE:
        PRINT_STRING "FALSE"
        NEWLINE
        
    TASK_3_EXIT:
        PRINT_STRING "==========="
    
        mov rsp,rbp
	pop rbp
        ret
        
