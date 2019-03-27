note
	description: "Summary description for {BOARD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BOARD


inherit
	ANY
	redefine
		out
	end

create
	make_empty, make_size

feature --attributes
	board: ARRAY2[SHIP_ALPHABET]

	row_indices: ARRAY[CHARACTER]
		once
			Result := <<'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'>>
		end

	board_size: INTEGER

	ship_list: SHIP_LIST
		attribute
			create Result.make_empty
		end

	player: PLAYER
		attribute
			create Result.make_empty
		end

	debug_mode: BOOLEAN

feature --contructors
	make_empty
		do
			board_size := 0
			create board.make_filled (create {SHIP_ALPHABET}.make ('_'), board_size, board_size)
		end

	make_size (a_size: INTEGER)
		do
			board_size := a_size
			create board.make_filled (create {SHIP_ALPHABET}.make ('_'), board_size, board_size)
		end

	make_level (a_level: INTEGER_64; a_debug_mode: BOOLEAN; a_gen: RANDOM_GENERATOR)
		do
			debug_mode := a_debug_mode

			if a_level = 13 then
				board_size := 4
			elseif a_level = 14 then
				board_size := 6
			elseif a_level = 15 then
				board_size := 8
			elseif a_level = 16 then
				board_size := 12
			end

			make_size (board_size)
			create ship_list.make_ships_level (a_level, debug_mode, a_gen)
			create player.make_level (a_level, ship_list.total_ships_size_sum)
		end

	make_custom_level (number_ships: INTEGER_64; a_gen: RANDOM_GENERATOR; size: INTEGER_64; max_shots: INTEGER_64; num_bombs:INTEGER_64)
		do
			board_size := size.as_integer_32

			make_size (board_size)
			create ship_list.make_ships_custom (False, a_gen, number_ships, size) -- new
			create player.make_costume (max_shots, num_bombs, number_ships, ship_list.total_ships_size_sum)
		end

feature --coordinate_operations
	update_coordinate (a_coordinate: COORDINATE; a_char: CHARACTER)
		do
			board.put (create {SHIP_ALPHABET}.make (a_char), a_coordinate.row, a_coordinate.col)
		end

	coordinate_alphabet (a_coordinate: COORDINATE): CHARACTER
		do
			Result := board.item (a_coordinate.row, a_coordinate.col).item
		end

feature --utilities
	show_ships
		do
			across ship_list.ship_list as ship loop
				across ship.item.coord_list as coordinate loop
					if ship.item.direction = True then
						update_coordinate (coordinate.item, 'v')
					else
						update_coordinate (coordinate.item, 'h')
					end
				end
			end
		end

	fire_board (a_coordinate: COORDINATE)
		do
			if ship_list.has_ship (a_coordinate) then
				update_coordinate (a_coordinate, 'X')
				ship_list.find_ship (a_coordinate).hit (a_coordinate)

				if ship_list.ship_is_sunken (a_coordinate) then
					player.increment_score (ship_list.find_ship (a_coordinate).ship_size)
				end
			else
				update_coordinate (a_coordinate, 'O')
			end
		end

	unfire_board (a_coordinate: COORDINATE)
		local
			ship_direction: BOOLEAN
		do
			if debug_mode = True and ship_list.has_ship (a_coordinate) then
				if ship_list.find_ship (a_coordinate).direction = True then
					update_coordinate (a_coordinate, 'v')
				else
					update_coordinate (a_coordinate, 'h')
				end

			else
				update_coordinate (a_coordinate, '_')
			end

			if ship_list.has_ship (a_coordinate) then
				if ship_list.ship_is_sunken (a_coordinate) then
					player.decrement_score (ship_list.find_ship (a_coordinate).ship_size)
				end
				ship_list.find_ship (a_coordinate).unhit (a_coordinate)
			end
		end

feature --queries
	ships_remaining: INTEGER
		do
			Result := ship_list.ship_list.count
		end

	fire_status (a_coordinate: COORDINATE): INTEGER
			--returns 0 if miss, 1 if hit, 2 if ship sunk
		do
			if ship_list.ship_is_sunken (a_coordinate) then
				Result := 2
			elseif ship_list.has_ship (a_coordinate) then
				Result := 1
			else
				Result := 0
			end
		end

	coordinate_status (a_coordinate: COORDINATE): INTEGER
			--returns status of the coordinate regarding the board
			--returns 0 for invalid coordinate, 1 for valid coordinate, 2 for already fired coordinate
		do
			if a_coordinate.col <= board.width and a_coordinate.row <= board.height then
				Result := 1

				if coordinate_alphabet (a_coordinate) = 'O' or coordinate_alphabet (a_coordinate) = 'X' then
					Result := 2
				end
			end

		ensure
			valid_status: Result = 0 or Result = 1 or Result = 2
		end

	out: STRING
		local
			fi: FORMAT_INTEGER
		do
			create fi.make (2)
			create Result.make_from_string ("%N   ")
			across 1 |..| board.width as i loop Result.append(" " + fi.formatted (i.item)) end
			across 1 |..| board.width as i loop
				Result.append("%N  "+ row_indices[i.item].out)
				across 1 |..| board.height as j loop
					Result.append ("  " + board[i.item,j.item].out)
				end
			end
		end
end
