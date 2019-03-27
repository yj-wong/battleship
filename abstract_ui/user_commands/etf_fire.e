note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_FIRE
inherit
	ETF_FIRE_INTERFACE
		redefine fire end
create
	make
feature -- command
	fire(coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		require else
			fire_precond(coordinate)
		local
			op: FIRE
    	do
			-- perform some update on the model state
			model.default_update

			if model.game_started = False then
				model.game_not_started_error
			else
				if model.history.no_prior_state then
					model.history.extend_state (model.i)
				else
					model.history.extend_state (model.history.state.item + 1)
				end
				create op.make (model, coordinate)
				model.history.extend_history (op)
				op.execute
			end

			etf_cmd_container.on_change.notify ([Current])
    	end

end
