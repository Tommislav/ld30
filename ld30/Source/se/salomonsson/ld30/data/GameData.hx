package se.salomonsson.ld30.data;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import se.salomonsson.ld30.scene.FireScene;
import se.salomonsson.ld30.scene.ForrestScene;
import se.salomonsson.ld30.scene.HubScene;
import se.salomonsson.ld30.scene.IronScene;
import se.salomonsson.ld30.scene.ShopScene;
import se.salomonsson.ld30.scene.StartScenee;

/**
 * Class that keeps all the game related data between levels.
 * @author Tommislav
 */
class GameData
{
	public static var instance:GameData;

	public static function resetGameData() {
		instance = new GameData();
	}
	
	public function new() {	
		lock = new Map();
		currentWorld = "";
		lastWorld = "";
	}
	
	public var maxSpeed:Float = 6;
	public var maxFall:Float = 14;
	public var moveSpeed:Float = 0.2;
	public var moveStaggering:Int = 400;
	public var gravity:Float = 1;
	public var moveFriction:Float = 0.8;
	public var jumpStr:Float = 60;
	
	public var dashSpeed:Float = 40;
	public var dashRecoveryTime:Int = 800;
	
	public var swordStr:Int = 1;
	public var swordLength:Int = 65;
	public var swordRecovery:Int = 500;
	
	public var health:Int = 100;
	public var maxHealth:Int = 100;
	
	public var money:Int = 0;
	
	public var lock:Map<String, Bool>;
	
	
	
	
	public var currentWorld:String;
	public var lastWorld:String;
	
	
	public function unlock(key:String) {
		
	}
	
	public function isUnlocked(key:String):Bool {
		return true;
	}
	
	public function gotoWorld(id:String) {
		lastWorld = currentWorld;
		currentWorld = id;
	
		HXP.scene = getWorldFromId(id);
	}
	
	public function getSpawnMoney(maxMoney:Int) 
	{
		return maxMoney;
	}
	
	private function getWorldFromId(id:String):Scene {
		switch(id) {
			case "0":
				return new StartScenee();
			case "1":
				return new HubScene();
			case "2":
				return new ShopScene();
			case "3":
				return new FireScene();
			case "4":
				return new ForrestScene();
			case "5":
				return new IronScene();
		}
		return new StartScenee();
	}
	
}