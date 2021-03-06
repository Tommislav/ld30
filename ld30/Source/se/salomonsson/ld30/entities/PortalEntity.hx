package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Joystick.XBOX_GAMEPAD;
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
	private var _id:String;
	private var _nextLevel:String;
	private var _lockId:String;
	
	public function new(x:Float, y:Float, w:Int, h:Int, id:String, str:String, nextLevel:String="", lockId:String="") 
	{
		_id = id;
		_nextLevel = nextLevel;
		_lockId = lockId;
		
		super(x, y, w, h, str);
	}
	
	override private function getLockedText():String 
	{
		if (_lockId == "exit") {
			var i:Int = 0;
			if (GameData.instance.fireLevelCompleted) i++;
			if (GameData.instance.mooseBossKilled) i++;
			if (GameData.instance.ironBossKilled) i++;
			
			return "LOCKED ("+i+"/3)";
		} else {
			return "LOCKED";
		}
		
	}
	
	override private function onPlayerTouching(player:Entity) 
	{
		if (_nextLevel != "") {
			
			var unlocked:Bool = true;
			
			if (_lockId != "") {
				unlocked = GameData.instance.isUnlocked(_lockId);
				showLockText(!unlocked);
			}
			
			if ((Input.pressed(Player.CTRL_ENTER_PORTAL) || Input.joystick(0).hat.y == 1) && unlocked) {
				SoundFactory.getSound("Portal.wav").play();
				GameData.instance.lastPassedPortalId = _id;
				GameData.instance.gotoWorld(_nextLevel);
				
				if (_lockId == "fire") {
					GameData.instance.fireLevelCompleted = true;
				}
				
			}
		}
	}
	
	
}