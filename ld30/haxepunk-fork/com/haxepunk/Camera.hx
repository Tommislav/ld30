package com.haxepunk;

import flash.geom.Point;

/**
 * ...
 * @author Tommislav
 */
class Camera extends Point {
	
	private var _originalX:Float;
	private var _originalY:Float;
	private var _shakeX:Float;
	private var _shakeY:Float;
	private var _rX:Float;
	private var _rY:Float;
	private var _shakeCount:Int;
	private var _smooth:Float;

	public function new(x:Float=0, y:Float=0) {
		super(x, y);
		_shakeX = _shakeY = 0;
	}
	
	public function update() {
		if (_shakeCount > 0) {
			_shakeCount--;
			
			if (_shakeCount == 0) { // RESTORE!
				
				this.x = _originalX;
				this.y = _originalY;
				_shakeX = _shakeY = 0;
				
			} else {
				
				_originalX = this.x - _shakeX;
				_originalY = this.y - _shakeY;
				
				_shakeX = Math.random() * _rX;
				_shakeY = Math.random() * _rY;
				
				this.x = _originalX + _shakeX;
				this.y = _originalY + _shakeY;
				
				_rX *= _smooth;
				_rY *= _smooth;
			}
		}
	}
	
	
	public function shake(x:Float, y:Float, count:Int, smooth:Float = 1.0) {
		_rX = x;
		_rY = y;
		_shakeCount = count;
		_smooth = smooth;
	}
	
}