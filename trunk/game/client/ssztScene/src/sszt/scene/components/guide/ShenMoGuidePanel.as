package sszt.scene.components.guide
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.data.shenMoGuide.GuideInfoList;
	import sszt.core.data.shenMoGuide.GuideItemInfo;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ShenMoGuidePanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _itemList:Array;
		private var _curItem:GuideItemView;
		private var _curIndex:int = -1;
		private var _views:Array;
		public function ShenMoGuidePanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.scene.GuideTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.GuideTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title), true, -1, true, true);
			initEvents();
		}
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(571,336);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,571,336)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(5,5,215,326)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(223,5,344,326))
			]);
			addContent(_bg as DisplayObject);
			
			_tile = new MTile(216,21,1);
			_tile.itemGapH = _tile.itemGapW = 4;
			_tile.move(9,5);
			_tile.setSize(210,326);
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addContent(_tile);
			
			initTile();
		}
		
		private function initTile():void
		{
			/**配表方式*/
//			GuideInfoList.test();/**初始化测试数据*/
			_itemList = [];
			_views = [];
			var richTextField:RichTextField;
			var item:GuideItemView;
			for each(var info:GuideItemInfo in GuideInfoList.infoList)
			{
				item = new GuideItemView(info.title,info.titleFormatList);
				_tile.appendItem(item);
				_itemList.push(item);
				
				richTextField = new RichTextField(329);
				richTextField.appendMessage(info.msg,info.deployList,info.formatList);
				_views.push(richTextField);
			}
			setIndex(0);
		}
		
		private function initEvents():void
		{
			for(var i:int=0;i<_itemList.length;i++)
			{
				(_itemList[i] as GuideItemView).addEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		private function removeEvents():void
		{
			for(var i:int=0;i<_itemList.length;i++)
			{
				(_itemList[i] as GuideItemView).removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{			
			var index:int = _itemList.indexOf(evt.currentTarget as GuideItemView);
			setIndex(index);
		}
		
		private function setIndex(index:int):void
		{
			if(_curIndex != -1)
			{
				if(_curIndex == index)
				{
					return;
				}
				_itemList[_curIndex].select = false;
				if(_views[_curIndex].parent)
				{
					_views[_curIndex].parent.removeChild(_views[_curIndex]);
				}
			}
			_curIndex = index;
			_itemList[_curIndex].select = true;
			_views[_curIndex].x = 230;
			_views[_curIndex].y = 12;
			addContent(_views[_curIndex]);
		}
		
		public override function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_itemList)
			{
				for each(var item:GuideItemView in _itemList)
				{
					item.dispose();
				}
				item = null;
				_itemList = null;
			}
			if(_views)
			{
				for each(var view:RichTextField in _views)
				{
					view.dispose();
				}
				view = null;
				_views = null;
			}
			_curItem = null;
			super.dispose();
		}
	}
}






















