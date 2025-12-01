# RISC-V-Team17
RISC-V 32I CPU designed as part of the Instruction Architectures and Compilers class.

Single Cycle - 
This single cycle implementation covers the basic requirements for most CPU operations, this implements the following instructions: R-type, I-type (immediate), lbu, sb, beq, bne, jal, jalr, lui.

Schematic 
<img width="6055" height="3297" alt="image" src="https://github.com/user-attachments/assets/943ed4a2-d1c2-4782-9086-019f564687ae" />

## Contributions

| Module                       | Vishal | Nikhil | Emir | Raph |
|------------------------------|:------:|:------:|:----:|:----:|
| **alu**                      |        |  X     |     |      *|
| **instr_mem**                |   X    |        |      |    *  |
| **pc_register**              |   *    |   *     |  X    |  *   |
| **datamem**                  |   X    |       |      |    *  |
| **control**                  |   X    |       |      |    *  |
| **reg_file**                 |        |   X     |     |   *   |
| **signextend**               |   X    |        |      |     * |
| **top (system integration)** |        |   X     |      |   *   |
| **F1 Assembly.s**            |        |        |      |   X   |
| **System Testing & Debugging** |     |        |      |   X   |
| **PDF testing**              |        |        |      |  X   |
| **F1 Testing**               |        |        |      |   X  |

**X = Lead Contributor**  
**\* = Partial Contributor**


