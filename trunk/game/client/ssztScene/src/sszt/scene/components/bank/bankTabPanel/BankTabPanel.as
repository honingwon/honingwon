package sszt.scene.components.bank.bankTabPanel
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	
	public class BankTabPanel extends Sprite
	{
		private var _mediator:SceneMediator;
		private var _bg:IMovieWrapper;
		private var _currentIndex:int = -1;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _panels:Vector.<IMaterialTabPanel>;
//		private var _class:Vector.<Class>;
		private var _btns:Array;
		private var _panels:Array;
		private var _class:Array;
		
		public function BankTabPanel(mediator:SceneMediator)
		{
			super();
			_mediator = mediator;
			initialView();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,3,582,137)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,143,582,195)),
			]);
			addChild(_bg as DisplayObject);
						
			var tabNameLabels:Array = [LanguageManager.getWord("ssztl.bank.bankImmdediately"),LanguageManager.getWord("ssztl.bank.bankMonth"),LanguageManager.getWord("ssztl.bank.bankLevel")];
			_btns = new Array(tabNameLabels.length);
			_panels = new Array(tabNameLabels.length);
			_class = [BankImmediatelyPanel,BankMonthTabPanel,BankLevelTabPanel];
			
			for(var i:int = 0;i < tabNameLabels.length;i++)
			{
				_btns[i] = new MCacheTabBtn1(0,2,tabNameLabels[i]);
				_btns[i].move(i * 69 + 6,-26);
				addChild(_btns[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,btnHandler);
			}
			setIndex(0);
		}
		
		
		private function btnHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		private function setIndex(argIndex:int):void
		{
			if(argIndex == _currentIndex)return;
			if(_currentIndex != -1)
			{
				_btns[_currentIndex].selected = false;
				_panels[_currentIndex].hide();
			}
			_currentIndex = argIndex;
			_btns[_currentIndex].selected = true;
			if(!_panels[_currentIndex])
			{
				_panels[_currentIndex] = new _class[_currentIndex](_mediator);
			}
			addChild(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
		}
		
		
		public function setCurrentPage():void
		{
			for(var i:int=0;i<_panels.length;i++)
			{
				if(_panels[i])
				{
					_panels[i].show();
				}
			}
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
//			_furnaceMediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
//			for each(var i:MCacheTabBtn1 in _btns)
//			{
//				if(i)
//				{
//					i.dispose();
//					i = null;
//				}
//			}
//			_btns = null;
//			for each(var j:IMaterialTabPanel in _panels)
//			{
//				if(j)
//				{
//					j.dispose();
//					j = null;
//				}
//			}
			_panels = null;
			_class = null;
		}
		
	}
}