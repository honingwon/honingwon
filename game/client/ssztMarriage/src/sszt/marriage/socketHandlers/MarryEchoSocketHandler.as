package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.marriage.componet.MarryTargetPanel;
	import sszt.ui.container.MAlert;
	
	public class MarryEchoSocketHandler extends BaseSocketHandler
	{
		/**
		 * 处理求婚者的求婚请求，返回求婚者求婚请求处理结果
		 * */
		public function MarryEchoSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MARRY_ECHO;
		}
		
		override public function handlePackage():void
		{
			var success:Boolean = _data.readBoolean();
			if(success)
			{
				MAlert.show('同意，等被传送');
				MarryTargetPanel.getInstance().dispose();
			}
			else
			{
				//				MAlert.show('失败');
			}
			handComplete();
		}
		
		/**
		 * @param yesOrNo   1  同意2 拒绝 3 特殊拒绝
		 * */
		public static function send(yesOrNo:int):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MARRY_ECHO);
			pkg.writeByte(yesOrNo);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}