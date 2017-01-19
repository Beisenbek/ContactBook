-module(contact_simple).
-compile(export_all).
 
-record(contact, {name,phone,timestamp}).

first_contact() ->
	#contact{name="Beisenbek",
	phone="87011257617",
	timestamp=calendar:local_time()}.