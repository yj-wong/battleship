note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_CUSTOM_SETUP_TEST
inherit
	ETF_CUSTOM_SETUP_TEST_INTERFACE
		redefine custom_setup_test end
create
	make
feature -- command
	custom_setup_test(dimension: INTEGER_64 ; ships: INTEGER_64 ; max_shots: INTEGER_64 ; num_bombs: INTEGER_64)
		require else
			custom_setup_test_precond(dimension, ships, max_shots, num_bombs)
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
				model.custom_setup(dimension, ships, max_shots, num_bombs, True) -- true indicates debug_mode
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
