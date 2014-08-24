package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.HXP;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import flash.geom.Point;
import flash.Lib;
import se.salomonsson.ld30.behaviours.IBehaviour;
import se.salomonsson.ld30.behaviours.UpdatePosBehaviour;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.gfx.SwordGfx;
import se.salomonsson.ld30.GraphicsFactory;
import se.salomonsson.ld30.SoundFactory;

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
	public static var CTRL_JUMP:String = "jump";
	public static var CTRL_ENTER_PORTAL:String = "portal";
	
	private var _emitter:EmitEntity;
	
	private var _gfx:DynamigGfxList;
	
	private var _velocity:Point;
	private var _maxVelocity:Point;
	private var _dashVelocity:Point;
	private var _behaviours:Array<IBehaviour>;
	
	private var _dir:Point;
	
	private var _isJumping:Bool;
	private var _onGround:Bool;
	private var _sword:Sword;
	
	private var _lastAttackTime:Int;
	private var _lastDashTime:Int;
	
	private var _leftDownTime:Int;
	private var _rightDownTime:Int;
	
	private var _dmgCoutnDown:Int;
	
	
	public function new() 
	{
		super(100,100);
		
		this.type = EntityType.PLAYER;
		this.name = EntityType.PLAYER;
		
		_gfx = GraphicsFactory.getPlayerGraphic();
		this.graphic = _gfx;
		this.setHitbox(32, 32);
		
		_velocity = new Point();
		_maxVelocity = new Point();
		_dashVelocity = new Point();
		_maxVelocity.x = GameData.instance.maxSpeed;
		_maxVelocity.y = GameData.instance.maxFall;
		_dir = new Point(1, 0);
		
		_behaviours = new Array<IBehaviour>();
		//_behaviours.push(new UpdatePosBehaviour(_velocity, _maxVelocity));
		
		
		
		
	}
	
	override public function added():Void 
	{
		super.added();
		_emitter = cast(HXP.scene.getInstance("emitter"), EmitEntity);
		
		_sword = new Sword(GameData.instance.swordLength);
		_sword.layer = HXP.BASELAYER - 1;
		_sword.type = EntityType.ATK;
		HXP.scene.add(_sword);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (GameData.instance.health <= 0) {
			// DEAD
			collidable = false;
			_velocity.x *= 0.8;
			_velocity.y += 1;
			this.x += _velocity.x;
			this.y += _velocity.y;
			
			if (this.y > HXP.height) {
				trace("GAME OVER");
			}
			
			return;
		}
		
		updateFromInput();
		updateDash();
		updatePosition();
		updateBehaviours();
		updateGfx();
		
		
		if (_dir.x < 0) {
			_gfx.setFlipped(true);
		} else {
			_gfx.setFlipped(false);
		}
		
		
		HXP.camera.setTo(this.x - HXP.halfWidth, this.y - HXP.halfHeight);
		_sword.x = this.x;
		_sword.y = this.y;
	}
	
	function updateGfx() {
		if (_dmgCoutnDown == 1) {
			_gfx.setGroupVisible("normal", true);
			_gfx.setGroupVisible("dmg", false);
		}
		
		if (_dmgCoutnDown > 0) { _dmgCoutnDown--; }
	}
	
	function updatePosition() {
		
		if (!isDashing()) {
			_velocity.y += GameData.instance.gravity;
		}
		
		_velocity.x = HXP.clamp(_velocity.x, -_maxVelocity.x, _maxVelocity.x);
		_velocity.y = HXP.clamp(_velocity.y, -_maxVelocity.y, _maxVelocity.y);
		
		var mX = _velocity.x + _dashVelocity.x;
		var mY = _velocity.y + _dashVelocity.y;
		
		var shoudSweep = (mX < -16 || mX > 16 || mY < -16 || mY > 16);
		
		moveBy(mX, mY, ["solid", "cloud"], shoudSweep);
	}
	
	
	
	function updateFromInput() {
		var isMoving:Bool = false;
		var gd:GameData = GameData.instance;
		
		_onGround = collideTypes(["solid", "cloud"], this.x, this.y + 1) != null;
		var staggering:Bool = (Lib.getTimer() - _lastAttackTime < gd.moveStaggering);
		
		
		
		if (Input.check(CTRL_LEFT)) {
			if (_velocity.x > 0) { _velocity.x *= 0.9; }
			isMoving = true;
			_velocity.x -= gd.moveSpeed;
			_dir.x = -1;
		}
		if (Input.check(CTRL_RIGHT)) {
			
			if (_velocity.x < 0) { _velocity.x *= 0.9; }
			isMoving = true;
			_velocity.x += gd.moveSpeed;
			_dir.x = 1;
		}
		if (!isMoving) {
			// apply friction
			_velocity.x *= gd.moveFriction;
			if (_velocity.x < 0.1 && _velocity.x > -0.1) {
				_velocity.x = 0;
			}
		}
		
		if (Input.check(CTRL_ATK)) {
			if (canAttack()) {
				attack();
			}
		}
		
		
		
		if (_isJumping && _onGround) {
			_isJumping = false;
		}
		
		if (_onGround) {
			_velocity.y = 0;
		}
		
		if (Input.pressed(CTRL_JUMP)) {
			if (_onGround) {
				_velocity.y -= gd.jumpStr;
				_isJumping = true;
			}
		}
		
		
		if (Input.pressed(CTRL_LEFT)) {
			if (checkDashDoubleClick(-1)) {
				if (canDash()) {
					dash( -1);
				}
			}
		}
		if (Input.pressed(CTRL_RIGHT)) {
			if (checkDashDoubleClick(1)) {
				if (canDash()) {
					dash(1);
				}
			}			
		}
		
		
		
		
	}
	
	
	
	
	// ATTACK
	
	private function canAttack():Bool {
		var now = Lib.getTimer();
		if (now - _lastAttackTime > GameData.instance.swordRecovery && _sword.getCanAttack()) {
			return true;
		}
		return false;
	}
	
	private function attack() {
		_lastAttackTime = Lib.getTimer();
		_sword.attack(_dir.x);
		SoundFactory.getSound("Swing.wav").play();
	}
	
	
	
	// DASH
	
	function isDashing():Bool {
		return (_dashVelocity.x > 0.5 || _dashVelocity.x < -0.5);
	}
	
	function checkDashDoubleClick(dir:Int):Bool {
		var now:Int = Lib.getTimer();
		var doubleClick:Int = now - ((dir < 0) ? _leftDownTime : _rightDownTime);
		
		if (dir < 0) {_leftDownTime = now;}
		else {_rightDownTime = now;}
			
		if (doubleClick < 200) {
			return true;
		}
		return false;
	}
	
	private function updateDash() {
		if (_dashVelocity.x != 0) {
			_dashVelocity.x *= 0.8;
			
			if (_dashVelocity.x < 0.1 && _dashVelocity.x > -0.1) {
				_dashVelocity.x = 0;
			}
			
			
			if (_dashVelocity.x > 5 || _dashVelocity.x < -5) {
				var name:String = _dashVelocity.x < 0 ? "dashL" : "dashR";
				_emitter.emit(name, 1, centerX, centerY, 16, 16);
			}
			
		}
	}
	
	private function canDash():Bool {
		return (Lib.getTimer() - _lastDashTime > GameData.instance.dashRecoveryTime);// DASH RECOVER TIME
	}
	
	private function dash(dir:Int) {
		_lastDashTime = Lib.getTimer();
		_dashVelocity.x += dir * GameData.instance.dashSpeed; // DASH LENGTH
		
		var name:String = (dir < 0) ? "dashL" : "dashR";
		_emitter.emit(name, 10, centerX, centerY, 16, 16);
	}
	
	
	
	
	
	
	
	public function collideWithEnemy(e:EnemyBase):Bool {
		
		if (isDashing()) {
			return false;
		}
		
		if (e.centerX > this.centerX) {
			_velocity.x -= 30;
		} else {
			_velocity.x += 30;
		}
		
		if (_dmgCoutnDown > 0) {
			_velocity.y -= 30;
			return false;
		}
		
		_gfx.setGroupVisible("normal", false);
		_gfx.setGroupVisible("dmg", true);
		
		GameData.instance.health -= e.getDamage();
		if (GameData.instance.health <= 0) {
			// DEAD!
			
		} else {
			_dmgCoutnDown = 30;
			_velocity.y -= 30;
		}
		
		return true;
	}
	
	
	
	
	function updateBehaviours() {
		for (b in _behaviours) {
			b.update(this);
		}
	}
}