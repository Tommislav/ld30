package se.salomonsson.ld30.entities;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import flash.geom.Point;
import flash.geom.Rectangle;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;
import se.salomonsson.ld30.SoundFactory;

/**
 * ...
 * @author Tommislav
 */
class MooseBoss extends EnemyBase
{
	private var STATE_IDLE:Int = 0;
	private var STATE_RUN:Int = 1;
	private var STATE_JUMP:Int = 2;
	
	private var _gfx:DynamigGfxList;
	
	private var _closeEyesTimer:Int;
	private var _currentState:Int;
	
	
	private var _runTimer:Int;
	private var _runSpeed:Float;
	
	private var _jumpStr:Float;
	private var _originalY:Float;
	
	private var _idleTime:Int;
	
	
	public function new(x:Float, y:Float) 
	{
		_gfx = GraphicsFactory.getMooseGraphics();
		super(x, y, _gfx);
		
		setHitbox(256, 256);
		_hp = 10;
		_money = 20;
		
		setOpenEyes(true);
		_gfx.setFlipped(true);
		
		_velocity = new Point();
		_maxVelocity = new Point(32, 32);
		
	}
	
	override private function preUpdate() 
	{
		if (_closeEyesTimer > 0) {
			_closeEyesTimer--;
			if (_closeEyesTimer == 0) { setOpenEyes(true); };
		}
		
		
		// update state
		switch(_currentState) {
			case 0:
				updateIdle();
				return;
			case 1:
				updateRun();
				return;
			case 2:
				updateJump();
				return;
		}
	}
	
	override private function onAttacked(e:Entity){
		super.onAttacked(e);
		setOpenEyes(false);
		_closeEyesTimer = 50;
		
	}
	
	private function setOpenEyes(open:Bool) {
		_gfx.setGroupVisible("eyesClosed", !open);
		_gfx.setGroupVisible("eyesOpen", open);
	}
	
	override private function canBeAttacked(e:Entity):Bool 
	{
		return _closeEyesTimer == 0;
	}
	
	override private function isCollidableWithPlayer() 
	{
		return _closeEyesTimer == 0;
	}
	
	override private function onKilled() 
	{
		super.onKilled();
		SoundFactory.playBgLoop("8BitDreams");
	}
	
	
	
	
	private function setIdleState() {
		_velocity.setTo(0, 0);
		_idleTime = Std.int(Math.random() * 30 + 100);
		_currentState = STATE_IDLE;
	}
	
	private function updateJump() {
		if (collide("solid", this.x, this.y + 1) != null) {
			setIdleState();
		}
	}
	
	private function updateRun() {
		
		_runTimer--;
		
		if (_runTimer <= 0) {
			_velocity.x *= 0.8;
			if (_velocity.x < 0.5 && _velocity.x > -0.5) {
				setIdleState();
			}
		}
	}
	
	private function updateIdle() {
		
		if (_idleTime == 0) {
			
			var player:Entity = HXP.scene.getInstance(EntityType.PLAYER);
			var dir:Float = player.centerX < centerX ? -1 : 1;
			
			if (dir < 0) {
				_gfx.setFlipped(true);
			} else {
				_gfx.setFlipped(false);
			}
			
			var doWhat:Float = Math.random();
			
			var playerIsAbove:Bool = player.centerY < centerY;
			var shouldJump:Bool = playerIsAbove;
			
			// Add some randomness
			if (Math.random() < 0.3) {
				shouldJump = Math.random() < 0.5;
			}
			
			
			// time to attack somehow!
			if (shouldJump) {
				// JUMP
				_currentState = STATE_JUMP;
				
				this.y -= 2;
				var xSpeed:Float = (Math.random() * 10 + 5) * dir;
				var ySpeed:Float = -30;
				_velocity.setTo(xSpeed, ySpeed);
				
			} else {
				// CHARGE!
				_currentState = STATE_RUN;
				
				var dist:Float = player.centerX - centerX;
				var speed:Float = Math.random() * 10 + 10;
				speed *= dir;
				var stepsNeeded:Float = dist / speed;
				_runTimer = Std.int(Math.abs(stepsNeeded));
				_runSpeed = speed;
				
				
				_velocity.setTo(_runSpeed, 0);
			}
			
			
		} else {
			_idleTime--;
		}
	}
	
	override private function updatePhysics() 
	{
		if (collide("solid", x, y + 1) == null) {
			_velocity.y += 1;
			if (_velocity.y > 10) {
				_velocity.y = 10;
			}
		} else {
			_velocity.y = 0;
		}
		
		moveBy(_velocity.x, _velocity.y, ["solid", "cloud"], true);
		
	}
	
	override public function getDamage():Int 
	{
		return 3;
	}
	
	override public function wantsToUpdate(cameraBounds:Rectangle):Bool {
		return true;
	}
}