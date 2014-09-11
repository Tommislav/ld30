package se.salomonsson.ld30.b;
import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import se.salomonsson.ld30.EntityType;

/**
 * ...
 * @author Tommislav
 */
class WithinDistanceSelector extends Behavior
{
	private var _me:Entity;
	private var _other:Entity;
	private var _distance:Float;
	
	public function new(me:Entity, distance:Float) 
	{
		super();
		_me = me;
		_distance = distance;
	}
	
	override private function initialize():Void 
	{
		_other = HXP.scene.getInstance(EntityType.PLAYER);
	}
	
	override private function update(context:Dynamic):BehaviorStatus 
	{
		var f = HXP.distance(_me.centerX, _me.centerY, _other.centerX, _other.centerY);
		if (f < _distance) {
			return BehaviorStatus.Success;
		}
		
		return BehaviorStatus.Failure;
	}
	
}