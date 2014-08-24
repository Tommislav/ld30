package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.scene.HubScene;
import se.salomonsson.ld30.SoundFactory;

/**
 * ...
 * @author Tommislav
 */
class PortalEntity extends InfoEntity
{
	private var _nextLevel:String;
	var _lockId:String;
	
	public function new(x:Float, y:Float, w:Int, h:Int, str:String, nextLevel:String="", lockId:String="") 
	{
		super(x, y, w, h, str);
		
		_nextLevel = nextLevel;
		_lockId = lockId;
	}
	
	
	override private function onPlayerTouching(player:Entity) 
	{
		if (_nextLevel != "") {
			
			var unlocked:Bool = true;
			if (_lockId != "") {
				unlocked = GameData.instance.isUnlocked(_lockId);
			}
			
			if (Input.pressed(Player.CTRL_ENTER_PORTAL)) {
				SoundFactory.getSound("Portal.wav").play();
				GameData.instance.gotoWorld(_nextLevel);
				
			}
		}
	}
	
	
}