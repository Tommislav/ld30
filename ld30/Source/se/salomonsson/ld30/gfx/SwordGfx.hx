package se.salomonsson.ld30.gfx;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import motion.Actuate;
import motion.easing.Cubic;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * TODO:
 * Sword should have origo at 0,0 and be displaced by parent entity
 * Sometimes emit particle trail relative to parent (slash), sometimes in world-space (upercut)
 * @author Tommislav
 */
class SwordGfx extends Graphiclist
{
	private var _gfxParts:Array<SwordGfxPart>;
	private var _bladeLength:Float;
	private var _dir:Float;
	private var _isAct:Bool;
	
	private var _hitbox:Rectangle;
	private var _shrinkDuringDelay:Bool;

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
	
	
	
	
	public function attackTopToBottom() {
		var extraSwing:Float = 0;
		_shrinkDuringDelay = true;
		
		var r:Float = -Math.PI/2 - extraSwing;
		var step:Float = (Math.PI + extraSwing) / 24.0;
		
		for (i in 0...24) {
			var sx = Math.cos(r) * _bladeLength;
			var sy = Math.sin(r) * 8;
			r += step;
			
			sx = (_dir > 0) ? sx + 32 : -sx;
			_gfxParts[i].initAttack(sx, sy + 16, i, _shrinkDuringDelay);
		}
		
		_isAct = true;
	}
	
	public function attackBottomToTop() {
		var extraSwing:Float = 0;
		_shrinkDuringDelay = true;
		
		var r:Float = Math.PI/2 - extraSwing;
		var step:Float = (Math.PI + extraSwing) / 24.0;
		
		for (i in 0...24) {
			var sx = Math.cos(r) * _bladeLength;
			var sy = Math.sin(r) * 8;
			r -= step;
			
			sx = (_dir > 0) ? sx + 32 : -sx;
			_gfxParts[i].initAttack(sx, sy + 16, i, _shrinkDuringDelay);
		}
		
		_isAct = true;
	}
	
	public function attackUppercut() {
		_shrinkDuringDelay = false;
		
		var sx:Float = 10;
		var sy:Float = 32;
		sx = (_dir > 0) ? sx + 32 : -sx;
		
		_gfxParts[0].initAttack(sx, sy, 24, _shrinkDuringDelay);
		_gfxParts[0].scale = 1;
		_gfxParts[0].visible = true;
		
		Actuate.tween(_gfxParts[0], 0.1, { y: -10 } ).ease( Cubic.easeOut );
		
		
		_isAct = true;
	}
	
	public function attackSmashDown() {
		_shrinkDuringDelay = false;
		
		var sx:Float = 10;
		var sy:Float = -10;
		sx = (_dir > 0) ? sx + 32 : -sx;
		
		_gfxParts[0].initAttack(sx, sy, 24, _shrinkDuringDelay);
		_gfxParts[0].scale = 1;
		_gfxParts[0].visible = true;
		_isAct = true;
		
		Actuate.tween(_gfxParts[0], 0.1, { y: 42 } ).ease( Cubic.easeOut );
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
	private var _shrinkDuringDelay:Bool;
	
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
	
	public function initAttack(x:Float, y:Float, delay:Int, shrinkDuringDelay:Bool) {
		this.x = x;
		this.y = y;
		_initDelay = delay;
		_delay = _initDelay;
		_shrinkDuringDelay = shrinkDuringDelay;
		isActive = true;
	}
	
	
	override public function update() {
		if (isActive) {
			if ((_delay > 0 && _shrinkDuringDelay) || _delay <= 0) {
				this.scale *= 0.91;
				if (scale < 0.2) {
					this.visible = false;
					
					if (_delay <= 0 ) { this.isActive = false; }
				}
			}
		}
		
		if (_delay > 0) {
			_delay -= 1;
			if (_delay == 0) {
				this.visible = true;
				this.scale = 1;
			}
			return;
		}
		
	}
}