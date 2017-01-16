# Paper : 

LDU :  
We propose a novel light weight concurrent update method, LDU, 
to improve performance scalability for Linux kernel on many-core systems
through eliminating lock contentions for update-heavy global data structures
during process spawning and optimizing update logs. 
The proposed LDU is implemented into Linux kernel 3.19 and evaluated 
using representative benchmark programs. 
Our evaluation reveals that the Linux kernel with LDU shows performance
improvement by ranging from 1.2x through 2.2x on a 120 core system.
[Paper](scalability.pdf)


Joohyun Kyong, Sung-Soo Lim
"LDU: A LIGHTWEIGHT CONCURRENT UPDATE METHOD WITH DEFERRED PROCESSING FOR LINUX KERNEL SCALABILITY"
Parallel and Distributed Computing and Networks (PDCN 2016) [Paper](scalability.pdf)
