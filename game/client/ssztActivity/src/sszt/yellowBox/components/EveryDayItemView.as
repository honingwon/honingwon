package sszt.yellowBox.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.openActivity.YellowBoxTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.openActivity.YellowBoxGetRewardSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.activity.PngGotAsset;
	import ssztui.yellowVip.BtnGetRewardAsset;
	
	public class EveryDayItemView extends Sprite implements IPanel
	{
		private var _bgBar:Bitmap;
		/**
		 * 黄钻图片 
		 */		
		private var _levelBg:Bitmap;
		/**
		 * 等级：如 “10级” 
		 */		
		private var _levelable:MAssetLabel;
		private var _itemTile:MTile;
		private var _itemList:Array;
		
		private var _itemObj:Object;
		
		private var _yellowTemplate:YellowBoxTemplateListInfo;
		
		/**
		 * 0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包 
		 */		
		private var _type:int;
		
//		private var _getedRewardBtn:MAssetButton1;
		
//		private var _getOver:Bitmap;
		private var _stats:MAssetLabel;
		
		public function EveryDayItemView(yellowTemplate:YellowBoxTemplateListInfo,type:int=0)
		{
			super();
			_yellowTemplate = yellowTemplate;
			_type = type;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bgBar = new Bitmap();
			addChild(_bgBar);
			
			_levelBg = new Bitmap();
			_levelBg.x = 0;
			_levelBg.y = 10;
			addChild(_levelBg);
			
			_levelable = new MAssetLabel("10",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_levelable.setLabelType([new TextFormat("Verdana",18,0xffdf91,true)]);
			_levelable.move(7,13);
			addChild(_levelable);
			_levelBg.visible = _levelable.visible = false;
			
			_itemList = [];
			_itemTile = new MTile(38,38,6);
			_itemTile.setSize(195,38);
			_itemTile.move(82,6);
			_itemTile.itemGapW = 1;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
//			_getedRewardBtn = new MAssetButton1(new BtnGetRewardAsset() as MovieClip);
//			_getedRewardBtn.move(248,12);
//			addChild(_getedRewardBtn);
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(248,18,84,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.onlineGet"),MAssetLabel.LABEL_TYPE20)));
			
			_stats = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_stats.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),12,0xbbae85)]);
			_stats.move(275,18);
			addChild(_stats);
			
//			_getOver = new Bitmap(new PngGotAsset(),"auto",true);
//			_getOver.x = _itemTile.width + _itemTile.x;
//			_getOver.y = _itemTile.y;
//			_getOver.scaleX = _getOver.scaleY = 0.7;
////			addChild(_getOver);
//			_getOver.visible = false;
		}
		
		public function initEvent():void
		{
//			_getedRewardBtn.addEventListener(MouseEvent.CLICK,getRewardClick);
		}
		
		private function getRewardClick(evt:MouseEvent):void
		{
			YellowBoxGetRewardSocketHandler.send(_type);
		}
		
		public function initData():void
		{
			var _cell:Cell;
			var itemObj:Object;
			for(var j:int; j<_yellowTemplate.templateIdArray.length; j++)
			{
				itemObj = {};
				itemObj.templateId = _yellowTemplate.templateIdArray[j];
				itemObj.count = _yellowTemplate.templateNumArray[j];
				
				var itemInfo:ItemInfo = new ItemInfo();
				itemInfo.templateId = itemObj.templateId;
				itemInfo.count = itemObj.count;
				
				_cell = new Cell();
				_cell.itemInfo = itemInfo;
				_itemTile.appendItem(_cell);
				_itemList.push(_cell);
			}
			
			if(_type == 1)
			{
				_levelBg.visible = _levelable.visible = true;
				_levelable.setValue(_yellowTemplate.level.toString());
				
				if(GlobalData.tmpIsYellowVip == 1)
				{
//					_getedRewardBtn.enabled = true;
					_stats.visible = true;
				}
				else
				{
//					_getedRewardBtn.enabled = false;
					_stats.visible = false;
				}
//				
//				if(GlobalData.yellowBoxInfo.levelUpPack)
//				{
//					_getedRewardBtn.enabled = false;
//				}
				
				
				
				if(_yellowTemplate.level <= GlobalData.yellowBoxInfo.levelUpPack)
				{
					_stats.setHtmlValue(LanguageManager.getWord("ssztl.common.hasGetShort"));
				}
				else if(_yellowTemplate.level <= GlobalData.selfPlayer.level && GlobalData.tmpIsYellowVip)
				{
					_stats.setHtmlValue("<font color='#8eff57'>" + LanguageManager.getWord("ssztl.common.canGetGiftAttention") + "</font>");
				}
//				else
//				{
//					_stats.setHtmlValue("<font color='#8eff57'>" + LanguageManager.getWord("ssztl.common.canGetGiftAttention") + "</font>");
//				}
			}
			else if(_type == 0)
			{
				_levelBg.visible = _levelable.visible = false;
				if(_yellowTemplate.level == GlobalData.tmpYellowVipLevel )
				{
					if(GlobalData.yellowBoxInfo.receDayPack > 0)
					{
						_stats.setHtmlValue(LanguageManager.getWord("ssztl.common.hasGetShort"));
					}
					else
					{
						_stats.setHtmlValue("<font color='#8eff57'>" + LanguageManager.getWord("ssztl.common.canGetGiftAttention") + "</font>");
					}
				}
				
//				if(GlobalData.tmpYellowVipLevel == _yellowTemplate.level)
//				{
//					_getedRewardBtn.enabled = true;
//				}
//				else
//				{
//					_getedRewardBtn.enabled = false;
//				}
//				
//				if(GlobalData.yellowBoxInfo.receDayPack > 0)
//				{
//					_getedRewardBtn.enabled = false;
//				}
			}
			
		
//			if(getLevlUp(GlobalData.yellowBoxInfo.levelUpPack))
//			{
//				_getOver.visible = true;
//			}
//			else
//			{
//				_getOver.visible = false;
//			}
		}
		
		public function updateState():void
		{
			_stats.setHtmlValue(LanguageManager.getWord("ssztl.common.hasGetShort"));
		}
		
		private function getLevlUp(returnLevel:int=0):Boolean
		{
			var isReturn:Boolean = false;
			var templateObj:YellowBoxTemplateListInfo;
			var temArray:Array = YellowBoxUtils.getYellowBoxArray(1);
			for(var i:int=0;i<temArray.length;i++)
			{
				templateObj = temArray[i];
				if(templateObj.level > returnLevel && GlobalData.selfPlayer.level >= templateObj.level)
				{
					isReturn = true;
				}
			}
			return isReturn;
		}
		
		public function clearData():void
		{
			var i:int = 0;
			if (_itemList)
			{
				while (i < _itemList.length)
				{
					
					_itemList[i].dispose();
					i++;
				}
				_itemList = [];
			}
			if(_itemTile)
			{
				_itemTile.disposeItems();
			}
		}
		
		public function removeEvent():void
		{
//			_getedRewardBtn.removeEventListener(MouseEvent.CLICK,getRewardClick);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function assetsCompleteHandler():void
		{
			_bgBar.bitmapData = AssetUtil.getAsset("ssztui.yellowVip.BgItemBarAsse",BitmapData) as BitmapData;
			_levelBg.bitmapData = AssetUtil.getAsset("ssztui.yellowVip.LevelTagAsse",BitmapData) as BitmapData;
		}		
		

//		/**
//		 * 领取奖励 
//		 */
//		public function get getedRewardBtn():MAssetButton1
//		{
//			return _getedRewardBtn;
//		}
//
//		/**
//		 * @private
//		 */
//		public function set getedRewardBtn(value:MAssetButton1):void
//		{
//			_getedRewardBtn = value;
//		}

//		/**
//		 * 已领取 
//		 */
//		public function get getOver():Bitmap
//		{
//			return _getOver;
//		}
//
//		/**
//		 * @private
//		 */
//		public function set getOver(value:Bitmap):void
//		{
//			_getOver = value;
//		}
		
		public function get yellowTemplate():YellowBoxTemplateListInfo
		{
			return _yellowTemplate ;
		}
		public function dispose():void
		{
			removeEvent();
			clearData();
			_bgBar = null;
			_levelBg = null;
			_levelable = null;
			_itemTile = null;
			_itemList = null;
			_itemObj = null;
			_yellowTemplate = null;
//			_getedRewardBtn = null;
		}

	}
}