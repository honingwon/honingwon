package sszt.core.data.characterActionInfos
{
	import sszt.constData.ActionType;
	import sszt.constData.DirectType;
	import sszt.constData.LayerType;

	public class SceneCharacterActions
	{
		public static function createActionInfo(layerType:String,actionType:int,start:int,end:int,directType:int = 0,frameRate:int=1):CharacterActionInfo
		{
			var frames:Array = [];
			var ret:CharacterActionInfo = null;
			for(var i:int = start ; i <= end; ++i)
			{
				for(var j:int = 0; j< frameRate ; ++j)
				{
					frames.push(i);
				}
			}
			
			switch(actionType)
			{
				case ActionType.STAND:
					ret = new CharacterActionInfo(ActionType.STAND,frames,directType,false,true,false);
					break;
				case ActionType.WALK:
					ret = new CharacterActionInfo(ActionType.WALK,frames,directType,false,true,false);
					break;
				case ActionType.READY:
					ret = new CharacterActionInfo(ActionType.READY,frames,directType,true,false,false);
					break;
				case ActionType.ATTACK:
					ret = new CharacterActionInfo(ActionType.ATTACK,frames,directType,false,false,false);
					break;
				case ActionType.BEHIT:
					ret = new CharacterActionInfo(ActionType.BEHIT,frames,directType,false,false,false);
					break;
				case ActionType.DEAD:
					ret = new CharacterActionInfo(ActionType.DEAD,frames,directType,true,false,false);
					break;
				case ActionType.SIT:
					ret = new CharacterActionInfo(ActionType.SIT,frames,directType,true,false,false);
					break;
				case ActionType.DIZZY:
					ret = new CharacterActionInfo(ActionType.DIZZY,frames,directType,false,true,false);
					break;
			}
			return ret;
		}
		
		public static const DEFAULT:CharacterActionInfo = new CharacterActionInfo(ActionType.STAND,[],DirectType.DIRECT_5,false,true,true);
		
		
//		/**
//		 * 站
//		 */		
////		public static const STAND:CharacterActionInfo = new CharacterActionInfo(1,Vector.<int>([100,100,100,101,101,101,102,102,102,103,103,103,104,104,104,105,105,105, 106,106,106,107,107,107,108,108,108,109,109,109,110,110,110,111,111,111, 112,112,112,113,113,113,114,114,114,115,115,115,116,116,116,117,117,117, 118,118,118,119,119,119,120,120,120,121,121,121,122,122,122,123,123,123, 124,124,124,125,125,125,126,126,126,127,127,127,128,128,128,129,129,129]),
////			DirectType.DIRECT_5,false,true,false);
//		public static const STAND:CharacterActionInfo = new CharacterActionInfo(1,[100,100,100,101,101,101,102,102,102,103,103,103,104,104,104,105,105,105, 106,106,106,107,107,107,108,108,108,109,109,109,110,110,110,111,111,111, 112,112,112,113,113,113,114,114,114,115,115,115,116,116,116,117,117,117, 118,118,118,119,119,119,120,120,120,121,121,121,122,122,122,123,123,123, 124,124,124,125,125,125,126,126,126,127,127,127,128,128,128,129,129,129],
//			DirectType.DIRECT_5,false,true,false);
//		
//		/**
//		 * 走
//		 */		
////		public static const WALK:CharacterActionInfo = new CharacterActionInfo(2,Vector.<int>([70,70,70,71,71,71,72,72,72,73,73,73,74,74,74,75,75,75, 76,76,76,77,77,77,78,78,78,79,79,79,80,80,80,81,81,81, 82,82,82,83,83,83,84,84,84,85,85,85,86,86,86,87,87,87, 88,88,88,89,89,89,90,90,90,91,91,91,92,92,92,93,93,93, 94,94,94,95,95,95,96,96,96,97,97,97,98,98,98,99,99,99]),
////			DirectType.DIRECT_5,false,true,false);
//		public static const WALK:CharacterActionInfo = new CharacterActionInfo(2,[70,70,70,71,71,71,72,72,72,73,73,73,74,74,74,75,75,75, 76,76,76,77,77,77,78,78,78,79,79,79,80,80,80,81,81,81, 82,82,82,83,83,83,84,84,84,85,85,85,86,86,86,87,87,87, 88,88,88,89,89,89,90,90,90,91,91,91,92,92,92,93,93,93, 94,94,94,95,95,95,96,96,96,97,97,97,98,98,98,99,99,99],
//			DirectType.DIRECT_5,false,true,false);
//		
//		/**
//		 * 备战
//		 */		
////		public static const READY:CharacterActionInfo = new CharacterActionInfo(3,Vector.<int>([0,1,2,3,4]),
////			DirectType.DIRECT_5,true,false,false);
//		public static const READY:CharacterActionInfo = new CharacterActionInfo(3,[0,1,2,3,4],
//			DirectType.DIRECT_5,true,false,false);
//		
//		/**
//		 * 攻击
//		 */		
////		public static const HIT:CharacterActionInfo = new CharacterActionInfo(4,Vector.<int>([5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,40,40,41,41,42,42,43,43,44,44]),
////			DirectType.DIRECT_5,false,false,false);
//		public static const HIT:CharacterActionInfo = new CharacterActionInfo(4,[5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39,40,40,41,41,42,42,43,43,44,44],
//			DirectType.DIRECT_5,false,false,false);
//		
//		/**
//		 * 受击
//		 */		
////		public static const BEHIT:CharacterActionInfo = new CharacterActionInfo(6,Vector.<int>([45,45,46,46,47,47,48,48,49,49]),
////			DirectType.DIRECT_5,false,false,false);
//		public static const BEHIT:CharacterActionInfo = new CharacterActionInfo(6,[45,45,46,46,47,47,48,48,49,49],
//			DirectType.DIRECT_5,false,false,false);
//		
//		/**
//		 * 击倒
//		 */		
////		public static const HITDOWN:CharacterActionInfo = new CharacterActionInfo(7,Vector.<int>([50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63,64,64,65,65,66,66,67,67,68,68,69,69]),
////			DirectType.DIRECT_5,true,false,false);
//		public static const HITDOWN:CharacterActionInfo = new CharacterActionInfo(7,[50,50,51,51,52,52,53,53,54,54,55,55,56,56,57,57,58,58,59,59,60,60,61,61,62,62,63,63,64,64,65,65,66,66,67,67,68,68,69,69],
//			DirectType.DIRECT_5,true,false,false);
	}
}