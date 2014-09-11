package se.salomonsson.ld30.b;

import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;
import flash.geom.Point;
import se.salomonsson.ld30.entities.EnemyBase;

/**
 * ...
 * @author Tommislav
 */
class PatrolBehaviour extends Behavior
{
	var _minX:Float;
	var _maxX:Float;
	var _e:EnemyBase;

	public function new(e:EnemyBase, minX:Float, maxX:Float) 
	{
		super();
		_e = e;
		_maxX = maxX;
		_minX = minX;
	}
	
	override private function update(context:Dynamic):BehaviorStatus {
		var dir:Int = _e.getProps()._dirX;
		var vel:Point = _e.getProps()._velocity;
		var max:Point = _e.getProps()._maxVelocity;
		
		var beforeX:Float = _e.x;
		
		if (dir < 0) {
			_e.moveBy( -2, 0, "solid");
			
			if (_e.x < _minX) _e.x = _minX;
			if (_e.x == _minX || _e.x == beforeX) {
				_e.setDirX(1);
			}
		} 
		else if (dir > 0) {
			_e.moveBy( 2, 0, "solid");
			
			if (_e.x > _maxX) _e.x = _maxX;
			if (_e.x == _maxX || _e.x == beforeX) {
				_e.setDirX(-1);
			}
		}
		
		return BehaviorStatus.Success;
	}
}