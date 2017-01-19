-module(main). 
-export([start/0]).

start() -> 
   io:fwrite("Hello, world!\n"),
   %Pets = #{"dog" => "winston", "fish" => "mrs.blub"},
   %io:fwrite("~s",[Pets]),
   {ok, [X]} = io:fread("input : ", "~d"),
   io:fwrite("~B\n",[X]).
