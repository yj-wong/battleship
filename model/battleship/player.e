note
	description: "Summary description for {PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	ANY
	redefine
		out
	end

create
	make_empty, make_level, make_costume

feature --attributes
	shots: INTEGER
	bombs: INTEGER
	score: INTEGER

	total_shots: INTEGER
	total_bombs: INTEGER
	total_score: INTEGER

feature --constructors
	make_empty
		do
			shots := 0
			bombs := 0
			score := 0

			total_shots := 0
			total_bombs := 0
			total_score := 0
		end

	make_level (a_level: INTEGER_64; a_total_score: INTEGER)
		do
			score := 0
			total_score := a_total_score
			shots := 0
			bombs := 0

			if a_level = 13 then
				total_shots := 8
				total_bombs := 2
			elseif a_level = 14 then
				total_shots := 16
				total_bombs := 3
			elseif a_level = 15 then
				total_shots := 24
				total_bombs := 5
			elseif a_level = 16 then
				total_shots := 40
				total_bombs := 7
			end
		end

	-- new made by Joseph
	make_costume(number_shots: INTEGER_64; number_bombs: INTEGER_64; number_ships: INTEGER_64; a_total_score: INTEGER)
		do
			score := 0
			total_score := a_total_score
			shots := 0
			bombs := 0
			total_shots := number_shots.as_integer_32
			total_bombs := number_bombs.as_integer_32
		end

feature --utilities
	use_shot
		do
			if shots < total_shots then
				shots := shots + 1
			end
		end

	use_bomb
		do
			if bombs < total_bombs then
				bombs := bombs + 1
			end
		end

	increment_score (a_ship_size: INTEGER)
		do
			score := score + a_ship_size
		end

	unuse_shot
		do
			if shots > 0 then
				shots := shots - 1
			end
		end

	unuse_bomb
		do
			if bombs > 0 then
				bombs := bombs - 1
			end
		end

	decrement_score (a_ship_size: INTEGER)
		do
			score := score - a_ship_size
		end

feature --queries		
	has_shots: BOOLEAN
		do
			Result := shots < total_shots
		end

	has_bombs: BOOLEAN
		do
			Result := bombs < total_bombs
		end

	out: STRING
		do
			create Result.make_from_string ("")
			Result.append ("  Shots: "+shots.out+"/"+total_shots.out+"%N")
			Result.append ("  Bombs: "+bombs.out+"/"+total_bombs.out+"%N")
			Result.append ("  Score: "+score.out+"/"+total_score.out)
		end

invariant
	valid_shot_number: shots >= 0 and shots <= total_shots
	valid_bomb_number: bombs >= 0 and bombs <= total_bombs
	valid_score_number: score >= 0 and score <= total_score
end
