note
	description: "Summary description for {SHIP_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHIP_LIST

inherit
	ANY
	redefine
		out
	end

create
	make_empty, make_ships_num, make_ships_level, make_ships_num_custom, make_ships_custom

feature --attributes
	ship_list: ARRAY[SHIP]

feature --constructors
	make_empty
		do
			create ship_list.make_empty
		end

	make_ships_num (board_size: INTEGER; gen: RANDOM_GENERATOR; num_ships: INTEGER)
		local
			counter: INTEGER
			ship: SHIP
		do
			create ship_list.make_empty

			from
				counter := num_ships
			until
				counter = 0
			loop
				create ship.make_random (board_size, gen, counter)

				if not collides_with_existing_ships (ship) and not ship.out_of_bounds (board_size)then
					ship_list.force (ship, ship_list.count + 1)
					counter := counter - 1
				end
				gen.forth
			end
		end

	make_ships_level (a_level: INTEGER_64; a_debug_mode: BOOLEAN; a_gen: RANDOM_GENERATOR)
		local
			num_ships: INTEGER
			gen: RANDOM_GENERATOR
			board_size: INTEGER
		do
			if a_level = 13 then
				num_ships := 2
				board_size := 4
			elseif a_level = 14 then
				num_ships := 3
				board_size := 6
			elseif a_level = 15 then
				num_ships := 5
				board_size := 8
			elseif a_level = 16 then
				num_ships := 7
				board_size := 12
			end

			if a_debug_mode = True then
				gen := a_gen
			else
				create gen.make_random
			end

			make_ships_num(board_size, gen, num_ships)
		end

	-- new made by Joseph
		make_ships_num_custom (board_size: INTEGER; gen: RANDOM_GENERATOR; num_ships: INTEGER)
		local
			counter: INTEGER
			ship: SHIP
		do
			create ship_list.make_empty

			from
				counter := num_ships
			until
				counter = 0
			loop
				create ship.make_random (board_size, gen, counter)

				if not collides_with_existing_ships (ship) and not ship.out_of_bounds (board_size)then
					ship_list.force (ship, ship_list.count + 1)
					counter := counter - 1
				end
				gen.forth
			end
		end

	make_ships_custom (a_debug_mode: BOOLEAN; a_gen: RANDOM_GENERATOR; number_ships: INTEGER_64; the_board_size: INTEGER_64)
		local
			num_ships: INTEGER
			gen: RANDOM_GENERATOR
			board_size: INTEGER
		do
			num_ships := number_ships.as_integer_32
			board_size := the_board_size.as_integer_32

			if a_debug_mode = True then
				gen := a_gen
			else
				create gen.make_random
			end

			make_ships_num_custom(board_size, gen, num_ships)
		end

feature --utilities
	collides_with_existing_ships (a_ship: SHIP): BOOLEAN
		do
			if ship_list.is_empty then
				Result := False
			else
				across ship_list as ship loop
					if a_ship.collides_with (ship.item) then
						Result := True
					end
				end
			end
		end

	has_ship (a_coordinate: COORDINATE): BOOLEAN
			--if a ship has that coordinate, hits the ship and return true
			--returns false if no ship has that coordinate.
		do
			across ship_list as ship loop
				if ship.item.has_coordinate (a_coordinate) then
					Result := True
				end
			end
		end

	find_ship (a_coordinate: COORDINATE): SHIP
		require
			has_ship(a_coordinate)
		do
			create Result.make_empty
			across ship_list as ship loop
				if ship.item.has_coordinate (a_coordinate) then
					Result := ship.item
				end
			end
		end

	ship_is_sunken (a_coordinate: COORDINATE): BOOLEAN
		do
			across ship_list as ship loop
				if ship.item.has_coordinate (a_coordinate) then
					if ship.item.is_sunken then
						Result := True
					end
				end
			end
		end

feature --queries
	total_ships_size_sum: INTEGER
			--returns the total sum of all of the ship sizes
		do
			across ship_list as ship loop
				Result := Result + ship.item.ship_size
			end
		end

	sunken_ships: INTEGER
		do
			across ship_list as ship loop
				if ship.item.is_sunken then
					Result := Result + 1
				end
			end
		end

	unsunken_ships: INTEGER
		do
			across ship_list as ship loop
				if not ship.item.is_sunken then
					Result := Result + 1
				end
			end
		end

	details: STRING
		do
			create Result.make_empty
			across ship_list as ship loop
				Result.append ("%N"+ship.item.out)
			end
		end

	debug_out: STRING
		do
			create Result.make_empty
			Result.append ("  Ships: ")
			Result.append (sunken_ships.out+"/"+ship_list.count.out)
			across ship_list as ship loop
				Result.append ("%N    "+ship.item.ship_size.out+"x1: ")
				Result.append (ship.item.debug_out)
			end
		end

	out: STRING
		do
			create Result.make_empty
			Result.append ("  Ships: ")
			Result.append (sunken_ships.out+"/"+ship_list.count.out)
			across ship_list as ship loop
				Result.append ("%N    "+ship.item.ship_size.out+"x1: ")

				if ship.item.is_sunken then
					Result.append ("Sunk")
				else
					Result.append ("Not Sunk")
				end
			end
		end
end
