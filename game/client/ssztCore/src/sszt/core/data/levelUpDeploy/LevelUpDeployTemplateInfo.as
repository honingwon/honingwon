package sszt.core.data.levelUpDeploy
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.deploys.DeployItemInfo;

	public class LevelUpDeployTemplateInfo
	{
		public var level:int;
		public var deploy:DeployItemInfo = new DeployItemInfo();
		
		public function LevelUpDeployTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			level = data.readInt();
			var list:Array = data.readUTF().split("#");
			
			deploy.type = int(list[0]);
			deploy.descript = list[1];
			deploy.param1 = Number(list[2]);
			deploy.param2 = Number(list[3]);
			deploy.param3 = Number(list[4]);
			deploy.param4 = Number(list[5]);
		}
	}
}