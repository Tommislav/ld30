package;


import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import flash.ui.Keyboard;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.Player;


class Main extends Engine {
	
	
	public function new () {
		super ();
	}
	
	override public function init() {
		super.init();
		
		#if debug
			HXP.console.enable();
			HXP.console.show();
			HXP.console.toggleKey = Keyboard.NUMBER_0;
			HXP.volume = 0;
		#end
		
		// DEFINE INPUT
		Input.define(Player.CTRL_LEFT, [Keyboard.LEFT]);
		Input.define(Player.CTRL_RIGHT, [Keyboard.RIGHT]);
		Input.define(Player.CTRL_UP, [Keyboard.UP]);
		Input.define(Player.CTRL_DOWN, [Keyboard.DOWN]);
		Input.define(Player.CTRL_ATK, [Keyboard.X]);
		Input.define(Player.CTRL_DASH_LEFT, [Keyboard.Z]);
		Input.define(Player.CTRL_DASH_RIGHT, [Keyboard.C]);
		Input.define(Player.CTRL_JUMP, [Keyboard.SPACE]);
		
		
		GameData.resetGameData();
		
		
		HXP.screen.color = 0xcccccc;
		HXP.scene = new TestScene();
	}
	
}