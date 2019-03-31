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
			if model.i = model.initial_i + 1 then
				-- If this is the first operation after game start
				old_state := model.initial_i
			end
			current_state := model.i
		end

feature -- commands
	execute
		do
			model.game_message.game_started_error
		end

	undo
		do
			model.game_message.new_game
			update_state_message (old_state)
		end

	redo
		do
			execute
			update_state_message (current_state)
		end

feature -- queries
	output: STRING
		do
			Result := "other operation"
		end
end
