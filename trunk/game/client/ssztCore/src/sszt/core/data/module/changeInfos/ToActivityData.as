package sszt.core.data.module.changeInfos
{
	public class ToActivityData
	{
		public var type:int;
		public var tabIndex:int;
		/**
		 * 等级提示：21:单挑王 22:一战到底 23:帮会突袭　24:京城巡逻  25:全服护送  26试炼boss 27资源战 28全民boss 30帮会乱斗
		 * 活动开始提示：0 捉贼  1 惩恶 2 巡逻 3 帮会突袭 4 资源战 7全民boss 8帮会乱斗 9 王城争霸 10圣地
		 */	
		
		public var other:int;
		
		public function ToActivityData(type:int,index:int,other:int=0)
		{
			this.type = type;
			this.tabIndex = index;
			this.other = other;
		}
	}
}