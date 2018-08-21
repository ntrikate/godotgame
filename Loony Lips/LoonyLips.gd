extends Node2D

var player_words = [] #the words the player chooses
var template = [
		{
		"prompt" : ["a name","a thing","a feeling", "another name", "another thing", "a place"],
		"story" : ("Once upon a time %s ate a %s and felt very %s. But %s wanted a %s so they went to the %s.")
		},
		{
		"prompt" : ["a number","things","a feeling", "a verb", "a description", "a thing"],
		"story" : ("Once upon a time, in a world far away there were %s %s. They were so %s, they %s %s %s.")
		}
		]
var current_story

func _ready():
	randomize()
	current_story = template[randi() % template.size()]
	$Blackboard/TextBox.text = ""
	prompt_player()
	
func _on_TextureButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		var new_text = $Blackboard/TextBox.get_text()
		_on_TextBox_text_entered(new_text)
	

func _on_TextBox_text_entered(new_text):
	player_words.append(new_text)
	$Blackboard/TextBox.text = ""
	check_player_word_length()

func is_story_done():
	return player_words.size() == current_story.prompt.size()
	
func prompt_player():
	if player_words.size() == 0:
		$Blackboard/StoryText.text = "Welcome to Loony Lips!  When prompted type a word in the box.\nCan I have " + current_story.prompt[player_words.size()] + ", please."
	else:
		$Blackboard/StoryText.text = ("Can I have " + current_story.prompt[player_words.size()] + ", please.")

func check_player_word_length():
	if is_story_done():
		tell_story()
	else:
		prompt_player()

func tell_story():
	$Blackboard/StoryText.text = current_story.story % player_words
	end_game()

func end_game():
	$Blackboard/TextBox.queue_free()  #removes the text input box
	$Blackboard/TextureButton/ButtonLabel.text = "Again!"