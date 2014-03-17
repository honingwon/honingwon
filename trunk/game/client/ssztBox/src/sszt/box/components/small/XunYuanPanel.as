package sszt.box.components.small
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.MCacheAsset2Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
//	import mhsm.box.ItemShowTitleAsset;
//	import mhsm.box.QiShiBtnAsset;
//	import mhsm.box.XianShiBtnAsset;
//	import mhsm.box.ZhenShiBtnAsset;
	import sszt.box.components.small.views.QiShiSmallView;
	import sszt.box.components.views.QiShiView;
	import sszt.box.mediators.BoxMediator;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	
	public class XunYuanPanel extends MPanel
	{
		private var _mediator:BoxMediator;
		private var _bg:IMovieWrapper;
		
		private var _autoBtn:MCacheAsset2Btn;
		private var _qiShiBtn:MCacheAsset2Btn;
		private var _zhenShiBtn:MCacheAsset2Btn;
		private var _xianShiBtn:MCacheAsset2Btn;
		private var _btnBitmaps:Array =  []//[new QiShiBtnAsset(),new ZhenShiBtnAsset(),new XianShiBtnAsset()];
		private var _btns:Array = [];
		
		private var _curIndex:int = -1;
//		private var _classes:Array;
//		private var _panels:Array;
		
		private var _panel:QiShiSmallView;
		public function XunYuanPanel(mediator:BoxMediator)
		{
			_mediator = mediator;
//			super(new MCacheTitle1("",new Bitmap(new ItemShowTitleAsset())), true, -1, true, true);
			initEvents();
			setIndex(2);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(462,227);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,462,227)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,6,157,215)),
			
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(169,8,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,8,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(267,8,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(316,8,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(365,8,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(414,8,40,40),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(169,55,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,55,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(267,55,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(316,55,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(365,55,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(414,55,40,40),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(169,102,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(218,102,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(267,102,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(316,102,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(365,102,40,40),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(414,102,40,40),new Bitmap(CellCaches.getCellBg()))
			]);
			
			addContent(_bg as DisplayObject);
			
			_autoBtn = new MCacheAsset2Btn(1,LanguageManager.getWord("ssztl.common.autoGo"),2);
			_autoBtn.move(253,182);
			addContent(_autoBtn);
			
			var points:Array = [new Point(9,13),new Point(9,83),new Point(9,154)];
			for(var i:int=0;i<_btnBitmaps.length;i++)
			{
				var btn:MBitmapButton = new MBitmapButton(_btnBitmaps[i]);
				btn.move(points[i].x,points[i].y);
				addContent(btn);
				_btns.push(btn);
			}
			
			_panel = new QiShiSmallView();
			_panel.move(163,0);
			setIndex(2);
			addContent(_panel);
		}
		
		private function initEvents():void
		{
			for(var i:int=0;i<_btns.length;i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,panelChangeHandler);
			}
			_autoBtn.addEventListener(MouseEvent.CLICK,autoClickHandler);
		}
		
		private function removeEvents():void
		{
			for(var i:int=0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,panelChangeHandler);
			}
			_autoBtn.removeEventListener(MouseEvent.CLICK,autoClickHandler);
		}
		
		private function panelChangeHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var button:MBitmapButton = evt.currentTarget as MBitmapButton;
			var index:int = _btns.indexOf(button);
			setIndex(index+1);
		}
		
		private function autoClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var target:Point;
			switch(_curIndex)
			{
				case 1:
					target = new Point(265,622);
					break;
				case 2:
					target = new Point(1015,620);
					break;
				case 3:
					target = new Point(1704,620);
					break;
			}
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTOPOINT,{sceneId:3021,target:target,stopAtDistance:0}));
		}
		
		public function setIndex(index:int):void
		{
			if(_curIndex == index)
				return;
			if(_curIndex > 0 && _curIndex != 1 && _btns[_curIndex - 1])_btns[_curIndex - 1].filters = [];

			_curIndex = index;
			if(_curIndex > 0 &&_btns[_curIndex - 1])_btns[_curIndex - 1].filters = MAssetButton.overFilter;
			
			_panel.initTile(_curIndex);
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btns)
			{
				for(var i:int=0;i<_btns.length;i++)
				{
					_btns[i].dispose();
				}
				_btns = null;
			}
			if(_autoBtn)
			{
				_autoBtn.dispose();
				_autoBtn = null;
			}
			if(_panel)
			{
				_panel.dispose();
			}
			_panel = null;
			super.dispose();
		}
	}
}
