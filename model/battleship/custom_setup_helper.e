note
	description: "Summary description for {CUSTOM_SETUP_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CUSTOM_SETUP_HELPER

create
	make

feature {NONE} -- attributes
	model: ETF_MODEL
	board_size: INTEGER_64
	ship_num: INTEGER_64
	max_shots: INTEGER_64
	max_bombs: INTEGER_64
	debug_mode: BOOLEAN

feature -- constructors
	make (a_model: ETF_MODEL; a_board_size: INTEGER_64; a_ship_num: INTEGER_64 ; a_max_shots: INTEGER_64; a_max_bombs: INTEGER_64; a_debug_mode: BOOLEAN)
		do
			model := a_model
			board_size := a_board_size
			ship_num := a_ship_num
			max_shots := a_max_shots
			max_bombs := a_max_bombs
			debug_mode := a_debug_mode
		end

feature -- commands
	set_message
		require
			not valid_setup
		do
			if too_many_ships then
				model.game_message.too_many_ships
			elseif not_enough_ships then
				model.game_message.not_enough_ships
			elseif too_many_shots then
				model.game_message.too_many_shots
			elseif not_enough_shots then
				model.game_message.not_enough_shots
			elseif too_many_bombs then
				model.game_message.too_many_bombs
			elseif not_enough_bombs then
				model.game_message.not_enough_bombs
			end
		end

feature -- queries
	valid_setup: BOOLEAN
		do
			Result :=
			board_size >= 4 and board_size <= 12 and

			(not too_many_ships) and not (not_enough_ships) and
			(not too_many_shots) and not (not_enough_shots) and
			(not too_many_bombs) and not (not_enough_bombs)
		end

feature {NONE} -- helper queries
	too_many_ships: BOOLEAN
		do
			Result := not (ship_num <= 7 and ship_num <= (board_size // 2) + 1)
		end

	not_enough_ships: BOOLEAN
		do
			Result := not (ship_num >= 1 and ship_num >= (board_size // 3))
		end

	too_many_shots: BOOLEAN
		do
			Result := not (max_shots <= 144 and max_shots <= board_size ^ 2)
		end

	not_enough_shots: BOOLEAN
		local
			min_shot_condition: INTEGER
		do
			across 1 |..| board_size.as_integer_32 as i loop
				min_shot_condition := min_shot_condition + i.item
			end
			Result := not (max_shots >= 1)
		end

	too_many_bombs: BOOLEAN
		do
			Result := not (max_bombs <= 7 and max_bombs <= (board_size // 2) + 1)
		end

	not_enough_bombs: BOOLEAN
		do
			Result := not (max_bombs >= 1 and max_bombs >= (board_size // 3))
		end
end

