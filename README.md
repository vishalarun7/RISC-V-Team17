# RISC-V-Team17
RISC-V 32I CPU designed as part of the Instruction Architectures and Compilers class.

Single Cycle - 
This single cycle implementation covers the basic requirements for most CPU operations, this implements the following instructions: R-type, I-type (immediate), lbu, sb, beq, bne, jal, jalr, lui.

Schematic 
<img width="6055" height="3297" alt="image" src="https://github.com/user-attachments/assets/943ed4a2-d1c2-4782-9086-019f564687ae" />

## Contributions

| Category         | Module                            | Vishal | Nikhil | Emir | Raph |
|------------------|-----------------------------------|:------:|:------:|:----:|:----:|
| **Single Cycle** | **ALU**                           |        |   X    |      |      |
|                  | **PC Register**                   |   *    |   *    |  X   |      |
|                  | **Instruction Memory**            |   X    |        |      |      |
|                  | **Data Memory**                   |   X    |        |      |      |
|                  | **Control Unit**                  |   X    |        |      |      |
|                  | **Register File**                 |        |   X    |      |      |
|                  | **Sign Extend**                   |   X    |        |      |      |
|                  | **Top (System Integration)**      |        |   *    |      |  X   |
| **Pipeline**     | **Fetch–Decode Pipeline**         |   X    |        |      |      |
|                  | **Decode–Execute Pipeline**       |   X    |        |      |      |
|                  | **Execute–Memory Pipeline**       |   X    |        |      |    *  |
|                  | **Memory–Writeback Pipeline**     |   X    |        |      |      |
<<<<<<< HEAD
|                  | **Hazard Unit**                   |   X   |      |      |      |
|                  | **System Integration + Debugging**                   |      |      |      |   X   |
=======
|                  | **Hazard Unit**                   |   X   |      |      |  *    |
>>>>>>> f3d37ca (update readme)
| **Cache**        | **Memory (Refactor)**             |        |    X    |      |      |
|                  | **Direct-Mapped Cache**           |        |     X   |      |      |
|                  | **Two-Way Set Associative Cache** |        |      X  |      |      |
| **Verification** | **F1 Testing**                    |        |        |      |  X   |
|                  | **PDF Testing**                   |        |        |      |  X   |
|                  | **System Testing & Debugging**    |        |        |      |  X   |
|                  | **F1 Assembly.s**                 |        |        |      |  X   |
| **Other**        | **Vbuddy**                        |        |        |      |  X   |


**X = Lead Contributor**  
**\* = Partial Contributor**


