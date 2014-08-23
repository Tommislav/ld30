package se.salomonsson.ld30;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

/**
 * ...
 * @author Tommislav
 */
class GraphicsFactory
{

	public function new() 
	{
		
	}
	
	public static function getColoredRectangle(width:Int, height:Int, color:Int) {
		var rect = Image.createRect(width, height, color);
		return rect;
	}

	public static function getPlayerGraphic() {
		return getColoredRectangle(32, 32, 0xcc0000);
	}
	
	public static function getGenericEnemyGraphic() {
		return getColoredRectangle(32, 32, 0xce7c07);
	}
	
}