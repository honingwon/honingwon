package sszt.core.data.personal
{
	public class PersonalDynamicType
	{
		/**好友升级userid,name,parm1(level)*/
		public static const FRIEND_UPGRADE:int = 0;
		/**好友被杀userid,name,parm1(otherId),parm5(name2),parm2(mapId),parm3(posX),parm4(posY)*/
		public static const FRIEND_DEAD:int = 1;
		/**好友任务共享userId,name,parm1(taskId),parm5(taskName)*/
		public static const FRIEND_TASK_SHARE:int =2;
		/**帮会升级提示parm1(level)*/
		public static const CLUB_UPGRADE:int = 3;
		/**帮会成员升级提示userId,name,parm1(level)*/
		public static const CLUBMATE_UPGRADE:int = 4;
		/**帮会成员被杀提示userId,name,parm1(otherId),parm5(name2),parm2(mapId),parm3(posX),parm4(posY)*/
		public static const CLUBMATE_DEAD:int = 5;
		/**帮会成员任务共享userId,name,parm1(taskId)*/
		public static const CLUBTASK_SHARE:int = 6;
	}
}