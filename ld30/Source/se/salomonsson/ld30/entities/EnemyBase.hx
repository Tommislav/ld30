package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import flash.geom.Point;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.EntityType;

/**
 * ...
 * @author Tommislav
 */
class EnemyBase extends Entity
{
	private var _velocity:Point;
	private var _maxVelocity:Point;
	private var _hp:Int;
	private var _dmgCounter:Int;
	private var _killBonus:Int;
	
	
	public function new(x:Float, y:Float, gfx:Graphic, w:Int=32, h:Int=32, type:String="enemy") 
	{
		super(x, y, gfx);
		this.type = type;
		setHitbox(w, h);
		_hp = 3;
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
		var e:Entity = collide("atk", this.x, this.y);
		if (e != null) {
			trace("enemy attacked");
			onAttacked(e);
		}
	}
	
	function postUpdate() 
	{
		
	}
	
	
	
	
	
	
	function onCollisionWithPlayer(e:Player) {
		//e.collideWithEnemy(this);
	}
	
	function onAttacked(e:Entity) {
		_hp -= GameData.instance.swordStr;
		if (_hp <= 0) {
			onKilled();
		}
	}
	
	function onKilled() {
		this.graphic = null;
		HXP.scene.remove(this);
	}
	
	
}