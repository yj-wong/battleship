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
--		require else
--			custom_setup_test_precond(dimension, ships, max_shots, num_bombs)
    	do
			-- perform some update on the model state
			model.default_update

			-- new made by Joseph
			if model.game_started ~ False then
--				if (dimension.item.as_integer_32 <=  12 and dimension.item.as_integer_32 >=  4) and (ships.item.as_integer_32 <= 7 and ships.item.as_integer_32 >= 1) and (max_shots.item.as_integer_32 <= 144 and max_shots.item.as_integer_32 >= 1) and (num_bombs.item.as_integer_32 <= 7 and num_bombs.item.as_integer_32 >= 1) then
					if model.game_iteration > 0 and model.debug_mode = False then
						model.reset
					end
					model.custom_setup(dimension, ships, max_shots, num_bombs, True) -- true indicates debug_mode
--				else
--					model.game_not_started_error -- temporary, MUST CHANGED
--				end
			else
				model.reset_game_message
				model.e.append ("Game already started")
				model.s1.append ("")
				model.s2.append ("Fire Away!")
			end

--			model.save_state
			etf_cmd_container.on_change.notify ([Current])
    	end

end
