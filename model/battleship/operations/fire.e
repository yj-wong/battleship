note
	description: "Summary description for {FIRE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIRE

inherit
	OPERATION

create
	make

feature -- attributes
	coordinate: COORDINATE

feature -- constructors
	make (a_model: ETF_MODEL; a_coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		do
			model := a_model
			if model.i = model.initial_i + 1 then
				-- If this is the first operation after game start
				old_state := model.initial_i
			end
			current_state := model.i
			create coordinate.make_from_tuple (a_coordinate)
		end

feature -- commands
	execute
		do
			fire
		end

	undo
		do
			if model.board.coordinate_status (coordinate) = 2 and op_success = True then
				-- only unfire if coordinate has been successfully fired
				unfire
			end
			--default update
			model.game_message.reset_game_message
			update_state_message (old_state)
		end

	redo
		do
			execute
			update_state_message (current_state)
		end

feature {NONE} -- helpers
	fire
		do
			model.game_message.reset_game_message

			if not model.board.player.has_shots then
				model.game_message.no_shots

			elseif model.board.coordinate_status (coordinate) = 0 then
				model.game_message.invalid_coordinate

			elseif model.board.coordinate_status (coordinate) = 2 then
				model.game_message.already_fired

			elseif model.board.coordinate_status (coordinate) = 1 then
				model.board.player.use_shot
				model.board.fire_board (coordinate)

				if model.board.fire_status(coordinate) = 0 then
					model.game_message.ship_miss
				elseif model.board.fire_status (coordinate) = 1 then
					model.game_message.ship_hit
				elseif model.board.fire_status (coordinate) = 2 then
					model.game_message.ship_sunk (model.board.ship_list.find_ship (coordinate).ship_size)
				end

				model.game_message.set_has_fired
				op_success := True
			end

			model.game_message.reset_game_status
			model.check_game_status
		end

	unfire
		do
			model.board.player.unuse_shot
			model.board.unfire_board (coordinate)
		end

feature -- queries
	output: STRING
		do
			Result := "fire coordinate: " + coordinate.out
		end
end
