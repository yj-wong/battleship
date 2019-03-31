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
			if model.game_started = False then
				model.game_message.game_not_started_error
				model.game_message.no_redo

			elseif model.history.can_redo = False then
				model.game_message.reset_game_message
				model.game_message.no_redo

			elseif model.game_started and model.history.can_redo then
				model.history.redo
			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
