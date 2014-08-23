package se.salomonsson.ld30.behaviours;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import flash.geom.Point;

/**
 * ...
 * @author Tommislav
 */
class UpdatePosBehaviour implements IBehaviour
{
	private var _velocityRef:Point;
	private var _maxVelocity:Point;
	
	private var _gravity:Int = 1;
	
	public function new(velRef:Point, maxVelocity:Point) {
		_velocityRef = velRef;
		_maxVelocity = maxVelocity;
	}
	
	
	public function update(e:Entity):Void {
		
		_velocityRef.y += _gravity;
		
		_velocityRef.x = HXP.clamp(_velocityRef.x, -_maxVelocity.x, _maxVelocity.x);
		_velocityRef.y = HXP.clamp(_velocityRef.y, -_maxVelocity.y, _maxVelocity.y);
		
		var shoudSweep = (_velocityRef.x < -16 || _velocityRef.x > 16 || _velocityRef.y < -16 || _velocityRef.y > 16);
		
		e.moveBy(_velocityRef.x, _velocityRef.y, ["solid", "cloud"], shoudSweep);
		
		
	}
	
}