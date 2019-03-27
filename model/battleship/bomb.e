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
				old_state := model.i - 1
				new_state := model.i
				e := model.e
				s1 := model.s1
				s2 := model.s2
				create coordinate1.make_from_tuple (a_coordinate1)
				create coordinate2.make_from_tuple (a_coordinate2)
		end

feature -- commands
	execute
		do
			model.reset_game_message
			bomb
		end

	undo
		do
			restore_game_message
--			model.set_state_message (old_state)
			unbomb
		end

	redo
		do
			bomb
--			model.set_state_message (new_state)
		end

feature -- {NONE} helpers
	bomb
		do
			if not model.board.player.has_bombs then
				model.set_e ("No bombs remaining")

			elseif not coordinate1.adjacent_to (coordinate2) then
				model.set_e ("Bomb coordinates must be adjacent")

			elseif model.board.coordinate_status (coordinate1) = 0 or model.board.coordinate_status (coordinate2) = 0 then
				model.set_e ("Invalid coordinate")

			elseif model.board.coordinate_status (coordinate1) = 2 or model.board.coordinate_status (coordinate2) = 2 then
				model.set_e ("Already fired there")

			elseif model.board.coordinate_status (coordinate1) = 1 or model.board.coordinate_status (coordinate2) = 1 then
				model.board.player.use_bomb
				model.board.fire_board (coordinate1)
				model.board.fire_board (coordinate2)

				model.set_e ("OK")

				if model.board.fire_status (coordinate1) = 0 and model.board.fire_status (coordinate2) = 0 then
					model.set_s2 ("Miss! ")
				elseif model.board.fire_status (coordinate1) = 1 or model.board.fire_status (coordinate2) = 1 then
					model.set_s2 ("Hit! ")
				elseif model.board.fire_status (coordinate1) = 2 and model.board.fire_status (coordinate2) /= 2 then
					model.set_s2 (model.board.ship_list.find_ship (coordinate1).ship_size.out+"x1 ship sunk! ")
				elseif model.board.fire_status (coordinate2) = 2 and model.board.fire_status (coordinate1) /= 2 then
					model.set_s2 (model.board.ship_list.find_ship (coordinate2).ship_size.out+"x1 ship sunk! ")
				elseif model.board.fire_status (coordinate1) = 2 and model.board.fire_status (coordinate2) = 2 then
					if model.board.ship_list.find_ship (coordinate1).ship_size = model.board.ship_list.find_ship (coordinate2).ship_size then
						model.set_s2 (model.board.ship_list.find_ship (coordinate1).ship_size.out+"x1 ship sunk! ")
					else
						model.set_s2 (model.board.ship_list.find_ship (coordinate1).ship_size.out+"x1 and "+
							model.board.ship_list.find_ship (coordinate2).ship_size.out+"x1 ships sunk! ")
					end
				end
				model.set_fired
			end
			if model.has_fired = True then
				model.set_s1 ("Keep Firing!")
			else
				model.set_s1 ("Fire Away")
			end

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
