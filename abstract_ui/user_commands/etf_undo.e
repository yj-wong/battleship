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
--			model.undo
			if model.history.after then
				model.history.back
			end

			if model.history.on_item and model.game_started = True then
				model.history.item.undo
				model.set_state_message (model.history.state)
				model.history.back
			elseif model.game_started = False then
				model.reset_game_message
				model.e.append ("Nothing to undo")
				model.s1.append ("")
				model.s2.append ("Start a new game")
			else
				model.reset_game_message
				model.e.append ("Nothing to undo")
				model.s1.append ("")
				model.s2.append ("Fire Away!")
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
