package sszt.core.data.deploys.deployHandlers
{
	import flash.geom.Point;
	
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.view.tips.ChatPlayerTip;
	
	public class PlayerMenuDeployHandler extends BaseDeployHandler
	{
		public function PlayerMenuDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.PLAYER_MENU;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			var posX:int = Math.floor(info.param4 / 100000);
			var posY:int = info.param4 % 100000;
			ChatPlayerTip.getInstance().show(info.param2,info.param1,info.descript,new Point(posX,posY));
		}
	}
}