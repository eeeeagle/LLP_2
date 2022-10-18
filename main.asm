%include "io64_float.inc"
global CMAIN

segment .rodata
	      A:      dq 5.4
        B:      dq -8.9
        C:      dq 0.16
        
        D:      dq 4.0
        
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
        
        FINIT
        
        PRINT_STRING "TASK 1"
        NEWLINE
        PRINT_STRING "y = (a*x+b)/c"
        NEWLINE
        NEWLINE

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
        
        
        PRINT_STRING "==========="
        NEWLINE
        
        mov rsp,rbp
	      pop rbp
	      ret



TASK_2:
        push rbp
        mov rbp, rsp
        sub rsp, 8
        
        PRINT_STRING "TASK 2"
        NEWLINE
        PRINT_STRING "a*x^2 + b*x +c = 0"
        NEWLINE
        NEWLINE
        
        FINIT
        
        FLD qword[A]
        FLDZ
        FCOMPP
        je TASK_2_A

        FINIT
            
        FLD qword[B]
        FLD qword[B]
        FMUL
        FLD qword[D]
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
        je TASK_2_1_root
        jb TASK_2_0_root
        
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
                  
        jmp TASK_2_EXIT
    
    TASK_2_1_root:
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
        
        jmp TASK_2_EXIT
        
    TASK_2_A:
        PRINT_STRING "A == 0"
        NEWLINE
    TASK_2_0_root:
        PRINT_STRING "NO REAL ROOTS"
        NEWLINE
        
    TASK_2_EXIT:
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
        PRINT_STRING "y < log_2(x+a)"
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
        FCOMPP
        jb FALSE
        
        PRINT_STRING "TRUE"
        NEWLINE
        jmp TASK_3_EXIT
        
    FALSE:
        PRINT_STRING "FALSE"
        NEWLINE
        
    TASK_3_EXIT:
        PRINT_STRING "==========="
    
        mov rsp,rbp
	      pop rbp
	      ret
        
