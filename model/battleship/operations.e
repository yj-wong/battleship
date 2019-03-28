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
	e, s1, s2: STRING

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
	restore_game_message
		do
			model.reset_game_message
			model.set_e (e)
			model.set_s1 (s1)
			model.set_s2 (s2)
		end

feature -- queries
	output: STRING
		deferred
		end
end
