/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-11-8 下午3:35:22 
 * 
 */ 
package sszt.mounts.component
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToMountsData;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.mounts.MountsItemInfoUpdateEvent;
	import sszt.core.data.mounts.MountsUpgradeTemplate;
	import sszt.core.data.mounts.MountsUpgradeTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mounts.MountsModule;
	import sszt.mounts.component.cells.MountsCell1;
	import sszt.mounts.component.cells.MountsFeedCell;
	import sszt.mounts.data.MountsInfo;
	import sszt.mounts.data.itemInfo.MountsFeedItemInfo;
	import sszt.mounts.event.MountsEvent;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.mounts.socketHandler.MountsFeedSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTodayAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.pet.TitleWYAsset;
	import ssztui.ui.ProgressBar3Asset;
	import ssztui.ui.ProgressTrack3Asset;

	public class MountsFeedPanel extends MPanel
	{
		public static const PAGESIZE:int = 12;
		
		private var _mediator:MountsMediator;
		public var _toData:ToMountsData;
		private var _pInfo:MountsItemInfo;
		
		private var _bg:IMovieWrapper;
		
		private var _rightPanel:QualityPanel;
		
		private var _nameLabel:MAssetLabel;
		private var _addTotalExp:MAssetLabel;
		private var _addTotalExpCounts:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _addItemFeedBtn:MCacheAssetBtn1;
		private var _feedBtn:MCacheAssetBtn1;
		private var _progressBar:ProgressBar;
		private var _mountsCell:MountsCell1;
		private var _mTile:MTile;
		private var _cellList:Array;
		private var  _tmpMountsItemInfo:MountsFeedItemInfo;
		private var _expCount:int = 0; 
		
		public function MountsFeedPanel(mediator:MountsMediator,toData:ToMountsData)
		{
			_mediator = mediator;
			_toData = toData;
			super(new MCacheTitle1("",new Bitmap(new TitleWYAsset())), true,-1);
		}
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(521,383);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,505,375)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,7,246,365)),
				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(15,9,242,100)),
//				new BackgroundInfo(BackgroundType.BAR_7,new Rectangle(75,77,169,12)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,118,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,156,228,38),new Bitmap(CellCaches.getCellBgPanel6())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(34,34,50,50),new Bitmap(CellCaches.getCellBigBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(87,43,31,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.level")+ "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(31,76,31,18),new MAssetLabel(LanguageManager.getWord("ssztl.common.experience")+ "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17, 247, 238, 5), new Bitmap(new MountsBgAsset) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(109, 241, 80, 18), new MAssetLabel(LanguageManager.getWord('ssztl.common.ruleIntro'), MAssetLabel.LABEL_TYPE_TITLE2, TextFieldAutoSize.LEFT) ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22, 267, 229, 102),  new MAssetLabel(LanguageManager.getWord('ssztl.mounts.feedRules'), MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(91,63,150,16),new ProgressTrack3Asset()),
			]);
			addContent(_bg as DisplayObject);
			
			_rightPanel = new QualityPanel(_mediator);
			_rightPanel.move(262,0);
			addContent(_rightPanel);
			
			_mTile = new MTile(38,38,6);
			_mTile.itemGapW = _mTile.itemGapH = 0;
			_mTile.horizontalScrollPolicy =_mTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_mTile.setSize(228,76);
			_mTile.move(22,118);
			addContent(_mTile);
			
			_cellList = new Array();
			for(var i:int = 0;i< PAGESIZE;i++)
			{
				var cell:MountsFeedCell = new MountsFeedCell();
				_cellList.push(cell);
				_mTile.appendItem(cell);
			}
			
			_addItemFeedBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.oneKeySplit"));
			_addItemFeedBtn.move(63,202);
			addContent(_addItemFeedBtn);
			_feedBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.mounts.feedLable"));
			_feedBtn.move(137,202);
			addContent(_feedBtn);
			_progressBar = new ProgressBar(new ProgressBar3Asset(),0,0,146,12,true,true);
			_progressBar.move(93,65);
			addContent(_progressBar);
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_nameLabel.move(92,35);
			addContent(_nameLabel);
			
			_addTotalExp = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_addTotalExp.move(103,84);
			addContent(_addTotalExp);
			_addTotalExp.setHtmlValue(LanguageManager.getWord("ssztl.mounts.feedItemExp"));
			
			_addTotalExpCounts = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_addTotalExpCounts.move(165,84);
			addContent(_addTotalExpCounts);
			_addTotalExpCounts.setValue(_expCount.toString());
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_levelLabel.move(127,43);
//			addContent(_levelLabel);
			
			_mountsCell = new MountsCell1();
			_mountsCell.move(34,34);
			addContent(_mountsCell);
			
			if(_pInfo)
			{
				_pInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE_EXP,onExpUpdateHandler);
			}
			if( mountsInfo.currentMounts)
			{
				_mountsCell.mountsInfo = mountsInfo.currentMounts;
				_pInfo = mountsInfo.currentMounts;
				_pInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE_EXP,onExpUpdateHandler);
			}
			initEvent();
			
			initView();
		}
		
		private function initEvent():void
		{
			mountsInfo.addEventListener(MountsEvent.CELL_CLICK,cellClickHandler);
			mountsInfo.addEventListener(MountsEvent.MOUNTS_CELL_UPDATE,updateFeedItemHandler);
			mountsInfo.addEventListener(MountsEvent.MOUNTS_ID_UPDATE,updateMounstsHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_addItemFeedBtn.addEventListener(MouseEvent.CLICK,addFeedItemHander);
			_feedBtn.addEventListener(MouseEvent.CLICK,feedHander);
			for(var i:int = 0;i< PAGESIZE;i++)
			{
				_cellList[i].addEventListener(MouseEvent.CLICK,feedItemClickHandler);
			}
		}
		private function removeEvent():void
		{
			mountsInfo.removeEventListener(MountsEvent.CELL_CLICK,cellClickHandler);
			mountsInfo.removeEventListener(MountsEvent.MOUNTS_CELL_UPDATE,updateFeedItemHandler);
			mountsInfo.removeEventListener(MountsEvent.MOUNTS_ID_UPDATE,updateMounstsHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagItemUpdateHandler);
			_addItemFeedBtn.removeEventListener(MouseEvent.CLICK,addFeedItemHander);
			_feedBtn.removeEventListener(MouseEvent.CLICK,feedHander);
			for(var i:int = 0;i< PAGESIZE;i++)
			{
				_cellList[i].removeEventListener(MouseEvent.CLICK,feedItemClickHandler);
			}
		}
		
		private function updateMounstsHandler(e:MountsEvent):void
		{
			if(_pInfo)
			{
				_pInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE_EXP,onExpUpdateHandler);
			}
			_pInfo = mountsInfo.currentMounts;
			_pInfo.addEventListener(MountsItemInfoUpdateEvent.UPDATE_EXP,onExpUpdateHandler);
			_mountsCell.mountsInfo = _pInfo;
			initView();
		}
		private function initView():void
		{
			onExpUpdate(mountsInfo.currentMounts.exp,mountsInfo.currentMounts.level);
			
//			_nameLabel.setValue(mountsInfo.currentMounts.nick);
//			_nameLabel.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(mountsInfo.currentMounts.templateId).quality);
//			_levelLabel.setValue(LanguageManager.getWord('ssztl.common.levelValue', mountsInfo.currentMounts.level));
			
			_nameLabel.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(mountsInfo.currentMounts.templateId).quality) +"'>" + mountsInfo.currentMounts.nick + "</font> " +
				LanguageManager.getWord('ssztl.common.levelValue', mountsInfo.currentMounts.level)
			);
			
		}
		
		/**监听背包信息更新**/
		private function bagItemUpdateHandler(e:BagInfoUpdateEvent):void
		{
			//			var tmpItemIdList:Vector.<Number> = e.data as Vector.<Number>;
			var tmpItemIdList:Array = e.data as Array;
			for(var i:int = 0;i < tmpItemIdList.length; i++)
			{
				mountsInfo.updateBagToMounts(tmpItemIdList[i],qualityItemListChecker);
			}
		}
		
		private function qualityItemListChecker(argItemInfo:ItemInfo):Boolean
		{
			if(argItemInfo && argItemInfo.template.canFeed && argItemInfo.template.feedCount >0)
			{
				return true;
			}
			return false;
		}
		
		protected function cellClickHandler(e:MountsEvent):void
		{
//			_tmpMountsItemInfo = new MountsFeedItemInfo;
			_tmpMountsItemInfo= e.data as MountsFeedItemInfo;
			var exp:int = _tmpMountsItemInfo.count * _tmpMountsItemInfo.bagItemInfo.template.feedCount;
			if(_tmpMountsItemInfo.bagItemInfo.template.categoryId==544)
				otherClickUpdate(_tmpMountsItemInfo);
			else
			{
				var msg :String = LanguageManager.getWord("ssztl.mounts.feedalert",exp);
				MTodayAlert.show(1,msg,LanguageManager.getWord("ssztl.common.alertTitle"),MTodayAlert.OK|MTodayAlert.CANCEL,null,feedMAlertHandler);
			}
		}
		private function feedMAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MTodayAlert.OK)
			{
				
				otherClickUpdate(_tmpMountsItemInfo);
			}
		}
		protected function feedItemClickHandler(e:MouseEvent):void
		{
			var cell:MountsFeedCell = e.currentTarget as MountsFeedCell;
			if(cell.info)
			{
				var id:Number = cell.itemInfo.itemId;
				var list:Array = mountsInfo.feedItemList;
				var exp:int = cell.itemInfo.count * cell.itemInfo.template.feedCount;
				_expCount -= exp;
				_expCount<0?0:_expCount;
				_addTotalExpCounts.setValue(_expCount.toString());
				for(var i:int = 0;i<list.length;i++)
				{
					if(list[i] && list[i].bagItemInfo.itemId == id)
					{
						var item:ItemInfo = list.splice(i,1)[0].bagItemInfo;
						item.lock = false;
					}
				}
				cell.itemInfo = null;
			}
			
		}
		
		private function clearCellLst():void
		{
			var cell:MountsFeedCell;
			for each(cell in _cellList)
			{
				cell.itemInfo = null;
			}
		}
		
		private function onExpUpdateHandler(evt:MountsItemInfoUpdateEvent):void
		{
			onExpUpdate(evt.data.exp,evt.data.level);
		}
		
		private function onExpUpdate(argexp:Number,arglevel:int):void
		{
			arglevel < 120?_feedBtn.enabled = true:_feedBtn.enabled = false;
			arglevel < 120?_addItemFeedBtn.enabled = true:_addItemFeedBtn.enabled = false;
			var exp:Number = 0;
			var total:Number = 0;
			var tem:MountsUpgradeTemplate = MountsUpgradeTemplateList.getMountsUpgradeTemplate(arglevel+1);
			var tem1:MountsUpgradeTemplate = MountsUpgradeTemplateList.getMountsUpgradeTemplate(arglevel)
			if(tem)
			{
				exp = argexp - tem1.totalExp;
				total = tem.totalExp - tem1.totalExp;
			}
			else
			{
				exp = argexp - tem1.totalExp;
				total = tem1.exp;
			}
			_nameLabel.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(mountsInfo.currentMounts.templateId).quality) +"'>" + mountsInfo.currentMounts.nick + "</font> " +
				LanguageManager.getWord('ssztl.common.levelValue', arglevel)
			);
//			_levelLabel.setValue(LanguageManager.getWord('ssztl.common.levelValue', arglevel));
			_progressBar.setValue(total,exp);
		}
		
		
		protected function updateFeedItemHandler(evt:MountsEvent):void
		{
			var _place:int =evt.data["place"] as int;
			var _mountsItemInfo:MountsFeedItemInfo = evt.data["info"] as MountsFeedItemInfo;
			_cellList[_place].itemInfo = _mountsItemInfo.bagItemInfo;
		}
		
		protected function otherClickUpdate(argMountsItemInfo:MountsFeedItemInfo,isShowTips:Boolean = true,flag:Boolean = false):Boolean
		{
			var isSuccess:Boolean = false;
			var tipsType:int;
			var tipsNullVector:Array = [];
			var tipsUnNullVector:Array = [];
			
			//格子满是不给点击
			var isFull:Boolean = true;
			for(var m:int = 0;m <_cellList.length;m++)
			{
				if(_cellList[m].info == null)
				{
					isFull = false;
					break;
				}
			}
			
			if(isFull)
			{
				return false;
			}
			var i:int = 0
			var id:Number = argMountsItemInfo.bagItemInfo.itemId;
			var list:Array = mountsInfo.feedItemList;
			var exp:int = argMountsItemInfo.count * argMountsItemInfo.bagItemInfo.template.feedCount;
			for(i = 0;i<list.length;i++)
			{
				if(list[i] && list[i].bagItemInfo.itemId == id)
				{
					return false;
				}
			}
			if(flag)//是否一键添加 
			{
				if(argMountsItemInfo.bagItemInfo.template.categoryId==544)//一键添加只能添加经验丹
				{
					for(i = 0;i <_cellList.length;i++)
					{
						if(_cellList[i].info == null)
						{
							_expCount += exp;
							_addTotalExpCounts.setValue(_expCount.toString());
							isSuccess = true;
							argMountsItemInfo.bagItemInfo.lock = true;
							mountsInfo.setToFeedItems(argMountsItemInfo,i);
							break;
						}
					}
				}
			}
			else
			{
				//先填充空格子
				for(i = 0;i <_cellList.length;i++)
				{
					if(_cellList[i].info == null)
					{
						_expCount += exp;
						_addTotalExpCounts.setValue(_expCount.toString());
						isSuccess = true;
						argMountsItemInfo.bagItemInfo.lock = true;
						mountsInfo.setToFeedItems(argMountsItemInfo,i);
						break;
					}
				}
			}
			
			
			
			return isSuccess;
		}
		
		
		private function addFeedItemHander(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(mountsInfo.feedItemList.length >= MountsInfo.PAGESIZE)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.mounts.feedCellFull"));
				return;
			}
			for each(var i:MountsFeedItemInfo in mountsInfo.qualityVector)
			{
				otherClickUpdate(i,true,true);
			}
			
		}
		
		private function feedHander(e:MouseEvent):void
		{
			clearCellLst();
			var placeList:Array = [];
			for each(var i:MountsFeedItemInfo in mountsInfo.feedItemList)
			{
				placeList.push(i.bagItemInfo.place);
			}
			MountsFeedSocketHandler.send(mountsInfo.currentMounts.id,placeList);
			mountsInfo.clearFeedItems();
			_expCount = 0;
			_addTotalExpCounts.setValue(_expCount.toString());
		}
		
		
		public function get mountsModule():MountsModule
		{
			return _mediator.module;
		}
		
		public function get mountsInfo():MountsInfo
		{
			return mountsModule.mountsInfo;
		}
		
		override public function dispose():void
		{
			removeEvent();
			mountsInfo.clearFeedItems();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_rightPanel)
			{
				_rightPanel.dispose();
				_rightPanel = null;
			}
			if(_addItemFeedBtn)
			{
				_addItemFeedBtn.dispose();
				_addItemFeedBtn = null;
			}
			if(_feedBtn)
			{
				_feedBtn.dispose();
				_feedBtn = null;
			}
			
			if(_pInfo)
			{
				_pInfo.removeEventListener(MountsItemInfoUpdateEvent.UPDATE_EXP,onExpUpdateHandler);
				_pInfo = null;
			}
			_nameLabel = null;
			_levelLabel = null;
			_addTotalExpCounts = null;
			_addTotalExp = null;
			super.dispose();
		}
	}
}