package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import flash.geom.Point;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class Punching extends EnemyBase
{
	private var _fist:Entity;
	
	static inline var EYES_IDLE = 1;
	static inline var EYES_DEF = 2;
	static inline var EYES_DMG = 3;
	
	static inline var FIST_IDLE = 1;
	static inline var FIST_ATK = 2;
	static inline var FIST_DEF = 3;
	
	static inline var STATE_IDLE = 1;
	static inline var STATE_DEFENDING = 2;
	static inline var STATE_ATTACK = 3;
	
	private var _gfx:DynamigGfxList;
	private var _fistGfx:DynamigGfxList;
	private var _fistPos:Point;
	private var _attackCnt:Int;
	
	private var _currentState:Int;
	private var _cnt:Int;
	
	private var _leftMost:Float;
	private var _rightMost:Float;
	
	public function new(x, y, width, height, money) 
	{
		_gfx = GraphicsFactory.instance.getPunchingEnemy();
		
		super(x, y, _gfx, 32, 48, money);
		setHitbox(32, 48);
		_hp = 12;
		
		// Walking bounds
		_leftMost = x - 150;
		_rightMost = x + 150;
		
		_fistPos = new Point();
		
		_fist = new Entity();
		_fist.x = this.x - 5;
		_fist.y = this.y + 19;
		_fist.setHitbox(16, 20, 0, -5);
		_fistGfx = GraphicsFactory.instance.getPunchingFist();
		_fist.graphic = _fistGfx;
		_fist.layer = HXP.BASELAYER - 1;
		HXP.scene.add(_fist);
		
		setState(STATE_IDLE);
	}
	
	override public function getDamage():Int { return 2; }
	
	
	private function setEyeState(state:Int) {
		if (_attackCnt == 0) {
			_gfx.setGroupVisible("eye", (state == EYES_IDLE));
			_gfx.setGroupVisible("atk", (state == EYES_DEF));
			_gfx.setGroupVisible("dmg", (state == EYES_DMG));
		}
	}
	
	private function setFistState(state:Int) {
		_fistGfx.setGroupVisible("open", state == FIST_DEF );
		_fistGfx.setGroupVisible("close", state != FIST_DEF );
		
		if (state == FIST_IDLE) {
			_fistPos.x = -5;
			_fistPos.y = 19;
		}
		
		if (state == FIST_DEF) {
			_fistPos.x = 28;
			_fistPos.y = 12;
		}
	}
	
	private function setState(s:Int) {
		_currentState = s;
		
		if (_currentState == STATE_IDLE) {
			setEyeState(EYES_IDLE);
			setFistState(FIST_IDLE);
			_cnt = 20;
		}
		
		if (_currentState == STATE_DEFENDING) {
			setEyeState(EYES_DEF);
			setFistState(FIST_DEF);
		}
		
		if (_currentState == STATE_ATTACK) {
			setEyeState(EYES_DEF);
			
			var pl:Entity = HXP.scene.getInstance(EntityType.PLAYER);
			var angle:Float = Math.atan2((pl.centerY + 24) - _fist.centerY, pl.centerX - _fist.centerX);
			var fx:Float = Math.cos(angle) * 110;
			var fy:Float = Math.sin(angle) * 110;
			
			HXP.tween(_fistPos, { x: fx, y: fy }, 0.4, { ease: Ease.backIn, complete: retractPunch } );
			
			_cnt = 40;
		}
	}
	
	private function retractPunch(_) {
		HXP.tween(_fistPos, { x: -3, y: 19 }, 0.2 );
	}
	
	override private function preUpdate() 
	{
		if (_cnt > 0) {
			_cnt--;
			if (_cnt == 0) {
				if (_currentState == STATE_IDLE) {
					setState(STATE_ATTACK);
				} else if (_currentState == STATE_ATTACK) {
					setState(STATE_IDLE);
				}
			}
		}
	}
	
	override private function postUpdate() 
	{
		_fist.x = this.x + _fistPos.x;
		_fist.y = this.y + _fistPos.y;
	}
	
	override public function removed():Void 
	{
		super.removed();
		HXP.scene.remove(_fist);
	}
	
	
	
	override private function canBeAttacked(e:Entity):Bool 
	{
		return _currentState != STATE_DEFENDING && _attackCnt == 0;
	}
	
	
	override function checkCollisionWithPlayer() {
		var e:Entity = _fist.collide(EntityType.PLAYER, _fist.x, _fist.y);
		if (e != null) {
			
			var pl:Player = cast(e, Player);
			
			if (pl.collideWithEnemy(this)) {
				onCollisionWithPlayer(pl);
			}
		}
	}
	
	override private function onAttacked(e:Entity) 
	{
		super.onAttacked(e);
		setEyeState(EYES_DMG);
		_attackCnt = 1;
		HXP.alarm(1, openEyes, TweenType.OneShot);
	}
	
	function openEyes(_) 
	{
		_attackCnt = 0;
		setEyeState(EYES_IDLE);
	}
	
}