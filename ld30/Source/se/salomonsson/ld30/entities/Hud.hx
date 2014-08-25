package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;

/**
 * ...
 * @author Tommislav
 */
class Hud extends Entity
{
	
	private var _fg:Image;
	private var _bg:Image;
	private var _gfx:Graphiclist;
	
	public function new(x:Float, y:Float, width:Int, name:String="") 
	{
		if (name != "") {
			this.name = name;
		}
		
		_bg = Image.createRect(width+2, 8+2, 0x3a3a3a);
		_fg = Image.createRect(width, 8, 0xcf0000);
		_fg.x = 1;
		_fg.y = 1;
		_gfx = new Graphiclist([_bg, _fg]);
		
		super(x, y, _gfx);
		followCamera = true;
	}
	
	public function setValue(f:Float) {
		_fg.scaleX = f;
	}
	
}