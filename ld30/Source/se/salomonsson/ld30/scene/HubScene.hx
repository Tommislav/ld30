package se.salomonsson.ld30.scene;
import com.haxepunk.HXP;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.MoneyHud;
import se.salomonsson.ld30.entities.Player;

/**
 * ...
 * @author Tommislav
 */
class HubScene extends GameBaseScene
{

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		super.begin();
		loadTileMap("assets/hub_level.tmx", ["main", "main_fg"]);
		playBgLoop("8BitDreams");
		
		add(new EmitEntity());
		add(new MoneyHud());
		
		HXP.screen.color = 0x808080;
		var lastWorld:String = GameData.instance.lastWorld;
		addPlayerAtPosition(new Player(), lastWorld);
		
	}
	
}