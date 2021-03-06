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
	PAGINATION = ets:new(pagination, [bag, public]), 
	menu(PAGINATION,TABLE).


menu(PAGINATION,TABLE)->
	{ok, [Operation]} = io:fread("please, enter command number [or -h for help] : ", "~s"),
	
	if  Operation =:= "1"			-> create(PAGINATION, TABLE),menu(PAGINATION,TABLE);
		Operation =:= "2"			-> update(TABLE),menu(PAGINATION,TABLE);
		Operation =:= "3"			-> delete(PAGINATION,TABLE),menu(PAGINATION,TABLE);
		Operation =:= "4"			-> get_all_asc(TABLE),menu(PAGINATION,TABLE);
		Operation =:= "5"			-> get_all_desc(TABLE),menu(PAGINATION,TABLE);
		Operation =:= "6"   		-> search(TABLE),menu(PAGINATION,TABLE);
		Operation =:= "7"   		-> pagination(PAGINATION,TABLE),menu(PAGINATION,TABLE);
		Operation =:= "-h"   		-> help(),menu(PAGINATION,TABLE);
		Operation =:= "0"   		-> clear(),io:fwrite("bye!\n");
					  true   		-> menu(PAGINATION,TABLE)
	end.

navigation(PAGINATION,TABLE,PAGE,MAXL) ->

	showInfoForPage(PAGINATION,TABLE,PAGE,MAXL),
	
	{ok, [Option]} = io:fread("\n\n\n\n\n\nplease, enter: \n1 for previous page \n2 for next page \n0 for returning previous menu for navigation: ", "~s"),

	if  Option =:= "1" -> 
			if PAGE >  1  -> navigation(PAGINATION,TABLE,PAGE - 1, MAXL);
					   true -> navigation(PAGINATION,TABLE,MAXL, MAXL)
			end;

		Option =:= "2" -> 
			if PAGE < MAXL -> navigation(PAGINATION,TABLE,PAGE + 1, MAXL);
					   true -> navigation(PAGINATION,TABLE,1, MAXL)
			end;

		Option =:= "0" -> clear(),ok;
		
		true -> navigation(PAGINATION,TABLE,PAGE,MAXL)
	end.


pagination(PAGINATION,TABLE) ->
	PAGE = 1,
	Length = lists:flatlength(ets:tab2list(TABLE)),
	Temp = idiv(Length,?PAGE_SIZE),
	if Length =:= ?PAGE_SIZE * Temp -> navigation(PAGINATION,TABLE,PAGE,Temp);
												  true -> navigation(PAGINATION,TABLE,PAGE,Temp + 1)	
	end.											  

update_pagination(PAGINATION,TABLE)->
	ets:delete_all_objects(PAGINATION),
	generate_pagination(PAGINATION,TABLE,1,ets:first(TABLE),0).

generate_pagination(PAGINATION,TABLE,PAGE,KEY,Cnt)->
	if 	KEY =:= '$end_of_table' -> true;
						   true -> 
						   		 if  Cnt >= ?PAGE_SIZE  -> generate_pagination(PAGINATION,TABLE,PAGE + 1, KEY,0);
	  						    	               true -> 
															ets:insert(PAGINATION, {PAGE,KEY}),
	  						    	               			generate_pagination(PAGINATION,TABLE,PAGE, ets:next(TABLE,KEY),Cnt + 1)
								 end
						          
	end.

showInfoForPage(PAGINATION,TABLE,PAGE,MAXL)->
	clear(),
	io:fwrite("\n\n######## page [~B] from [~B] ##########\n\n\n\n\n\n",[PAGE,MAXL]),

	List = ets:lookup(PAGINATION, PAGE),
	lists:foreach(fun(N) ->
					  {PAGE, Key} = N,
					  List2 = ets:lookup(TABLE,Key),
                      io:format("Item:~p~n",List2)
              end, List).

help() ->
	clear(),
	io:fwrite("1 create\n2 update\n3 delete\n4 get_all_asc\n5 get_all_desc\n6 search\n7 pagination\n0 exit\n").

create(PAGINATION,TABLE) ->
	clear(),
	{ok, [Name]} = io:fread("please, enter new contact name: ", "~s"),
	{ok, [Phone]} = io:fread("please, enter new contact phone: ", "~s"),
	ets:insert(TABLE, {Name,Phone,my_time("created")}),
	%ets:insert(TABLE, {"1","2124",my_time("created")}),
	%ets:insert(TABLE, {"2","2",my_time("created")}),
	%ets:insert(TABLE, {"3","2",my_time("created")}),
	%ets:insert(TABLE, {"4","2",my_time("created")}),
	%ets:insert(TABLE, {"5","2",my_time("created")}),
	%ets:insert(TABLE, {"6","2",my_time("created")}),
	%ets:insert(TABLE, {"7","2",my_time("created")}),
	%ets:insert(TABLE, {"8","2",my_time("created")}),
	update_pagination(PAGINATION,TABLE),
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

delete(PAGINATION,TABLE) ->
	clear(),
	{ok, [Name]} = io:fread("please, enter contact name for deleting: ", "~s"),
	ets:delete(TABLE, Name),
	update_pagination(PAGINATION,TABLE),
	io:fwrite("done.\n").

get_all_desc(TABLE)->
	clear(),
	List = lists:keysort(3,ets:tab2list(TABLE)),
	io:fwrite("\~-13w => \~p\~n", [ordered_set, lists:reverse(List)]),
	io:fwrite("done.\n").

get_all_asc(TABLE)->
	clear(),
	List = lists:keysort(3,ets:tab2list(TABLE)),
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