extends Node2D
class_name BaseComponent

signal was_enabled
signal was_disabled

@export_category("BaseComponent")

@export var enabled: bool = true:
    set(_enabled):
        var previous_state: bool = enabled
        enabled = _enabled

        if (previous_state != enabled):
            if (enabled):
                was_enabled.emit()
            else:
                was_disabled.emit()

func set_enabled(val: bool):
    enabled = val

func is_enabled():
    return enabled

# Returns a nice smoothed value independent of frame rate.
func _smoothed(value: float, delta: float) -> float:
    return 1.0 - exp(-delta * value)