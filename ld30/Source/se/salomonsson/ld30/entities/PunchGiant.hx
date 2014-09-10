package se.salomonsson.ld30.entities;

import com.haxepunk.ai.behaviors.Composite;
import com.haxepunk.ai.behaviors.Repeat;
import com.haxepunk.ai.behaviors.Selector;
import com.haxepunk.ai.behaviors.Sequence;
import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.Mask;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.tweens.misc.MultiVarTween;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import flash.geom.Point;
import se.salomonsson.ld30.b.DebugBehaviour;
import se.salomonsson.ld30.b.PauseBehaviour;
import se.salomonsson.ld30.b.PositionEntityBehaviour;
import se.salomonsson.ld30.b.ShakeCameraBehaviour;
import se.salomonsson.ld30.b.TweenBehaviour;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class PunchGiant extends EnemyBase
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
		width = 80;
		height = 112;
		_gfx = GraphicsFactory.instance.getPunchGiantEnemy();
		
		super(x, y, _gfx, width, height, money);
		setHitbox(width, height);
		_hp = 12;
		
		// Walking bounds
		_leftMost = x - 150;
		_rightMost = x + 150;
		
		_fistPos = new Point();
		
		_fist = new Entity();
		_fist.x = this.x - 5;
		_fist.y = this.y + 19;
		_fist.setHitbox(48, 48);
		_fistGfx = GraphicsFactory.instance.getPunchGiantFist();
		_fist.graphic = _fistGfx;
		_fist.layer = HXP.BASELAYER - 1;
		HXP.scene.add(_fist);
		
		//http://obviam.net/index.php/game-ai-an-introduction-to-behavior-trees/
		
		var tree = new Selector();
		tree.addChild( new Selector()
			.addChild(new Sequence()
				.addChild(new TweenBehaviour(_fistPos, {x:-30, y:-50}, 0.2, Ease.backIn))
				.addChild(new PauseBehaviour(10))
				.addChild(new TweenBehaviour(_fistPos, { x: 96, y: 64 }, 0.1, Ease.sineIn))
				.addChild(new ShakeCameraBehaviour(20,6,6,0.8))
				.addChild(new PauseBehaviour(40))
				.addChild(new TweenBehaviour(_fistPos, { x: -5, y: 19 }, 1, Ease.circOut))
			)
		);
		behaviorTree = tree;
		
	}
	
	override public function getDamage():Int { return 2; }
	
	
	private function setEyeState(state:Int) {
		//if (_attackCnt == 0) {
			//_gfx.setGroupVisible("eye", (state == EYES_IDLE));
			//_gfx.setGroupVisible("atk", (state == EYES_DEF));
			//_gfx.setGroupVisible("dmg", (state == EYES_DMG));
		//}
	}
	
	
	override private function preUpdate() {
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
	
	//override private function onAttacked(e:Entity) 
	//{
		//super.onAttacked(e);
		//setEyeState(EYES_DMG);
		//_attackCnt = 1;
		//HXP.alarm(1, openEyes, TweenType.OneShot);
	//}
	
	//function openEyes(_) 
	//{
		//_attackCnt = 0;
		//setEyeState(EYES_IDLE);
	//}
	
}