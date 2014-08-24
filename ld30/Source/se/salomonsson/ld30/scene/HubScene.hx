package se.salomonsson.ld30.scene;
import se.salomonsson.ld30.entities.EmitEntity;
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
		add(new Player());
	}
	
}