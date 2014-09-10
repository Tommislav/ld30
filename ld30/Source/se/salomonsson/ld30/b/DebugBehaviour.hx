package se.salomonsson.ld30.b;

import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;
import com.haxepunk.Entity;
import com.haxepunk.Tween;

/**
 * ...
 * @author Tommislav
 */
class DebugBehaviour extends Behavior
{

	public function new() {
		super();
	}
	
	override private function initialize():Void { 
		trace("initialize()");
	}
	
	override private function terminate(status:BehaviorStatus):Void { 
		trace("terminate() with status: " + status);
	}
	
	override private function update(context:Dynamic):BehaviorStatus { 
		trace("update with context: " + context);
		return BehaviorStatus.Success; 
	}
}