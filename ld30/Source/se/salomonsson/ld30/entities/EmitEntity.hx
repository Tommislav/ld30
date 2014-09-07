package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Emitter;
import com.haxepunk.HXP;
import com.haxepunk.utils.Ease;

/**
 * ...
 * @author Tommislav
 */
class EmitEntity extends Entity
{
	public var emitter:Emitter;
	private var _e:Entity;
	
	
	public function new() 
	{
		emitter = new Emitter("assets/emitter-p.png", 16, 16);
		super(0, 0, emitter);
		this.name = "emitter";
		this.type = "emitter";
		collidable = false;
		
		emitter.newType("expl-s", [0]);
		emitter.setMotion("expl-s", 0, 50, 1, 360, 5, 0, Ease.sineOut);
		emitter.setAlpha("expl-s", 1, 0, Ease.sineOut);
		
		emitter.newType("expl-l", [0]);
		emitter.setMotion("expl-l", 0, 50, 1, 360, 5, 0, Ease.sineOut);
		emitter.setAlpha("expl-l", 1, 0, Ease.sineOut);
		
		emitter.newType("dashL", [0]);
		emitter.setMotion("dashL", -90, 20, 0.3, 180, 40, 0.1, Ease.sineOut);
		emitter.setAlpha("dashL", 1, 0, Ease.sineOut);
		
		emitter.newType("dashR", [0]);
		emitter.setMotion("dashR", 180-90, 20, 0.3, 180, 40, 0.1, Ease.sineOut);
		emitter.setAlpha("dashR", 1, 0, Ease.sineOut);
		
		emitter.newType("coin", [1]);
		emitter.setMotion("coin", 90-45, 64, 1, 90, 64, 1, Ease.circOut);
		emitter.setAlpha("coin", 1, 0);
		emitter.setGravity("coin", 1, 1);
		
		emitter.newType("splash", [2]);
		emitter.setMotion("splash", 90 - 20, 64, 1, 40, 14, 1, Ease.circOut);
		emitter.setAlpha("splash", 1, 0);
		emitter.setGravity("splash", 1, 1);
	}
	
	public function emit(name:String, num:Int, x:Float, y:Float, rX:Float=0, rY:Float=0) {
		
		HXP.scene.add(this);
		
		for (i in 0...num) {
			var eX = x;
			var eY = y;
			
			if (rX != 0) { eX += Math.random() * rX - (rX / 2); }
			if (rY != 0) { eY += Math.random() * rY - (rY / 2); }
			
			this.emitter.emit(name,x, y);
		}
	}
	
	override public function update():Void 
	{
		super.update();
	}
	
	public function destroy() {
		_e = null;
		emitter.destroy();
		HXP.scene.remove(this);
	}
	
}