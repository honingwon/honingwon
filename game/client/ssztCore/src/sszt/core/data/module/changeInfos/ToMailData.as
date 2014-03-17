package sszt.core.data.module.changeInfos
{
	public class ToMailData
	{
		public var isMainPanel:Boolean;
		public var serverId:int;
		public var nick:String;
		/**
		 * 强制打开
		 */
		public var forciblyOpen:Boolean;
		public function ToMailData(value:Boolean,serverId:int = 0,name:String = "", forciblyOpen:Boolean = false)
		{
			isMainPanel = value;
			this.serverId = serverId;
			nick = name;
			this.forciblyOpen = forciblyOpen;
		}
	}
}