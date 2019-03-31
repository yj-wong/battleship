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
		do
			create game_message.make
			i := 0
			create board.make_empty
			create gen.make_debug
			create history.make
		end

feature -- game_message
	game_message: GAME_MESSAGE
	i: INTEGER
	initial_i: INTEGER

feature -- game_status
	debug_mode: BOOLEAN
	game_iteration: INTEGER
	game_started: BOOLEAN
	did_give_up: BOOLEAN -- status if user did give up before
	game_iteration_before: INTEGER

feature -- score_keeping
	grand_total_score: INTEGER
	cumulative_score: INTEGER
	prev_grand_total_score: INTEGER -- save prev grand_total_score

feature -- game_objects
	board: BOARD
	gen: RANDOM_GENERATOR
	history: HISTORY

feature -- model updates
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

feature -- model operations
	reset
			-- Reset model state.
		do
			game_iteration := 0
			grand_total_score := 0
			cumulative_score := 0
			create game_message.make
			create board.make_empty
			create history.make
			create gen.make_debug
		end

	soft_reset (a_debug_mode: BOOLEAN)
			-- Reset for new game.
		do
			check_if_user_did_give_up
			debug_mode := a_debug_mode
			game_iteration := game_iteration + 1
			initial_i := i
			game_started := True

			create history.make
			game_message.new_game

			cumulative_score := cumulative_score + board.player.score
		end

	give_up
		do
			game_message.give_up
			did_give_up:= True
			game_started := False
		end

	custom_setup(dimension: INTEGER_64 ; ships: INTEGER_64 ; max_shots: INTEGER_64 ; num_bombs: INTEGER_64; a_debug_mode: BOOLEAN)
		do
			if
				((dimension // 3) <= ships) and
				(ships <= (dimension // 2) + 1) and
				((2 * dimension) <= max_shots) and
				max_shots <= 144 and
				max_shots >= 1 and
				num_bombs <= 7 and
				num_bombs >= 1
			then
				soft_reset (a_debug_mode)

				board.make_custom_level (ships, gen, dimension, max_shots, num_bombs, debug_mode)

				if debug_mode = True then
					board.show_ships
				end

				grand_total_score := grand_total_score + board.player.total_score

			elseif dimension <= ships then
				game_message.too_many_ships
			elseif ships > 7 then
				game_message.too_many_ships
			elseif ships < 1 then
				game_message.not_enough_ships
			elseif max_shots > 144 then
				game_message.too_many_shots
			elseif max_shots < 1 then
				game_message.not_enough_shots
			elseif num_bombs > 7 then
				game_message.too_many_bombs
			elseif num_bombs < 1 then
				game_message.not_enough_bombs
			end
		end

	new_game (a_debug_mode: BOOLEAN; a_level: INTEGER_64)
		do
			soft_reset (a_debug_mode)

			board.make_level (a_level, a_debug_mode, gen)

			if debug_mode = True then
				board.show_ships
			end

			grand_total_score := grand_total_score + board.player.total_score
		end

feature --utilities
	check_game_status
		do
			if board.ship_list.unsunken_ships = 0 then
				game_started := False
				game_message.game_win
			elseif not board.player.has_shots and not board.player.has_bombs then
				game_started := False
				game_message.game_over
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
			Result.append (game_message.get_game_message)

			if i > 0 and board.board_size > 0 then
				Result.append (board.out)

				if debug_mode = True then
					Result.append (debug_details)
				else
					Result.append (details)
				end
--				Result.append ("%N" + history.out)
			end
		end
end




