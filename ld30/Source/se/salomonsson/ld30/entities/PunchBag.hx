package se.salomonsson.ld30.entities;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import flash.geom.Point;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class PunchBag extends EnemyBase
{
	public var useGravity:Bool = true;
	
	private var _gfx:DynamigGfxList;
	
	private var _onGround:Bool;
	
	public function new(x:Float, y:Float) 
	{
		_gfx = GraphicsFactory.instance.getPuchBagGfx();
		super(x, y, _gfx, 32, 64, 2);
		_maxVelocity = new Point(16, 16);
		setHitbox(32, 64);
		_hp = 999999;
	}
	
	
	override private function canBeAttacked(e:Entity):Bool 
	{
		return true;
	}
	
	override private function updatePhysics() 
	{
		_onGround = collideTypes(["solid", "cloud"], this.x, this.y + 1) != null;
		trace("on ground: " + _onGround);
		
		if (useGravity) {
			_velocity.y += GameData.instance.gravity;
		}
		
		_velocity.x = HXP.clamp(_velocity.x, -_maxVelocity.x, _maxVelocity.x);
		_velocity.y = HXP.clamp(_velocity.y, -_maxVelocity.y, _maxVelocity.y);
		
		var mX = _velocity.x;
		var mY = _velocity.y;
		
		if (_onGround) {
			mX *= 0.9;
		}
		
		//mY *= _resistance;
		
		var shoudSweep = (mX < -16 || mX > 16 || mY < -16 || mY > 16);
		
		moveBy(mX, mY, ["solid", "cloud"], shoudSweep);
	}
	
	override private function checkAttacked() 
	{
		if (!isAttackableByPlayer) {
			return;
		}
		
		if (_dmgCounter <= 0) {
			var e:Entity = collide("atk", this.x, this.y);
			if (e != null) {
				if (!canBeAttacked(e)) {
					
					// play deflect sound
					onDeflectAttack();
					return;
				}
				
				
				_dmgCounter = 30;
				_hp -= GameData.instance.swordStr;
				if (_hp <= 0) {
					spawnCoins();
					onKilled();
				} else {
					onAttacked(e);
					
					var player:Player = cast(scene.getInstance(EntityType.PLAYER), Player);
					var plVel = player.getAttackedVelocity();
					_velocity = new Point(plVel.x, plVel.y);
				}
			}
		} else {
			_dmgCounter--;
		}
	}
	
	override private function postUpdate() 
	{
		var dmg = _dmgCounter > 0;
		_gfx.setGroupVisible("eyesOpen", !dmg);
		_gfx.setGroupVisible("eyesClosed", dmg);
		
	}
}