note
	description: "Summary description for {SHIP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SHIP

inherit
	ANY
	redefine
		out
	end

create
	make, make_empty, make_random

feature --attributes
	ship_size: INTEGER

	direction: BOOLEAN --True for vertical, False for horizontal

	coord_list: ARRAY[COORDINATE]

	coord_status_list: ARRAY[CHARACTER]

	hit_points: INTEGER

	is_sunken: BOOLEAN

feature --constructors
	make (a_row: INTEGER; a_col: INTEGER; a_direction: BOOLEAN; a_ship_size: INTEGER)
		local
			counter: INTEGER
		do
			direction := a_direction
			ship_size := a_ship_size
			hit_points := a_ship_size

			create coord_list.make_empty

			if a_direction = True then
				create coord_status_list.make_filled ('v', 1, ship_size)
			else
				create coord_status_list.make_filled ('h', 1, ship_size)
			end

			from
				counter := 0
			until
				counter = ship_size
			loop
				if a_direction = True then
					coord_list.force (create {COORDINATE}.make (a_row + counter, a_col), coord_list.count + 1)
				else
					coord_list.force (create {COORDINATE}.make (a_row, a_col + counter), coord_list.count + 1)
				end

				counter := counter + 1
			end
		end

	make_empty
		do
			make (1, 1, True, 1)
		end

	make_random (board_size: INTEGER; gen: RANDOM_GENERATOR; a_ship_size: INTEGER)
		local
			row: INTEGER
			col: INTEGER
		do
			direction := (gen.direction \\ 2 = 1)

			if direction = True then
				col := (gen.column \\ board_size) + 1
				row := (gen.row \\ (board_size - a_ship_size)) + 1
				make (row + 1, col, direction, a_ship_size)
			else
				row := (gen.row \\ board_size) + 1
				col := (gen.column \\ (board_size - a_ship_size)) + 1
				make (row, col + 1, direction, a_ship_size)
			end
		end

feature --utilities
	collides_with (a_ship: SHIP): BOOLEAN
			--check if this ship collides with another ship
		local
			counter: INTEGER
			smaller_ship: SHIP
		do
			if ship_size > a_ship.ship_size then
				smaller_ship := a_ship
			else
				smaller_ship := Current
			end

			across a_ship.coord_list as i loop
				across coord_list as j loop
					if j.item.same_as (i.item) then
						Result := True
					end
				end
			end
		end

	out_of_bounds (board_size: INTEGER): BOOLEAN
			--check if this ship is out of the board boundary
		do
			if direction = True then
				Result := coord_list.item (1).row > board_size - ship_size + 1
			else
				Result := coord_list.item (1).col > board_size - ship_size + 1
			end
		end

	hit (a_coordinate: COORDINATE)
		do
			hit_points := hit_points - 1

			across coord_list as coordinate loop
				if coordinate.item.same_as (a_coordinate) then
					coord_status_list.force ('X', coordinate.cursor_index)
				end
			end

			if hit_points = 0 then
				is_sunken := True
			end
		end

	unhit (a_coordinate: COORDINATE)
		do
			if hit_points = 0 then
				is_sunken := False
			end

			hit_points := hit_points + 1

			across coord_list as coordinate loop
				if coordinate.item.same_as (a_coordinate) then
					if direction = True then
						coord_status_list.force ('v', coordinate.cursor_index)
					else
						coord_status_list.force ('h', coordinate.cursor_index)
					end
				end
			end
		end

feature --queries
	has_coordinate (a_coordinate: COORDINATE): BOOLEAN
			--check if this ship has a coordinate, used for when firing to a coordinate
		do
			across coord_list as coordinate loop
				if a_coordinate.same_as (coordinate.item) then
					Result := True
				end
			end
		end

	debug_out: STRING
		do
			create Result.make_empty

			across coord_list as coordinate loop
				Result.append (coordinate.item.out)
				Result.append ("->"+coord_status_list.item (coordinate.cursor_index).out)

				if coordinate.cursor_index < coord_list.count then
					Result.append (";")
				end
			end
		end

	out: STRING
		do
			create Result.make_empty

			Result.append ("ship_coordinates: ")

			across coord_list as coordinate loop
				Result.append (coordinate.item.out+", ")
			end
			Result.append ("%N size "+ship_size.out+" ")

			if direction = True then
				Result.append("vertical ")
			else
				Result.append("horizontal ")
			end

			Result.append ("hit_points: "+hit_points.out)
		end

invariant
	valid_hit_points: hit_points >= 0
end
