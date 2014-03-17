package sszt.consign.components.quickConsign
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.consign.components.SearchConsignPanel;
	import sszt.consign.data.ConsignInfo;
	import sszt.consign.events.ConsignEvent;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.consign.QuickConsignTitleAsset;
	
	public class QuickConsignPanel extends MPanel
	{
		private var _consignMediator:ConsignMediator;
		private var _bg:IMovieWrapper;
//		private var _labels:Vector.<String>;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _class:Vector.<Class>;
//		private var _panels:Vector.<IConsignPanelView>;
		private var _labels:Array;
		private var _btns:Array;
		private var _class:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;

		
		public function QuickConsignPanel(consignMediator:ConsignMediator)
		{
			_consignMediator = consignMediator;
			super(new MCacheTitle1("",new Bitmap(new QuickConsignTitleAsset())),true,-1,true,true);
			initEvent();
		}
		
		public function get panels():Array
		{
			return _panels;
		}
		
		public function get currentIndex():int
		{
			return _currentIndex;
		}

		override protected function configUI():void
		{
			super.configUI();
			setContentSize(255,315);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,239,282)),
			]);
			addContent(_bg as DisplayObject);
			
			_labels = [LanguageManager.getWord("ssztl.common.itemConsign"),LanguageManager.getWord("ssztl.consign.moneyConsign"),LanguageManager.getWord("ssztl.common.myConsign")];
			_btns = [];
			for(var i:int = 0;i<_labels.length;i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(15+69*i,0);
				addContent(btn);
				_btns.push(btn);
			}
			
			_class = [ItemConsignPanel,YuanBaoConsignPanel,MyConsignPanel];
			_panels = new Array(_class.length);
			
			setIndex(0);
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		
		public function assetsCompleteHandler():void
		{
//			_bg.bitmapData = AssetUtil.getAsset("ssztui.consign.BgAsset2",BitmapData) as BitmapData;
		}
		
		public function btnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		public function setIndex(index:int):void
		{
			if(_currentIndex == index) return;
			if(_currentIndex > -1)
			{
				if(_btns[_currentIndex])
				{
					_btns[_currentIndex].selected = false;
				}
				_panels[_currentIndex].hide();
			}
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			if(_currentIndex == 2 && _panels[_currentIndex])
			{
//				(_panels[_currentIndex] as MyConsignPanel).queryByPage();
			}
			else if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _class[_currentIndex](_consignMediator);	
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].move(12,29);
			_panels[_currentIndex].show();
		}
		
		private function get consignInfo():ConsignInfo
		{
			return _consignMediator.module.consignInfo;
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_labels = null;
			for each(var i:MCacheTabBtn1 in _btns)
			{
				i.dispose();
				i = null;
			}
			_btns = null;
			_class = null;
			for(var j:int = 0;j<_panels.length;j++)
			{
				if(_panels[j])
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			_panels = null;
			_consignMediator.consignInfo.clearMyItemList();
			_consignMediator = null;
			super.dispose();
		}
	}
}