package se.salomonsson.ld30.scene;
import se.salomonsson.ld30.data.GameData;

/**
 * ...
 * @author Tommislav
 */
class SplashStartScene extends SplashScreen
{

	public function new() 
	{
		super("assets/startscreen.jpg", new StartScenee());
	}
	
	override public function begin() 
	{
		super.begin();
		GameData.resetGameData();
	}
	
}