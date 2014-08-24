package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import se.salomonsson.ld30.EntityType;

/**
 * ...
 * @author Tommislav
 */
class BounceEntity extends Entity
{

	public function new(x:Float, y:Float, width:Int, height:Int) 
	{
		super(x, y);
		setHitbox(width, height);
	}
	
	override public function update():Void 
	{
		super.update();
		
		var player:Player = cast(collide(EntityType.PLAYER, this.x, this.y), Player);
		if (player != null) {
			player.setBounce( -40);
		}
		
	}
	
}