package se.salomonsson.ld30;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.atlas.AtlasData;
import com.haxepunk.graphics.atlas.AtlasRegion;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.prototype.Rect;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.HXP;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.Assets;
import se.salomonsson.ld30.gfx.DynamigGfxList;

/**
 * ...
 * @author Tommislav
 */
class GraphicsFactory
{
	
	//private var _imgParts:Map<String, Graphic>;
	
	private var _rect:Map<String, Rectangle>;
	
	
	
	public static var instance:GraphicsFactory;
	public static function init() {
		instance = new GraphicsFactory();
	}
	
	private function rect32(i, j):Rectangle {
		return new Rectangle(i * 32, j * 32, 32, 32);
	}
	
	private function registerImgPart32(name:String, x:Int, y:Int) {
		_rect.set(name, rect32(x, y));
	}
	
	private function getImgPart(name:String):Image {
		var img:Image;
		#if flash
			var bd:BitmapData = HXP.getBitmap("assets/gameobject_assets.png");
			img = new Image(bd, _rect.get(name), name);
		#else
			var atlas:AtlasData = AtlasData.getAtlasDataByName("assets/gameobject_assets.png", false);
			img = new Image(atlas.createRegion(_rect.get(name), new Point()), null, name);
		#end
		return img;
	}
	
	
	public function new() 
	{
		_rect = new Map();
		
		#if !flash
			var atlas:AtlasData = AtlasData.getAtlasDataByName("assets/gameobject_assets.png", true);
		#end
		
		registerImgPart32("eye", 5, 0);
		registerImgPart32("eye-close", 6, 0);
		registerImgPart32("shade", 1, 0);
		registerImgPart32("ninja", 2, 0);
		registerImgPart32("ninja-eyes1", 3, 0);
		registerImgPart32("ninja-eyes2", 4, 0);
		
		registerImgPart32("coin1", 7, 0);
		registerImgPart32("coin2", 8, 0);
		registerImgPart32("coin3", 9, 0);
		registerImgPart32("coin4", 10, 0);
		
		registerImgPart32("square1", 0, 1);
		registerImgPart32("square2", 1, 1);
		
		
		registerImgPart32("large-eyes1", 11, 0);
		registerImgPart32("large-eyes2	", 12, 0);
		
		// Free form images registration
		_rect.set("shade32x96", new Rectangle(13 * 32, 0, 32, 96));
		_rect.set("shield96", new Rectangle(14 * 32, 0, 32, 96));
	}
	
	
	
	public static function getColoredRectangle(width:Int, height:Int, color:Int) {
		var rect = Image.createRect(width, height, color);
		return rect;
	}

	public static function getPlayerGraphic() {
		var g:DynamigGfxList = new DynamigGfxList();
		g.add2(instance.getImgPart("square1"), 		false, "");
		g.add2(instance.getImgPart("shade"), 		false, "");
		g.add2(instance.getImgPart("ninja"), 		true, "");
		g.add2(instance.getImgPart("ninja-eyes1"), 	true, "normal");
		g.add2(instance.getImgPart("ninja-eyes2"), 	true, "dmg");
		g.setGroupVisible("dmg", false);
		
		return g;
	}
	
	public static function getGenericEnemyGraphic() {
		var g:DynamigGfxList = new DynamigGfxList();
		g.add2(instance.getImgPart("square2"), 		false, "");
		g.add2(instance.getImgPart("shade"), 		false, "");
		g.add2(instance.getImgPart("eye"), 			false, "eye");
		g.add2(instance.getImgPart("eye-close"),	false, "dmg");
		g.setGroupVisible("dmg", true);
		g.setGroupVisible("eye", false);
		return g;
	}
	
	
	static public function getCoinGraphic() 
	{
		var g:DynamigGfxList = new DynamigGfxList();
		g.add2(instance.getImgPart("coin1"), false, "");
		g.add2(instance.getImgPart("coin2"), false, "");
		g.add2(instance.getImgPart("coin3"), false, "");
		g.add2(instance.getImgPart("coin4"), false, "");
		return g;
	}
	
	public function getLargeShiledGfx() 
	{
		var g:DynamigGfxList = new DynamigGfxList();
		g.add2(getColoredRectangle(32, 96, 0xfcd600), false, "");
		g.add2(getImgPart("shade32x96"), false, "");
		g.add2(instance.getImgPart("large-eyes1"), false, "");
		var shield:Image = instance.getImgPart("shield96");
		shield.x = 10;
		g.add2(shield, false, "");
		return g;
	}
	
	
	
	
	
}