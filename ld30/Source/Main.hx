package;


import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine {
	
	
	public function new () {
		super ();
	}
	
	override public function init() {
		super.init();
		
		HXP.scene = new TestScene();
	}
	
}