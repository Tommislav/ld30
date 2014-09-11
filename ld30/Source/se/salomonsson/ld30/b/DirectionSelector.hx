package se.salomonsson.ld30.b;

import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;
import se.salomonsson.ld30.entities.EnemyBase;

/**
 * ...
 * @author Tommislav
 */
class DirectionSelector extends Behavior
{
	private var _entity:EnemyBase;
	private var _x:Int;
	private var _y:Int;
	
	public function new(e:EnemyBase) {
		super();
		_entity = e;
	}
	
	public function facingLeft():Behavior {
		_x = -1;
		return this;
	}
	
	public function facingRight():Behavior {
		_x = 1;
		return this;
	}
	
	public function facingUp():Behavior {
		_y = -1;
		return this;
	}
	
	public function facingDown():Behavior {
		_y = 1;
		return this;
	}
	
	override private function update(context:Dynamic):BehaviorStatus {
		var prop = _entity.getProps();
		var xMatch = true;
		var yMatch = true;
		if (_x != 0) {
			if ((_x < 0 && prop._dirX > 0) || _x > 0 && prop._dirX < 0) { xMatch = false; }
		}
		if (_y != 0) {
			if ((_y < 0 && prop._dirY > 0) || (_y > 0 && prop._dirY < 0)) { yMatch = false; }
		}
		
		return (xMatch && yMatch) ? BehaviorStatus.Success : BehaviorStatus.Failure;
	}
	
}