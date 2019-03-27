note
	description: "Summary description for {COORDINATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COORDINATE

inherit
	any
	redefine
		out
	end

create
	make, make_from_tuple

feature --attributes
	row: INTEGER
	col: INTEGER

feature --constructors
	make (a_row: INTEGER; a_col: INTEGER)
		do
			row := a_row
			col := a_col
		end
	make_from_tuple (a_coordinate: TUPLE[row: INTEGER_64; column: INTEGER_64])
		do
			row := a_coordinate.row.as_integer_32
			col := a_coordinate.column.as_integer_32
		end

feature --utilities
	same_as (a_coordinate: COORDINATE): BOOLEAN
		do
			Result := a_coordinate.row = Current.row and a_coordinate.col = Current.col
		end

	adjacent_to (a_coordinate: COORDINATE): BOOLEAN
		do
			if a_coordinate.row = Current.row + 1 or a_coordinate.row = Current.row - 1 then
				Result := True
			elseif a_coordinate.col = Current.col + 1 or a_coordinate.col = Current.col - 1 then
				Result := True
			end
		end

	row_to_alphabet: CHARACTER
		local
			ascii_int: INTEGER
		do
			ascii_int := row + 64
			Result := ascii_int.to_character_8
		end

feature --queries
	details: STRING
		do
			create Result.make_empty
			Result.append ("row: "+row.out+" ")
			Result.append ("col: "+col.out+" ")
		end

	out: STRING
		do
			create Result.make_from_string ("[")
			Result.append (row_to_alphabet.out+", ")
			Result.append (col.out+"]")
		end

invariant
	valid_coordinates:
		row > 0 and col > 0
end
