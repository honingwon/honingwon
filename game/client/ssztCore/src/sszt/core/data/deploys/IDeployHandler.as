package sszt.core.data.deploys
{
	public interface IDeployHandler
	{
		function getType():int;
		function handler(info:DeployItemInfo):void;
	}
}