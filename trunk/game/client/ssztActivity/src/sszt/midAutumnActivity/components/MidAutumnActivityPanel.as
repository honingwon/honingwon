package sszt.midAutumnActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.midAutumnActivity.components.IndexItemView;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	
	import ssztui.midAutmn.winBgAsset;
	import ssztui.ui.BtnAssetClose;
	
	public class MidAutumnActivityPanel extends MSprite implements IPanel
	{
		public static const PANEL_WIDTH:int = 635;
		public static const PANEL_HEIGHT:int = 381;
		
		private var _closeBtn:MAssetButton1;
		private var _dragArea:Sprite;
		private var _assetsComplete:Boolean;
		
		private var _bg:IMovieWrapper;
		private var _bgLayout:Bitmap;
		private var _bgWeltLeft:Bitmap;
		private var _bgWeltRight:Bitmap;
		private var _bgTitle:Bitmap;
		
		/**
		 * 当前选择的活动类型  1:"充值礼包"，2："消费礼包",3："冲级礼包"
		 */
		private var _currentIndex:int = -1;
		private var _btns:Array;
		private var _classes:Array = [];
		private var _panels:Array;
		
		private var _itemTile:MTile;
		
		public function MidAutumnActivityPanel()
		{
			init();
			initEvent();
		}
		protected function init():void
		{
			sizeChangeHandler(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,0,PANEL_WIDTH,PANEL_HEIGHT),new winBgAsset() as MovieClip),
			]);
			addChild(_bg as DisplayObject);
			
			_bgLayout = new Bitmap();
			_bgLayout.x = _bgLayout.y = 14;
			addChild(_bgLayout);
			
			_bgWeltLeft = new Bitmap();
			_bgWeltLeft.x = -8;
			_bgWeltLeft.y = 11;
			addChild(_bgWeltLeft);
			
			_bgWeltRight = new Bitmap();
			_bgWeltRight.x = PANEL_WIDTH+8;
			_bgWeltRight.y = 11;
			_bgWeltRight.scaleX = -1;
			addChild(_bgWeltRight);
			
			_bgTitle = new Bitmap();
			_bgTitle.x = 189;
			_bgTitle.y = -31;
			addChild(_bgTitle);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,PANEL_WIDTH,30);
			_dragArea.graphics.drawRect(205,-31,226,31);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_closeBtn = new MAssetButton1(new BtnAssetClose());
			_closeBtn.move(PANEL_WIDTH-31,8);
			addChild(_closeBtn);
			
			_itemTile = new MTile(157,52,1);
			_itemTile.setSize(170,378);
			_itemTile.move(25,30);
			_itemTile.itemGapW = 0;
			_itemTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemTile.verticalScrollPolicy =  ScrollPolicy.AUTO;
			addChild(_itemTile);
			
			_classes = [LogInRewardView,ExchangeView,StoreView,Recharge]; //2: ExchangeView, 3: BossFlopView 4:OnlineRewardView,
			
			_btns = [];
			_panels = [];
			
			for(var i:int = 0;i< _classes.length ; i++)
			{
				var item:IndexItemView = new IndexItemView(i);
				_itemTile.appendItem(item);
				_btns.push(item);
			}
			
			setIndex(0);
		}
		private function initEvent():void
		{
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i<_btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_closeBtn.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			_bgLayout.bitmapData = AssetUtil.getAsset("ssztui.midAutmn.bgAsset",BitmapData) as BitmapData;
			_bgWeltLeft.bitmapData = AssetUtil.getAsset("ssztui.midAutmn.WeltAsset",BitmapData) as BitmapData;
			_bgWeltRight.bitmapData = AssetUtil.getAsset("ssztui.midAutmn.WeltAsset",BitmapData) as BitmapData;
			_bgTitle.bitmapData = AssetUtil.getAsset("ssztui.midAutmn.TitleAsset2",BitmapData) as BitmapData;
			
			if(_currentIndex != -1 && _panels[_currentIndex])
			{
				_panels[_currentIndex].assetsCompleteHandler();
			}
		}
		
		private function setIndex(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
			if(_currentIndex != -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = argIndex;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex]();
				_panels[_currentIndex].move(189,30);
				if(_assetsComplete)
				{
					_panels[_currentIndex].assetsCompleteHandler();
				}
			}
			addChild(_panels[_currentIndex]);
			_panels[_currentIndex].show();
		}
		
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - PANEL_WIDTH,parent.stage.stageHeight - PANEL_HEIGHT));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(Math.round((CommonConfig.GAME_WIDTH - PANEL_WIDTH)/2),Math.round((CommonConfig.GAME_HEIGHT - PANEL_HEIGHT)/2));
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget);
			if(_currentIndex == index)
			{
				return;
			}
			setIndex(index);
			
		}
		
		public function doEscHandler():void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btns)
			{
				for(var i:int =0;i<_btns.length;i++)
				{
					_btns[i].dispose();
					_btns[i] = null;
				}
				_btns = null;
			}
			_dragArea = null;
			for(i=0;i<_panels.length;i++)
			{
				if(_panels[i])
				{
					_panels[i].dispose();
					_panels[i] = null;
				}
			}
			if(_bgLayout && _bgLayout.bitmapData)
			{
				_bgLayout.bitmapData.dispose();
				_bgLayout = null;
			}
			if(_bgWeltLeft && _bgWeltLeft.bitmapData)
			{
				_bgWeltLeft.bitmapData.dispose();
				_bgWeltLeft = null;
			}
			if(_bgWeltRight && _bgWeltRight.bitmapData)
			{
				_bgWeltRight.bitmapData.dispose();
				_bgWeltRight = null;
			}
			if(_bgTitle && _bgTitle.bitmapData)
			{
				_bgTitle.bitmapData.dispose();
				_bgTitle = null;
			}
			if(_closeBtn)
			{
				_closeBtn.dispose();
				_closeBtn = null;
			}
			_classes = null;
			_btns = null;
			_panels = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}