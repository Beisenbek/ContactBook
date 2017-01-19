-module(contact_crud_while_set).
-compile(export_all).

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

clear()->
	io:fwrite("\e[H\e[J").

help() ->
	clear(),
	io:fwrite("1 create\n2 update\n3 delete\n4 get_all_asc\n5 get_all_desc\n6 search\n7 get_from_to\n0 exit\n").

create(TABLE) ->
	clear(),
	{ok, [Name]} = io:fread("please, enter new contact name: ", "~s"),
	{ok, [Phone]} = io:fread("please, enter new contact phone: ", "~s"),
	ets:insert(TABLE, {Name,Phone}),
	io:fwrite("done.\n").

update(TABLE) ->
	io:fwrite("update\n").

delete(TABLE) ->
	clear(),
	{ok, [Name]} = io:fread("please, enter contact name for delete: ", "~s"),
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
	io:fwrite("\~-13w => \~p\~n", [ordered_set, ets:lookup(TABLE, Name)]),
	io:fwrite("done.\n").

get_from_to(TABLE)->
	io:fwrite("get_from_to\n").
