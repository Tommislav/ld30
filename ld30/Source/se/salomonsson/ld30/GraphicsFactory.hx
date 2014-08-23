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
	
	private var _imgParts:Map<String, Graphic>;
	
	
	public static var instance:GraphicsFactory;
	public static function init() {
		instance = new GraphicsFactory();
	}
	
	private function rect32(i, j):Rectangle {
		return new Rectangle(i * 32, j * 32, 32, 32);
	}
	
	private function registerImgPart32(name:String, x:Int, y:Int) {
		var img:Image;
		#if flash
			var bd:BitmapData = HXP.getBitmap("assets/gameobject_assets.png");
			img = new Image(bd, rect32(x, y), name);
		#else
			var atlas:AtlasData = AtlasData.getAtlasDataByName("assets/gameobject_assets.png", false);
			img = new Image(atlas.createRegion(rect32(x, y)), name);
		#end
		
		_imgParts.set(name, img);
		
	}
	
	
	public function new() 
	{
		_imgParts = new Map();
		
		#if !flash
			var atlas:AtlasData = AtlasData.getAtlasDataByName("assets/gameobject_assets.png", true);
		#end
		
		registerImgPart32("eye", 0, 0);
		registerImgPart32("shade", 1, 0);
		registerImgPart32("ninja", 2, 0);
		registerImgPart32("ninja-eye", 3, 0);
	}
	
	
	
	public static function getColoredRectangle(width:Int, height:Int, color:Int) {
		var rect = Image.createRect(width, height, color);
		return rect;
	}

	public static function getPlayerGraphic() {
		var g:DynamigGfxList = new DynamigGfxList();
		//g.add2(getColoredRectangle(32, 32, 0xcc0000), false, "");
		g.add2(instance._imgParts.get("shade"), false, "");
		g.add2(instance._imgParts.get("ninja"), true, "");
		g.add2(instance._imgParts.get("ninja-eyes"), true, "");
		return g;
	}
	
	public static function getGenericEnemyGraphic() {
		return getColoredRectangle(32, 32, 0xce7c07);
	}
	
}