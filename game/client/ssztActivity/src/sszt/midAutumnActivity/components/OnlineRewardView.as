package sszt.midAutumnActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.midAutumnActivity.components.item.BigCell;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.activity.IconStarAsset;

	public class OnlineRewardView extends Sprite
	{
		private var _bg:IMovieWrapper;
		
		private var _txtTitle:MAssetLabel;
		private var _txtTime:MAssetLabel;
		private var _txtDetail:MAssetLabel;
		private var _getReward:MCacheAssetBtn1;
		private var _getGo:MCacheAssetBtn1;
		
		private var _tile:MTile;
		private var _cellList:Array;
		
		public function OnlineRewardView()
		{
			initView();
			initEvent();
		}
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,42,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,64,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.rewardLevel")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,86,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.activityDescription")+"：",MAssetLabel.LABEL_TYPE20,"left")),
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,188,422,15),new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.openGiftGet1"),MAssetLabel.LABEL_TYPE_TAG)),
			
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(80,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(95,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(110,64,15,15),new Bitmap(new IconStarAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTitle = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_txtTitle.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),20,0xffcc00,true)]);
			_txtTitle.move(211,10);
			addChild(_txtTitle);
			_txtTitle.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acName6"));
			
			_txtTime = new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.endTime"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtTime.move(79,42);
			addChild(_txtTime);
			
			_txtDetail = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtDetail.wordWrap = true;
			_txtDetail.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtDetail.setSize(322,68);
			_txtDetail.move(79,86);
			addChild(_txtDetail);
			_txtDetail.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acDetail6"));
			
			_tile = new MTile(50,50,4);
			_tile.setSize(210,50);
			_tile.move(220,213);
			_tile.itemGapW = 5;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_cellList = [];
			
			_getReward = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.goTo")+LanguageManager.getWord("ssztl.club.getWelFare"));
			_getReward.move(178,287);
			addChild(_getReward);
			
			setTemplateListData();
		}
		public function initEvent():void
		{
			_getReward.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		public function removeEvent():void
		{
			_getReward.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_ONLINE_REWARD_PANEL));
		}
		
		/**
		 * 设置模板数据
		 */		
		private function setTemplateListData():void
		{
			var bigItem:ItemTemplateInfo = ItemTemplateList.getTemplate(300100);
			
//			var i:int = 0
//			var itemArray:Array = []; //物品模板id数组
//			var itemNumArray:Array = []; //物品数量数组
//			var scriptArray:Array = bigItem.script.split("|"); 
//			var scriptStr:String = "";
//			var scriptStrArray:Array = [];
//			for(;i<scriptArray.length;i++)
//			{
//				scriptStrArray = scriptArray[i].toString().split(",");
//				if(scriptStrArray.length >= 6)
//				{
//					itemArray.push(scriptStrArray[2]);
//					itemNumArray.push(scriptStrArray[3]);
//				}
//			}
//			i = 0; 
//			for(; i<itemArray.length; i++)
//			{
				bigItem = ItemTemplateList.getTemplate(300100);
				var itemInfo:ItemInfo = new ItemInfo();
				itemInfo.templateId = bigItem.templateId;
				
				var item:BigCell = new BigCell();
				item.itemInfo = itemInfo;
				_tile.appendItem(item);
				_cellList.push(item);
//			}
			_tile.columns = _tile.getItemCount();
			_tile.width = _tile.getItemCount()*55;
			_tile.x = Math.round((422-_tile.getItemCount()*50-(_tile.getItemCount()-1)*5)/2);
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function assetsCompleteHandler():void
		{
		}
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			this.parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_txtTitle = null;
			_txtTime = null;
			_txtDetail = null;
			_getReward = null;
			_getGo = null;
			if(_tile)
			{
				_tile.disposeItems();
				_tile = null;
			}
			_cellList = null;
		}
		
	}
}