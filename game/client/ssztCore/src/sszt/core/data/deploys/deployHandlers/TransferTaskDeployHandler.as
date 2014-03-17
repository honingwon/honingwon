/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-2-4 下午3:14:06 
 * 
 */ 
package sszt.core.data.deploys.deployHandlers
{
	import sszt.core.data.deploys.BaseDeployHandler;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.view.task.TransferTaskPanel;

	public class TransferTaskDeployHandler extends BaseDeployHandler
	{
		public function TransferTaskDeployHandler()
		{
			
		}
		override public function getType() : int
		{
			return DeployEventType.TRANSFER_TASK;
		}
		
		override public function handler(info:DeployItemInfo) : void
		{
			TransferTaskPanel.getInstance().show(info.param1);
		}
	}
}