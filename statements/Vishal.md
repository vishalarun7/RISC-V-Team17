Vishal Arun
CID: 02636117

Overview







##Single Cycle 
Instruction Memory

Sign Extension Unit

Control Unit

Data Memory



##Pipelined

Code that could not be carried forward from my Single-Cycle design

Why flags cannot be used in Decode stage
When you are in Decode stage (ID):
* The branch instruction is only being decoded.
* The ALU has not yet executed the comparison.
* So the Zero flag you want does not exist yet.
Pipeline timing:
Stage	What’s happening?
ID	We decode a branch (beq, blt…)
EX	Only here do we subtract rs1 - rs2 and compute Zero/Negative
MEM	Optional for branch
WB	N/A
Therefore:
❗ Branch decision is ONLY valid in the Execute stage, not Decode.
If you try to use the flag in Decode, you are using the previous instruction’s flag → wrong.
This causes:
* Incorrect branching
* Nasty pipeline hazards
* Random jump behaviour


Had to Change control to use jump and branch signals explicitly in pipeline and talk about it 


A data hazard occurs when an instruction tries to read a register that has not yet been written back by a previous instruction. A control hazard occurs when the decision of what instruction to fetch next has not been made by the time the fetch takes place

The hazard unit examines the instruction in the Execute stage. If it is lw and its destination register (rtE) matches either source operand of the instruction in the Decode stage (rsD or rtD), that instruction must be stalled in the Decode stage until the source operand is ready.


"The instruction in the Decode stage is invalid. Replace it with a NOP.It will flow down the pipeline and do nothing."
This is exactly what flushing means.

❗ Why not simply disable control signals in later stages?
Because the instruction in Decode hasn't been turned into control signals yet — it's still a raw instruction.Decode happens after this register.


Why MemRead is often omitted
* The data memory is modeled so that reads happen whenever its address changes, without needing an enable; only writes are controlled by MemWrite. 
* The control unit therefore only generates MemWrite (for stores) plus ResultSrc to choose between ALUResult, ReadData, and PC+4 in writeback. 
When MemRead is useful
* Some designs add MemRead mainly for the hazard detection unit: to detect a load‑use hazard, the unit checks if the instruction in EX/MEM is a load via MemRead and compares its rd with the next instruction’s rs1/rs2. 
* If you encode “is a load” some other way (e.g., ResultSrcE == LOAD), you can avoid a separate MemRead signal and still implement the hazard unit correctly. 

