# ICS3203-CAT2-Assembly--Peter-Kimani-148165--

## Overview of the Tasks

### Task 1: Control Flow and Conditional Logic
-------------------------------------------------
This program is a number classification utility written in x86 assembly language for Linux systems. It prompts the user to enter a number, determines whether the number is positive, negative, or zero, and outputs the corresponding message. It utilizes both conditional and unconditional jump instructions to effectively manage the classification of a user-input number. 

### Task 2: Array Manipulation with Looping and Reversal
----------------------------------------------------------
This program is an interactive digit input and reversal utility written in x86-64 assembly for Linux systems. It prompts the user to input exactly five valid single-digit numbers (0–9), validates each input, stores the digits in an array, reverses their order, and then prints the reversed digits, each on a new line. Essentially it performs this in-place reversal without additional memory, using loop-based two-pointer logic.

### Task 3: Modular Program and Register Handling
----------------------------------------------------
This program computes the factorial of a user-input number (0-12) using a modular approach with subroutines and proper register management. The factorial calculation is implemented as a separate subroutine, demonstrating a clear understanding of modularity and stack usage.

### Task 4: Data Monitoring and Control Simulation
-----------------------------------------------------
This program simulates a sensor-based control system for managing a motor and alarm based on the sensor input. The control flow is determined by sensor thresholds (LOW, MODERATE, and HIGH levels). Memory locations represent the motor and alarm states and updates memory locations to simulate hardware behavior.


## Compiling and running the code

### Requirements
- Linux-based operating system or emulator for syscalls.
- `NASM` (Netwide Assembler) for assembling the code.
- `ld` (GNU Linker) for linking the object files

In order to run the code, follow the following instructions:

#### Using NASM:
**Open a terminal in your WSL environment.**

Navigate to the directory containing your .asm file. We shall use task1.asm for this example however it can apply to all the other tasks.
Use the following command to assemble the code:
```
Bash
nasm -f elf64 task1.asm -o task1.o
```

**Link the Object File**:

Use the ld linker to create an executable file:
```
Bash
ld task1.o -o task1
```

**Execute the Program**:

Run the executable:
```
Bash
./task1
```

**Additional Considerations**:

**WSL Configuration**:
Ensure that your WSL environment is configured correctly, including any necessary toolchains and libraries.

**Debugging**:
Use a debugger like GDB to step through the code and inspect variables.

**Testing**:
Test your program with various input values to verify its correctness.

## Insights and Challenges

### 1. **Number Classification**
   - **Insights**: Efficient use of conditional (`JE`, `JL`) and unconditional (`JMP`) jumps simplifies program flow.
   - **Challenges**: Ensuring correct branching logic to handle each case without redundant checks.

### 2. **Array Reversal**
   - **Insights**: Demonstrates efficient in-place array reversal using two-pointer logic and loops.
   - **Challenges**: Direct memory access requires precise index calculations to avoid out-of-bounds errors.



### 3. **Factorial Calculation**
   - **Insights**: Modular design using subroutines enhances readability and reusability.
   - **Challenges**: Managing the stack to preserve registers and ensuring accurate results for edge cases (e.g., 0!).

### 4. **Sensor Control Simulation**
   - **Insights**: Simulates real-world scenarios by updating memory locations to reflect motor and alarm statuses.
   - **Challenges**: Handling multiple thresholds and ensuring memory is manipulated safely and accurately.


---

## Contribution
Feel free to fork, modify, and submit pull requests for improvements or new features.

---

## License
This repository is licensed under the MIT License. See the [LICENSE](LICENSE.txt) file for details.
