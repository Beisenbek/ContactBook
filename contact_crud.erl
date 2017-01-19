-module(contact_crud).
-compile(export_all).
 
-record(contact, {name,phone,timestamp=calendar:local_time()}).

start()->
	M = create(1,#{}),
	create(2,M).

create(N,M) ->
	Contact = #contact{
			name="Beisenbek",
			phone="87011257617"
	},
	maps:put(N, Contact, M).

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
