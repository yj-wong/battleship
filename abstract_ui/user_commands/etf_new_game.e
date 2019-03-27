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
    	do
			-- perform some update on the model state
			model.default_update

			if model.game_started = True then
				model.game_started_error
			else
				if model.game_iteration > 0 and model.debug_mode = True then
					model.reset
				end
				model.new_game(False, level)
			end

--			model.save_state
			etf_cmd_container.on_change.notify ([Current])
    	end

end
