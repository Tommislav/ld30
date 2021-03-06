package se.salomonsson.ld30.scene;
import com.haxepunk.HXP;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.EyeEnemy;
import se.salomonsson.ld30.entities.MoneyHud;
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
		loadTileMap("assets/fire_level.tmx", ["bg2", "bg1", "main", "main_fg"], ["fg"]);
		
		playBgLoop("8BitDreams");
		
		add(new EmitEntity());
		add(new MoneyHud());
		addPlayerAtPosition(new Player(), GameData.instance.lastPassedPortalId);
		GraphicsFactory.setBackgroundColor(0x343434);
		
	}
	
}