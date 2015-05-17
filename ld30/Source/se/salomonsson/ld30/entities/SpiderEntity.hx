package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class SpiderEntity extends EnemyBase
{

	private var _gfx:DynamigGfxList;
	private var _startY:Float;
	private var _targetY:Float;
	private var _currentFrame:String = "1";
	
	private var _frameCount:Int;
	private var _pauseCount:Int;
	private var _attackDir:Float;
	private var _attackSpeed:Float;
	private var _isAttacking:Bool;
	
	public function new(x:Float, y:Float, maxMoney:Int=1, targetY:Float) {
		_gfx = GraphicsFactory.getSpiderEnemyGraphic();
		super(x, y, _gfx, 64, 32, maxMoney);
		
		_startY = y;
		_targetY = targetY;
		_hp = 1;
		
		_pauseCount = 120;
		_frameCount = 0;
	}
	
	override private function postUpdate() 
	{
		if (--_frameCount < 0 ) {
			_frameCount = 16;
			_gfx.setGroupVisible(_currentFrame, false);
			_currentFrame = (_currentFrame == "1") ? "2" : "1";
			_gfx.setGroupVisible(_currentFrame, true);
		}
		
		if (_isAttacking) {
			moveBy(0, _attackSpeed * _attackDir, "");
			
			if (_attackDir == 1 && this.y > _targetY) {
				_attackDir = -1;
				_attackSpeed = 1;
			}
			
			if (_attackDir == -1 && this.y < _startY ) {
				_isAttacking = false;
			}
			
			
		} else {
			var player:Entity = HXP.scene.getInstance("player");
			var dist = Math.abs(player.centerX - centerX);
			if (dist < 64) {
				_attackDir = 1;
				_attackSpeed = 8;
				_isAttacking = true;
			}
		}
	}
	
	override private function onKilled() {
		super.onKilled();
		emit("expl-l", 40, centerX, centerY, 64 , 64);
	}
}