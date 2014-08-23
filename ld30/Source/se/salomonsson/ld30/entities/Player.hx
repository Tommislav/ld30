package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.utils.Input;
import flash.geom.Point;
import se.salomonsson.ld30.behaviours.IBehaviour;
import se.salomonsson.ld30.behaviours.UpdatePosBehaviour;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class Player extends Entity
{
	public static var CTRL_LEFT:String = "left";
	public static var CTRL_RIGHT:String = "right";
	public static var CTRL_UP:String = "up";
	public static var CTRL_DOWN:String = "down";
	public static var CTRL_ATK:String = "attack";
	public static var CTRL_DASH_LEFT:String = "dashLeft";
	public static var CTRL_DASH_RIGHT:String = "dashRight";
	
	
	private var _velocity:Point;
	private var _maxVelocity:Point;
	private var _behaviours:Array<IBehaviour>;
	
	public function new(x:Float, y:Float) 
	{
		super(x, y);
		
		
		this.graphic = GraphicsFactory.getPlayerGraphic();
		this.setHitbox(32, 32);
		
		_velocity = new Point();
		_maxVelocity = new Point();
		_maxVelocity.x = GameData.instance.maxSpeed;
		_maxVelocity.y = GameData.instance.maxFall;
		
		_behaviours = new Array<IBehaviour>();
		_behaviours.push(new UpdatePosBehaviour(_velocity, _maxVelocity));
	}
	
	override public function update():Void 
	{
		super.update();
		
		updateFromInput();
		updateBehaviours();
		
		
		
	}
	
	
	
	function updateFromInput() {
		var isMoving:Bool = false;
		var gd:GameData = GameData.instance;
		
		if (Input.check(CTRL_LEFT)) {
			isMoving = true;
			_velocity.x -= gd.moveSpeed;
		}
		if (Input.check(CTRL_RIGHT)) {
			isMoving = true;
			_velocity.x += gd.moveSpeed;
		}
		if (!isMoving) {
			// apply friction
			_velocity.x *= gd.moveFriction;
			if (_velocity.x < 0.1 && _velocity.x > -0.1) {
				_velocity.x = 0;
			}
		}
	}
	
	function updateBehaviours() {
		for (b in _behaviours) {
			b.update(this);
		}
	}
}