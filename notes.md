
# What needs to happen to make this work in PSEUDO CODE 
Current version -> walks through map for n steps. Can not add :- not goal because of the way it is constructed. Goal is only achievable in the final step. 

This works only for single shot, not multishot. Multishot requires being able to see the full path Since optimization of the shortest path is not possible because the map is unknown.  

Split the solving (agent part) into additional functions 
 1 Observe 
     1.1 observe true or false 
 2 Think 
     2.1 Identify possible actions 
     2.2 identify possible pit, wumpus, gold, wall
 3 Act
    Either: 
    3.1 def Move 
    3.2 def Grab Gold
    3.3 def Move with gold
    3.4 def Exit

===========================================================
The above is not dynamic / interactive since there is only 1 solution, 1 path -> using clingraph might be feasible to see what happens. 

For the multishot solution using only the clingo API one would need to either embed python external code inside the agent encoding where environment data is added. 
 
That means for clinguin IFF interactive for each choice the user does, the clingo backend needs ground and solve.  
