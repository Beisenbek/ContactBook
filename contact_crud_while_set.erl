-module(contact_crud_while_set).
-compile(export_all).
-define(PAGE_SIZE,3).

%============Begin of util functions==============
for(0,_) -> 
   []; 
   
for(N,Term) when N > 0 -> 
   		io:format("~B~n",[N]), 
   		[Term|for(N-1,Term)]. 

floor(X) when X < 0 ->
    T = trunc(X),
    case X - T == 0 of
        true -> T;
        false -> T - 1
    end;

floor(X) -> 
    trunc(X) .

idiv(A, B) ->
    floor(A / B).

my_time(S) ->
    {{Year, Month, Day}, {Hour, Minute, Second}} = calendar:local_time(),
	lists:flatten(io_lib:format("~s at: ~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w",[S,Year,Month,Day,Hour,Minute,Second])).

clear()->
	io:fwrite("\e[H\e[J").
%=============End of util functions==============


start()->
	TABLE = ets:new(phones, [ordered_set, public]),
	menu(TABLE).


menu(TABLE)->
{ok, [Operation]} = io:fread("please, enter command number [or -h for help] : ", "~s"),
	
	if  Operation =:= "1"			-> create(TABLE),menu(TABLE);
		Operation =:= "2"			-> update(TABLE),menu(TABLE);
		Operation =:= "3"			-> delete(TABLE),menu(TABLE);
		Operation =:= "4"			-> get_all_asc(TABLE),menu(TABLE);
		Operation =:= "5"			-> get_all_desc(TABLE),menu(TABLE);
		Operation =:= "6"   		-> search(TABLE),menu(TABLE);
		Operation =:= "7"   		-> get_from_to(TABLE),menu(TABLE);
		Operation =:= "-h"   		-> help(),menu(TABLE);
		Operation =:= "0"   		-> clear(),io:fwrite("bye!\n");
					  true   		-> menu(TABLE)
	end.



help() ->
	clear(),
	io:fwrite("1 create\n2 update\n3 delete\n4 get_all_asc\n5 get_all_desc\n6 search\n7 get_from_to\n0 exit\n").

create(TABLE) ->
	clear(),
	%{ok, [Name]} = io:fread("please, enter new contact name: ", "~s"),
	%{ok, [Phone]} = io:fread("please, enter new contact phone: ", "~s"),
	%ets:insert(TABLE, {Name,Phone,my_time("created")}),
	ets:insert(TABLE, {"1","2",my_time("created")}),
	ets:insert(TABLE, {"2","2",my_time("created")}),
	ets:insert(TABLE, {"3","2",my_time("created")}),
	ets:insert(TABLE, {"4","2",my_time("created")}),
	ets:insert(TABLE, {"5","2",my_time("created")}),
	ets:insert(TABLE, {"6","2",my_time("created")}),
	ets:insert(TABLE, {"7","2",my_time("created")}),
	ets:insert(TABLE, {"8","2",my_time("created")}),
	io:fwrite("done.\n").

update(TABLE) ->
	clear(),
	{ok, [Name]} = io:fread("please, enter contact name for phone update: ", "~s"),

	Length = lists:flatlength(ets:lookup(TABLE, Name)),

	if 
		Length > 0 	-> 
						{ok, [Phone]} = io:fread("please, enter new phone: ", "~s"),
						ets:insert(TABLE, {Name,Phone,my_time("updated")});

		true 	-> 
						io:fwrite("not found!.\n")	
	end,

	io:fwrite("done.\n").

delete(TABLE) ->
	clear(),
	{ok, [Name]} = io:fread("please, enter contact name for deleting: ", "~s"),
	ets:delete(TABLE, Name),
	io:fwrite("done.\n").

get_all_desc(TABLE)->
	clear(),
	List = ets:tab2list(TABLE),
	io:fwrite("\~-13w => \~p\~n", [ordered_set, lists:reverse(List)]),
	io:fwrite("done.\n").

get_all_asc(TABLE)->
	clear(),
	List = ets:tab2list(TABLE),
	io:fwrite("\~-13w => \~p\~n", [ordered_set, List]),
	io:fwrite("done.\n").

search(TABLE)->
	clear(),
	{ok, [Name]} = io:fread("please, enter contact name for search: ", "~s"),
	Length = lists:flatlength(ets:lookup(TABLE, Name)),
	if Length > 0 ->
		      io:fwrite("\~-13w => \~p\~n", [ordered_set, ets:lookup(TABLE, Name)]);
 	   true -> 
	          io:fwrite("not found!.\n")
	end,
	io:fwrite("done.\n").

get_from_to(TABLE)->
	{ok, [Direction]} = io:fread("please, enter direction -> or <-: ", "~s"),
	if Direction =:= "->" ->
							showNextInfoForKey(TABLE,ets:first(TABLE),0,Direction);
	   Direction =:= "<-" ->
	   						showNextInfoForKey(TABLE,ets:last(TABLE),0,Direction);
	   				true -> ok
	 end.

showNextInfoForKey(TABLE,Key,Cnt,Direction)->
	if 	Key =:= '$end_of_table' -> true;
		Cnt >= ?PAGE_SIZE -> true;
						   true -> io:fwrite("~s~n",[Key]),
						   		 if Direction =:= "->" ->
											 showNextInfoForKey(TABLE,ets:next(TABLE,Key),Cnt + 1,Direction);
	  						    	Direction =:= "<-" ->
	   										 showNextInfoForKey(TABLE,ets:prev(TABLE,Key),Cnt + 1,Direction);
	   											 true -> ok
								 end
						          
	end.

