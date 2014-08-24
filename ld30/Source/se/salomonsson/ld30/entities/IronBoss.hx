package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.HXP;
import flash.geom.Rectangle;
import se.salomonsson.ld30.data.GameData;
import se.salomonsson.ld30.gfx.DynamigGfxList;
import se.salomonsson.ld30.GraphicsFactory;

/**
 * ...
 * @author Tommislav
 */
class IronBoss extends EnemyBase
{
	private var _gfx:DynamigGfxList;
	private var _dirX:Int;
	private var _dirY:Int;
	private var _speed:Float;
	private var _collisionPause:Int;
	private var _size:Int;
	private var _life:Int;
	
	public function new(x:Float, y:Float, size:Int, money:Int, dirX:Int=0, dirY:Int=0, life:Int=0) 
	{
		if (size == 0) {
			_gfx = GraphicsFactory.instance.getIronBouncerLarge();
			setHitbox(256, 256);
			_speed = 4;
			
		} else if (size == 1) {
			_gfx = GraphicsFactory.instance.getIronBouncerMedium();
			setHitbox(128, 128);
			_speed = 6;
		} else {
			_gfx = GraphicsFactory.instance.getIronBouncerSmall();
			setHitbox(64, 64);
			_speed = 4;
		}
		_size = size;
		_life = life;
		
		_dirX = dirX;
		if (_dirX == 0) {
			_dirX = Math.random() < 0.5 ? -1 : 1;
		}
		
		_dirY = dirY;
		if (_dirY == 0) {
			_dirY = Math.random() < 0.5 ? -1 : 1;
		}
		
		super(x, y, _gfx, width, height, money);
		_hp = 2;
	}
	
	override public function wantsToUpdate(cameraBounds:Rectangle):Bool { return true; }
	
	override private function postUpdate() 
	{
		if (_life > 0) {
			if (--_life <= 0) {
				// SELF DESTRUCT - no coins
				_hp = 0;
				onKilled();
			}
		}
	}
	
	override private function updatePhysics() 
	{
		if (_collisionPause > 0) {
			_collisionPause--;
			return;
		}
		moveBy(_dirX * _speed, _dirY * _speed, "solid");
	}
	
	override public function moveCollideX(e:Entity):Bool 
	{
		_dirX = -_dirX;
		_collisionPause = 10;
		return true;
	}
	
	override public function moveCollideY(e:Entity):Bool 
	{
		_dirY = -_dirY;
		_collisionPause = 10;
		return true;
	}
	
	override private function spawnCoins() 
	{
		if (_size == 2) {
			super.spawnCoins();
		}
	}
	
	override private function onKilled() {
		
		if (_size == 0 || _size == 1) {
			var off = (_size == 0) ? 128 / 2 : 64 / 2;
			if (_size == 0) {
				HXP.scene.add( new IronBoss(centerX - off, centerY - off, _size + 1, _money, -1, 0) );
				HXP.scene.add( new IronBoss(centerX - off, centerY - off, _size + 1, _money, 1, 0) );
			} else {
				HXP.scene.add( new IronBoss(centerX - off, centerY - off, _size + 1, _money, -1, 1, Std.int(Math.random() * 400+400)) );
				HXP.scene.add( new IronBoss(centerX - off, centerY - off, _size + 1, _money, 1, 1, Std.int(Math.random() * 400+400)) );
				HXP.scene.add( new IronBoss(centerX - off, centerY - off, _size + 1, _money, -1, -1, Std.int(Math.random() * 400+400)) );
				HXP.scene.add( new IronBoss(centerX - off, centerY - off, _size + 1, _money, 1, -1, Std.int(Math.random() * 400+400)) );
			}
			
		}
		
		if (_size == 2) {
			GameData.instance.ironSpawnsKilled++;
			trace("KILLED: " + GameData.instance.ironSpawnsKilled);
			if (GameData.instance.ironSpawnsKilled == 8) {
				GameData.instance.ironBossKilled;
				SoundFactory.playBgLoop("8BitDreams");
			}
		}
		
		super.onKilled();
	}
	
	
	
}