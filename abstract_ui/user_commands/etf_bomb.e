note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_BOMB
inherit
	ETF_BOMB_INTERFACE
		redefine bomb end
create
	make
feature -- command
	bomb(coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64]; coordinate2: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			bomb_precond(coordinate1, coordinate2)
		local
			op: BOMB
    	do
			-- perform some update on the model state
			model.default_update
			create op.make (model, coordinate1, coordinate2)

			if model.game_started = False then
				model.game_not_started_error
			else
				model.history.extend_state (model.i)
				model.history.extend_history (op)
				op.execute
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

end
