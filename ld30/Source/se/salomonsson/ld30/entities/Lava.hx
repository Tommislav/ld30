package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;

/**
 * ...
 * @author Tommislav
 */
class Lava extends Entity
{
	private var _playerInLava:Bool;
	private var _dmgCounter:Int;

	public function new(x:Float, y:Float, w:Int, h:Int) 
	{
		super(x, y);
		setHitbox(w, h);
	}
	
	override public function update():Void 
	{
		super.update();
		var player:Entity = collide("player", x, y);
		if (player != null) {
			var p:Player = cast(player, Player);
			p.setResistance(0.5);
			
			if (!_playerInLava) {
				var e:EmitEntity = cast(HXP.scene.getInstance("emitter"), EmitEntity);
				e.emit("splash", 8, p.centerX, p.y + p.height, 32, 0);
				_dmgCounter = 10;
			}
			
			if (--_dmgCounter <= 0) {
				_dmgCounter = 40;
				p.addExternalDamage(1);
			}
			
			_playerInLava = true;
		} else {
			if (_playerInLava) {
				// player was in lava
				
				var p:Player = cast(HXP.scene.getInstance("player"), Player);
				p.setResistance(1);
				_playerInLava = false;
			}
		}
	}
	
}