package;


import com.haxepunk.Engine;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import flash.ui.Keyboard;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.Player;
import se.salomonsson.ld30.GraphicsFactory;
import se.salomonsson.ld30.scene.FireScene;
import se.salomonsson.ld30.scene.ForrestScene;
import se.salomonsson.ld30.scene.HubScene;
import se.salomonsson.ld30.scene.IronScene;
import se.salomonsson.ld30.scene.ShopScene;
import se.salomonsson.ld30.scene.SplashEndScreen;
import se.salomonsson.ld30.scene.SplashScreen;
import se.salomonsson.ld30.scene.SplashStartScene;
import se.salomonsson.ld30.scene.StartScenee;


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
		Input.define(Player.CTRL_LEFT, [Keyboard.LEFT, Keyboard.A]);
		Input.define(Player.CTRL_RIGHT, [Keyboard.RIGHT, Keyboard.D]);
		Input.define(Player.CTRL_UP, [Keyboard.UP, Keyboard.W]);
		Input.define(Player.CTRL_DOWN, [Keyboard.DOWN, Keyboard.S]);
		Input.define(Player.CTRL_ATK, [Keyboard.SPACE]);
		//Input.define(Player.CTRL_DASH_LEFT, [Keyboard.Z]);
		//Input.define(Player.CTRL_DASH_RIGHT, [Keyboard.C]);
		Input.define(Player.CTRL_JUMP, [Keyboard.UP, Keyboard.W]);
		Input.define(Player.CTRL_ENTER_PORTAL, [Keyboard.DOWN, Keyboard.S]);
		
		GraphicsFactory.init();
		GameData.resetGameData();
		
		
		HXP.screen.color = 0xffffff;
		//HXP.scene = new SplashStartScene();
		HXP.scene = new ShopScene();
	}
	
	public function changeLevel(name:String) 
	{
		GameData.instance.gotoWorld(name);
		
	}
	
}