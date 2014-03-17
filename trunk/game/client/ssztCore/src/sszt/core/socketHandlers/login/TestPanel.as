package sszt.core.socketHandlers.login
{
	import flash.display.DisplayObject;
	
	import sszt.ui.container.MPanel;
	
	public class TestPanel extends MPanel
	{
		public function TestPanel()
		{
			super(null,true,-1,true);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(700,450);
		}
	}
}