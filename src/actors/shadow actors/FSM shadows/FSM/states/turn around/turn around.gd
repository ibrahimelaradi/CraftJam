extends "res://addons/net.kivano.fsm/content/FSMState.gd";
################################### R E A D M E ##################################
# For more informations check script attached to FSM node
#
#

##################################################################################
#####  Variables (Constants, Export Variables, Node Vars, Normal variables)  #####
######################### var myvar setget myvar_set,myvar_get ###################
var distance = 0

signal idle
signal detected

onready var vision = get_node("../../../detectors/vision")
onready var sense = get_node("../../../detectors/sense")
##################################################################################
#########                       Getters and Setters                      #########
##################################################################################
#you will want to use those
func getFSM(): return fsm; #defined in parent class
func getLogicRoot(): return logicRoot; #defined in parent class 

##################################################################################
#########                 Implement those below ancestor                 #########
##################################################################################
#you can transmit parameters if fsm is initialized manually
func stateInit(inParam1=null,inParam2=null,inParam3=null,inParam4=null, inParam5=null): 
	pass

#when entering state, usually you will want to reset internal state here somehow
func enter(fromStateID=null, fromTransitionID=null, inArg0=null,inArg1=null, inArg2=null):
	print('turn around state')
	if getLogicRoot().position.y > getLogicRoot().environment.get_player().position.y:
		getLogicRoot().vision.look_at(Vector2(getLogicRoot().environment.get_player().position.x,getLogicRoot().environment.get_player().position.y-8))
		turn_around()
	else:
		getLogicRoot().velocity.x = 0
		var timer = Timer.new()
		timer.connect("timeout",self,"turn_around")
		timer.set_wait_time(1)
		timer.set_one_shot(true)
		add_child(timer)
		timer.start()
	
	
	pass

#when updating state, paramx can be used only if updating fsm manually
func update(deltaTime, param0=null, param1=null, param2=null, param3=null, param4=null):
	
	
	
	
	pass

#when exiting state
func exit(toState=null):
	pass

##################################################################################
#########                       Connected Signals                        #########
##################################################################################

##################################################################################
#########     Methods fired because of events (usually via Groups interface)  ####
##################################################################################

##################################################################################
#########                         Public Methods                         #########
##################################################################################
func turn_around():
	if not (vision.is_colliding() and vision.get_collider().is_in_group("player")):
		if getLogicRoot().sprite().flip_h:
			getLogicRoot().look_right()
		else:
			getLogicRoot().look_left()
	if (vision.is_colliding() and vision.get_collider().is_in_group("player")):
		emit_signal("detected")
	else:
		emit_signal("idle")
		
		pass
##################################################################################
#########                         Inner Methods                          #########
##################################################################################

##################################################################################
#########                         Inner Classes                          #########
##################################################################################