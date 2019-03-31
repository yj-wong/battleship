note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DEBUG_TEST
inherit
	ETF_DEBUG_TEST_INTERFACE
		redefine debug_test end
create
	make
feature -- command
	debug_test(level: INTEGER_64)
		require else
			debug_test_precond(level)
		local
			op: OTHER_OP
    	do
			-- perform some update on the model state
			model.default_update

			if model.game_started then
				create op.make (model)
				model.history.extend_history (op)
				model.game_message.game_started_error
			else
				if model.game_iteration > 0 and model.debug_mode = False then
					model.reset
				end
				model.new_game(True, level)
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
