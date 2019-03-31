note
	description: "Summary description for {GAME_MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_MESSAGE

create
	make

feature {NONE} -- attributes
	state_message: STRING
	error: STRING
	fire_status: STRING
	game_status: STRING
	has_fired: BOOLEAN
	debug_output: STRING

feature -- constructor
	make
		do
			create error.make_from_string ("OK")
			create game_status.make_from_string ("Start a new game")
			create fire_status.make_empty
			create state_message.make_empty
			create debug_output.make_empty
			has_fired := False
		end

feature -- commands
	set_has_fired
		do
			has_fired := True
		end

	set_state_message (a_state: INTEGER)
		do
			state_message := "(= state " + a_state.out + ") "
		end

	reset_game_message
		do
			clear_game_message
			set_error ("OK")
			set_fire_status ("")
			reset_game_status
		end

	reset_game_status
		do
			if has_fired then
				set_game_status ("Keep Firing!")
			else
				set_game_status ("Fire Away!")
			end
		end

	set_debug_output (message: STRING)
		do
			debug_output := "%N" + message
		end

feature {NONE} -- helper commands
	set_error (message: STRING)
		do
			error:= message
		end

	set_game_status (message: STRING)
		do
			game_status:= message
		end

	set_fire_status (message: STRING)
		do
			fire_status := message
		end

	clear_game_message
		do
			create error.make_empty
			create game_status.make_empty
			create fire_status.make_empty
			create state_message.make_empty
			create debug_output.make_empty
		end

feature -- game_start_messages
	new_game
		do
			has_fired := False
			reset_game_message
		end

	game_started_error
		do
			set_error ("Game already started")
			if has_fired = True then
				set_game_status ("Keep Firing!")
			else
				set_game_status ("Fire Away!")
			end
			fire_status := ""
		end

	game_not_started_error
		do
			set_error ("Game not started")
			set_game_status ("Start a new game")
			set_fire_status ("")
		end

feature -- game_end_message
	game_win
		do
			set_game_status ("You Win!")
		end

	game_over
		do
			set_game_status ("Game Over!")
		end

	give_up
		do
			reset_game_message
			set_game_status ("You gave up!")
		end

feature -- custom_setup_messages
	too_many_ships
		do
			set_error ("Too many ships")
		end

	not_enough_ships
		do
			set_error ("Not enough ships")
		end

	too_many_shots
		do
			set_error ("Too many shots")
		end

	not_enough_shots
		do
			set_error ("Not enough shots")
		end

	too_many_bombs
		do
			set_error ("Too many bombs")
		end

	not_enough_bombs
		do
			set_error ("Not enough bombs")
		end

feature -- fire_bomb_errors
	no_shots
		do
			set_error ("No shots remaining")
		end

	no_bombs
		do
			set_error ("No bombs remaining")
		end

	invalid_coordinate
		do
			set_error ("Invalid coordinate")
		end

	already_fired
		do
			set_error ("Already fired there")
		end

	bomb_not_adjacent
		do
			set_error ("Bomb coordinates must be adjacent")
		end

feature -- fire_bomb_status
	ship_hit
		do
			set_fire_status ("Hit! ")
		end

	ship_miss
		do
			set_fire_status ("Miss! ")
		end

	ship_sunk (a_ship_size: INTEGER)
		do
			set_fire_status (a_ship_size.out + "x1 ship sunk! ")
		end

	double_ship_sunk (a_ship_size1: INTEGER; a_ship_size2: INTEGER)
		do
			set_fire_status (a_ship_size1.out + "x1 and " + a_ship_size2.out + "x1 ships sunk! ")
		end

feature -- undo_redo_messages
	no_undo
		do
			set_error ("Nothing to undo")
		end

	no_redo
		do
			set_error ("Nothing to redo")
		end

feature -- queries
	get_state_message: STRING
		do
			Result := state_message
		end

	get_error: STRING
		do
			Result := error
		end

	get_game_status: STRING
		do
			Result := game_status
		end

	get_fire_status: STRING
		do
			Result := fire_status
		end

	get_game_message: STRING
		do
			create Result.make_from_string (state_message)
			Result.append (error)
			Result.append (" -> ")
			Result.append (fire_status)
			Result.append (game_status)
			Result.append (debug_output)
		end

end
