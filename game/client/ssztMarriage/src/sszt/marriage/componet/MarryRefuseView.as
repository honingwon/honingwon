package sszt.marriage.componet
{
	import sszt.core.data.GlobalAPI;
	import sszt.interfaces.layer.IPanel;
	import sszt.ui.container.MSprite;
	
	public class MarryRefuseView extends MSprite
	{
		private static var _instance:MarryRefuseView;
		
		public function MarryRefuseView()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0,0,50,50);
			graphics.endFill();
		}
		
		public static function getInstance():MarryRefuseView
		{
			if(!_instance)
			{
				_instance = new MarryRefuseView();
			}
			return _instance;
		}
		
		public function show():void
		{
			if(!parent)
			{
				GlobalAPI.layerManager.getPopLayer().addChild(this);
			}
		}
		
		public function doEscHandler():void
		{
		}
		
		override public function dispose():void
		{
			super.dispose();
			_instance = null;
		}
	}
}