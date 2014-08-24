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
class PortalEntity extends Entity
{
	
	private var _txt:Text;
	private var _bg:Image;
	private var _str:String;
	private var _halfW:Float;
	private var _nextLevel:String;
	
	public function new(x:Float, y:Float, w:Int, h:Int, str:String, nextLevel:String) 
	{
		_str = str;
		_nextLevel = nextLevel;
		
		_txt = new Text(str, 0, 0, 0, 0, {color:0x000000});
		_txt.autoHeight = true;
		_txt.autoWidth = true;
		
		_bg = Image.createRect(_txt.width, _txt.height, 0xeeeeee);
		_halfW = _txt.width / 2;
		
		super(x, y, new Graphiclist([_bg, _txt]));
		setHitbox(w, h);
	}
	
	override public function update():Void 
	{
		super.update();
		
		var e:Entity = collide(EntityType.PLAYER, this.x, this.y);
		if (e != null) {
			_txt.visible = _bg.visible = true;
			
			this.graphic.x = e.centerX - this.x - _halfW;
			this.graphic.y = e.y - this.y - 60;
			
			if (_nextLevel != "") {
				if (Input.pressed(Player.CTRL_UP)) {
					
					if (_nextLevel == "1") {
						gotoWorld(new TestScene());
					} else if (_nextLevel == "0") {
						gotoWorld(new HubScene());
					}
					
					
					
				}
			}
			
			
			
		} else {
			_txt.visible = _bg.visible = false;
		}
	}
	
	private function gotoWorld(scene:Scene) {
		SoundFactory.getSound("Portal.wav").play();
		HXP.scene = scene;
	}
	
}