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
	private var _originalY:Float;
	private var _r:Float;
	private var _add:Float;
	private var _max:Float;
	
	public function new(x:Float, y:Float, maxMoney:Int) {
		_gfx = GraphicsFactory.getGenericEnemyGraphic();
		super(x, y, _gfx, 32, 32, maxMoney);
		
		_r = 0;
		_add = Math.random() * 0.08 + 0.02;
		_max = Math.random() * 16 + 16;
		_originalY = y;
	}
	
	
	override private function updatePhysics() 
	{
		this.y = _originalY + Math.sin(_r) * _max;
		_r += _add;
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
		emit("expl-s", 3, centerX, centerY, 32 , 32);
	}
	
	override private function onKilled() {
		super.onKilled();
		emit("expl-l", 40, centerX, centerY, 64 , 64);
	}
}