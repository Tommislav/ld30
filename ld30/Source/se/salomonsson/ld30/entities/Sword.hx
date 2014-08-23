package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.gfx.SwordGfx;

/**
 * ...
 * @author Tommislav
 */
class Sword extends Entity
{
	private var _gfx:SwordGfx;
	private var _lastLen:Int;

	public function new(bladeLen) 
	{
		_gfx = new SwordGfx();
		setBladeLength(bladeLen);
		
		this.type = EntityType.ATK;
		collidable = true;
		this.name = "sword";
		super(0, 0, _gfx);
	}
	
	public function attack(dir:Float) {
		_gfx.setDir(dir);
		_gfx.attack();
		
		var w:Int = _lastLen;
		var h:Int = 30;
		var x = (dir > 0) ? -32 : w;
		var y = 0;
		setHitbox(w, h, x, y);
		collidable = true;
	}
	
	override public function update():Void 
	{
		super.update();
		_gfx.update();
		
		if (_gfx.isSwinging()) {
			collidable = true;
		} else {
			collidable = false;
		}
		
	}
	
	public function getCanAttack() {
		return !_gfx.isSwinging();
	}
	
	public function setBladeLength(len:Int) {
		if (len != _lastLen) {
			_gfx.setBladeLength(len);
			_lastLen = len;
		}
	
	}
	
}