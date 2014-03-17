package sszt.furnace.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.manager.LanguageManager;
	import sszt.furnace.components.item.FurnaceItemView;
	import sszt.furnace.components.item.FurnaceQucikBuyItemView;
//	import sszt.furnace.components.materialTabPanel.MaterialQuickBuyTabPanel;
	import sszt.furnace.data.FurnaceInfo;
	import sszt.furnace.data.itemInfo.FurnaceItemInfo;
	import sszt.furnace.events.FuranceEvent;
	import sszt.furnace.mediators.FurnaceMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	public class BaseFurnacePanel extends MPanel
	{
		
		private var _furnaceMediator:FurnaceMediator;
		private var _currentIndex:int = -1;
		private var _btns:Array;
		private var _panels:Array;
		private var _class:Array;
		
		public function BaseFurnacePanel(mediator:FurnaceMediator)
		{
			super();
			_furnaceMediator = mediator;
			initialView();
		}
		private function initialView():void
		{			
			var tabNameLabels:Array = [LanguageManager.getWord("ssztl.common.material"),LanguageManager.getWord("ssztl.common.quickBuy")];
			var tabPoints:Array = [new Point(-20,1),new Point(-20,30)];
			_btns = new Array(tabPoints.length);
			_panels = new Array(tabNameLabels.length);
			_class = [FurnacePanel,FurnacePanel];
			
			for(var i:int = 0;i < tabPoints.length;i++)
			{
				_btns[i] = new MCacheTabBtn1(0,1,tabNameLabels[i]);
				//				_btns[i].move(tabPoints[i].x,tabPoints[i].y);
				_btns[i].move(i * 55 + 7,1);
				addChild(_btns[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,btnHandler);
			}
			setIndex(0);
		}
		
		public function addAssets():void
		{	
			//			_sideBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.SideBgAsset",BitmapData) as BitmapData;
//			_defaultBg.bitmapData = AssetUtil.getAsset("ssztui.furnace.DefaultBgAsset",BitmapData) as BitmapData;
//			_assetsComplete = true;
			if(_currentIndex != -1 && _panels[_currentIndex])
			{
				(_panels[_currentIndex] as IFurnaceTabPanel).addAssets();
			}
		}
		
		private function btnHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		public function setIndex(argIndex:int):void
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
//			_panels[_currentIndex].show();
			_panels[_currentIndex].setIndex(0);
		}
		
		private function get furnaceInfo():FurnaceInfo
		{
			return _furnaceMediator.furnaceModule.furnaceInfo;
		}
		
		override public function dispose():void
		{
			_furnaceMediator = null;
			for each(var i:MCacheTabBtn1 in _btns)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_btns = null;
			for(var j:int = 0;j<_panels.length;j++)
			{
				if(_panels[j])
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			_panels = null;
			_class = null;
		}		
	}
}