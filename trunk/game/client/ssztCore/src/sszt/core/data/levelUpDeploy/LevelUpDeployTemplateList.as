package sszt.core.data.levelUpDeploy
{
	import flash.utils.ByteArray;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class LevelUpDeployTemplateList
	{
		public static var deployList:Array = new Array();
		
		public function LevelUpDeployTemplateList()
		{
		}
		
		public static function parseData(data:ByteArray):void
		{
			if(!data.readBoolean())
			{
				MAlert.show(data.readUTF(),LanguageManager.getAlertTitle());
			}
			else
			{
				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var info:LevelUpDeployTemplateInfo = new LevelUpDeployTemplateInfo();
					info.parseData(data);
					deployList.push(info);
				}
			}
		}
	}
}