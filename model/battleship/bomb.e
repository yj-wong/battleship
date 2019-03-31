note
	description: "Summary description for {BOMB}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOMB

inherit
	OPERATION

create
	make

feature -- attributes
	coordinate1: COORDINATE
	coordinate2: COORDINATE

feature -- constructors
	make(a_model: ETF_MODEL; a_coordinate1: TUPLE[row: INTEGER_64; column: INTEGER_64]; a_coordinate2: TUPLE[row: INTEGER_64; column: INTEGER_64])
		do
			model := a_model
			if model.i = model.initial_i + 1 then
				-- If this is the first operation after game start
				old_state := model.initial_i
			end
			current_state := model.i
			create coordinate1.make_from_tuple (a_coordinate1)
			create coordinate2.make_from_tuple (a_coordinate2)
		end

feature -- commands
	execute
		do
			bomb
		end

	undo
		do
			if
				model.board.coordinate_status (coordinate1) = 2 and
				model.board.coordinate_status (coordinate2) = 2 and
				op_success = True
			then
				-- only unbomb if coordinates has been successfully fired
				unbomb
				model.game_message.reset_game_message
				update_state_message (old_state)
			end
		end

	redo
		do
			execute
			update_state_message (current_state)
		end

feature {NONE} -- helpers
	bomb
		do
			model.game_message.reset_game_message

			if not model.board.player.has_bombs then
				model.game_message.no_bombs

			elseif not coordinate1.adjacent_to (coordinate2) then
				model.game_message.bomb_not_adjacent

			elseif model.board.coordinate_status (coordinate1) = 0 or model.board.coordinate_status (coordinate2) = 0 then
				model.game_message.invalid_coordinate

			elseif model.board.coordinate_status (coordinate1) = 2 or model.board.coordinate_status (coordinate2) = 2 then
				model.game_message.already_fired

			elseif model.board.coordinate_status (coordinate1) = 1 or model.board.coordinate_status (coordinate2) = 1 then
				model.board.player.use_bomb
				model.board.fire_board (coordinate1)
				model.board.fire_board (coordinate2)

				if model.board.fire_status (coordinate1) = 0 and model.board.fire_status (coordinate2) = 0 then
					model.game_message.ship_miss

				elseif model.board.fire_status (coordinate1) = 2 and model.board.fire_status (coordinate2) /= 2 then
					model.game_message.ship_sunk (model.board.ship_list.find_ship (coordinate1).ship_size)

				elseif model.board.fire_status (coordinate2) = 2 and model.board.fire_status (coordinate1) /= 2 then
					model.game_message.ship_sunk (model.board.ship_list.find_ship (coordinate2).ship_size)

				elseif model.board.fire_status (coordinate1) = 2 and model.board.fire_status (coordinate2) = 2 then
					if model.board.ship_list.find_ship (coordinate1).ship_size = model.board.ship_list.find_ship (coordinate2).ship_size then
						model.game_message.ship_sunk (model.board.ship_list.find_ship (coordinate1).ship_size)
					else
						model.game_message.double_ship_sunk (model.board.ship_list.find_ship (coordinate1).ship_size,
							model.board.ship_list.find_ship (coordinate2).ship_size)
					end

				elseif model.board.fire_status (coordinate1) = 1 or model.board.fire_status (coordinate2) = 1 then
					model.game_message.ship_hit

				end
				model.game_message.set_has_fired
				op_success := True
			end

			model.game_message.reset_game_status
			model.check_game_status
		end

	unbomb
		do
			model.board.player.unuse_bomb
			model.board.unfire_board (coordinate1)
			model.board.unfire_board (coordinate2)
		end

feature -- queries
	output: STRING
		do
			Result := "bomb coordinates: " + coordinate1.out + " " + coordinate2.out
		end
end
