package se.salomonsson.ld30;

/**
 * ...
 * @author Tommislav
 */
class SPlayer
{
	public static function playSFX(name:String) {
		SoundFactory.getSound(name).play();
	}
	
	
	public function new() 
	{
		
	}
	
}