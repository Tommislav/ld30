package se.salomonsson.ld30.b;

import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;
import com.haxepunk.Tween.TweenType;
import com.haxepunk.Tweener;
import com.haxepunk.tweens.misc.MultiVarTween;
import com.haxepunk.tweens.TweenEvent;
import com.haxepunk.utils.Ease.EaseFunction;

/**
 * ...
 * @author Tommislav
 */
class TweenBehaviour extends Behavior
{
	private var _tween:MultiVarTween;
	private var _tweener:Tweener;
	
	private var _object:Dynamic;
	private var _props:Dynamic;
	private var _duration:Float;
	private var _ease:EaseFunction;
	
	public function new(object:Dynamic, properties:Dynamic, duration:Float, ease:EaseFunction = null) {
		super();
		
		_object = object;
		_props = properties;
		_duration = duration;
		_ease = ease;
	}
	
	override private function initialize():Void {
		super.initialize();
		status = BehaviorStatus.Running;
		
		_tween = new MultiVarTween(onTweenFinished, TweenType.OneShot);
		_tween.tween(_object, _props, _duration, _ease);
		
		_tweener = new Tweener();
		_tweener.addTween(_tween);
	}
	
	private function onTweenFinished(e:TweenEvent):Void {
		status = BehaviorStatus.Success;
	}
	
	override private function terminate(status:BehaviorStatus):Void { 
		_tweener.clearTweens();
	}
	
	override private function update(context:Dynamic):BehaviorStatus { 
		_tweener.updateTweens();	
		return status; 
	}
}