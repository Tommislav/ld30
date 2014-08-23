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
	public var moveSpeed:Float = 1;
	public var gravity:Float = 1;
	public var moveFriction:Float = 0.9;
	
}