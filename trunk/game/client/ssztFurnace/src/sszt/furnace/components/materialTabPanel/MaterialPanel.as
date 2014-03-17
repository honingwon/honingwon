package sszt.furnace.components.materialTabPanel
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.furnace.components.item.FurnaceItemView;
	import sszt.furnace.components.item.FurnaceQucikBuyItemView;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	public class MaterialPanel extends Sprite
	{
		private var _furnaceMediator:FurnaceMediator;
		private var _bg:IMovieWrapper;
		private var _currentIndex:int = -1;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _panels:Vector.<IMaterialTabPanel>;
//		private var _class:Vector.<Class>;
		private var _btns:Array;
		private var _panels:Array;
		private var _class:Array;
		
		public function MaterialPanel(argFurnaceMediator:FurnaceMediator)
		{
			super();
			_furnaceMediator = argFurnaceMediator;
			initialView();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,23,247,136)),
				new BackgroundInfo(BackgroundType.BAR_4,new Rectangle(10,12,230,10)),
			]);
			addChild(_bg as DisplayObject);
						
			var tabNameLabels:Array = [LanguageManager.getWord("ssztl.common.material"),LanguageManager.getWord("ssztl.common.quickBuy")];
			_btns = new Array(tabNameLabels.length);
			_panels = new Array(tabNameLabels.length);
			_class = [MaterialTabPanel,MaterialQuickBuyTabPanel];
			
			for(var i:int = 0;i < tabNameLabels.length;i++)
			{
				_btns[i] = new MCacheTabBtn1(0,i+1,tabNameLabels[i]);
				_btns[i].move(i * 57 + 5,-3);
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
				_panels[_currentIndex] = new _class[_currentIndex](_furnaceMediator);
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
		
		private function get furnaceInfo():FurnaceInfo
		{
			return _furnaceMediator.furnaceModule.furnaceInfo;
		}
		
		public function dispose():void
		{
			_furnaceMediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for each(var i:MCacheTabBtn1 in _btns)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_btns = null;
			for each(var j:IMaterialTabPanel in _panels)
			{
				if(j)
				{
					j.dispose();
					j = null;
				}
			}
			_panels = null;
			_class = null;
		}
		
	}
}