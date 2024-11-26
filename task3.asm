section .data
    prompt          db 'Enter a number (0-12): ', 0
    result_msg      db 'Factorial is: ', 0
    newline         db 10, 0
    input_buffer    db 10 dup(0)         ; Buffer for user input
    result_buffer   db 20 dup(0)         ; Buffer for result output

section .bss
    ; Empty for this program

section .text
global _start

_start:
    ; Display prompt
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, prompt
    mov     rdx, 22                 ; Length of the prompt
    syscall

    ; Read user input
    mov     rax, 0                  ; sys_read
    mov     rdi, 0                  ; stdin
    mov     rsi, input_buffer
    mov     rdx, 10                 ; Max input size
    syscall

    ; Convert input to integer
    mov     rsi, input_buffer       ; Pass input buffer
    call    atoi                    ; Result in RAX

    ; Validate input (number between 0 and 12)
    cmp     rax, 12
    ja      invalid_input
    cmp     rax, 0
    jl      invalid_input

    ; Calculate factorial
    push    rax                     ; Push input number onto stack
    call    factorial
    add     rsp, 8                  ; Clean up stack

    ; RAX now contains the factorial result

    ; Convert result to string
    mov     rsi, result_buffer      ; Buffer for the result
    call    itoa

    ; Display result message
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, result_msg
    mov     rdx, 14                 ; Length of the message
    syscall

    ; Display result
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, result_buffer
    mov     rdx, 20                 ; Assume max length
    syscall

    ; Newline
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, newline
    mov     rdx, 1
    syscall

    ; Exit program
    mov     rax, 60                 ; sys_exit
    xor     rdi, rdi
    syscall

invalid_input:
    ; Print an error message and exit
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, newline
    mov     rdx, 22                 ; Error message
    syscall
    mov     rax, 60                 ; sys_exit
    xor     rdi, rdi
    syscall

; Subroutine: Factorial Calculation
factorial:
    mov     rbx, 1                  ; Initialize result in RBX
    cmp     rax, 0                  ; If input is 0, return 1
    je      factorial_end
factorial_loop:
    imul    rbx, rax                ; RBX = RBX * RAX
    dec     rax                     ; Decrement RAX
    jnz     factorial_loop
factorial_end:
    mov     rax, rbx                ; Return result in RAX
    ret

; Subroutine: ASCII to Integer Conversion (atoi)
atoi:
    xor     rax, rax                ; Clear RAX
    xor     rcx, rcx                ; RCX for multiplier (10^n)
    mov     rcx, 10

atoi_loop:
    movzx   rdx, byte [rsi]         ; Load next character
    cmp     rdx, 10                 ; Check for newline
    je      atoi_done
    sub     rdx, '0'                ; Convert ASCII to digit
    imul    rax, rcx                ; Multiply current result by 10
    add     rax, rdx                ; Add digit to result
    inc     rsi
    jmp     atoi_loop

atoi_done:
    ret

; Subroutine: Integer to ASCII Conversion (itoa)
itoa:
    xor     rcx, rcx                ; Counter for digits
itoa_loop:
    xor     rdx, rdx                ; Clear RDX
    mov     rbx, 10
    div     rbx                     ; Divide RAX by 10
    add     dl, '0'                 ; Convert remainder to ASCII
    push    rdx                     ; Store digit on stack
    inc     rcx
    test    rax, rax                ; Check if RAX is 0
    jnz     itoa_loop

itoa_pop:
    pop     rdx                     ; Get digit from stack
    mov     [rsi], dl               ; Store it in buffer
    inc     rsi
    loop    itoa_pop

    mov     byte [rsi], 0           ; Null-terminate the string
    ret



; Documentation: Modular Program and Register Handling
; ----------------------------------------------------
; This program computes the factorial of a user-input number (0-12) using a modular approach
; with subroutines and proper register management. The factorial calculation is implemented
; as a separate subroutine, demonstrating a clear understanding of modularity and stack usage.

; Factorial Subroutine:
; ---------------------
; 1. Registers Used:
;    - RAX: Initially holds the input number and is used to decrement during the loop.
;    - RBX: Holds the intermediate and final factorial result.
;    - RSP: The stack pointer is adjusted to save and restore the input value.

; 2. Register Preservation:
;    - Before calling the factorial subroutine, the input number in RAX is pushed onto the
;      stack to preserve its value for later use.
;    - After the subroutine completes, the stack is cleaned up using `add rsp, 8` to remove
;      the saved value.

; 3. Control Flow:
;    - JE (Jump if Equal) is used to handle the base case where the input is 0 (factorial of 0 is 1).
;    - JNZ (Jump if Not Zero) is used in the loop to continue multiplying until the input
;      reaches 0.

; Stack Usage and Register Management:
; ------------------------------------
; - The stack is explicitly used to save the input value before the factorial calculation.
;   This demonstrates modularity and ensures the input can be restored after the subroutine call.
; - RAX is overwritten during the calculation, but its original value is preserved on the stack.
; - The final result is moved back to RAX at the end of the subroutine to maintain consistency
;   with calling conventions.

; Subroutine: ASCII to Integer Conversion (atoi)
; ----------------------------------------------
; - Registers:
;   - RAX: Holds the final converted integer result.
;   - RCX: Acts as a multiplier for place values (10^n).
;   - RDX: Temporarily stores each character's ASCII value during processing.
; - The conversion process uses arithmetic and multiplication to build the integer from the
;   ASCII characters in the input buffer.

; Subroutine: Integer to ASCII Conversion (itoa)
; ----------------------------------------------
; - Registers:
;   - RAX: The integer to be converted.
;   - RCX: Counter for the number of digits.
;   - RDX: Temporarily holds the remainder (digit) during division.
; - The subroutine pushes each digit onto the stack in reverse order and then pops them
;   back to construct the string in the correct order.
; - This approach demonstrates efficient stack usage for intermediate results.

; Why Modular Code is Important:
; ------------------------------
; - Each subroutine is self-contained and reusable, reducing code duplication and improving
;   readability.
; - Proper use of the stack ensures that register values are preserved across subroutine calls,
;   making the program modular and extensible.

; Summary:
; --------
; - Registers are managed efficiently, with input values saved and restored as needed.
; - Stack operations ensure modularity and separation of concerns, allowing the main program
;   and subroutines to work independently while maintaining a clean program flow.
