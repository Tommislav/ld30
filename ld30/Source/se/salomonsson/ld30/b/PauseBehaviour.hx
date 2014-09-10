package se.salomonsson.ld30.b;

import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;

/**
 * ...
 * @author Tommislav
 */
class PauseBehaviour extends Behavior
{
	private var _waitTics:Int;
	private var _counter:Int;

	public function new(waitTicks:Int) {
		super();
		_waitTics = waitTicks;
	}
	
	override private function initialize():Void { 
		_counter = _waitTics;
	}
	
	override private function terminate(status:BehaviorStatus):Void { }
	
	override private function update(context:Dynamic):BehaviorStatus {
		if (--_counter <= 0) {
			return BehaviorStatus.Success;
		}
		return BehaviorStatus.Running;
	}
	
}