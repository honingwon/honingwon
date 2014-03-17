/** 
 * @author 王鸿源
 * @E-mail: honingwon@gmail.com
 */ 
package sszt.pet.component.popup
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.sampler.NewObjectSample;
	import flash.text.TextFieldAutoSize;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetItemInfoUpdateEvent;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.pet.component.PetPanel;
	import sszt.pet.component.cells.DanCell;
	import sszt.pet.component.cells.PetCellBig;
	import sszt.pet.data.PetsInfo;
	import sszt.pet.event.PetEvent;
	import sszt.pet.mediator.PetMediator;
	import sszt.pet.socketHandler.PetStatisUpdateSocketHandler;
	import sszt.pet.util.PetUtil;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pet.TitleAsset;
	import ssztui.ui.SplitCompartLine;
	
	public class PetUpgradeQualityLevelPanel extends MPanel
	{
		public static const PANEL_WIDTH:int = 272;
		public static const PANEL_HEIGHT:int = 383;
		
		private var _mediator:PetMediator;
		private var _bg:IMovieWrapper;
		private var _currentPetInfo:PetItemInfo;
		private var _qualityLevel:int;
		private var _qualityLevelMax:int;
		private var _currentDanAmount:int;
		private var _currentDanTemplateId:int;
		private var _PetHeadCell:PetCellBig;
		
		private var _scBg:Bitmap;
		private var _txtName:MAssetLabel;
		private var _txtQuality:MAssetLabel;
		private var _txtDanNumber:MAssetLabel;
		private var _txtSuccessProbability:MAssetLabel;
		
		private var _danCell:DanCell;
		private var _btnUpgrade:MCacheAssetBtn1;
		private var _btnUpgradeMask:MSprite;
		
		public function PetUpgradeQualityLevelPanel(mediator:PetMediator)
		{
			_mediator = mediator;
			_currentPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			
			super(new MCacheTitle1("Jinghua"), true,-1,true,false,GlobalAPI.layerManager.getTopPanelRec());
			setData(null);
			initEvent();
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.PET1));
			
//			setPosition();
		}
		
//		private function setPosition():void
//		{
//			var x:int = (CommonConfig.GAME_WIDTH - PetPanel.PANEL_WIDTH - PetUpgradeQualityPanel.PANEL_WIDTH)/2 + PetPanel.PANEL_WIDTH
//			var y:int = (CommonConfig.GAME_HEIGHT - PetPanel.PANEL_HEIGHT)/2
//			move(x,y);
//		}
		
		override protected  function configUI():void
		{
			super.configUI();
			setContentSize(PANEL_WIDTH,PANEL_HEIGHT);
			
			var txtBgQuality:MAssetLabel = new MAssetLabel('',  MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			txtBgQuality.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.sword.qualityLevel') + '：</font></b>';
			var txtBgRulesIntro:MAssetLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			txtBgRulesIntro.multiline = txtBgRulesIntro.wordWrap = true;
			txtBgRulesIntro.setSize(230,114);
			txtBgRulesIntro.setHtmlValue(LanguageManager.getWord('ssztl.pet.stairsRules'));
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 2, 256, 375)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13, 7, 246, 205)),
				new BackgroundInfo(BackgroundType.BORDER_13, new Rectangle(15,9, 242, 201)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(13,215, 246, 157)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(15,79,242,2)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(15,219,242,26)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(22,17,54,54), new Bitmap(CellCaches.getCellBigBoxBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(24,19,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(30,116,38,38), new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(204,123,40,22)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(85,47,48,18), txtBgQuality ),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(182,126,15,18), new MAssetLabel('×', MAssetLabel.LABEL_TYPE1, TextFieldAutoSize.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(96,223,80,18), new MAssetLabel(LanguageManager.getWord('ssztl.common.ruleIntro'), MAssetLabel.LABEL_TYPE_TITLE2)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(21,249,230,114),txtBgRulesIntro),
			]);
			addContent(_bg as DisplayObject);
			_PetHeadCell = new PetCellBig();
			_PetHeadCell.move(24,19);
			addContent(_PetHeadCell);
			
			_scBg = new Bitmap();
			_scBg.x = 16;
			_scBg.y = 80;
			if(_mediator.module.assetsReady)
			{
				_scBg.bitmapData = AssetUtil.getAsset('ssztui.pet.ScBarBgAsset',BitmapData) as BitmapData;
			}
			addContent(_scBg);
			
			_txtName = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtName.move(85,22);
			addContent(_txtName);
			
			_txtQuality = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtQuality.move(130,47);
			addContent(_txtQuality);
			
			_txtSuccessProbability = new MAssetLabel('', MAssetLabel.LABEL_TYPE7);
			_txtSuccessProbability.move(136,86);
			addContent(_txtSuccessProbability);
			
			_danCell = new DanCell();
			_danCell.move(30,116);
			addContent(_danCell);
			
			_txtDanNumber = new MAssetLabel('', MAssetLabel.LABEL_TYPE20, TextFieldAutoSize.LEFT);
			_txtDanNumber.setSize(29,16);
			_txtDanNumber.move(214,126);
			addContent(_txtDanNumber);
			
			_btnUpgrade = new MCacheAssetBtn1(0, 3, LanguageManager.getWord('ssztl.common.stairs'));
			_btnUpgrade.move(101,165);
			addContent(_btnUpgrade);
			
			_btnUpgradeMask = new MSprite();
			_btnUpgradeMask.graphics.beginFill(0,0);
			_btnUpgradeMask.graphics.drawRect(0,0,75,30);
			_btnUpgradeMask.graphics.endFill();
			_btnUpgradeMask.move(101,165);
			addContent(_btnUpgradeMask);
			_btnUpgradeMask.visible = false;
			_btnUpgradeMask.mouseEnabled = false;
		}
		
		private function setData(e:Event):void
		{
			_currentDanTemplateId = PetUtil.getPetStairPillType(_currentPetInfo.stairs);
			
			_danCell.danInfo = ItemTemplateList.getTemplate(_currentDanTemplateId);
			
			updateCurrentDanAmount();
			
			_qualityLevel = _currentPetInfo.stairs;
			if(_qualityLevel == PetsInfo.PET_STAIRS_MAX)
			{
				_btnUpgrade.enabled = false;
				_btnUpgradeMask.visible = true;
				_btnUpgradeMask.mouseEnabled = true;
				_btnUpgradeMask.addEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
				_btnUpgradeMask.addEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
			}
			else
			{
				_btnUpgrade.enabled = true;
				_btnUpgradeMask.visible = false;
				_btnUpgradeMask.mouseEnabled = false;
				_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
				_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
			}
			
//			_txtName.setValue(_currentPetInfo.nick + " " + LanguageManager.getWord('ssztl.common.levelValue', _currentPetInfo.level));
			_txtName.setHtmlValue(
				"<font color='#" + CategoryType.getQualityColorString(ItemTemplateList.getTemplate(_currentPetInfo.templateId).quality) +"'>" + _currentPetInfo.nick + "</font> " +
				LanguageManager.getWord('ssztl.common.levelValue',_currentPetInfo.level)
			);
			_PetHeadCell.petItemInfo = _currentPetInfo;
			_txtQuality.htmlText = '<b><font size="14">' + _qualityLevel + '</font></b>';
			var rate:int;
			var addtionalRate:int;
			if(_qualityLevel < 2)
			{
				rate = 100;
			}
			else if(_qualityLevel < 4)
			{
				rate = 75;
			}
			else if( _qualityLevel < 6)
			{
				rate = 55;
			}
			else if(_qualityLevel < 8)
			{
				rate = 40;
			}
			else if(_qualityLevel < 9)
			{
				rate = 30;
			}
			else if(_qualityLevel < 10)
			{
				rate = 20;
			}
			else
			{
				rate = 10;
			}
			var vipType:int = GlobalData.selfPlayer.getVipType();
			if(vipType > VipType.NORMAL)
			{
				addtionalRate = VipTemplateList.getVipTemplateInfo(vipType).petStairRate;
				rate += addtionalRate;
				rate = (rate > 100) ? 100 : rate;
			}
			if(GlobalData.selfPlayer.getVipType()>1)
			{
				switch(GlobalData.selfPlayer.getVipType())
				{
					case 2:
						_txtSuccessProbability.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' +  '</font></b>'+LanguageManager.getWord('ssztl.pet.successRateAddh');
						break;
					case 3:
						_txtSuccessProbability.htmlText = '<b><font size="14">' + LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' +  '</font></b>'+LanguageManager.getWord('ssztl.pet.successRateAddb');
						break;
				}
				
			}
			else
				_txtSuccessProbability.htmlText = '<b><font size="12">' + LanguageManager.getWord('ssztl.pet.successRate') + '：' + rate + '%' + '</font></b>';
			_txtDanNumber.setValue(''+_currentDanAmount);
		}
		
		private function initEvent():void
		{
			_btnUpgrade.addEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.addEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_btnUpgrade.removeEventListener(MouseEvent.CLICK, btnUpgradeClickHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_ID_UPDATE,bagInfoUpdateHandler);
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_mediator.module.petsInfo.removeEventListener(PetEvent.PET_SWITCH, currentPetChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OVER, handleBtnUpgradeMouseOver);
			_btnUpgradeMask.removeEventListener(MouseEvent.MOUSE_OUT, handleBtnUpgradeMouseOut);
		}
		
//		private function gameSizeChangeHandler(e:CommonModuleEvent):void
//		{
//				setPosition();
//		}		
		
		private function handleBtnUpgradeMouseOver(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.pet.stairsMax'),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function handleBtnUpgradeMouseOut(e:Event):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function currentPetChangeHandler(e:PetEvent):void
		{
			_currentPetInfo.removeEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			_currentPetInfo = _mediator.module.petsInfo.currentPetItemInfo;
			_currentPetInfo.addEventListener(PetItemInfoUpdateEvent.UPDATE, setData);
			setData(null);
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.PET1)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addContent);
			}
		}
		
		private function bagInfoUpdateHandler(event:Event):void
		{
			updateCurrentDanAmount();
			_txtDanNumber.setValue(''+_currentDanAmount);
		}
		
		private function updateCurrentDanAmount():void
		{
			_currentDanAmount = GlobalData.bagInfo.getItemCountById(_currentDanTemplateId);
		}
		
		private function btnUpgradeClickHandler(event:MouseEvent):void
		{
			if(_currentDanAmount == 0)
			{
				if(_currentDanTemplateId == CategoryType.PET_STAIRS_PILL4 || _currentDanTemplateId == CategoryType.PET_STAIRS_PILL5)
				{
					QuickTips.show(LanguageManager.getWord('ssztl.common.hasNotEnoughpItem'));
				}
				else
				{
					BuyPanel.getInstance().show([_currentDanTemplateId],new ToStoreData(ShopID.STORE));
				}
			}
			else
			{
				PetStatisUpdateSocketHandler.send(_currentPetInfo.id);
				GuideTip.getInstance().hide();
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_scBg){
				_scBg.bitmapData.dispose();
				_scBg = null;
			}
			if(_currentPetInfo)
			{
				_currentPetInfo = null;
			}
			if(_txtName)
			{
				_txtName= null;
			}
			if(_txtQuality)
			{
				_txtQuality= null;
			}
			if(_txtDanNumber)
			{
				_txtDanNumber= null;
			}
			if(_txtSuccessProbability)
			{
				_txtSuccessProbability= null;
			}
			if(_danCell)
			{
				_danCell.dispose();
				_danCell = null;
			}
			if(_PetHeadCell)
			{
				_PetHeadCell.dispose();
				_PetHeadCell = null;
			}
			if(_btnUpgrade)
			{
				_btnUpgrade.dispose();
				_btnUpgrade = null;
			}
		}
	}
}