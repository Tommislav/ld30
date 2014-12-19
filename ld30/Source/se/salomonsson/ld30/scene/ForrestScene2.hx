package se.salomonsson.ld30.scene;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.MoneyHud;
import se.salomonsson.ld30.entities.Player;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class ForrestScene2 extends GameBaseScene
{

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		super.begin();
		loadTileMap("assets/forest_level2.tmx", ["moon","bg2", "bg", "main", "main_fg"]);
		
		
		add(new EmitEntity());
		add(new MoneyHud());
		
		addPlayerAtPosition(new Player(), GameData.instance.lastPassedPortalId);
		GraphicsFactory.setBackgroundColor(0x18238b);
	}
	
}