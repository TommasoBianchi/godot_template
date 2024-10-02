extends TextEdit

func _ready() -> void:
	text = Config.get_config(Config.ConfigSectionName.OPTIONS_GAME, "the_text", "Modify me")

func _on_text_changed() -> void:
	Config.set_config(Config.ConfigSectionName.OPTIONS_GAME, "the_text", text)
