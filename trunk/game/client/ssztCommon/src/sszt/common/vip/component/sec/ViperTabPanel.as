package sszt.common.vip.component.sec
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	
	import sszt.common.vip.VipController;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.common.vip.component.IVipPanel;
	
	public class ViperTabPanel extends Sprite implements IVipPanel
	{
		private var _controller:VipController;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		private var _itemList:Array;
		
		public function ViperTabPanel(control:VipController)
		{
			_controller = control;
			super();
			init();
		}
		
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,337,371)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(4,4,331,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(41,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(150,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(191,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(237,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,57,307,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,91,307,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,125,307,2),new MCacheSplit2Line()),			
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,159,307,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,193,307,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,227,307,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,261,307,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,295,307,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,329,307,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,363,307,2),new MCacheSplit2Line())
				]);
			addChild(_bg as DisplayObject);

			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(15,7,22,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.VIP"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(89,7,28,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.name2"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(162,7,22,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(206,7,22,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer3"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(263,7,22,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.operation"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT)));
			
			
			_tile = new MTile(305,34);
			_tile.setSize(328,341);
			_tile.move(4,26);
			_tile.itemGapH = 0;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.ON;
			addChild(_tile);
			_tile.verticalScrollBar.lineScrollSize = 34;
		}
		
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);	
		}
		
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
	}
}