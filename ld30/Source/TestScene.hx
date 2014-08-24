package ;

import com.haxepunk.graphics.Emitter;
import com.haxepunk.Scene;
import com.haxepunk.Sfx;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import se.salomonsson.ld30.entities.EmitEntity;
import se.salomonsson.ld30.entities.EnemyBase;
import se.salomonsson.ld30.entities.EyeEnemy;
import se.salomonsson.ld30.entities.PortalEntity;
import se.salomonsson.ld30.entities.Player;
import se.salomonsson.ld30.EntityType;
import se.salomonsson.ld30.GraphicsFactory;
import se.salomonsson.ld30.scene.GameBaseScene;
import se.salomonsson.ld30.SoundFactory;
	

/**
 * ...
 * @author Tommislav
 */
class TestScene extends GameBaseScene
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
		add(new Player(10,10));
		add(new EyeEnemy(100, 10, GraphicsFactory.getGenericEnemyGraphic()));
		add(new EyeEnemy(200, 10, GraphicsFactory.getGenericEnemyGraphic()));
		
	}
	
}