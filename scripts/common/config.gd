## Interface for a single configuration file through [ConfigFile].
## Adapted from https://github.com/Maaack/Godot-Game-Template/blob/9405579ab33e6b7acf037648775bc500e08493b6/addons/maaacks_game_template/base/scripts/config.gd

class_name Config
extends Node

const CONFIG_FILE_LOCATION := "user://config.cfg"
const DEFAULT_CONFIG_FILE_LOCATION := "res://default_config.cfg"

enum ConfigSectionName {
	OPTIONS_AUDIO,
	OPTIONS_GRAPHICS,
	OPTIONS_GAME
}

static var config_file : ConfigFile

static func _init():
	load_config_file()

static func _save_config_file() -> void:
	var save_error : int = config_file.save(CONFIG_FILE_LOCATION)
	if save_error:
		printerr("[Config] Save config file failed with error %d" % save_error)

static func load_config_file() -> void:
	if config_file != null:
		return
	config_file = ConfigFile.new()
	var load_error : int = config_file.load(CONFIG_FILE_LOCATION)
	if load_error:
		var load_default_error : int = config_file.load(DEFAULT_CONFIG_FILE_LOCATION)
		if load_default_error:
			printerr("[Config] Loading default config file failed with error %d" % load_default_error)
		var save_error : int = config_file.save(CONFIG_FILE_LOCATION)
		if save_error:
			printerr("[Config] Save config file failed with error %d" % save_error)

static func set_config(section: ConfigSectionName, key: String, value) -> void:
	load_config_file()
	var section_name = ConfigSectionName.find_key(section)
	config_file.set_value(section_name, key, value)
	_save_config_file()

static func get_config(section: ConfigSectionName, key: String, default = null) -> Variant:
	load_config_file()
	var section_name = ConfigSectionName.find_key(section)
	return config_file.get_value(section_name, key, default)

static func has_section(section: ConfigSectionName):
	load_config_file()
	var section_name = ConfigSectionName.find_key(section)
	return config_file.has_section(section_name)

static func has_section_key(section: ConfigSectionName, key: String):
	load_config_file()
	var section_name = ConfigSectionName.find_key(section)
	return config_file.has_section_key(section_name, key)

static func erase_section(section: ConfigSectionName):
	if has_section(section):
		var section_name = ConfigSectionName.find_key(section)
		config_file.erase_section(section_name)
		_save_config_file()

static func erase_section_key(section: ConfigSectionName, key: String):
	if has_section_key(section, key):
		var section_name = ConfigSectionName.find_key(section)
		config_file.erase_section_key(section_name, key)
		_save_config_file()

static func get_section_keys(section: ConfigSectionName):
	load_config_file()
	var section_name = ConfigSectionName.find_key(section)
	if config_file.has_section(section_name):
		return config_file.get_section_keys(section_name)
	return []
