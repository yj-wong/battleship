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



--			if
--				model.history.before
--				or not model.history.after
--			then
--				model.history.forth
--			end

--			-- redo
--			if model.history.on_item and model.game_started = True then
--				model.history.item.redo
----				model.set_state_message (model.history.new_state_item)

--			else
--				model.game_message.no_redo
--			end

--			elseif model.game_started = False then
--				model.reset_game_message
--				model.set_e ("Nothing to redo")
--				model.set_s2 ("Start a new game")
--			else
--				model.reset_game_message
--				model.set_e ("Nothing to redo")
----				if model.has_fired = True then
----					model.set_s1 ("Keep Firing!")
----				else
----					model.set_s1 ("Fire Away!")
----				end
--			end
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
