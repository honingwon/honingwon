/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-29 下午1:48:35 
 * 
 */ 
package sszt.scene.actions.characterActions
{
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.core.action.BaseAction;
	import sszt.core.utils.Geometry;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.data.BaseActionInfo;

	public class MonsterBackAction extends BaseCharacterAction
	{
		private var _current:Point;
		private var _to:Point;
		private var _updateScale:Number;
		private var _currentScale:Number;
		private var _dtS:Number;
		
		
		private var _speedx:Number;
		private var _speedy:Number;
		private var _dist:int = 150;
		private var _angle:Number
		public function MonsterBackAction(actionInfo:BaseActionInfo,angle:Number,updateScale:Number = 1)
		{
			super(actionInfo);
			_life = 5;
			_angle = angle;
			_updateScale = updateScale;
			_currentScale = 1;
			_dtS = (_currentScale  - _updateScale) / 5;
			_speedx = CommonConfig.MONSTER_BASK_STEP * Math.cos(_angle);
			_speedy = CommonConfig.MONSTER_BASK_STEP * Math.sin(_angle);
		}
		
		override public function setCharacter(character:BaseRole):void
		{
			super.setCharacter(character);
			_current = new Point(_character.sceneX,_character.sceneY);
			_to = new Point(Math.cos(_angle) * _dist,Math.sin(_angle) * _dist);
			
			
			
		}
		
		override public function update(times:int,dt:Number=0.04):void
		{
			for(var i:int = 0; i < times; i++)
			{
				if(Point.distance(_current,_to) <= CommonConfig.MONSTER_BASK_STEP)
				{
					_character.getBaseRoleInfo().setScenePos(_to.x,_to.y);
					dispose();
				}
				else
				{
					_current.x = int(_current.x + _speedx);
					_current.y = int(_current.y +_speedy);
					if(_dtS != 0)
					{
						if(_currentScale > _updateScale)
						{
							_currentScale -= _dtS;
							_character.scaleX = _character.scaleY = _currentScale;
						}
					}
					_character.getBaseRoleInfo().setScenePos(_current.x,_current.y);
				}
			}
			super.update(times,dt);	
			
		}
		override public function dispose():void
		{
			super.dispose();
			_current = null;
			_to = null;
			
		}
		
		
	}
}