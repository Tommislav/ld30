package se.salomonsson.ld30.entities;

import com.haxepunk.Graphic;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class EyeEnemy extends EnemyBase
{
	private var _gfx:DynamigGfxList;
	
	public function new(x:Float, y:Float, g:Graphic) 
	{
		_gfx = GraphicsFactory.getGenericEnemyGraphic();
		super(x, y, _gfx);
	}
	
	override private function postUpdate() 
	{
		super.postUpdate();
		
		if (_dmgCounter <= 0) {
			_gfx.setGroupVisible("eye", true);
			_gfx.setGroupVisible("dmg", false);
		} else {
			_gfx.setGroupVisible("eye", false);
			_gfx.setGroupVisible("dmg", true);
		}
	}
	
}