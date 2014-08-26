package se.salomonsson.ld30.scene;
import com.haxepunk.HXP;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.EyeEnemy;
import se.salomonsson.ld30.entities.MoneyHud;
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
	}
	
	override public function begin() 
	{
		super.begin();
		loadTileMap("assets/start_level.tmx", ["main", "main_fg"]);
		
		playBgLoop("8BitDreams");
		
		add(new EmitEntity());
		add(new MoneyHud());
		addPlayerAtPosition(new Player(), "start");
		HXP.screen.color = 0xcccccc;
	}
}