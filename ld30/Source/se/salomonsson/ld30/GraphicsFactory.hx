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
		
		//var img:Image;
		//#if flash
			//var bd:BitmapData = HXP.getBitmap("assets/gameobject_assets.png");
			//img = new Image(bd, rect32(x, y), name);
		//#else
			//var atlas:AtlasData = AtlasData.getAtlasDataByName("assets/gameobject_assets.png", false);
			//img = new Image(atlas.createRegion(rect32(x, y)), name);
		//#end
		//
		//_imgParts.set(name, img);
		
	}
	
	private function getImgPart(name:String):Image {
		var img:Image;
		#if flash
			var bd:BitmapData = HXP.getBitmap("assets/gameobject_assets.png");
			img = new Image(bd, _rect.get(name), name);
		#else
			var atlas:AtlasData = AtlasData.getAtlasDataByName("assets/gameobject_assets.png", false);
			img = new Image(atlas.createRegion(_rect.get(name), name));
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
		registerImgPart32("ninja-eyes", 3, 0);
		
		registerImgPart32("square1", 0, 1);
		registerImgPart32("square2", 1, 1);
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
		g.add2(instance.getImgPart("ninja-eyes"), 	true, "");
		return g;
	}
	
	public static function getGenericEnemyGraphic() {
		var g:DynamigGfxList = new DynamigGfxList();
		g.add2(instance.getImgPart("square2"), 		false, "");
		g.add2(instance.getImgPart("shade"), 		false, "");
		g.add2(instance.getImgPart("eye"), 			false, "eye");
		g.add2(instance.getImgPart("eye-close"),		false, "dmg");
		g.setGroupVisible("dmg", true);
		g.setGroupVisible("eye", false);
		return g;
	}
	
}