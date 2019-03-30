note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_GAME
inherit
	ETF_NEW_GAME_INTERFACE
		redefine new_game end
create
	make
feature -- command
	new_game(level: INTEGER_64)
		require else
			new_game_precond(level)
		local
			op: OTHER_OP
    	do
			-- perform some update on the model state
			model.default_update

			if model.game_started then
				create op.make (model)
				model.history.extend_state (model.i)
				model.history.extend_history (op)
				
				model.game_started_error
			else
				if model.game_iteration > 0 and model.debug_mode = True then
					model.reset
				end
				model.new_game(False, level)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
