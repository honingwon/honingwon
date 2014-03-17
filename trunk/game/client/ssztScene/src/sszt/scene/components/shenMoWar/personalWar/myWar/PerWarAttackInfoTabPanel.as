package sszt.scene.components.shenMoWar.personalWar.myWar
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.personalWar.myInfo.PerWarMyWarInfo;
	import sszt.scene.data.personalWar.myInfo.PerWarMyWarItemInfo;
	import sszt.scene.data.shenMoWar.ShenMoWarInfo;
	import sszt.scene.data.shenMoWar.myWarInfo.ShenMoWarMyWarInfo;
	import sszt.scene.data.shenMoWar.myWarInfo.ShenMoWarMyWarItemInfo;
	import sszt.scene.events.ScenePerWarUpdateEvent;
	import sszt.scene.events.SceneShenMoWarUpdateEvent;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class PerWarAttackInfoTabPanel extends Sprite implements IPerWarMyWarInfoInterface
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		private var _mTile:MTile;
		private var _itemList:Array;
		
		public function PerWarAttackInfoTabPanel(argMediator:SceneWarMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			_mediator.perWarInfo.initPerWarMyWarInfo();
			initialEvents();
			_mediator.sendPerWarMyWarList();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,360,357)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(3,3,355,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(96,5,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(137,5,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(234,5,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(271,5,11,17),new MCacheSplit3Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,49,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,76,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,103,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,130,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,157,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,184,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,211,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,238,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,265,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,292,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,319,328,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,346,328,2),new MCacheSplit2Line()),
			]);
			addChild(_bg as DisplayObject);
			
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.name2"),MAssetLabel.LABELTYPE14);
			label1.move(38,5);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE14);
			label2.move(108,5);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.club2"),MAssetLabel.LABELTYPE14);
			label3.move(177,5);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer3"),MAssetLabel.LABELTYPE14);
			label4.move(244,5);
			addChild(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.killNum"),MAssetLabel.LABELTYPE14);
			label5.move(284,5);
			addChild(label5);
			
			_itemList = [];
			_mTile = new MTile(350,27);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.verticalScrollPolicy = ScrollPolicy.ON;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalScrollBar.lineScrollSize = 27;
			_mTile.setSize(350,325);
			_mTile.move(6,27);
			addChild(_mTile);
		}
		
		private function initialEvents():void
		{
			myWarInfo.addEventListener(ScenePerWarUpdateEvent.PERWAR_MYWAR_INFO_UPDATE,initData);
		}
		
		private function removeEvents():void
		{
			myWarInfo.removeEventListener(ScenePerWarUpdateEvent.PERWAR_MYWAR_INFO_UPDATE,initData);
		}
		
		private function initData(e:ScenePerWarUpdateEvent):void
		{
			clearList();
			for each(var i:PerWarMyWarItemInfo in myWarInfo.attackInfoList)
			{
				var tmpItemView:PerWarMyWarItemView = new PerWarMyWarItemView(_mediator,i);
				_itemList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
		}
		
		private function clearList():void
		{
			_itemList.length = 0;
			_mTile.disposeItems();
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function get myWarInfo():PerWarMyWarInfo
		{
			return _mediator.perWarInfo.perWarMyWarInfo;
		}
		
		public function move(argX:int, argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator.perWarInfo.clearPerWarMyWarInfo();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			for each(var i:PerWarMyWarItemView in _itemList)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_itemList = null;
		}
	}
}