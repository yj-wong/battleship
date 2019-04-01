note
	description: "Summary description for {HISTORY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HISTORY

inherit
	ANY
	redefine
		out
		end

create
	make

feature {NONE} -- attributes
	history: LIST[OPERATION]

feature{NONE} --constructors
	make
		do
			create {ARRAYED_LIST[OPERATION]}history.make (10)
		end

feature -- commands
	undo
		do
			if after then
				history.back
			end

			if on_item then
				item.undo

				-- restore old message
				if history.index > 1 then
					if history.index = 2 then
						item.model.game_message.new_game
					end

					old_item.undo
					old_item.redo
				else
					item.model.game_message.new_game
					item.model.game_message.set_state_message (item.model.initial_i)
				end

				history.back
			end
		end

	redo
		do
			if before or not after then
				history.forth
			end

			if on_item then
				item.redo
			end
		end

	extend_history (a_op: OPERATION)
			-- remove all operations to the right of the current
			-- cursor in history, then extend with `a_op'
		do
			remove_right
			history.extend(a_op)
			history.finish

			if history.is_empty or history.index = 1 then
				item.set_old_state (item.model.initial_i)
			elseif history.index > 1 then
				item.set_old_state (old_item.current_state)
			end
		ensure
			history_extended: history[history.count] = a_op
		end

feature -- queries
	can_undo: BOOLEAN
		do
			Result := not before
		end

	can_redo: BOOLEAN
		do
			Result := history.index < history.count
		end

	out: STRING
		do
			create Result.make_empty
			across history as op
			loop
				Result.append (op.item.output + " ")
				Result.append ("old: " + op.item.old_state.out + " ")
				Result.append ("current: " + op.item.current_state.out + " ")
				Result.append ("%N")
			end
			Result.append ("index: " + " " + history.index.out + " ")
			Result.append ("count: " + history.count.out)
--			Result.append (" " + history_state.index.out)
			Result.append ("%N")

		end


feature {NONE} -- helper commands
	remove_right
			--remove all elements
			-- to the right of the current cursor in history
		do
			if not history.islast and not history.after then
				from
					history.forth
				until
					history.after
				loop
					history.remove
				end
			end
		end


	forth
		require
			not after
		do
			history.forth
		end

	back
		require
			not before
		do
			history.back
		end


feature {NONE} -- helper queries
	old_item: OPERATION
		require
			history.index > 1
		do
			Result := history.at (history.index - 1)
		end

	item: OPERATION
			-- Cursor points to this user operation
		require
			on_item
		do
			Result := history.item
		end

	on_item: BOOLEAN
			-- cursor points to a valid operation
			-- cursor is not before or after
		do
			Result :=
				not history.before and not history.after
		end


	after: BOOLEAN
			-- Is there no valid cursor position to the right of cursor?
		do
			Result := history.index = history.count + 1
		end

	before: BOOLEAN
			-- Is there no valid cursor position to the left of cursor?
		do
			Result := history.index = 0
		end
end
