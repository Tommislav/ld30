package se.salomonsson.ld30.scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.utils.Input;
import flash.geom.Point;
import flash.geom.Rectangle;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.SoundFactory;

/**
 * ...
 * @author Tommislav
 */
class ShopScene extends GameBaseScene
{
	private var _costNext:Text;
	private var _wallet:Text;
	private var _notAfford:Text;
	
	private var _clickRects:Array<Rectangle>;
	
	private var _thanksCountdown:Int;
	
	public function new() {super();}
	
	override public function begin() 
	{
		super.begin();
		var gfx = new Image("assets/shop.png");
		addGraphic(gfx);
		
		//var to:TextOptions
		_costNext = getText(GameData.instance.upgradeCost + " $", 519, 32);
		_wallet = getText(GameData.instance.money + " $", 240, 76);
		_notAfford = getText("YOU DON'T HAVE ENOUGH MONEY!", 130, 150, 0xa00000);
		
		if (GameData.instance.upgradeCost < GameData.instance.money) {
			_notAfford.visible = false;
		}
		
		_clickRects = new Array<Rectangle>();
		for (i in 0...6) {
			_clickRects.push(new Rectangle(42, 222 + (i * 50), 275, 40));
		}
		_clickRects.push(new Rectangle(42, 524, 420, 40));
		
		
		GameData.instance.lastPassedPortalId = "shop-hub";
	}
	
	private function getText(str:String, x:Float, y:Float, col:Int=0xffffff) {
		var t:Text = new Text(str, x, y);
		t.autoHeight = t.autoWidth = true;
		t.size = 28;
		t.color = col;
		addGraphic(t);
		return t;
	}
	
	
	override public function update() 
	{
		super.update();
		
		if (--_count > 0) {
			return;
		}
		
		if (Input.mousePressed) {
			var p:Point = new Point(Input.mouseX, Input.mouseY);
			for (i in 0..._clickRects.length) {
				if (_clickRects[i].containsPoint(p)) {
					checkClickItem(i);
				}
			}
		}
	}
	
	function checkClickItem(item:Int) 
	{
		if (item == 6) {
			// GET OUT
			HXP.scene = new HubScene();
			return;
		}
		
		var statusText:String = "";
		
		if (GameData.instance.money < GameData.instance.upgradeCost) {
			playFailSound();
			_notAfford.visible = true;
			_notAfford.text = "YOU DON'T HAVE ENOUGH MONEY";
			return;
		}
		
		switch (item) {
			case 0:
				// HEALTH
				GameData.instance.maxHealth += 5;
				GameData.instance.health = GameData.instance.maxHealth;
				statusText = "HEALTH FULLY RESTORED";
				
			case 1:
				// ATTACK STR
				if (GameData.instance.swordStr >= 2) {
					playFailSound();
					return;
				}
				GameData.instance.swordStr++;
				statusText = "ATK STR UPGRADED!";
				
			case 2:
				// ATTACK LENGTH
				if (GameData.instance.swordLength >= 100) {
					playFailSound();
					return;
				}
				GameData.instance.swordLength += 30;
				statusText = "ATK REACH UPGRADED!";
				
			case 3:
				// ATTACK SPEED
				if (GameData.instance.swordRecovery <= 200) {
					playFailSound();
					return;
				}
				GameData.instance.swordRecovery -= 100;
				statusText = "ATK SPEED UPGRADED!";
				
			case 4:
				// DASH LENGTH
				if (GameData.instance.dashSpeed >= 80) {
					playFailSound();
					return;
				}
				GameData.instance.dashSpeed += 10;
				statusText = "DASH LEN UPGRADED!";
				
			case 5:
				// DASH SPEED
				if (GameData.instance.dashRecoveryTime < 600) {
					playFailSound();
					return;
				}
				GameData.instance.dashRecoveryTime -= 50;
				statusText = "DASH SPEED UPGRADED!";
			
		}
		
		_notAfford.visible = true;
		_notAfford.text = statusText;
		GameData.instance.money -= GameData.instance.upgradeCost;
		GameData.instance.upgradeCost = Std.int(GameData.instance.upgradeCost * 1.5);
		_count = 60;
		_costNext.text = GameData.instance.upgradeCost + " $";
		_wallet.text = GameData.instance.money + " $";
		
		playBuySound();
	}
	
	
	function playBuySound() {
		SoundFactory.getSound("Portal.wav").play();
	}
	
	function playFailSound() {
		SoundFactory.getSound("Bounce.wav").play();
		_notAfford.visible = true;
		_notAfford.text = "SORRY, YOU ARE FULLY UPGRADED ON THAT";
	}
	
	
	
}