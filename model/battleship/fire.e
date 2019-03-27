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
			old_state := model.i - 1
			new_state := model.i
			e := model.e
			s1 := model.s1
			s2 := model.s2
			create coordinate.make_from_tuple (a_coordinate)
		end

feature -- commands
	execute
		do
			model.reset_game_message
			fire
		end

	undo
		do
			restore_game_message
--			model.set_state_message (old_state)
			unfire
		end
	redo
		do
			fire
--			model.set_state_message (new_state)
		end

feature -- {NONE} helpers
	fire
		do
			if not model.board.player.has_shots then
				model.set_e ("No shots remaining")

			elseif model.board.coordinate_status (coordinate) = 0 then
				model.set_e ("Invalid coordinate")

			elseif model.board.coordinate_status (coordinate) = 2 then
				model.set_e ("Already fired there")

			elseif model.board.coordinate_status (coordinate) = 1 then
				model.board.player.use_shot
				model.board.fire_board (coordinate)

				model.set_e ("OK")

				if model.board.fire_status(coordinate) = 0 then
					model.set_s2 ("Miss! ")
				elseif model.board.fire_status (coordinate) = 1 then
					model.set_s2 ("Hit! ")
				elseif model.board.fire_status (coordinate) = 2 then
					model.set_s2 (model.board.ship_list.find_ship (coordinate).ship_size.out+"x1 ship sunk! ")
				end
				model.set_fired
			end

			if model.has_fired = True then
				model.set_s1 ("Keep Firing!")
			else
				model.set_s1 ("Fire Away!")
			end

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
