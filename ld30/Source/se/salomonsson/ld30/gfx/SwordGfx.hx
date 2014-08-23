package se.salomonsson.ld30.gfx;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class SwordGfx extends Graphiclist
{
	private var _gfxParts:Array<SwordGfxPart>;
	private var _bladeLength:Float;
	private var _dir:Float;
	private var _isAct:Bool;
	
	private var _hitbox:Rectangle;

	public function new() 
	{
		var numParts = 24;
		var size = 20;
		var source:BitmapData = HXP.createBitmap(size, size, true, 0xFFFFFFFF);
		var extraSwing = 0;
		
		_gfxParts = new Array<SwordGfxPart>();
		for (i in 0...24) {
			var sPart = new SwordGfxPart(source, 0, 0);
			_gfxParts.push(sPart);
		}
		
		_hitbox = new Rectangle();
		
		super(_gfxParts);
	}
	
	public function setBladeLength(len:Int) {
		_bladeLength = len;
	}
	
	public function setDir(dir:Float) {
		_dir = dir;
	}
	
	public function attack() {
		var extraSwing:Float = 0;
		
		var r:Float = -Math.PI/2 - extraSwing;
		var step:Float = (Math.PI + extraSwing) / 24.0;
		
		for (i in 0...24) {
			var sx = Math.cos(r) * _bladeLength;
			var sy = Math.sin(r) * 8;
			r += step;
			
			sx = (_dir > 0) ? sx + 32 : -sx;
			_gfxParts[i].initAttack(sx, sy + 16, i);
		}
		
		_isAct = true;
	}
	
	public function isSwinging() {
		return _isAct;
	}
	
	
	
	override public function update()
	{
		if (_isAct) {
			var anyActive = false;
			
			for (i in 0...24) {
				if (_gfxParts[i].isActive) {
					anyActive = true;
					_gfxParts[i].update();
				}
			}
			
			if (!anyActive) {
				_isAct = false;
			}
		}
	}
}

private class SwordGfxPart extends Image {
	
	public var isActive:Bool;
	private var _initDelay:Int;
	private var _delay:Int;
	
	public function new(src:BitmapData, x:Float, y:Float) {
		
		var size:Int = 20;
		var source:BitmapData = HXP.createBitmap(size, size, true, 0xFFFFFFFF);
		super(source);
		this.x = x;
		this.y = y;
		this.color = 0x0000ff;
		centerOrigin();
		this.active = true;
		this.visible = false;
	}
	
	public function initAttack(x:Float, y:Float, delay:Int) {
		this.x = x;
		this.y = y;
		_initDelay = delay;
		_delay = _initDelay;
		isActive = true;
	}
	
	
	override public function update() {
		if (_delay > 0) {
			_delay -= 1;
			if (_delay == 0) {
				this.visible = true;
				this.scale = 1;
			}
			return;
		}
			
		this.scale *= 0.91;
		if (scale < 0.2) {
			this.visible = false;
			this.isActive = false;
		}
	}
}