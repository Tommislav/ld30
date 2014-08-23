package ;

import com.haxepunk.Scene;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

/**
 * ...
 * @author Tommislav
 */
class TestScene extends Scene
{

	public function new() 
	{
		super();
		
	}
	
	override public function begin() 
	{
		super.begin();
		
		var mapData:TmxMap = TmxMap.loadFromFile("assets/test_level.tmx");
		var _map = new TmxEntity(mapData);
		
		var levelGfxArray = ["main"];
		#if debug
			levelGfxArray.push("collision");
		#end
		
		
		_map.loadGraphic("assets/level_tilesheet.png", levelGfxArray);
		_map.loadMask("collision");
		
		
		add(new TestEntity());
		add(_map);
	}
	
}