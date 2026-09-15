extends Node

var config: AppConfig = AppConfig.new()

@warning_ignore_start("unused_signal")
signal delete_timer(uid: String)
signal edit_timer(uid: String)
