package se.salomonsson.ld30.b;

import com.haxepunk.ai.behaviors.Behavior;
import com.haxepunk.ai.behaviors.BehaviorStatus;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import se.salomonsson.ld30.entities.EnemyBase;
import se.salomonsson.ld30.EntityType;

/**
 * ...
 * @author Tommislav
 */
class FacePlayerBehaviour extends Behavior
{
	private var _entity:EnemyBase;
	
	public function new(e:EnemyBase) 
	{
		super();
		_entity = e;
	}
	
	override private function update(context:Dynamic):BehaviorStatus 
	{
		var player:Entity = HXP.scene.getInstance(EntityType.PLAYER);
		if (player.centerX < _entity.centerX) {
			_entity.setDirX(-1);
		} else if (player.centerX > _entity.centerX) {
			_entity.setDirX(1);
		}
		return BehaviorStatus.Success;
	}
	
}