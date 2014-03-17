/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-11-14 上午11:21:14 
 * 
 */ 
package sszt.constData
{
	public class ActionType
	{
		public function ActionType()
		{
		}
		
		/**
		 * 站
		 */	
		public static const STAND:int = 1;
		/**
		 * 走
		 */	
		public static const WALK:int = 2;
		/**
		 * 备战
		 */	
		public static const READY:int = 3;
		/**
		 * 攻击
		 */	
		public static const ATTACK:int = 4;
		/**
		 * 受击
		 */	
		public static const BEHIT:int = 5;
		/**
		 * 死亡
		 */	
		public static const DEAD:int = 6;
		/**
		 * 坐下 
		 */		
		public static const SIT:int = 7;
		/**
		 * 晕 
		 */		
		public static const DIZZY:int = 8;
		
		
		
		public static function getActionType(name:String):int
		{
			switch(name)
			{
				case "stand":return STAND;
				case "run":return WALK;
				case "ready":return READY;
				case "attack":return ATTACK;
				case "death":return DEAD;
				case "hit":return BEHIT;
				case "sit":return SIT;
				case "dizzy":return DIZZY;
			}
			return STAND;		
		}
		
		public static function getActionName(action:int):String
		{
			switch(action)
			{
				case STAND:return "stand";
				case WALK:return "run";
				case READY:return "ready";
				case ATTACK:return "attack";
				case DEAD:return "death";
				case BEHIT:return "hit";
				case SIT:return "sit";
				case DIZZY:return "dizzy";
			}
			return "stand";		
		}
		
		
		public static function getActionObj(actionType:int,obj:Object):Object
		{
			if(!obj || !obj.action || !obj.actionSE)
			{
				return {start:0,end:0};
			}
			var actionName:String = ActionType.getActionName(actionType);
			var index:int = (obj.action as Array).indexOf(actionName);
			var start:int = (obj.actionSE[index*2]);
			var end:int = (obj.actionSE[index*2 + 1]);
			var directType:int = obj.directType;
			return {start:start,end:end,directType:directType};
		}
		
		
	}
}