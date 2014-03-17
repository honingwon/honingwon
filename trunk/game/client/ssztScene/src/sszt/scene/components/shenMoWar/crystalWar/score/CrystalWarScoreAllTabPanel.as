package sszt.scene.components.shenMoWar.crystalWar.score
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
	import sszt.scene.data.crystalWar.scoreInfo.CrystalWarScoreInfo;
	import sszt.scene.data.crystalWar.scoreInfo.CrystalWarScoreItemInfo;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class CrystalWarScoreAllTabPanel extends Sprite implements CrystalWarScoreInterface
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		private var _mTile:MTile;
		private var _itemList:Array;
		
		public function CrystalWarScoreAllTabPanel(argMediator:SceneWarMediator)
		{
			super();
			_mediator = argMediator;
			initView();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(46,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(165,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(211,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(320,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(420,6,11,17),new MCacheSplit3Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(500,6,11,17),new MCacheSplit3Line()),
			]);
			addChild(_bg as DisplayObject);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.rank"),MAssetLabel.LABELTYPE14);
			label1.move(17,6);
			addChild(label1);
			var label2:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.playerName"),MAssetLabel.LABELTYPE14);
			label2.move(90,6);
			addChild(label2);
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.level2"),MAssetLabel.LABELTYPE14);
			label3.move(180,6);
			addChild(label3);
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.camp2"),MAssetLabel.LABELTYPE14);
			label4.move(250,6);
			addChild(label4);
			var label5:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer3"),MAssetLabel.LABELTYPE14);
			label5.move(360,6);
			addChild(label5);
			var label6:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.killCount"),MAssetLabel.LABELTYPE14);
			label6.move(440,6);
			addChild(label6);
			var label7:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.score"),MAssetLabel.LABELTYPE14);
			label7.move(540,6);
			addChild(label7);
			
			_itemList = [];
			_mTile = new MTile(620,28);
			_mTile.itemGapH = _mTile.itemGapW = 0;
			_mTile.verticalScrollPolicy = ScrollPolicy.ON;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalScrollBar.lineScrollSize = 28;
			_mTile.setSize(620,336);
			_mTile.move(2,22);
			addChild(_mTile);
			
			updateTabData();
		}
		
		private function initEvents():void
		{
			
		}
		private function removeEvents():void
		{
			
		}
		
		public function show():void
		{
			
		}
		
		private function updateTabData():void
		{
			var tmpList:Array = crystalWarScoreInfo.getSortOnList(1);
			if(!tmpList)return;
			for each(var i:CrystalWarScoreItemInfo in tmpList)
			{
				var tmpItemView:CrystalWarScoreItemView = new CrystalWarScoreItemView();
				tmpItemView.info = i;
				_itemList.push(tmpItemView);
				_mTile.appendItem(tmpItemView);
			}
		}
		
		private function get crystalWarScoreInfo():CrystalWarScoreInfo
		{
			return _mediator.crystalWarInfo.crystalWarScoreInfo;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function move(argX:int, argY:int):void
		{
			this.x = argX;
			this.y = argY;
		}
		
		public function dispose():void
		{
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
			for each(var i:CrystalWarScoreItemView in _itemList)
			{
				if(i)
				{
					i.dispose();
					i = null;
				}
			}
			_itemList = null;
			if(parent)parent.removeChild(this);
		}
	}
}