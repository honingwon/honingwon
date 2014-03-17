package sszt.sevenActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.SevenActivityItemInfo;
	import sszt.core.data.activity.SevenActivityUserItemInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.openActivity.SevenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.sevenActivity.socketHandlers.SevenActivityGetReward2SocketHandler;
	import sszt.sevenActivity.socketHandlers.SevenActivityGetRewardSocketHandler;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.sevenActivity.BgItemAsset;
	import ssztui.sevenActivity.BgItemOverAsset;
	import ssztui.sevenActivity.IndexTitleAsset1;
	import ssztui.sevenActivity.IndexTitleAsset2;
	import ssztui.sevenActivity.IndexTitleAsset3;
	import ssztui.sevenActivity.IndexTitleAsset4;
	import ssztui.sevenActivity.IndexTitleAsset5;
	import ssztui.sevenActivity.IndexTitleAsset6;
	import ssztui.sevenActivity.IndexTitleAsset7;
	import ssztui.sevenActivity.TagGetListAsset;
	import ssztui.sevenActivity.TagLeadListAsset;
	
	public class SevenActivityItemView extends Sprite implements IPanel
	{
		private var _bg:Bitmap;
		private var _dayTitle:Bitmap;
		private var _dayList:Array = [IndexTitleAsset1,IndexTitleAsset2,IndexTitleAsset3,IndexTitleAsset4,IndexTitleAsset5,IndexTitleAsset6,IndexTitleAsset7];
		
//		private var _nobodyRanking:MAssetLabel;

		/**
		 * 获得奖励的图片 
		 */
		private var _cell:Cell;
//		private var _cell2:Cell;
//		private var _cell3:Cell;
		private var _cellAll:Cell;
		
		private var _cellBitmap:Bitmap;
		private var _picPath:String;
		
		private var _itemTile:MTile;
//		private var _itemList:Array;
		private var _requestLabel:MAssetLabel;
		private var _showDetail:MCacheAssetBtn1;
		private var _allRewardDetail:MAssetLabel;
		
		private var _getRewardBtn1:MCacheAssetBtn1;
		
		private var _getRewardTxt2:MAssetLabel;
		private var _getRewardBtn2:Sprite;
		
		private var _selectedBg:Bitmap;
//		private var _tagList:Bitmap;
		
		private var _sevenActInfo:SevenActivityTemplateListInfo;
		
		public function SevenActivityItemView(sevenActInfo:SevenActivityTemplateListInfo)
		{
			super();
			_sevenActInfo = sevenActInfo;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bg = new Bitmap(new BgItemAsset());
			addChild(_bg);
			
			_dayTitle = new Bitmap();
			addChild(_dayTitle);
			
//			_nobodyRanking = new MAssetLabel(LanguageManager.getWord('ssztl.common.nobodyRanking'),MAssetLabel.LABEL_TYPE7);
//			_nobodyRanking.move(52,241);
//			addChild(_nobodyRanking);
			
			
			_requestLabel = new MAssetLabel(LanguageManager.getWord('ssztl.activity.sevenDetail1'+_sevenActInfo.id),MAssetLabel.LABEL_TYPE7);
			_requestLabel.move(77-_requestLabel.width/2,207);
			addChild(_requestLabel);
			
			_cellBitmap = new Bitmap();
			_cellBitmap.x = 11;
			_cellBitmap.y = 59;
			addChild(_cellBitmap);
			
			_cell = new Cell();
			_cell.move(64,236);
			addChild(_cell);
			
//			_cell2 = new Cell();
//			_cell2.move(71,122);
//			addChild(_cell2);
//			
//			_cell3 = new Cell();
//			_cell3.move(114,122);
//			addChild(_cell3);
			
			_showDetail = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.openActivityactCont.showDetail'));
			_showDetail.move(46,169);
			addChild(_showDetail);
			
//			_tagList = new Bitmap(new TagGetListAsset());
//			_tagList.x = 53;
//			_tagList.y = 205;
//			addChild(_tagList);
			
//			_itemList = [];
//			_itemTile = new MTile(156,16,1);
//			_itemTile.setSize(156,60);
//			_itemTile.move(5,232);
//			_itemTile.itemGapH = 0;
//			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
//			addChild(_itemTile);
			
			_cellAll = new Cell();
			_cellAll.move(64,336);
			addChild(_cellAll);
			
			_allRewardDetail = new MAssetLabel("",MAssetLabel.LABEL_TYPE21);
			_allRewardDetail.move(83,317);
			addChild(_allRewardDetail);
			if(GlobalData.functionYellowEnabled)
				var condition:String = 'ssztl.activity.sevenEveryOneCondition' + _sevenActInfo.id;
			else
				condition = 'ssztl.activity.sevenEveryOneCondition2' + _sevenActInfo.id;
			_allRewardDetail.setHtmlValue( LanguageManager.getWord(condition));
			
			_getRewardTxt2 = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_getRewardTxt2.move(68,374);
			addChild(_getRewardTxt2);
			_getRewardTxt2.setHtmlValue("<u>" + LanguageManager.getWord("ssztl.common.getLabel") + "</u>");
			
			_getRewardBtn1 =  new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.club.getWelFare'));
			_getRewardBtn1.move(46,169);
			addChild(_getRewardBtn1);
			
			_getRewardBtn2 = new MSprite();
			_getRewardBtn2.graphics.beginFill(0,0);
			_getRewardBtn2.graphics.drawRect(65,374,30,16);
			_getRewardBtn2.graphics.endFill();
			_getRewardBtn2.buttonMode = true;
			addChild(_getRewardBtn2);
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
			var i:int = 0;
//			if (_itemList)
//			{
//				while (i < _itemList.length)
//				{
//					
//					_itemList[i].dispose();
//					i++;
//				}
//				_itemList = [];
//			}
			if(_itemTile)
			{
				_itemTile.disposeItems();
			}
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			clearData();
			var sevenActivityItemInfo:SevenActivityItemInfo = GlobalData.sevenActInfo.activityDic[_sevenActInfo.id];
//			_actName.setValue("第"+ _sevenActInfo.id +"天 \n"+_sevenActInfo.title);
			_dayTitle.bitmapData = new _dayList[_sevenActInfo.id-1];
			
			var info:ItemTemplateInfo = new ItemTemplateInfo();
			var templateId:int = int(_sevenActInfo.rewardFirstThreeDic['1'+GlobalData.selfPlayer.career]);
			info = ItemTemplateList.getTemplate(templateId);
			_cell.info = info;
			
//			templateId = _sevenActInfo.rewardFirstThreeDic['2'+GlobalData.selfPlayer.career];
//			info = ItemTemplateList.getTemplate(templateId);
//			_cell2.info = info;
//			
//			templateId = _sevenActInfo.rewardFirstThreeDic['3'+GlobalData.selfPlayer.career];
//			info = ItemTemplateList.getTemplate(templateId);
//			_cell3.info = info;
			
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _sevenActInfo.item;
			itemInfo.count =_sevenActInfo.count;
			_cellAll.itemInfo = itemInfo;
			
			if(sevenActivityItemInfo.isEnd)
			{
				if(SevenActivityUtils.isGetReward(GlobalData.selfPlayer.userId,_sevenActInfo.id))
				{
					_getRewardBtn1.visible = true;
				}
				else
				{
					_getRewardBtn1.visible = false;
				}
				
				if(SevenActivityUtils.isRewardGot(GlobalData.selfPlayer.userId,_sevenActInfo.id))
				{
					_getRewardBtn1.label = LanguageManager.getWord("ssztl.activity.hasGotten");
					_getRewardBtn1.enabled = false;
					_getRewardBtn1.visible =true;
					_showDetail.visible = false;
				}
			}
			else
			{
				_getRewardBtn1.visible = false;
			}
			
			//全民奖励是否领取
			var isGot:Boolean;
			var gotStateCode:int = GlobalData.sevenActInfo.gotState;
			isGot = ((1 << ( _sevenActInfo.id)) & gotStateCode) > 0;
			
			var isCurrentDay:Boolean;
			isCurrentDay = GlobalData.sevenActInfo.getDay() == _sevenActInfo.id
			if(!isCurrentDay)
			{
				_getRewardTxt2.visible = false;
				_getRewardBtn2.visible = false;
			}
			if(isGot)
			{
				_getRewardBtn2.visible =false;
				_getRewardTxt2.setValue(LanguageManager.getWord('ssztl.activity.hasGotten'));
				_getRewardTxt2.textColor = 0xa38061;
			}
			
			
			var uersArray:Array = sevenActivityItemInfo.userArray;
			var sevenActivityUserItemInfo:SevenActivityUserItemInfo;
			var unTV:UserNameItemView;
			var day:int = GlobalData.sevenActInfo.getDay();
			var isCurrDay:Boolean = _sevenActInfo.id==day;
			var isEnd:Boolean = sevenActivityItemInfo.isEnd;
//			if(isEnd || (!isEnd && isCurrDay))
//			{
//				for(var i:int;i<uersArray.length;i++)
//				{
//					sevenActivityUserItemInfo = uersArray[i];
//					unTV = new UserNameItemView(sevenActivityUserItemInfo,i,_sevenActInfo.id,isEnd,isCurrDay);
//					_itemTile.appendItem(unTV);
//					_itemList.push(unTV);
//				}
//				_nobodyRanking.visible = false;
//			}
			
//			if(isCurrentDay)
//			{
//				_tagList.bitmapData = new TagLeadListAsset();
//				_selectedBg = new Bitmap(new BgItemOverAsset());
//				addChild(_selectedBg);
//			}else
//			{
//				_itemTile.height = 16;
//				_itemTile.y = 227+16;
//			}
			
			_picPath = GlobalAPI.pathManager.getActivityBannerPath(100+_sevenActInfo.id);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
		}
		
		public function initEvent():void
		{
			_getRewardBtn1.addEventListener(MouseEvent.CLICK,getBtnClick);
			_getRewardBtn2.addEventListener(MouseEvent.CLICK,getBtnClick2);
			_showDetail.addEventListener(MouseEvent.CLICK,showDetailClick);
			
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.SEVEN_ACTIVITY_GET_RED,getSevenAwardData);
		}
		
		public function removeEvent():void
		{
			_getRewardBtn1.removeEventListener(MouseEvent.CLICK,getBtnClick);
			_getRewardBtn2.removeEventListener(MouseEvent.CLICK,getBtnClick2);
			_showDetail.removeEventListener(MouseEvent.CLICK,showDetailClick);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.SEVEN_ACTIVITY_GET_RED,getSevenAwardData);
		}
		
		private function getBtnClick(evt:MouseEvent):void
		{
			SevenActivityGetRewardSocketHandler.send(_sevenActInfo.id);
		}
		
		private function getBtnClick2(evt:MouseEvent):void
		{
			SevenActivityGetReward2SocketHandler.send(_sevenActInfo.id);
		}
		private function showDetailClick(evt:MouseEvent):void
		{
			DetailShowPanel.getInstance().show();
		}
		
		private function tipOver(evt:MouseEvent):void
		{
			
			TipsUtil.getInstance().show("",null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function tipOut(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function getSevenAwardData(evt:ModuleEvent):void
		{
			
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_cellBitmap.bitmapData = data;
		}
		
		public function move(x:Number, y:Number):void
		{
			// TODO Auto Generated method stub
			this.x = x;
			this.y = y;
		}
		
		public function set gotBtn2Visible(value:Boolean):void
		{
			_getRewardBtn2.visible =value;
			_getRewardTxt2.setValue(LanguageManager.getWord('ssztl.activity.hasGotten'));
			_getRewardTxt2.textColor = 0xa38061;
		}
		
		public function dispose():void
		{
			clearData();
			removeEvent();
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_cellBitmap && _cellBitmap.bitmapData)
			{
//				_cellBitmap.bitmapData.dispose();
				_cellBitmap = null;
			}
			if(_cell)
			{
				_cell.dispose();
				_cell = null;
			}
			if(_cellAll)
			{
				_cellAll.dispose();
				_cellAll = null;
			}
			if(_dayTitle && _dayTitle.bitmapData)
			{
				_dayTitle.bitmapData.dispose();
				_dayTitle = null;
			}
			if(_getRewardBtn1 && _getRewardBtn1.parent)
			{
				_getRewardBtn1.graphics.clear();
				_getRewardBtn1.parent.removeChild(_getRewardBtn1);
				_getRewardBtn1 = null;
			}
			if(_getRewardBtn2 && _getRewardBtn2.parent)
			{
				_getRewardBtn2.graphics.clear();
				_getRewardBtn2.parent.removeChild(_getRewardBtn2);
				_getRewardBtn2 = null;
			}
			_getRewardTxt2 = null;
			_allRewardDetail = null;
			_itemTile = null;
//			_itemList = null;
		}
	}
}