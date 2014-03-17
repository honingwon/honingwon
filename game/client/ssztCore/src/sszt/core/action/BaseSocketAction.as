package sszt.core.action
{
	import sszt.constData.CommonConfig;
	import sszt.interfaces.socket.IPackageIn;
	/**
	 * 加入socket队列，需要设finish状态，
	 * 或者由执行完成设置（setFinish），或者由life时间帧设置
	 * 跳过状态处理
	 * @author Administrator
	 * 
	 */	
	public class BaseSocketAction extends BaseAction
	{
		protected var _pkg:IPackageIn;
		
		public function BaseSocketAction(pkg:IPackageIn = null)
		{
			_pkg = pkg;
			super(ActionLevel.LOW);
		}
		
		override public function get type():String
		{
			return "BaseSocketAction";
		}
		
		protected function readPackage():void
		{
			if(_pkg)
				_pkg.position = CommonConfig.PACKAGE_HEAD_SIZE + 1;
		}
		
		protected function setFinish():void
		{
			isFinished = true;
		}
		
		override public function dispose():void
		{
			_pkg = null;
			super.dispose();
		}
	}
}