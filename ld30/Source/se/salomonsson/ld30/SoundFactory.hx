package se.salomonsson.ld30;
import com.haxepunk.Sfx;

/**
 * ...
 * @author Tommislav
 */
class SoundFactory
{

	public function new() {}
	
	public static function getSound(soundName:String):Sfx {
		var url:String = "audio/" + soundName;
		
		#if flash
			url += ".mp3";
		#else 
			url += ".ogg";
		#end
		
		var sfx:Sfx = new Sfx(url);
		return sfx;
	}
	
}