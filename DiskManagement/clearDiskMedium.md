# Clear medium after using for booting (Windows)

## Meaning of commands

### Program for disk management
 
> diskpart
By entering this command, a new window will popup, where you will be able to run other commands for disk management

### Mediums 

> list disk

> select disk X

> clean

These 3 are pretty self explainatory, but first one lists medium and second one selects it for use, like in databases, the last one CLEANS the whole disk, wipes all the information.

### Reformating the disk

> create partition primary

> format fs=fat32 quick

> assign

Firstly we create new primary "node", than we select file system, last one will name it like "E:"    


## Commands

`diskpart`

`list disk`

`select disk X`

`clean`

`create partition primary`

`format fs=fat32 quick`

`assign`

`exit`


