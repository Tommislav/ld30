package se.salomonsson.ld30.scene;

import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.tweens.misc.VarTween;
import com.haxepunk.utils.Ease;
import com.haxepunk.utils.Input;

/**
 * ...
 * @author Tommislav
 */
class SplashScreen extends Scene
{
	private var _countdown:Int;
	private var _countdown2:Int;
	private var _asset:String;
	private var _next:Scene;
	private var _clicked:Bool;
	private var _img:Image;

	public function new(asset:String, next:Scene) 
	{
		super();
		_asset = asset;
		_next = next;
	}
	
	override public function begin() 
	{
		_img = new Image(_asset);
		_img.alpha = 0;
		addGraphic(_img);
		_countdown = 10;
		super.begin();
	}
	
	
	override public function update()
	{
		super.update();
		
		if (_countdown > 0) {
			_countdown--;
			if (_countdown == 0) {
				fadeIn();
			}
		}
		
		if (!_clicked && _countdown == 0) {
			if (Input.mousePressed) {
				_clicked = true;
				_countdown2 = 10;
			}
		}
		
		if (_clicked) {
			if (--_countdown2 <= 0) {
				nextScene();
			}
		}
	}
	
	function nextScene() 
	{
		HXP.scene = _next;
	}
	
	function fadeIn() 
	{
		
		var t:VarTween = new VarTween();
		t.tween(_img, "alpha", 1, 2, Ease.sineOut);
		addTween(t, true);
	}
	
}