package se.salomonsson.ld30.data;

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
	
	
	
	//public var 
	
}