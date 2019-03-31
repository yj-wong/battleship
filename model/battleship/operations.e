note
	description: "Summary description for {OPERATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OPERATION

feature -- attributes
	model: ETF_MODEL
	op_success: BOOLEAN -- if operation succesful, ie. the shot/bomb isn't invalid
	old_state, current_state: INTEGER
--	e, s1, s2: STRING

feature -- commands
	execute
		deferred
		end
	undo
		deferred
		end
	redo
		deferred
		end

feature -- {NONE} helpers
	set_old_state (a_old_state: INTEGER)
		do
			old_state := a_old_state
		end

	update_state_message (a_state: INTEGER)
		do
			model.game_message.set_state_message (a_state)
		end

feature -- queries
	output: STRING
		deferred
		end

invariant
	current_state_greater_than_old_state: current_state > old_state
end
