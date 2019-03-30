note
	description: "Summary description for {GAME_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MESSAGE

create
	make

feature -- {NONE} attributes
	state_message: STRING
	error: STRING
	fire_status: STRING
	game_status: STRING

feature -- constructor
	make
		do
			create state_message.make_
		end
end
