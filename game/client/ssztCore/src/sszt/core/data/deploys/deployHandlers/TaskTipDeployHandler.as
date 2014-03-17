package sszt.core.data.deploys.deployHandlers
{
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.view.tips.TipsUtil;
	
	public class TaskTipDeployHandler extends BaseDeployHandler
	{
		private var _pattern:RegExp = /{[^}]*}/g;
		private var _timeoutIndex:int = -1;
		
		public function TaskTipDeployHandler()
		{
			super();
		}
		
		override public function getType():int
		{
			return DeployEventType.TASK_TIP;
		}
		
		override public function handler(info:DeployItemInfo):void
		{
			_timeoutIndex = setTimeout(showTaskTip,100);
			
			function showTaskTip():void
			{
				var target:String = TaskTemplateList.getTaskTemplate(info.param1).target;
				var list:Array = target.match(_pattern);
				var descript:String;
				for(var i:int = 0; i < list.length; i++)
				{
					descript = String(list[i]).split("#")[1];
					target = target.replace(list[i],descript);
				}
				var posX:int = Math.floor(info.param4 / 100000);
				var posY:int = info.param4 % 100000;
				TipsUtil.getInstance().show(target,null,new Rectangle(posX,posY));
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
	}
}