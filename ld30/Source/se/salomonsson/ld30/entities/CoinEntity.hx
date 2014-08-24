package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class CoinEntity extends EnemyBase
{
	private var _value:Int;
	private var _frame:Int;
	private var _gfx:DynamigGfxList;
	private var _isMoving:Bool;
	private var _life:Int;
	
	
	private var _pickupCounter:Int = 0;
	
	private static var frames:Array<Int> = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3];
	
	
	public function new(x:Float, y:Float, value:Int = 1, startMoving:Bool=false) 
	{
		_gfx = GraphicsFactory.getCoinGraphic();
		super(x, y, _gfx, 32, 32, 0, EntityType.COIN);
		setHitbox(24,32, 4, 0);
		_value = value;
		
		this.isAttackableByPlayer = false;
		
		if (startMoving) {
			_isMoving = true;
			_velocity.x = Math.random() * 12 - 6;
			_velocity.y = Math.random() * -4 - 3;
			_pickupCounter = 30;
			_life = 400 + Std.int(Math.random() * 60);
		}
	}
	
	
	override function checkCollisionWithPlayer() {
		if (_pickupCounter > 0) {
			_pickupCounter--;
			return;
		}
		
		var e:Entity = collide(EntityType.PLAYER, this.x, this.y);
		if (e != null) {
			// play coin sound
			emit("coin", 10, centerX, centerY, 10, 10);
			
			GameData.instance.money += 1;
			HXP.scene.remove(this);
		}
	}
	
	
	override public function update():Void 
	{
		super.update();
		var f:Int = (++_frame % frames.length);
		setFrame(frames[f]);
		
		if (_isMoving) {
			if (--_life < 100) {
				this.visible = (_life % 10 <= 5);
			}
			if (_life <= 0) {
				HXP.scene.remove(this);
			}
		}
	}
	
	function setFrame(f:Int) 
	{
		var c = _gfx.children;
		for (i in 0...c.length) {
			c[i].visible = (i == f);
		}
	}
	
	
	override private function updatePhysics() 
	{
		if (_isMoving) {
			if (_velocity.y < GameData.instance.maxFall) {
				
				var coinGravity:Float = 0.2;
				_velocity.y += coinGravity;
			}
			
			moveBy(_velocity.x, _velocity.y, ["solid", "cloud"], true);
			_velocity.x *= 0.99;
			_velocity.y *= 0.99;
			
			// Bounce up if on floor
			if (collideTypes(["solid", "cloud"], this.x, this.y + 1) != null) {
				_velocity.y = -_velocity.y;
				_velocity.y *= 0.8;
				_velocity.x *= 0.8;
			}
		}
	}
}