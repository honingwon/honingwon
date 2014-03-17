package sszt.core.data.characterActionInfos
{
	import sszt.constData.DirectType;

	public class SceneCarActionInfo
	{
		/**
		 * 站
		 */		
//		public static const STAND:CharacterActionInfo = new CharacterActionInfo(1,Vector.<int>([4,12,20,28,36]),
//			DirectType.DIRECT_5,false,true,false);
		public static const STAND:CharacterActionInfo = new CharacterActionInfo(1,[4,12,20,28,36],
			DirectType.DIRECT_5,false,true,false);
		
		/**
		 * 走
		 */		
//		public static const WALK:CharacterActionInfo = new CharacterActionInfo(2,Vector.<int>([0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39]),
//			DirectType.DIRECT_5,false,true,false);
		public static const WALK:CharacterActionInfo = new CharacterActionInfo(2,[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31,32,32,33,33,34,34,35,35,36,36,37,37,38,38,39,39],
			DirectType.DIRECT_5,false,true,false);
	}
}