package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import flash.geom.Point;
import flash.geom.Rectangle;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.SoundFactory;

/**
 * ...
 * @author Tommislav
 */
class EnemyBase extends Entity
{
	private var _emitter:EmitEntity;
	
	private var _velocity:Point;
	private var _maxVelocity:Point;
	private var _hp:Int;
	private var _dmgCounter:Int;
	private var _killBonus:Int;
	private var _money:Int;
	
	public var isAttackableByPlayer:Bool = true;
	
	
	public function new(x:Float, y:Float, gfx:Graphic, w:Int=32, h:Int=32, maxMoney:Int=1, type:String="enemy") 
	{
		super(x, y, gfx);
		this.type = type;
		setHitbox(w, h);
		_hp = 3;
		_velocity = new Point();
		_maxVelocity = new Point();
		_money = GameData.instance.getSpawnMoney(maxMoney);
	}
	
	override public function wantsToRender(cameraBounds:Rectangle):Bool {
		return isWithinBounds(cameraBounds, 0);
	}
	
	override public function wantsToUpdate(cameraBounds:Rectangle):Bool {
		return isWithinBounds(cameraBounds, 50);
	}
	
	
	private function emit(name:String, num:Int, x:Float, y:Float, rX:Float=0, rY:Float=0) {
		if (_emitter == null) {
			_emitter = cast(HXP.scene.getInstance("emitter"), EmitEntity);
		}
		_emitter.emit(name, num, x, y, rX, rY);
	}
	
	public function getDamage():Int {
		return 10;
	}
	
	
	
	override public function update():Void 
	{
		super.update();
		preUpdate();
		updatePhysics();
		updateBehviours();
		checkCollisionWithPlayer();
		checkAttacked();
		postUpdate();
	}
	
	
	
	
	
	
	
	
	function preUpdate() 
	{
		
	}
	
	function updatePhysics() 
	{
		
	}
	
	function updateBehviours() 
	{
		
	}
	
	function checkCollisionWithPlayer() {
		var e:Entity = collide(EntityType.PLAYER, this.x, this.y);
		if (e != null) {
			var pl:Player = cast(e, Player);
			
			if (pl.collideWithEnemy(this)) {
				onCollisionWithPlayer(pl);
			}
		}
	}
	
	function checkAttacked() {
		if (!isAttackableByPlayer) {
			return;
		}
		
		if (_dmgCounter <= 0) {
			var e:Entity = collide("atk", this.x, this.y);
			if (e != null) {
				_dmgCounter = 30;
				_hp -= GameData.instance.swordStr;
				if (_hp <= 0) {
					spawnCoins();
					onKilled();
				} else {
					onAttacked(e);
				}
			}
		} else {
			_dmgCounter--;
		}
		
		
	}
	
	function spawnCoins() 
	{
		if (_money > 0) {
			for (i in 0..._money) {
				var rx:Float = centerX + Math.random() * 32 - 16;
				var ry:Float = centerY + Math.random() * 32 - 16;
				HXP.scene.add(new CoinEntity(rx, ry, 1, true));
			}
		}
	}
	
	function postUpdate() 
	{
		
	}
	
	
	
	
	
	
	function onCollisionWithPlayer(e:Player) {
		//e.collideWithEnemy(this);
	}
	
	function onAttacked(e:Entity) {
		SoundFactory.getSound("Punch2.wav").play();
	}
	
	function onKilled() {
		SoundFactory.getSound("Death.wav").play();
		this.graphic = null;
		HXP.scene.remove(this);
	}
	
	
}