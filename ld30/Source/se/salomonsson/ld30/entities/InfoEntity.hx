package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.scene.HubScene;
import se.salomonsson.ld30.SoundFactory;

/**
 * ...
 * @author Tommislav
 */
class InfoEntity extends Entity
{
	
	private var _txt:Text;
	private var _bg:Image;
	private var _str:String;
	private var _halfW:Float;
	private var _isVisible:Bool;
	
	public function new(x:Float, y:Float, w:Int, h:Int, str:String) 
	{
		_str = str;
		
		_txt = new Text(str, 0, 0, 0, 0, {color:0x000000});
		_txt.autoHeight = true;
		_txt.autoWidth = true;
		
		_bg = Image.createRect(_txt.width, _txt.height, 0xeeeeee);
		_halfW = _txt.width / 2;
		
		super(x, y, new Graphiclist([_bg, _txt]));
		setHitbox(w, h);
		
		_isVisible = true;
	}
	
	override public function update():Void 
	{
		super.update();
		
		var e:Entity = collide(EntityType.PLAYER, this.x, this.y);
		if (e != null) {
			showInfo(e);
			onPlayerTouching(e);
		} else {
			hideInfo();
		}
	}
	
	function showInfo(e:Entity) {
		if (!_isVisible) {
			_txt.visible = _bg.visible = true;
			_isVisible = true;
		}
		
		this.graphic.x = e.centerX - this.x - _halfW;
		this.graphic.y = e.y - this.y - 60;
	}
	
	function hideInfo() {
		if (_isVisible) {
			_txt.visible = _bg.visible = false;
			_isVisible = false;
		}
	}
	
	private function onPlayerTouching(player:Entity) {
		
	}
	
}