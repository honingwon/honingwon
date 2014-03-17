package sszt.marriage.componet
{
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class WeddingBlessingPanel extends MPanel
	{
		private static var _instance:WeddingBlessingPanel;
		
		private var _blessingHandler:Function;
		
		private var _blessingBtn1:MCacheAssetBtn1;
		private var _blessingBtn2:MCacheAssetBtn1;
		private var _blessingBtn3:MCacheAssetBtn1;
		
		public function WeddingBlessingPanel()
		{
			super(new MCacheTitle1("WeddingBlessingPanel"),true,-1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(200, 100);
			
			_blessingBtn1 = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marriage.blessingType1'));
			addContent(_blessingBtn1);
			
			_blessingBtn2 = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marriage.blessingType2'));
			_blessingBtn2.move(50,0)
			addContent(_blessingBtn2);
			
			_blessingBtn3 = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marriage.blessingType3'));
			_blessingBtn3.move(100,0)
			addContent(_blessingBtn3);
		}
		
		private function initEvent():void
		{
			_blessingBtn1.addEventListener(MouseEvent.CLICK,btnClickedHandler);
			_blessingBtn2.addEventListener(MouseEvent.CLICK,btnClickedHandler);
			_blessingBtn3.addEventListener(MouseEvent.CLICK,btnClickedHandler);
		}
		
		private function removeEvent():void
		{
			_blessingBtn1.removeEventListener(MouseEvent.CLICK,btnClickedHandler);
			_blessingBtn2.removeEventListener(MouseEvent.CLICK,btnClickedHandler);
			_blessingBtn3.removeEventListener(MouseEvent.CLICK,btnClickedHandler);
		}
		
		private function btnClickedHandler(event:MouseEvent):void
		{
			var btn:MCacheAssetBtn1 = event.currentTarget as MCacheAssetBtn1;
			var type:int;
			switch(btn)
			{
				case _blessingBtn1 :
					type = 0;
					break;
				case _blessingBtn2 :
					type = 1;
					break;
				case _blessingBtn3 :
					type = 2;
					break;
			}
			_blessingHandler(type);
		}
		
		public static function getInstance():WeddingBlessingPanel
		{
			if(!_instance)
			{
				_instance = new WeddingBlessingPanel();
			}
			return _instance;
		}
		
		public function show(blessingHandler:Function):void
		{
			_blessingHandler = blessingHandler;
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}
		}
		
		override protected function draw():void
		{
			super.draw();
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			_instance = null;
			_blessingHandler = null;
			if(_blessingBtn1)
			{
				_blessingBtn1.dispose();
				_blessingBtn1 = null;
			}
			if(_blessingBtn2)
			{
				_blessingBtn2.dispose();
				_blessingBtn2 = null;
			}
			if(_blessingBtn3)
			{
				_blessingBtn3.dispose();
				_blessingBtn3 = null;
			}
		}
	}
}