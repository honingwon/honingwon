package sszt.yellowBox.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.openActivity.YellowBoxTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.ModuleEvent;
	import sszt.events.YellowBoxEvent;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.yellowVip.BtnGetRewardAsset;
	
	/**
	 * 每日礼包,每日年费礼包 
	 * @author chendong
	 * 
	 */	
	public class EveryDayGift extends Sprite implements IPanel,IYellowPanelView
	{
		private var _bgImg:Bitmap;
		
		private var _itemTile:MTile;
		private var _itemList:Array;
		
		private var _itemTile1:MTile;
		private var _itemList1:Array;
		
		/**
		 * 类型,0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包
		 */		
		private var _type:int = 0;
		private var _type1:int = 3;
		/**
		 * 模板数据 
		 */
		private var templateArray:Array;
		
		
		/**
		 * 领取奖励 领取年费黄钻奖励
		 */
		private var _getedRewardBtn:MAssetButton1;
		private var assetsReady:Boolean;
		private var _levelIcon:Array;
		
		public function EveryDayGift(type:int=0)
		{
			super();
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bgImg = new Bitmap();
			_bgImg.x = _bgImg.y = 2;
			addChild(_bgImg);
			
			_itemList = [];
			_itemTile = new MTile(314,51);
			_itemTile.setSize(332,255);
			_itemTile.move(238,5);
			_itemTile.itemGapW = 0;
			_itemTile.itemGapH = 1;
			_itemTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemTile.verticalScrollPolicy = ScrollPolicy.ON;
			addChild(_itemTile);
			
			_itemList1 = [];
			_itemTile1 = new MTile(50,50,2);
			_itemTile1.setSize(343,112);
			_itemTile1.move(73,121);
			_itemTile1.itemGapW = 2;
			_itemTile1.horizontalScrollPolicy = _itemTile1.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile1);
			
			
			_getedRewardBtn = new MAssetButton1(new BtnGetRewardAsset() as MovieClip);
			_getedRewardBtn.move(66,198);
//			addChild(_getedRewardBtn);
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(66,204,84,15),new MAssetLabel(LanguageManager.getWord("ssztl.club.allAcceptLabel"),MAssetLabel.LABEL_TYPE20)));
		}
		
		public function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(YellowBoxEvent.GET_AWARD,getAwardEveryDay);
		}
		
		public function initData():void
		{
			clearData();
			//每日礼包
			var i:int = 0;
			var templateObj:YellowBoxTemplateListInfo;
			var itemEvery:EveryDayItemView;
			templateArray = YellowBoxUtils.getYellowBoxArray(_type);
			for(i = 0; i<templateArray.length; i++)
			{
				templateObj = templateArray[i];
				itemEvery = new EveryDayItemView(templateObj,_type);
				_itemTile.appendItem(itemEvery);
				_itemList.push(itemEvery);
				
				var levelIcon:Bitmap = new Bitmap();
				levelIcon.x = 21;
				levelIcon.y = 12;
				itemEvery.addChild(levelIcon);
				_levelIcon.push(levelIcon);
				if(assetsReady) itemEvery.assetsCompleteHandler();
			}
			//每日年费礼包
			templateArray = YellowBoxUtils.getYellowBoxArray(_type1);
			i = 0;
			var item:YellowBoxItemView;
			var itemObj:Object;
			for(i = 0; i<templateArray.length; i++)
			{
				templateObj = templateArray[i];
				for(var j:int; j<templateObj.templateIdArray.length; j++)
				{
					itemObj = {};
					itemObj.templateId = templateObj.templateIdArray[j];
					itemObj.count = templateObj.templateNumArray[j];
					item = new YellowBoxItemView(itemObj);
					_itemTile1.appendItem(item);
					_itemList1.push(item);
				}
			}
			
			if(GlobalData.tmpIsYellowVip == 0 || GlobalData.yellowBoxInfo.receDayPack > 0)
			{
				_getedRewardBtn.enabled = false;
			}
			else
			{
				_getedRewardBtn.enabled = true;
			}
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
			i = 0;
			if (_itemList1)
			{
				while (i < _itemList1.length)
				{
					
					_itemList1[i].dispose();
					i++;
				}
				_itemList1 = [];
			}
			if(_itemTile1)
			{
				_itemTile1.disposeItems();
			}
			_levelIcon = [];
		}
		
		private function getAwardEveryDay(evt:ModuleEvent):void
		{
			
			if(int(evt.data.type) == _type || int(evt.data.type) == _type1)
			{
				_getedRewardBtn.enabled = false;
				var itemEvery:EveryDayItemView;
				for(var i:int=0;i<_itemList.length;i++)
				{
					itemEvery = _itemList[i];
					if(itemEvery.yellowTemplate.level == GlobalData.tmpYellowVipLevel)
					{
						itemEvery.updateState();
					}
//					itemEvery.getedRewardBtn.enabled = false;
				} 
			}
		}
		
		public function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(YellowBoxEvent.GET_AWARD,getAwardEveryDay);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_bgImg = null;
			_itemTile = null;
			_itemList = null;
			_itemTile1 = null;
			_itemList1 = null;
			templateArray = null;
			_getedRewardBtn = null;
			_levelIcon = null;
		}
		
		public function assetsCompleteHandler():void
		{
			assetsReady = true;
			_bgImg.bitmapData = AssetUtil.getAsset("ssztui.yellowVip.BgAsset3",BitmapData) as BitmapData;
			for(var i:int=0; i<_itemList.length; i++)
			{
				_itemList[i].assetsCompleteHandler();
				_levelIcon[i].bitmapData = AssetUtil.getAsset("ssztui.yellowVip.YellowVipIconAsse"+i,BitmapData) as BitmapData;
			}
		}
		
		public function hide():void
		{
			this.parent.removeChild(this);
		}
		
		public function show():void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}