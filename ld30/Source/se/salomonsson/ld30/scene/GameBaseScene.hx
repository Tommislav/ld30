package se.salomonsson.ld30.scene;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.tmx.TmxObject;
import com.haxepunk.tmx.TmxObjectGroup;
import flash.geom.Point;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.BounceEntity;
import se.salomonsson.ld30.entities.CoinEntity;
import se.salomonsson.ld30.entities.EyeEnemy;
import se.salomonsson.ld30.entities.EyeEnemy2;
import se.salomonsson.ld30.entities.InfoEntity;
import se.salomonsson.ld30.entities.IronBoss;
import se.salomonsson.ld30.entities.LargeShieldEntity;
import se.salomonsson.ld30.entities.Lava;
import se.salomonsson.ld30.entities.MooseBoss;
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
	private var _playerEntryPoints:Map<String,Point>;
	
	public function new() {
		super();
		_playerEntryPoints = new Map();
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
			if (o.type == "start") {
				var key:String = o.custom.has("from") ? o.custom.resolve("from") : "";
				_playerEntryPoints.set(key, new Point(o.x, o.y));
			}
			
			if (o.type == "portal") {
				var nextLevel:String 	= o.custom.has("level") 	? o.custom.resolve("level") 	: "";
				var lockId:String 		= o.custom.has("locked") 	? o.custom.resolve("locked") 	: "";
				add(new PortalEntity(o.x, o.y, o.width, o.height, o.custom.resolve("info"), nextLevel, lockId));
			}
			
			if (o.type == "info") {
				add(new InfoEntity(o.x, o.y, o.width, o.height, o.custom.resolve("info")));
			}
			
			if (o.type == "coin") {
				add(new CoinEntity(o.x, o.y, 1, false));
			}
			
			if (o.type == "bouncer") {
				add(new BounceEntity(o.x, o.y, o.width, o.height));
			}
			
			if (o.type == "enemy") {
				var enemyType:String = o.custom.resolve("id");
				var maxMoney:Int = (o.custom.has("money")) ? Std.parseInt(o.custom.resolve("money")) : 0;
				spawnEnemy(enemyType, o.x, o.y, maxMoney, o);
			}
		}
		
		
		if (fgLayers != null) {
			_fgLayer = new TmxEntity(_mapData);
			_fgLayer.loadGraphic(TILESHEET_URL, fgLayers);
			_fgLayer.layer = HXP.BASELAYER - 4;
			add(_fgLayer);
		}
	}
	
	function addPlayerAtPosition(e:Entity, from:String = "") {
		
		
		var p:Point;
		
		if (_playerEntryPoints.exists(from)) {
			p = _playerEntryPoints.get(from);
		} else {
			p = _playerEntryPoints.iterator().next();
		}
		
		e.x = p.x;
		e.y = p.y;
		
		add(e);
	}
	
	function spawnEnemy(enemyType:String, x:Float, y:Float, maxMoney:Int, obj:TmxObject) {
		switch(enemyType) {
			case "eye":
				add(new EyeEnemy(x, y, maxMoney));
			case "eye2":
				add(new EyeEnemy2(x, y, Std.parseFloat(obj.custom.resolve("dist")), maxMoney));
			case "shield":
				add(new LargeShieldEntity(x, y));
			case "moose":
				if (!GameData.instance.mooseBossKilled) {
					add(new MooseBoss(x,y));
				}
			case "ironboss":
				add(new IronBoss(x, y, 0, 1));
			case "lava":
				add(new Lava(x,y,obj.width, obj.height));
		}
	}
	
	public function playBgLoop(name:String) {
		_bgLoop = SoundFactory.playBgLoop(name);
	}
	
	
	
	override public function end() 
	{
		super.end();
		//SoundFactory.stopBgLoop();
	}
	
}