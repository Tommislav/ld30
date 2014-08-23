package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

/**
 * ...
 * @author Tommislav
 */
class TestEntity extends Entity
{
	public function new() {
		super();
		
		var gfx = Image.createRect(32, 32, 0xff0000);
		this.graphic = gfx;
		this.x = 10;
		this.y = 20;
	}
	
	override public function update():Void 
	{
		super.update();
		
	}
}