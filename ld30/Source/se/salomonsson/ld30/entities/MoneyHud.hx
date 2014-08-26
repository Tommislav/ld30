package se.salomonsson.ld30.entities;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import se.salomonsson.ld30.data.GameData;

/**
 * ...
 * @author Tommislav
 */
class MoneyHud extends Entity
{
	private var _txt:Text;
	
	
	public function new() 
	{
		super();
		_txt = new Text("", 10, 20);
		_txt.autoHeight = _txt.autoWidth = true;
		this.graphic = _txt;
		this.followCamera = true;
	}
	
	override public function update():Void 
	{
		super.update();
		_txt.text = "$ " + GameData.instance.money;
	}
	
}