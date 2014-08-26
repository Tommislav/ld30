package se.salomonsson.ld30.entities;
import se.salomonsson.ld30.data.GameData;

/**
 * ...
 * @author Tommislav
 */
class IronBossHud extends Hud
{

	public function new() 
	{
		super(7, 583, 786, "ironBoss");
	}

	override public function update():Void 
	{
		super.update();
		var val:Float = GameData.instance.ironBossHP / GameData.instance.ironBossMaxHp;
		setValue(val);
		if (val == 0) {
			visible = false;
		}
	}
}