package se.salomonsson.ld30.scene;

import com.haxepunk.HXP;
import com.haxepunk.Scene;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.IronBossHud;
import se.salomonsson.ld30.entities.MoneyHud;
import se.salomonsson.ld30.entities.Player;
import se.salomonsson.ld30.GraphicsFactory;

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
		add(new MoneyHud());
		
		addPlayerAtPosition(new Player(), GameData.instance.lastPassedPortalId);
		GraphicsFactory.setBackgroundColor(0x000000);
		
		if (!GameData.instance.ironBossKilled) {
			
			GameData.instance.ironBossHP = GameData.instance.ironBossMaxHp;
			GameData.instance.ironSpawnsKilled = 0;
			
			playBgLoop("LDBossSong");
			add(new IronBossHud());
			
		} else {
			playBgLoop("8BitDreams");
		}
	}
	
}