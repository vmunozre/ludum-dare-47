extends CanvasLayer

signal introduction_finished

export var time_fadein = 2.0;
export var time_fadein_button = 1.5;
export var time_next_slide = 1.5;

var current_index_carousel_item = 0
var n_carousel_items
var is_shown_buttons_progressively = false
# Called when the node enters the scene tree for the first time.
func _ready():
        $Tween.interpolate_property($Carousel, "modulate",
        Color(1, 1, 1, 0), Color(1, 1, 1, 1), time_fadein,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        $Tween.start()
        disable_buttons()

func create_carousel(images):
        n_carousel_items = images.size()
        for i in images.size():
                var new_carousel_item = TextureRect.new()
                new_carousel_item.texture = images[i]
                new_carousel_item.rect_position = Vector2(1920 * i, 0)
                new_carousel_item.rect_size = Vector2(1920, 1080)
                $Carousel.add_child(new_carousel_item)
                
func move_one_forward():
        if (current_index_carousel_item + 1) >= n_carousel_items:
                emit_signal("introduction_finished")
                return
        current_index_carousel_item+=1
        disable_buttons()
        move_carousel()
        $Back.show()

func move_one_backwards():
        if (current_index_carousel_item - 1) < 0:
                return
        current_index_carousel_item-=1
        disable_buttons()
        move_carousel()
        if (current_index_carousel_item == 0):
                $Back.hide()
        
func move_carousel():
        $Tween.remove($Carousel, "rect_position")
        $Tween.interpolate_property($Carousel, "rect_position",
                null, Vector2(current_index_carousel_item * -1920, 0), time_next_slide,
                Tween.TRANS_QUART, Tween.EASE_IN_OUT)
        $Tween.start()
        
func enable_buttons():
        $Continue.disabled = false
        $Back.disabled = false
        $Skip.disabled = false

func disable_buttons():
        $Continue.disabled = true
        $Back.disabled = true
        $Skip.disabled = true

func _on_Tween_tween_all_completed():
        enable_buttons()


func _on_Back_pressed():
        move_one_backwards()


func _on_Continue_pressed():
        move_one_forward()


func _on_TimerStartIntroduction_timeout():
        $Tween.interpolate_property($Continue, "modulate",
        Color(1, 1, 1, 0), Color(1, 1, 1, 1), time_fadein_button,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        $Tween.interpolate_property($Skip, "modulate",
        Color(1, 1, 1, 0), Color(1, 1, 1, 1), time_fadein_button,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        $Tween.interpolate_property($Back, "modulate",
        Color(1, 1, 1, 0), Color(1, 1, 1, 1), time_fadein_button,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
        $Tween.start()
        move_one_forward()

func _on_Skip_pressed():
        emit_signal("introduction_finished")
