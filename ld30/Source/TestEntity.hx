package ;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;

/**
 * ...
 * @author Tommislav
 */
class TestEntity extends Entity
{
	public function new() {
		super();
		
		var gfx = Image.createRect(32, 32, 0x00ff00);
		this.graphic = gfx;
		this.x = 80;
		this.y = 110;
	}
	
	override public function update():Void 
	{
		super.update();
		
	}
}