package se.salomonsson.ld30.scene;
import com.haxepunk.HXP;

/**
 * ...
 * @author Tommislav
 */
class SplashEndScreen extends SplashScreen
{

	public function new() 
	{
		super("assets/endscreen.jpg", null);
	}
	
	override private function nextScene() 
	{
		HXP.scene = new SplashStartScene();
	}
}