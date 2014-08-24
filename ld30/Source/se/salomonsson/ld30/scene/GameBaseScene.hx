package se.salomonsson.ld30.scene;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.tmx.TmxObjectGroup;
import se.salomonsson.ld30.entities.PortalEntity;
import se.salomonsson.ld30.SoundFactory;

/**
 * Loads map from tiled
 * @author Tommislav
 */
class GameBaseScene extends Scene
{
	private static var TILESHEET_URL:String = "assets/level_tilesheet.png";
	
	private var _mapData:TmxMap;
	private var _bgLayer:TmxEntity;
	private var _fgLayer:TmxEntity;
	
	private var _bgLoop:Sfx;
	
	public function new() {
		super();
	}
	
	public function loadTileMap(tiledFile:String, bgLayers:Array<String>, fgLayers:Array<String>=null) {
		
		_mapData = TmxMap.loadFromFile(tiledFile);
		_bgLayer = new TmxEntity(_mapData);
		
		#if debug
			bgLayers.push("collision");
		#end
		
		_bgLayer.loadGraphic(TILESHEET_URL, bgLayers);
		_bgLayer.loadMask("collision");
		_bgLayer.layer = HXP.BASELAYER + 2;
		
		add(_bgLayer);
		
		var obj:TmxObjectGroup = _mapData.getObjectGroup("obj");
		for (o in obj.objects) {
			if (o.type == "info") {
				var nextLevel:String = o.custom.has("level") ? o.custom.resolve("level") : "";
				add(new PortalEntity(o.x, o.y, o.width, o.height, o.custom.resolve("info"), nextLevel));
			}
		}
		
		
		if (fgLayers != null) {
			_fgLayer = new TmxEntity(_mapData);
			_fgLayer.loadGraphic(TILESHEET_URL, fgLayers);
			_fgLayer.layer = HXP.BASELAYER - 4;
			add(_fgLayer);
		}
		
	}
	
	public function playBgLoop(name:String) {
		_bgLoop = SoundFactory.getSound(name);
		_bgLoop.loop();
	}
	
	
	
	override public function end() 
	{
		super.end();
		if (_bgLoop != null) {
			_bgLoop.stop();
		}
	}
	
}