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

feature{NONE} --constructors
	make
		do
			create {ARRAYED_LIST[OPERATION]}history.make (10)
			create {ARRAYED_LIST[TUPLE[old_state: INTEGER; new_state: INTEGER]]}history_state.make (10)
		end
	history: LIST[OPERATION]
	history_state: LIST[TUPLE[old_state: INTEGER; new_state: INTEGER]]

feature -- queries
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
				not history.before and not history.after and
				not history_state.before and not history_state.after
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

	old_state_item: INTEGER
		do
			check attached {INTEGER} history_state.last.at (1) as os then
				Result := os
			end
		end

	new_state_item: INTEGER
		do
			check attached {INTEGER} history_state.last.at (2) as ns then
				Result := ns
			end
		end

	out: STRING
		do
			create Result.make_empty
			across history as op
			loop
				Result.append (op.item.output + " ")
				Result.append ("%N")
			end
			Result.append ("index: " + " " + history.index.out + " " + history_state.index.out)
			Result.append ("%N")
			across history_state as s
			loop
				Result.append ("state: " + s.item.out + " ")
			end
		end

feature -- commands
	extend_history (a_op: OPERATION)
			-- remove all operations to the right of the current
			-- cursor in history, then extend with `a_op'
		do
			remove_right
			history.extend(a_op)
			history.finish
		ensure
			history_extended: history[history.count] = a_op
		end

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
			history_state.forth
		end

	back
		require
			not before
		do
			history.back
			history_state.back
		end

	extend_state (a_new_state: INTEGER)
		local
			old_state: INTEGER
		do
			if history_state.is_empty then
				old_state := a_new_state - 1
			elseif history_state.index = 0 then
				check attached {INTEGER} history_state.first.at (1) as prev_old_state then
					old_state := prev_old_state
				end
			else
				check attached {INTEGER} history_state.last.at (2) as prev_new_state then
					old_state := prev_new_state
				end
			end

			remove_right_state
			history_state.extend ([old_state, a_new_state])
			history_state.finish
		ensure
--			history_state_extended: history_state[history_state.count] = [old_state, a_new_state]
		end

	remove_right_state
		do
			if not history_state.islast and not history_state.after then
				from
					history_state.forth
				until
					history_state.after
				loop
					history_state.remove
				end
			end
		end


invariant
	history_sync_with_state: history.index <= history_state.index + 1
	history_same_count_with_state: history.count <= history_state.count + 1
end
