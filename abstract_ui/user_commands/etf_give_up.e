note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_GIVE_UP
inherit
	ETF_GIVE_UP_INTERFACE
		redefine give_up end
create
	make
feature -- command
	give_up
    	do
			-- perform some update on the model state
			model.default_update

			if model.game_started = True then
				model.give_up
			else
				model.game_message.game_not_started_error
			end
			
			etf_cmd_container.on_change.notify ([Current])
    	end

end
