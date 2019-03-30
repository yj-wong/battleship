note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_UNDO
inherit
	ETF_UNDO_INTERFACE
		redefine undo end
create
	make
feature -- command
	undo
    	do
			-- perform some update on the model state
			if model.history.after then
				model.history.back
			end

			if model.history.on_item and model.game_started = True then
				model.history.item.undo
				model.set_state_message (model.history.old_state_item)
				model.history.back
			elseif model.game_started = False then
				model.reset_game_message
				model.set_e ("Nothing to undo")
				model.set_s2 ("Start a new game")
			else
				model.reset_game_message
				model.set_e ("Nothing to undo")
				if model.has_fired = True then
					model.set_s1 ("Keep Firing!")
				else
					model.set_s1 ("Fire Away!")
				end
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
