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
			if model.game_started = False then
				model.game_message.game_not_started_error
				model.game_message.no_undo

			elseif model.history.can_undo = False then
				model.game_message.reset_game_message
				model.game_message.no_undo

			elseif model.game_started and model.history.can_undo then
				model.history.undo
			end

			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
