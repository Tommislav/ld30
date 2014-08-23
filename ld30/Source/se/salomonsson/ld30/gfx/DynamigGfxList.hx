package se.salomonsson.ld30.gfx;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.Graphic;

/**
 * ...
 * @author Tommislav
 */
class DynamigGfxList extends Graphiclist
{
	private var _flippable:Array<Bool>;
	private var _group:Array<String>;
	private var _flip:Bool;

	public function new() 
	{
		super();
		_flippable = new Array<Bool>();
		_group = new Array<String>();
	}
	
	public function add2(graphic:Graphic, flippable:Bool, group:String) {
		super.add(graphic);
		_flippable.push(flippable);
		_group.push(group);
	}
	
	public function getFlipped():Bool {
		return _flip;
	}
	public function setFlipped(f:Bool) {
		if (f != _flip) {
			_flip = f;
			
			var c = children;
			var img:Image;
			for (i in 0...c.length) {
				trace("flipp " + i + " ->> " + _flippable[i]);
				if (_flippable[i]) {
					img = cast(c[i], Image);
					img.flipped = f;
				}
			}
		}
	}
}