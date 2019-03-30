note
	description: "For operations that are not fire or bomb after game started."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	OTHER_OP

inherit
	OPERATION

create
	make

feature -- constructors
	make (a_model: ETF_MODEL)
		do
			model := a_model
			e := model.e
			s1 := model.s1
			s2 := model.s2
		ensure
			e = model.e
		end

feature -- commands
	execute
		do
			model.game_started_error
		end

	undo
		do
			restore_game_message
		end

	redo
		do
			execute
		end

feature -- queries
	output: STRING
		do
			Result := "other operation"
		end
end
