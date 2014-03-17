/** 
 * @author Aron 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-12-21 上午9:18:34 
 * 
 */ 
package sszt.club.components.clubMain.pop.sec.manager
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.components.clubMain.pop.items.MClubCacheSelectBtn;
	import sszt.club.components.clubMain.pop.sec.IClubMainPanel;
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	import sszt.club.events.ClubDeviceUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubLevelUpSocketHandler;
	import sszt.club.socketHandlers.ClubUpgradeDeviceSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.club.ClubFurnaceLevelTemplate;
	import sszt.core.data.club.ClubFurnaceTemplateList;
	import sszt.core.data.club.ClubLevelTemplate;
	import sszt.core.data.club.ClubLevelTemplateList;
	import sszt.core.data.club.ClubShopLevelTemplate;
	import sszt.core.data.club.ClubShopLevelTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.icon.MCacheIcon1;
	
	public class FacilityPanel extends MSprite implements IClubMainPanel
	{
		
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		private var _rowBg:Shape;
		
		/**
		 * 设施列表
		 * */
		private var _btnArray:Array;
		private var _currentType:int;
		
		private var _icon:Bitmap;
		private var _iconSrcArray:Array;
		private var _name:MAssetLabel;
		private var _descript:MAssetLabel;
		private var _curLevel:MAssetLabel;
		private var _curEffect:MAssetLabel;
		private var _nextLevel:MAssetLabel;
		private var _nextEffect:MAssetLabel;
		private var _okBtn:MCacheAssetBtn1;
		
		private var _need1:MAssetLabel;
		private var _need2:MAssetLabel;
		
		
		private var _decripts:Array = [LanguageManager.getWord("ssztl.club.upgradeClubPrompt1"),
			LanguageManager.getWord("ssztl.club.upgradeClubPrompt2"),
			LanguageManager.getWord("ssztl.club.upgradeClubPrompt3")];
		
//		private var _types:Array = [LanguageManager.getWord("ssztl.club.upgradeClub"),
//			LanguageManager.getWord("ssztl.club.clubFurnace2"),
//			LanguageManager.getWord("ssztl.club.clubStore2")];
		
		
		public function FacilityPanel(mediator:ClubMediator)
		{
			_mediator = mediator;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_rowBg = new Shape();	
			_rowBg.graphics.beginFill(0x172527,1);
			_rowBg.graphics.drawRect(0,0,443,23);
			_rowBg.graphics.endFill();
			//addChild(_rowBg);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,455,120)),				
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,123,455,230)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,135,443,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,135,443,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,160,443,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,185,443,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(6,248,443,2)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,137,443,23),_rowBg),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,288,6,7),new MCacheIcon1(0)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,306,6,7),new MCacheIcon1(0)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(197,137,40,23),new MCacheIcon1(1)), //RightArrow
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(113,45,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.devDescript") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,141,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.currentLevel") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(245,141,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.nextLevel2") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,165,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.curEffect") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(245,165,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.upgradeEffect") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,260,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.upgradeCondition") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				
			]);
			addChild(_bg as DisplayObject);	
			
			_iconSrcArray = [];
			_icon = new Bitmap();
			_icon.x = _icon.y = 19;
			addChild(_icon);
			
//			for(var j:int = 0; j<3; j++){
//				var _icon:Bitmap = new Bitmap();
//				_icon.x = _icon.y = 19;
//				addChild(_icon);
//				_icon.visible = false;
//				_iconSrcArray.push(_icon);
//			}
			
			_currentType = 0;
			
			/*
			_btnArray = [];						
			var labels:Array = [LanguageManager.getWord("ssztl.common.club"),
				LanguageManager.getWord("ssztl.club.clubStore"),
				LanguageManager.getWord("ssztl.club.clubFurnace")];
			var px:int = 140;
			var btn1:MClubCacheSelectBtn;
			
			for(var i:int = 0;i<labels.length;i++)
			{
				btn1 = new MClubCacheSelectBtn(0,102,"1/1",labels[i]);
				btn1.move(px,370);
				addChild(btn1);
				_btnArray.push(btn1);
				px += 112;
			}
			
			_btnArray[_currentType].selected = true;
			*/
			
			_name = new MAssetLabel("",MAssetLabel.LABEL_TYPE21B,TextFormatAlign.LEFT);
			_name.move(113,20);
			addChild(_name);
			_descript = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_descript.wordWrap = true;
			_descript.multiline = true;
			_descript.move(113,64);
			_descript.setSize(286,34);
			_descript.mouseEnabled = _descript.mouseWheelEnabled = false;
			addChild(_descript);
			
			_curLevel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_curLevel.move(81,141);
			addChild(_curLevel);
			
			_curEffect = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_curEffect.wordWrap = true;
			_curEffect.multiline = true;
			_curEffect.move(21,191);
			_curEffect.setSize(188,58);
			_curEffect.mouseEnabled = _curEffect.mouseWheelEnabled = false;
			addChild(_curEffect);
			
			_nextLevel = new MAssetLabel("",MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
			_nextLevel.move(304,141);
			addChild(_nextLevel);
			
			_nextEffect = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_nextEffect.wordWrap = true;
			_nextEffect.multiline = true;
			_nextEffect.move(245,191);
			_nextEffect.setSize(188,58);
			_nextEffect.mouseEnabled = _nextEffect.mouseWheelEnabled = false;
			addChild(_nextEffect);
			
			_need1 = new MAssetLabel("",MAssetLabel.LABEL_TYPE6,TextFormatAlign.LEFT);
			_need1.move(34,283);
			addChild(_need1);
			
			_need2= new MAssetLabel("",MAssetLabel.LABEL_TYPE6,TextFormatAlign.LEFT);
			_need2.move(34,301);
			addChild(_need2);
			
			_okBtn = new MCacheAssetBtn1(0,1,LanguageManager.getWord("ssztl.common.upgrade"));
			_okBtn.move(246,296);
			addChild(_okBtn);
			_okBtn.enabled = false;
			if(GlobalData.selfPlayer.clubDuty == ClubDutyType.MASTER)
			{
				_okBtn.enabled = true;
			}
			
			initEvent();
			//updateHandler(null);
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			//if(parent) parent.removeChild(this);
			this.visible= false;
		}
		public function setData(index:int):void{
			if(index > -1)
				updateData(index);
		}
		
		public function assetsCompleteHandler():void
		{
			_iconSrcArray.push(AssetUtil.getAsset("ssztui.club.ClubFacilityAsset1",BitmapData) as BitmapData);
			_iconSrcArray.push(AssetUtil.getAsset("ssztui.club.ClubFacilityAsset2",BitmapData) as BitmapData);
			_iconSrcArray.push(AssetUtil.getAsset("ssztui.club.ClubFacilityAsset3",BitmapData) as BitmapData);
			_icon.bitmapData = _iconSrcArray[_currentType];
		}
		
		private function initEvent():void
		{
//			for(var i:int = 0;i<_btnArray.length;i++)
//			{
//				_btnArray[i].addEventListener(MouseEvent.CLICK,changeType);
//			}
			
			_okBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
//			_mediator.clubInfo.deviceInfo.addEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,updateHandler);
			_mediator.clubInfo.clubDetailInfo.addEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,clubLevelUpdateHandler);
		}
		
		private function removeEvent():void
		{
			
//			for(var i:int = 0;i<_btnArray.length;i++)
//			{
//				_btnArray[i].removeEventListener(MouseEvent.CLICK,changeType);
//			}
			_okBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			
//			_mediator.clubInfo.deviceInfo.removeEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,updateHandler);
			_mediator.clubInfo.clubDetailInfo.removeEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,clubLevelUpdateHandler);
		}
		
		
		private function upClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			switch (_currentType)
			{
				case 0:					
					var info1:ClubLevelTemplate = ClubLevelTemplateList.getTemplate(_mediator.clubInfo.clubDetailInfo.clubLevel + 1);
					if(info1)
					{
						if(info1.needRich > _mediator.clubInfo.clubDetailInfo.clubRich)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough"));
							return;
						}
						ClubLevelUpSocketHandler.send();
					}else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.club.levelAchieveMax"));
					}
					break;
				case 1:
					var info3:ClubShopLevelTemplate = ClubShopLevelTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.shopLevel + 1);
					if(info3)
					{
						if(_mediator.clubInfo.clubDetailInfo.clubLevel < info3.needClubLevel)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubLevelNotEnough"));
							return;
						}
						if(GlobalData.selfPlayer.userMoney.copper < info3.needCopper)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
							return;
						}
						if(_mediator.clubInfo.clubDetailInfo.clubRich < info3.needClubRich)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough2"));
							return;
						}
						ClubUpgradeDeviceSocketHandler.send(2);
					}else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.club.levelAchieveMax"));
					}
					break;
				case 2:
					var info2:ClubFurnaceLevelTemplate = ClubFurnaceTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.furnaceLevel + 1);
					if(info2)
					{
						if(_mediator.clubInfo.clubDetailInfo.clubLevel < info2.needClubLevel)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubLevelNotEnough"));
							return;
						}
						if(GlobalData.selfPlayer.userMoney.copper < info2.needCopper)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
							return;
						}
						if(_mediator.clubInfo.clubDetailInfo.clubRich < info2.needClubRich)
						{
							QuickTips.show(LanguageManager.getWord("ssztl.club.clubMoneyNotEnough2"));
							return;
						}
						ClubUpgradeDeviceSocketHandler.send(1);
					}
					else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.club.levelAchieveMax"));
					}
					break;
					
			}
		}
		
		/*
		private function changeType(evt:MouseEvent):void
		{  
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _btnArray.indexOf(evt.currentTarget);
			setCurrentTypeSelect(index);
			updateData(index);
		}
		
		private function setCurrentTypeSelect(index:int):void
		{
			if(index==_currentType) return;
			_currentType = index;
			
			for(var i:int = 0; i < _btnArray.length;i++){
				_btnArray[i].selected = false;
			}
			
			_btnArray[_currentType].selected=true;						
		}
		*/
		
		private function updateData(index:int):void
		{
			_currentType = index;
			
			var needClubLevel:int;
			var needClubRich:int;
			
			_descript.setValue(_decripts[index]);
			if(index == 0)
			{
				_name.setValue(LanguageManager.getWord("ssztl.club.facilityClub"));
				var info1:ClubLevelTemplate = ClubLevelTemplateList.getTemplate(_mediator.clubInfo.clubDetailInfo.clubLevel);
				var info1_1:ClubLevelTemplate = ClubLevelTemplateList.getTemplate(_mediator.clubInfo.clubDetailInfo.clubLevel + 1);
				if(info1)
				{
					_curLevel.setValue(String(_mediator.clubInfo.clubDetailInfo.clubLevel));
					_curEffect.setValue(info1.getCurEffectToString());
					needClubLevel = info1.clubLevel;
					_need1.setValue(info1.getNeed1ToString());
				}
				if(info1_1)
				{
					_nextLevel.setValue(String(_mediator.clubInfo.clubDetailInfo.clubLevel+1));
					_nextEffect.setValue(info1_1.getNextEffectToString());
					_need2.setValue(info1_1.getNeed2ToString());
					needClubRich = info1_1.needRich;
				
				}
				else
				{
					_nextLevel.setValue(LanguageManager.getWord("ssztl.common.none"));
					_nextEffect.setValue(LanguageManager.getWord("ssztl.common.none"));
					_nextEffect.textColor = 0xffffff;
					_need1.setValue(LanguageManager.getWord("ssztl.common.none"));
					_need2.setValue(LanguageManager.getWord("ssztl.common.none"));
				}
			}
			else if(index == 1)
			{
				_name.setValue(LanguageManager.getWord("ssztl.club.facilityChop"));
				var info3:ClubShopLevelTemplate = ClubShopLevelTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.shopLevel );
				var info3_1:ClubShopLevelTemplate = ClubShopLevelTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.shopLevel + 1);
				if(info3)
				{
					_curLevel.setValue(String(_mediator.clubInfo.deviceInfo.shopLevel));
					_curEffect.setValue(info3.getCurEffectToString());
				}
				if(info3_1)
				{
					_nextLevel.setValue(String(_mediator.clubInfo.deviceInfo.shopLevel+1));
					_nextEffect.setValue(info3_1.getNextEffectToString());
					_need1.setValue(info3_1.getNeed1ToString());
					_need2.setValue(info3_1.getNeed2ToString());
					
					needClubRich = info3_1.needClubRich;
					needClubLevel = info3_1.needClubLevel;
				}
				else
				{
					_nextLevel.setValue(LanguageManager.getWord("ssztl.common.none"));
					_nextEffect.setValue(LanguageManager.getWord("ssztl.common.none"));
					_nextEffect.textColor = 0xffffff;
					_need1.setValue(LanguageManager.getWord("ssztl.common.none"));
					_need2.setValue(LanguageManager.getWord("ssztl.common.none"));
				}
			}
			else 
			{
				_name.setValue(LanguageManager.getWord("ssztl.club.facilitySkill"));
				var info2:ClubFurnaceLevelTemplate = ClubFurnaceTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.furnaceLevel);
				var info2_1:ClubFurnaceLevelTemplate = ClubFurnaceTemplateList.getTemplate(_mediator.clubInfo.deviceInfo.furnaceLevel + 1);
				if(info2)
				{
					_curLevel.setValue(String(_mediator.clubInfo.deviceInfo.furnaceLevel));
					_curEffect.setValue(info2.getCurEffectToString());
				}
				
				if(info2_1)
				{
					_nextLevel.setValue(String(_mediator.clubInfo.deviceInfo.furnaceLevel+1));
					_nextEffect.setValue(info2_1.getCurEffectToString());
					_need1.setValue(info2_1.getNeed1ToString());
					_need2.setValue(info2_1.getNeed2ToString());
					needClubRich = info2_1.needClubRich;
					needClubLevel = info2_1.needClubLevel;
				}
				else
				{
					_nextLevel.setValue(LanguageManager.getWord("ssztl.common.none"));
					_nextEffect.setValue(LanguageManager.getWord("ssztl.common.none"));
					_nextEffect.textColor = 0xffffff;
					_need1.setValue(LanguageManager.getWord("ssztl.common.none"));
					_need2.setValue(LanguageManager.getWord("ssztl.common.none"));
				}
			}
			if(_mediator.clubInfo.clubDetailInfo.clubLevel >= needClubLevel)
			{
				_need1.setLabelType(MAssetLabel.LABEL_TYPE7);
			}
			else
			{
				_need1.setLabelType(MAssetLabel.LABEL_TYPE6);
			}
			if(_mediator.clubInfo.clubDetailInfo.clubRich >= needClubRich)
			{
				_need2.setLabelType(MAssetLabel.LABEL_TYPE7);
			}
			else
			{
				_need2.setLabelType(MAssetLabel.LABEL_TYPE6);
			}
//			for(var i:int=0; i<3; i++){
//				(_iconSrcArray[i] as Bitmap).visible = false;
//			}
//			_iconSrcArray[index].visible = true;
			_icon.bitmapData = _iconSrcArray[index];
		}
		
		
		private function clubLevelUpdateHandler(evt:ClubDetailInfoUpdateEvent):void
		{
			updateHandler(null);
		}
		private function updateHandler(evt:ClubDeviceUpdateEvent):void
		{
//			(_btnArray[0] as MClubCacheSelectBtn).setLevel( _mediator.clubInfo.clubDetailInfo.clubLevel + "/10");
//			(_btnArray[1] as MClubCacheSelectBtn).setLevel( _mediator.clubInfo.deviceInfo.shopLevel + "/5");
//			(_btnArray[2] as MClubCacheSelectBtn).setLevel( _mediator.clubInfo.deviceInfo.furnaceLevel + "/10");
			updateData(_currentType);
		}
		
		
		
		override public function dispose():void
		{
			removeEvent();
			if(parent) parent.removeChild(this);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_icon && _icon.bitmapData){
				_icon.bitmapData.dispose();
				_icon = null;
			}
//			for(var i:int=0; i<3; i++){
//				if(_iconSrcArray[i] && _iconSrcArray[i].bitmapData)
//				{
//					_iconSrcArray[i][i].bitmapData.dispose();
//					_iconSrcArray[i] = null;
//				}
//			}
			
			if(_rowBg)
			{
				_rowBg = null;
			}
			
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
						
			_btnArray = null;
			_iconSrcArray = null;
			_descript = null;
			_curEffect = null;
			_nextEffect = null;
			_need1 = null;
			_need2 = null;
			
			super.dispose();
		}
		
		
	}
}