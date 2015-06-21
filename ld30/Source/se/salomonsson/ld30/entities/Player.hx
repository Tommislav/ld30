package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick;
import flash.geom.Point;
import flash.Lib;
import se.salomonsson.ld30.behaviours.IBehaviour;
import se.salomonsson.ld30.behaviours.UpdatePosBehaviour;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.gfx.SwordGfx;
import se.salomonsson.ld30.GraphicsFactory;
import se.salomonsson.ld30.scene.SplashStartScene;
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
	private var _punch:Punch;
	
	private var _lastAttackTime:Int;
	private var _lastDashTime:Int;
	private var _attackButtonDown:Bool;
	private var _lastAttackType:Int;
	
	private var _leftDownTime:Int;
	private var _rightDownTime:Int;
	
	private var _resistance:Float;
	
	private var _dmgCoutnDown:Int;
	var _gameOver:Bool;
	
	private var _hud:Hud;
	
	
	private var _joystick:Joystick;
	
	
	public function new() 
	{
		super(100, 100);
		_resistance = 1;
		
		_joystick = new Joystick();
		trace("number of joysticks: " + Input.joysticks);
		
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
		
		
		_hud = new Hud(10, 10, 160, "playerHud");
		#if debug
			_hud.y = 25;
		#end
		
		HXP.scene.add(_hud);
		
		
	}
	
	public function addExternalDamage(amount:Int) {
		GameData.instance.health -= amount;
		_dmgCoutnDown = 30;
		_gfx.setGroupVisible("lava", true);
	}
	
	override public function added():Void 
	{
		super.added();
		_emitter = cast(HXP.scene.getInstance("emitter"), EmitEntity);
		
		_sword = new Sword(GameData.instance.swordLength);
		_sword.layer = HXP.BASELAYER - 1;
		_sword.type = EntityType.ATK;
		
		_punch = new Punch();
		_punch.layer = HXP.BASELAYER - 1;
		
		
		HXP.scene.add(_sword);
		HXP.scene.add(_punch);
	}
	
	override public function update():Void 
	{
		super.update();
		
		_hud.setValue(GameData.instance.health / GameData.instance.maxHealth);
		
		if (GameData.instance.health <= 0) {
			// DEAD
			collidable = false;
			_velocity.x *= 0.8;
			_velocity.y += 1;
			this.x += _velocity.x;
			this.y += _velocity.y;
			
			if (this.y > HXP.height) {
				if (!_gameOver) {
					_gameOver = true;
					var gameOverSign:Image = new Image("assets/game_over.png");
					gameOverSign.x = HXP.camera.x + 276;
					gameOverSign.y = HXP.camera.y + 194;
					HXP.scene.addGraphic(gameOverSign);
				}
			}
			
			if (_gameOver) {
				if (Input.mousePressed) {
					HXP.scene = new SplashStartScene();
				}
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
		_punch.setJointPosition(x, y);
	}
	
	function updateGfx() {
		if (_dmgCoutnDown == 1) {
			_gfx.setGroupVisible("normal", true);
			_gfx.setGroupVisible("dmg", false);
			_gfx.setGroupVisible("lava", false);
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
		
		mX *= _resistance;
		mY *= _resistance;
		
		var shoudSweep = (mX < -16 || mX > 16 || mY < -16 || mY > 16);
		
		moveBy(mX, mY, ["solid", "cloud"], shoudSweep);
	}
	
	public function setResistance(r:Float):Void {
		_resistance = r;
	}
	
	
	function updateFromInput() {
		var isMoving:Bool = false;
		var gd:GameData = GameData.instance;
		
		_onGround = collideTypes(["solid", "cloud"], this.x, this.y + 1) != null;
		var staggering:Bool = (Lib.getTimer() - _lastAttackTime < gd.moveStaggering);
		
		
		
		if (Input.check(CTRL_LEFT) || Input.joystick(0).hat.x == -1) {
			if (_velocity.x > 0) { _velocity.x *= 0.9; }
			isMoving = true;
			_velocity.x -= gd.moveSpeed;
			_dir.x = -1;
		}
		if (Input.check(CTRL_RIGHT) || Input.joystick(0).hat.x == 1) {
			
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
		
		if (Input.check(CTRL_ATK) || Input.joystick(0).check(XBOX_GAMEPAD.X_BUTTON)) {
			
			if (_attackButtonDown) { return; }
			_attackButtonDown = true;
			
			//if (!_sword.getCanAttack()) { return; }
			
			var swordCanAttack = _sword.getCanAttack();
			var sinceAtk = Lib.getTimer() - _lastAttackTime;
			
			if (sinceAtk < 5) {
				return;
			}
			
			if (Input.check(CTRL_UP) || Input.joystick(0).hat.y == -1) {
				attack(2); // uppercut
				_velocity.y = -50;
				_onGround = false;
			} else if (Input.check(CTRL_DOWN) || Input.joystick(0).hat.y == 1 && !_onGround) {
				attack(3); // smackDown
				_velocity.y = 60;
				_velocity.x = 0;
			} else {
				attack(0);
			}
			
		} else {
			_attackButtonDown = false;
		}
		
		
		
		if (_isJumping && _onGround) {
			_isJumping = false;
		}
		
		if (_onGround) {
			_velocity.y = 0;
		}
		
		
		
		if (Input.pressed(CTRL_JUMP) || Input.joystick(0).pressed(XBOX_GAMEPAD.A_BUTTON)) {
			if (_onGround && !isDashing()) {
				_velocity.y -= gd.jumpStr;
				_isJumping = true;
			}
		}
		
		
		if (Input.joystick(0).pressed(XBOX_GAMEPAD.LB_BUTTON)) {
			if (canDash()) dash( -1);
		} else {
			if (Input.pressed(CTRL_LEFT)) {
				if (checkDashDoubleClick(-1)) {
					if (canDash()) {
						dash( -1);
					}
				}
			}
		}
		
		if (Input.joystick(0).pressed(XBOX_GAMEPAD.RB_BUTTON)) {
			if (canDash()) dash(1);
		} else {
			if (Input.pressed(CTRL_RIGHT)) {
				if (checkDashDoubleClick(1)) {
					if (canDash()) {
						dash(1);
					}
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
	
	private function attack(type:Int) {
		_lastAttackType = type;
		_lastAttackTime = Lib.getTimer();
		_sword.attack(_dir.x, type);
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
		
		if (_dashVelocity.y != 0) {
			_dashVelocity.y *= 0.92;
			
			if (_dashVelocity.y < 0.1 && _dashVelocity.y > -0.1) {
				_dashVelocity.y = 0;
			}
		}
	}
	
	private function canDash():Bool {
		return (Lib.getTimer() - _lastDashTime > GameData.instance.dashRecoveryTime);// DASH RECOVER TIME
	}
	
	private function dash(dir:Int) {
		_lastDashTime = Lib.getTimer();
		_dashVelocity.x += dir * GameData.instance.dashSpeed; // DASH LENGTH
		_velocity.y = 0;
		
		var name:String = (dir < 0) ? "dashL" : "dashR";
		_emitter.emit(name, 10, centerX, centerY, 16, 16);
	}
	
	
	
	public function setBounce(y:Float) {
		_dashVelocity.y = y;
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
	
	
	public function getAttackedVelocity():Point {
		if (!_sword.getCanAttack()) {
			if (_lastAttackType == 2) {
				return new Point(0, _velocity.y);
			} else if (_lastAttackType == 3) {
				return new Point(0, _velocity.y * 3);
			}
		}
		
		return new Point(0,0);
	}
	
	
	
	function updateBehaviours() {
		for (b in _behaviours) {
			b.update(this);
		}
	}
}