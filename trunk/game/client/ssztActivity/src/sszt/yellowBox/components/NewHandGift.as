package sszt.yellowBox.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.openActivity.YellowBoxTemplateList;
	import sszt.core.data.openActivity.YellowBoxTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.openActivity.YellowBoxGetRewardSocketHandler;
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
	 * 新手礼包 
	 * @author chendong
	 * 
	 */	
	public class NewHandGift extends Sprite implements IPanel,IYellowPanelView
	{
		private var _bgImg:Bitmap;
		private var _itemTile:MTile;
		private var _itemList:Array;
		
		/**
		 * 类型,0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包
		 */		
		private var _type:int = 2;
		/**
		 * 模板数据 
		 */
		private var templateArray:Array;
		
		/**
		 * 领取奖励
		 */
		private var _getedRewardBtn:MAssetButton1;
		
		public function NewHandGift(type:int=0)
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
			_itemTile = new MTile(50,50,10);
			_itemTile.setSize(343,112);
			_itemTile.move(370,125);
			_itemTile.itemGapW = 0;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			_getedRewardBtn = new MAssetButton1(new BtnGetRewardAsset() as MovieClip);
			_getedRewardBtn.label = LanguageManager.getWord("ssztl.common.onlineGet");
			_getedRewardBtn.move(327,203);
			addChild(_getedRewardBtn);
		}
		
		public function initEvent():void
		{
			_getedRewardBtn.addEventListener(MouseEvent.CLICK,getClick);
			ModuleEventDispatcher.addModuleEventListener(YellowBoxEvent.GET_INFO,yellowBoxNewHand);
			ModuleEventDispatcher.addModuleEventListener(YellowBoxEvent.GET_AWARD,getAwardNewHand);
			
		}
		
		public function initData():void
		{
			clearData();
			templateArray = YellowBoxUtils.getYellowBoxArray(_type);
			var templateObj:YellowBoxTemplateListInfo;
//			templateObj = YellowBoxTemplateList.yellowBoxDic[_type];
			var i:int = 0;
			var item:YellowBoxItemView
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
					_itemTile.appendItem(item);
					_itemList.push(item);
				}
			}
			_itemTile.move(370-(50*_itemList.length)/2,125);
			
			
			if(GlobalData.yellowBoxInfo.isReceNewPack || GlobalData.tmpIsYellowVip == 0)
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
		}
		
		private function getClick(evt:MouseEvent):void
		{
			YellowBoxGetRewardSocketHandler.send(YellowBoxUtils.currentType);
		}
		
		private function yellowBoxNewHand(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function getAwardNewHand(evt:ModuleEvent):void
		{
			if(int(evt.data.type) == _type)
			{
				_getedRewardBtn.enabled = false;
			}
		}
		
		public function removeEvent():void
		{
			clearData();
			_getedRewardBtn.removeEventListener(MouseEvent.CLICK,getClick);
			ModuleEventDispatcher.removeModuleEventListener(YellowBoxEvent.GET_INFO,yellowBoxNewHand);
			ModuleEventDispatcher.removeModuleEventListener(YellowBoxEvent.GET_AWARD,getAwardNewHand);
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
			templateArray = null;
			_getedRewardBtn = null;
		}
		
		public function assetsCompleteHandler():void
		{
			_bgImg.bitmapData = AssetUtil.getAsset("ssztui.yellowVip.BgAsset1",BitmapData) as BitmapData;
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