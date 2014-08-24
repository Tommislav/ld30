package se.salomonsson.ld30.scene;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.Player;

/**
 * ...
 * @author Tommislav
 */
class IronScene extends GameBaseScene
{

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{	
		super.begin();
		loadTileMap("assets/iron_level.tmx", ["bg2", "bg", "main", "main_fg"]);
		
		
		add(new EmitEntity());
		
		var lastWorld:String = GameData.instance.lastWorld;
		addPlayerAtPosition(new Player(), lastWorld);
		HXP.screen.color = 0x000000;
		
		if (!GameData.instance.ironBossKilled) {
			playBgLoop("LDBossSong");
			GameData.instance.ironSpawnsKilled = 0;
		} else {
			playBgLoop("8BitDreams");
		}
	}
	
}