-module(contact_crud_while).
-compile(export_all).
 
-record(contact, {name,phone,timestamp=calendar:local_time()}).

start()->
	M = #{},

	{ok, [Operation]} = io:fread("please, enter command name [or -h for help] : ", "~s"),
	
	if  Operation =:= "create"   -> M = create(M),start();
		Operation =:=   "read"   -> read(),start();
		Operation =:= "update"   -> update(),start();
		Operation =:= "delete"   -> delete(),start();
		Operation =:=     "-h"   -> help(),start();
		Operation =:=   "exit"   -> io:fwrite("bye!\n");
						  true   -> start()
	end.

help() ->
	io:fwrite(" create\n read\n update\n delete\n exit\n").

create(M) ->
	{ok, [Name]} = io:fread("please, enter new contact name: ", "~s"),
	{ok, [Phone]} = io:fread("please, enter new contact phone: ", "~s"),
	Contact = #contact{
			name=Name,
			phone=Phone
	},
	maps:put(Name, Contact, M).

read() ->
	io:fwrite("read\n").

update() ->
	io:fwrite("update\n").

delete() ->
	io:fwrite("delete\n").

get_all_asc()->
	io:fwrite("get_all_asc\n").

get_all_desc()->
	io:fwrite("get_all_desc\n").

search()->
	io:fwrite("get_with_name\n").

get_from_to()->
	io:fwrite("get_from_to\n").
