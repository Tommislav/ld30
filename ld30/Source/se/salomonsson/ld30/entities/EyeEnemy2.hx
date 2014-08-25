package se.salomonsson.ld30.entities;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

/**
 * ...
 * @author Tommislav
 */
class EyeEnemy2 extends EyeEnemy
{
	private var _speed:Float = 0;
	private var _angle:Float;
	private var _chasing:Bool;
	private var _triggerDistance:Float;
	private var _chaseCooldown:Int;
	var _chasePause:Int;
	
	public function new(x:Float, y:Float, triggerDist:Float, maxMoney:Int) 
	{
		super(x, y, maxMoney);
		_triggerDistance = triggerDist;
	}
	
	override public function update():Void 
	{
		super.update();
		var player:Entity = HXP.scene.getInstance("player");
		if (distanceFrom(player, true) < _triggerDistance) {
			if (!_chasing) {
				_angle = Math.atan2(centerY - player.centerY, player.centerX - centerX);
				_angle = _angle / Math.PI * 180;
			}
			
			_chasing = true;
			_chaseCooldown = Std.int(Math.random() * 40 + 20);
		} else {
			if (--_chaseCooldown <= 0) {
				_chasing = false;
			}
		}
	}
	
	override private function updatePhysics() 
	{
		if (--_chasePause > 0) {
			return;
		}
		
		if (_chasing) {
			moveAtAngle(_angle, 4, "solid");
		}
	}
	
	override private function onAttacked(e:Entity) 
	{
		super.onAttacked(e);
		_chasePause = 30;
	}
}