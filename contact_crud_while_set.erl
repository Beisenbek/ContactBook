-module(contact_crud_while_set).
-compile(export_all).

start()->
	TABLE = ets:new(phones, [ordered_set, public]),
	menu(TABLE).


menu(TABLE)->
{ok, [Operation]} = io:fread("please, enter command number [or -h for help] : ", "~s"),
	
	if  Operation =:= "1"			-> create(TABLE),menu(TABLE);
		Operation =:= "2"			-> read(),menu(TABLE);
		Operation =:= "3"			-> update(),menu(TABLE);
		Operation =:= "4"			-> delete(),menu(TABLE);
		Operation =:= "5"			-> get_all_asc(TABLE),menu(TABLE);
		Operation =:= "6"			-> get_all_desc(TABLE),menu(TABLE);
		Operation =:= "7"   		-> search(),menu(TABLE);
		Operation =:= "8"   		-> get_from_to(),menu(TABLE);
		Operation =:= "-h"   		-> help(),menu(TABLE);
		Operation =:= "0"   		-> clear(),io:fwrite("bye!\n");
					  true   		-> menu(TABLE)
	end.

clear()->
	io:fwrite("\e[H\e[J").

help() ->
	clear(),
	io:fwrite("1 create\n2 read\n3 update\n4 delete\n5 get_all_asc\n6 get_all_desc\n7 search\n8 get_from_to\n0 exit\n").

create(TABLE) ->
	clear(),
	{ok, [Name]} = io:fread("please, enter new contact name: ", "~s"),
	{ok, [Phone]} = io:fread("please, enter new contact phone: ", "~s"),
	ets:insert(TABLE, {Name,Phone}),
	io:fwrite("done.\n").

read() ->
	io:fwrite("read\n").

update() ->
	io:fwrite("update\n").

delete() ->
	io:fwrite("delete\n").

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

search(Name)->
	io:fwrite("get_with_name\n").

get_from_to()->
	io:fwrite("get_from_to\n").
