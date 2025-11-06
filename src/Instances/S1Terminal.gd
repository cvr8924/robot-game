extends "res://src/UI/dialogue_area.gd"



func additional_triggers():
	if Flags.flag_dictionary[flag_key] == 0:
		Flags.flag_dictionary[flag_key] = 1
		dialog_key = "S1TerminalUsed"
	
