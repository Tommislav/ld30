package se.salomonsson.ld30.entities;

import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.Mask;
import flash.display.BitmapData;
import flash.geom.Point;
import se.salomonsson.ld30.EntityType;

/**
 * The fist
 * while punching we should sweep for hitting walls or enemies
 * while detracting, we should not sweep
 * @author $(DefaultUser)
 */
class Punch extends Entity
{
	private var _source:BitmapData;
	private var _joint:Point;
	
	public function new() 
	{
		collidable = true;
		this.name = "sword";
		this.type = EntityType.ATK;
		
		_joint = new Point();
		
		var g = Image.createRect(20, 20, 0xFFFFFFFF, 1);
		g.centerOrigin();
		g.color = 0x0000ff;
		
		super(0, 0, g, mask);
		
	}
	
	public function setJointPosition(x, y) {
		_joint.x = x;
		_joint.y = y;
		this.x = x;
		this.y = y;
	}
	
	public function getIsPunching() {
		
	}
	
	// if punching - check if hitting an enemy or hittable object
	// transfer velocity from fist to enemy
	
	public function smallPunch() {
		
	}
	
	public function largePunch() {
		
	}
	
	public function uppercut() {
		
	}
	
	public function smashDown() {
		
	}
	
	
}