-module(for). 
-export([for/2,start/0]). 

for(0,_) -> 
   []; 
   
   for(N,Term) when N > 0 -> 
   io:format("~B~n",[N]), 
   [Term|for(N-1,Term)]. 
   
start() -> 
   for(1,5).