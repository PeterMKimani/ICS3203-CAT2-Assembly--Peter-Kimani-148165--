global _start

section .data
    sensor_value    dd 0        ; Simulated sensor input
    motor_status    db 0        ; Motor status: 0=OFF, 1=ON
    alarm_status    db 0        ; Alarm status: 0=OFF, 1=ON

    HIGH_LEVEL      equ 80
    MODERATE_LEVEL  equ 50

    prompt          db 'Enter sensor value: ', 0
    input_buffer    db 10 dup(0)
    motor_msg       db 'Motor Status: ', 0
    alarm_msg       db 'Alarm Status: ', 0
    on_msg          db 'ON', 10, 0
    off_msg         db 'OFF', 10, 0

section .bss
    ; Uninitialized data section

section .text
_start:
    ; Prompt for sensor value
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, prompt
    mov     rdx, 20                 ; Length of the prompt
    syscall

    ; Read user input
    mov     rax, 0                  ; sys_read
    mov     rdi, 0                  ; stdin
    mov     rsi, input_buffer
    mov     rdx, 10
    syscall

    ; Convert input to integer
    mov     rsi, input_buffer
    call    atoi                    ; Result in RAX

    ; Store sensor value
    mov     [sensor_value], eax

    ; Read sensor value
    mov     eax, [sensor_value]

    ; Determine actions based on sensor value
    cmp     eax, HIGH_LEVEL
    jg      high_level

    cmp     eax, MODERATE_LEVEL
    jg      moderate_level

low_level:
    ; Low level: Motor ON, Alarm OFF
    mov     byte [motor_status], 1
    mov     byte [alarm_status], 0
    jmp     display_status

moderate_level:
    ; Moderate level: Motor OFF, Alarm OFF
    mov     byte [motor_status], 0
    mov     byte [alarm_status], 0
    jmp     display_status

high_level:
    ; High level: Motor ON, Alarm ON
    mov     byte [motor_status], 1
    mov     byte [alarm_status], 1

display_status:
    ; Display motor status
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, motor_msg
    mov     rdx, 14
    syscall

    mov     al, [motor_status]
    cmp     al, 1
    je      motor_on
    jmp     motor_off

motor_on:
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, on_msg
    mov     rdx, 3
    syscall
    jmp     display_alarm

motor_off:
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, off_msg
    mov     rdx, 4
    syscall

display_alarm:
    ; Display alarm status
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, alarm_msg
    mov     rdx, 13
    syscall

    mov     al, [alarm_status]
    cmp     al, 1
    je      alarm_on
    jmp     alarm_off

alarm_on:
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, on_msg
    mov     rdx, 3
    syscall
    jmp     exit_program

alarm_off:
    mov     rax, 1                  ; sys_write
    mov     rdi, 1                  ; stdout
    mov     rsi, off_msg
    mov     rdx, 4
    syscall

exit_program:
    ; Exit the program
    mov     rax, 60                 ; sys_exit
    xor     rdi, rdi
    syscall

; Subroutine: ASCII to Integer Conversion (atoi)
atoi:
    xor     rax, rax                ; Clear RAX
    xor     rbx, rbx                ; Clear RBX for temporary storage
    mov     rbx, 10                 ; Multiplier (base 10)

atoi_loop:
    movzx   rcx, byte [rsi]         ; Load the next character
    cmp     rcx, 10                 ; Check for newline
    je      atoi_done
    sub     rcx, '0'                ; Convert ASCII to digit
    imul    rax, rbx                ; Multiply current value by 10
    add     rax, rcx                ; Add digit to result
    inc     rsi
    jmp     atoi_loop

atoi_done:
    ret


; Documentation: Data Monitoring and Control Simulation
; -----------------------------------------------------
; This program simulates a sensor-based control system for managing a motor and alarm
; based on the sensor input. The control flow is determined by sensor thresholds (LOW,
; MODERATE, and HIGH levels). Memory locations represent the motor and alarm states.

; How the Program Determines Actions:
; -----------------------------------
; 1. Sensor Input:
;    - The program reads a "sensor value" from user input and stores it in the
;      `sensor_value` memory location. This simulates a water-level sensor.

; 2. Decision Logic:
;    - `HIGH_LEVEL` and `MODERATE_LEVEL` constants define thresholds for decision-making.
;    - Comparisons (`cmp` instructions) and conditional jumps (`jg`, `jmp`) decide the
;      actions based on the sensor value:
;      - High Level (`sensor_value > HIGH_LEVEL`):
;        - Motor is turned ON (`motor_status` set to 1).
;        - Alarm is triggered (`alarm_status` set to 1).
;      - Moderate Level (`sensor_value > MODERATE_LEVEL` but `<= HIGH_LEVEL`):
;        - Motor is turned OFF (`motor_status` set to 0).
;        - Alarm remains OFF (`alarm_status` set to 0).
;      - Low Level (`sensor_value <= MODERATE_LEVEL`):
;        - Motor is turned ON (`motor_status` set to 1).
;        - Alarm remains OFF (`alarm_status` set to 0).

; How Memory Locations/Ports Are Manipulated:
; -------------------------------------------
; 1. `motor_status`:
;    - Represents the motor's state (0=OFF, 1=ON).
;    - Updated directly based on the sensor value during decision-making.
; 2. `alarm_status`:
;    - Represents the alarm's state (0=OFF, 1=ON).
;    - Set based on the sensor value, indicating whether the alarm is active.
; 3. `sensor_value`:
;    - Temporarily holds the input sensor value for processing.

; Conditional Jumps and Control Flow:
; -----------------------------------
; - `JG` (Jump if Greater): Used to check if the sensor value exceeds a threshold
;   (e.g., `HIGH_LEVEL` or `MODERATE_LEVEL`). This determines the corresponding
;   control action (e.g., turning the motor or alarm ON/OFF).
; - `JMP`: Used to redirect program flow unconditionally after processing each case.
;   This ensures that only one case is executed and avoids unintended behavior.

; Example Control Flow:
; ---------------------
; - Input: Sensor value = 85
;   1. Compared with `HIGH_LEVEL` (80): `JG high_level` is taken.
;   2. Motor and alarm are turned ON.
;   3. Status is displayed, and program exits.

; Program Modularity:
; -------------------
; - The decision-making logic is separated from the display logic, making the program
;   easier to modify and debug.
; - Subroutine `atoi` handles ASCII-to-integer conversion for user input.
; - Each section of the program (sensor input, decision, display, exit) is clearly
;   delineated for readability and maintainability.
