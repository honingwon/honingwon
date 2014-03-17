/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-8 下午1:55:13 
 * 
 */ 
package sszt.scene.checks
{
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.PlayerSitSocketHandler;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;

	public class DoubleSitChecker
	{
		private static var _mediator:SceneMediator;
		private static var _sceneInfo:SceneInfo;
		private static var _doubleSitalert:MAlert;
		
		public function DoubleSitChecker()
		{
		}
		
		public static function setup(mediator:SceneMediator) : void
		{
			_mediator = mediator;
			_sceneInfo = _mediator.sceneInfo;
		}
		
		public static function cancelDoubleSit(cancelComplete:Function) : void
		{
			function doCallback(event:CloseEvent) : void
			{
				if (event.detail == MAlert.OK)
				{
					PlayerSitSocketHandler.send(false);
					_sceneInfo.playerList.clearDoubleSit();
					cancelComplete();
				}
				if (_doubleSitalert)
				{
					_doubleSitalert = null;
				}
			};
			
			if (_sceneInfo.playerList.isDoubleSit())
			{
				if (!_doubleSitalert)
				{
					_doubleSitalert = MAlert.show(LanguageManager.getWord("ssztl.scene.sureBreakDoubleSit"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,doCallback);
				}
			}
			else
			{
				cancelComplete();
			}
			
			
			
		}
		
		
		
		
		
		
	}
}