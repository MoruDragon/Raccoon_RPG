@tool
class_name Util
extends Node


static func get_save_data_variables() -> PackedStringArray:
	var valid_vars: PackedStringArray = []
	
	for prop: Dictionary in (SaveData as Script).get_script_property_list():
		if prop.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			valid_vars.append(prop.name)
			
	return valid_vars
