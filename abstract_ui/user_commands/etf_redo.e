note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REDO
inherit
	ETF_REDO_INTERFACE
		redefine redo end
create
	make
feature -- command
	redo
    	do
			-- perform some update on the model state
			if
				model.history.before
				or not model.history.after
			then
				model.history.forth
			end

			-- redo
			if model.history.on_item and model.game_started = True then
				model.history.item.redo
				model.set_state_message (model.history.state + 1)
			elseif model.game_started = False then
				model.reset_game_message
				model.e.append ("Nothing to redo")
				model.s1.append ("")
				model.s2.append ("Start a new game")
			else
				model.reset_game_message
				model.e.append ("Nothing to redo")
				model.s1.append ("")
				model.s2.append ("Fire Away!")
			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
