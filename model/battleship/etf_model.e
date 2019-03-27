 	 note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create e.make_from_string ("OK")
			create s1.make_from_string ("Start a new game")
			create s2.make_empty
			create state_message.make_empty
			i := 0
			create board.make_empty
			create gen.make_debug
			create history.make
		end

feature -- game_message
	e: STRING
	s1: STRING
	s2: STRING
	i: INTEGER
	state_message: STRING

feature -- game_status
	debug_mode: BOOLEAN
	game_iteration: INTEGER
	game_started: BOOLEAN
	did_give_up: BOOLEAN -- status if user did give up before
	game_iteration_before: INTEGER
	has_fired: BOOLEAN

feature -- score_keeping
	grand_total_score: INTEGER
	cumulative_score: INTEGER

	-- new made by Joseph
	prev_grand_total_score:INTEGER -- save prev grand_total_score

feature -- game_objects
	board: BOARD
	gen: RANDOM_GENERATOR
	history: HISTORY

feature -- model updates
	set_e (message: STRING)
		do
			e:= message
		end

	set_s1 (message: STRING)
		do
			s1:= message
		end

	set_s2 (message: STRING)
		do
			s2 := message
		end

	set_state_message (state: INTEGER)
		do
--			-- clear state message if state is -1

--			if state = -1 then
--				state_message := ""
--			end
--			
			state_message := "(= state " + state.out + ") "
		end

	reset_game_message
		do
			create e.make_empty
			create s1.make_empty
			create s2.make_empty
			create state_message.make_empty
		end

	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	set_fired
		do
			has_fired := True
		end

feature -- model operations
	reset
			-- Reset model state.
		do
			game_iteration := 0
			has_fired := False
			grand_total_score := 0
			cumulative_score := 0
			create board.make_empty
			create history.make
			create gen.make_debug
		end

	give_up
		do
			e := "OK"
			s2 := ""
			s1 := "You gave up!"
			did_give_up:= True
			game_started := False
		end

	-- new made by Joseph (underconstruction)
	custom_setup(dimension: INTEGER_64 ; ships: INTEGER_64 ; max_shots: INTEGER_64 ; num_bombs: INTEGER_64; a_debug_mode: BOOLEAN)
		do
			if dimension > ships and ships <= 7 and ships >=1 and max_shots <= 144 and max_shots >= 1 and num_bombs <= 7 and num_bombs >= 1 then
				create history.make
				check_if_user_did_give_up
				debug_mode := a_debug_mode
				game_iteration := game_iteration + 1
				game_started := True
				e := "OK"
				s2 := ""
				s1 := "Fire Away!"

				cumulative_score := cumulative_score + board.player.score

				board.make_custom_level (ships, gen, dimension, max_shots, num_bombs, debug_mode)

				if debug_mode = True then
					board.show_ships
				end

				grand_total_score := grand_total_score + board.player.total_score
			elseif dimension <= ships then
				e := "Too many ships"
				s2 := ""
				s1 := "Start a new game"
			elseif ships > 7 then
				e := "Too many ships"
				s2 := ""
				s1 := "Start a new game"
			elseif ships < 1 then
				e := "Not enough ships"
				s2 := ""
				s1 := "Start a new game"
			elseif max_shots > 144 then
				e := "Too many shots"
				s2 := ""
				s1 := "Start a new game"
			elseif max_shots < 1 then
				e := "Not enough shots"
				s2 := ""
				s1 := "Start a new game"
			elseif num_bombs > 7 then
				e := "Too many bombs"
				s2 := ""
				s1 := "Start a new game"
			elseif num_bombs < 1 then
				e := "Not enough bombs"
				s2 := ""
				s1 := "Start a new game"
			end
		end

	new_game (a_debug_mode: BOOLEAN; a_level: INTEGER_64)
		do
			-- new made by Joseph
			create history.make
			check_if_user_did_give_up

			debug_mode := a_debug_mode
			game_iteration := game_iteration + 1
			game_started := True
			e := "OK"
			s2 := ""
			s1 := "Fire Away!"
			cumulative_score := cumulative_score + board.player.score

			board.make_level (a_level, a_debug_mode, gen)

			if debug_mode = True then
				board.show_ships
			end

			grand_total_score := grand_total_score + board.player.total_score
		end

feature --utilities
	game_started_error
		do
			e := "Game already started"
			s2 := ""
		end

	game_not_started_error
		do
			e := "Game not started"
			s1 := "Start a new game"
			s2 := ""
		end

	check_game_status
		do
			if board.ship_list.unsunken_ships = 0 then
				game_started := False
				s1 := "You Win!"
			elseif not board.player.has_shots and not board.player.has_bombs then
				game_started := False
				s1 := "Game Over!"
			end
		end

	check_if_user_did_give_up
		do
			if did_give_up ~ True then
				grand_total_score := prev_grand_total_score
				did_give_up := False
				game_iteration:= game_iteration_before
			else
				prev_grand_total_score := grand_total_score
				game_iteration_before := game_iteration
			end
		end

feature -- queries
	cumulative_score_details: STRING
		local
			display_score: INTEGER
		do
			display_score := cumulative_score + board.player.score
			create Result.make_empty
			Result.append ("(Total: "+display_score.out+"/"+grand_total_score.out+")")
		end

	debug_details: STRING
		do
			create Result.make_from_string("%N")
			Result.append ("  Current Game (debug)")
			Result.append (": "+game_iteration.out)
			Result.append ("%N"+board.player.out)
			Result.append (" "+cumulative_score_details)
			Result.append ("%N"+board.ship_list.debug_out)
		end

	details: STRING
		do
			create Result.make_from_string("%N")
			Result.append ("  Current Game")
			Result.append (": "+game_iteration.out)
			Result.append ("%N"+board.player.out)
			Result.append (" "+cumulative_score_details)
			Result.append ("%N"+board.ship_list.out)
		end

	out: STRING
		local
		do
			create Result.make_empty
			Result.append ("  state " + i.out + " ")
			Result.append (state_message)
			Result.append (e + " -> " + s2 + s1)

			if i > 0 and board.board_size > 0 then
				Result.append (board.out)

				if debug_mode = True then
					Result.append (debug_details)
				else
					Result.append (details)
				end
				Result.append ("%N" + history.out)
			end
		end
end




