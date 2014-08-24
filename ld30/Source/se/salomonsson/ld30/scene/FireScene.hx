package se.salomonsson.ld30.scene;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.EyeEnemy;
import se.salomonsson.ld30.entities.Player;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class FireScene extends GameBaseScene
{

	public function new() 
	{
		super();
	}
	
	override public function begin() 
	{
		super.begin();
		loadTileMap("assets/test_level.tmx", ["main", "main_fg"], ["fg"]);
		
		playBgLoop("8BitDreams");
		
		add(new EmitEntity());
		add(new Player());
		add(new EyeEnemy(100, 10, 1));
		add(new EyeEnemy(200, 10, 1));
		
	}
	
}