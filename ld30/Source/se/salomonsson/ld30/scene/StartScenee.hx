package se.salomonsson.ld30.scene;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.EyeEnemy;
import se.salomonsson.ld30.entities.Player;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class StartScenee extends GameBaseScene
{

	public function new() 
	{
		super();
		super.begin();
		loadTileMap("assets/start_level.tmx", ["main", "main_fg"]);
		
		playBgLoop("8BitDreams");
		
		add(new EmitEntity());
		add(new Player( 26*16, 10*16 ));
		//add(new EyeEnemy(100, 10, GraphicsFactory.getGenericEnemyGraphic()));
		//add(new EyeEnemy(200, 10, GraphicsFactory.getGenericEnemyGraphic()));
	}
	
}