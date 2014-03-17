package sszt.scene.data.dropItem
{
	public class DropItemStateType
	{
		/**
		 * 指定人物可拾取
		 */		
		public static const LOCK:int = 1;
		/**
		 * 所有人可拾取,此状态到时后发删除命令
		 */		
		public static const UNLOCK:int = 2;
		public static const DELETE:int = 3;
	}
}
