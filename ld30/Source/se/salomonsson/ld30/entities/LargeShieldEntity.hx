package se.salomonsson.ld30.entities;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class LargeShieldEntity extends EnemyBase
{
	private var _gfx:DynamigGfxList;
	private var _shield:Entity;
	
	public function new(x:Float, y:Float) 
	{
		_gfx = GraphicsFactory.instance.getLargeShiledGfx();
		super(x, y, _gfx, 32, 96, 4);
		setHitbox(32, 96);
		_hp = 1;
	}
	
	
	override private function canBeAttacked(e:Entity):Bool 
	{
		var player:Entity = HXP.scene.getInstance(EntityType.PLAYER);
		if (player.centerX > centerX) {
			// can only be attacked from behind!
			return false;
		}
		return true;
	}
	
	override private function updatePhysics() 
	{
		var player:Entity = HXP.scene.getInstance(EntityType.PLAYER);
		if (player.centerX > this.centerX && (player.centerY > this.centerY - 100 && player.centerY < this.centerY + 100) ) {
			this.moveBy(1, 0, "solid");
		}
		
		
	}
	
}