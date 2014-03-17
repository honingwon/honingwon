package sszt.scene.data.roles
{
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.monster.MonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.scene.actions.CharacterWalkActionII;
	
	public class BaseSceneMonsterInfo extends BaseRoleInfo
	{
		protected var _id:Number;
		private var _templateId:int;
		private var _template:MonsterTemplateInfo;
		
		public function BaseSceneMonsterInfo(walkAction:CharacterWalkActionII)
		{
			super(walkAction);
		}
		
		public function setObjId(id:Number):void
		{
			_id = id;
		}
		
		override public function getObjId():Number
		{
			return _id;
		}
		
		public function set templateId(value:int):void
		{
			_templateId = value;
//			totalHp = MonsterTemplateList.getMonster(_templateId).maxHp;
		}
		public function get templateId():int
		{
			return _templateId;
		}
		
		public function get template():MonsterTemplateInfo
		{
			if(_template == null)
				_template = MonsterTemplateList.getMonster(_templateId);
			return _template;
		}
		
		override public function getCanAttack():Boolean
		{
			if(template.camp == GlobalData.selfPlayer.camp)return false;
			//倒地，无敌
			return super.getCanAttack();
		}
		
		override public function getObjType():int
		{
			if(template.type == 0)
				return MapElementType.MONSTER;
			else if(template.type == 1)
				return MapElementType.BOSS;
			else
				return MapElementType.OUR_TOWER;
					
		}
		public function getCamp():int
		{
			return template.camp;
		}
		override public function getName():String
		{
			return template.name;
		}
		
		override public function getLevel():int
		{
			return template.level;
		}
	}
}