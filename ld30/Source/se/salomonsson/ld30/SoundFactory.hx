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
			if (url.indexOf(".") == -1) {
				url += ".mp3";
			}
		#else 
			if ( url.indexOf(".") == -1) {
				url += ".ogg";
			}
			
		#end
		
		var sfx:Sfx = new Sfx(url);
		return sfx;
	}
	
	private static var _bgLoop:Sfx;
	
	public static function playBgLoop(soundName:String):Sfx {
		stopBgLoop();
		_bgLoop = getSound(soundName);
		_bgLoop.loop();
		return _bgLoop;
	}
	
	public static function stopBgLoop() {
		if (_bgLoop != null) {
			_bgLoop.stop();
			_bgLoop = null;
		}
	}
	
}