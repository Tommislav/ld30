package se.salomonsson.ld30.b;

import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;
import com.haxepunk.HXP;

/**
 * ...
 * @author Tommislav
 */
class ShakeCameraBehaviour extends Behavior
{
	private var _shakeX:Float;
	private var _shakeY:Float;
	private var _count:Int;
	private var _smooth:Float;

	public function new(shakeX:Float, shakeY:Float, count:Int, smooth:Float=1.0) {
		super();
		
		_shakeX = shakeX;
		_shakeY = shakeY;
		_count = count;
		_smooth = smooth;
	}
	
	override private function update(context:Dynamic):BehaviorStatus {
		HXP.camera.shake(_shakeX, _shakeY, _count, _smooth);
		return BehaviorStatus.Success;
	}
	
	
}