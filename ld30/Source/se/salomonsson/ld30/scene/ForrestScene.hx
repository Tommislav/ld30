package se.salomonsson.ld30.scene;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.MoneyHud;
import se.salomonsson.ld30.entities.MooseBoss;
import se.salomonsson.ld30.entities.Player;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class ForrestScene extends GameBaseScene
{

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		super.begin();
		loadTileMap("assets/forest_level.tmx", ["moon","bg2", "bg", "main", "main_fg"]);
		
		
		add(new EmitEntity());
		add(new MoneyHud());
		
		var lastWorld:String = GameData.instance.lastWorld;
		addPlayerAtPosition(new Player(), lastWorld);
		GraphicsFactory.setBackgroundColor(0x18238b);
		
		if (!GameData.instance.mooseBossKilled) {
			playBgLoop("LDBossSong");
		} else {
			playBgLoop("8BitDreams");
		}
		
	}
	
}