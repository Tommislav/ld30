package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import com.haxepunk.utils.Ease;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class EyeEnemy extends EnemyBase
{
	private var _gfx:DynamigGfxList;
	
	public function new(x:Float, y:Float, g:Graphic) {
		_gfx = GraphicsFactory.getGenericEnemyGraphic();
		super(x, y, _gfx);
	}
	
	override public function added():Void {
		super.added();
		_emitter = cast(HXP.scene.getInstance("emitter"), EmitEntity);
	}
	
	override private function postUpdate() {
		super.postUpdate();
		
		if (_dmgCounter <= 0) {
			_gfx.setGroupVisible("eye", true);
			_gfx.setGroupVisible("dmg", false);
		} else {
			_gfx.setGroupVisible("eye", false);
			_gfx.setGroupVisible("dmg", true);
		}
	}
	
	override private function onAttacked(e:Entity) {
		super.onAttacked(e);
		_emitter.emit("expl-s", 3, centerX, centerY, 32 , 32);
	}
	
	override private function onKilled() {
		super.onKilled();
		_emitter.emit("expl-l", 40, centerX, centerY, 64 , 64);
	}
}