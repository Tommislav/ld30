package se.salomonsson.ld30.b;

import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;
import flash.geom.Point;

/**
 * ...
 * @author Tommislav
 */
class PositionEntityBehaviour extends Behavior
{
	private var _p:Point;
	private var _left:Point;
	private var _right:Point;

	public function new(p:Point, left:Point, right:Point) {
		_p = p;
		_left = left;
		_right = right;
		super();
	}
	
	override private function initialize():Void {
		super.initialize();
	}
	
	override private function terminate(status:BehaviorStatus):Void  {
		super.terminate(status);
	}
	
	override public function tick(?context:Dynamic):BehaviorStatus {
		_p.x = _right.x;
		_p.y = _right.y;
		return BehaviorStatus.Success;
	}
	
}