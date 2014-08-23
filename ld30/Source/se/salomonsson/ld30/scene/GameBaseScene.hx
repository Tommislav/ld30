package se.salomonsson.ld30.scene;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

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
		
		
		if (fgLayers != null) {
			_fgLayer = new TmxEntity(_mapData);
			_fgLayer.loadGraphic(TILESHEET_URL, fgLayers);
			_fgLayer.layer = HXP.BASELAYER - 4;
			add(_fgLayer);
		}
		
	}
	
}