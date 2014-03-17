/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-27 下午8:01:34 
 * 
 */ 
package sszt.club.components.clubMain.pop.sec
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.club.components.clubMain.pop.items.MClubCacheSelectBtn;
	import sszt.club.components.clubMain.pop.sec.manager.ApplyPanel;
	import sszt.club.components.clubMain.pop.sec.manager.FacilityPanel;
	import sszt.club.components.clubMain.pop.sec.manager.MailPanel;
	import sszt.club.events.ClubDetailInfoUpdateEvent;
	import sszt.club.events.ClubDeviceUpdateEvent;
	import sszt.club.events.TryinUpdateEvent;
	import sszt.club.mediators.ClubMediator;
	import sszt.club.socketHandlers.ClubLevelUpSocketHandler;
	import sszt.club.socketHandlers.ClubUpgradeDeviceSocketHandler;
	import sszt.club.socketHandlers.GetMailNumSocketHandler;
	import sszt.core.data.GlobalData;
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
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.icon.MCacheIcon1;
	
	import ssztui.ui.BorderAsset15;
	
	public class ClubManagerPanel extends MSprite implements IClubMainPanel
	{
		
		private var _mediator:ClubMediator;
		private var _bg:IMovieWrapper;
		/**
		 * 设施列表
		 * */
		private var _labels:Array;			
		private var _btnArray:Array;		//btns
		private var _btnText:Array;			//TextFields
		private var _currentType:int = -1;		
		private var _selected:Sprite;
		private var _panels:Array;
		private var _classes:Array;
		
		private var _descriptT:MAssetLabel;
		private var _curEffectT:MAssetLabel;
		private var _nextEffectT:MAssetLabel;
		private var _upgradeConditionT:MAssetLabel;
		private var _descript:MAssetLabel;
		private var _curEffect:MAssetLabel;
		private var _nextEffect:MAssetLabel;
		private var _okBtn:MCacheAssetBtn1;
		private var _icon1:MCacheIcon1;
		private var _icon2:MCacheIcon1;
		
		private var _need1:MAssetLabel;
		private var _need2:MAssetLabel;
		
		private var _assetsComplete:Boolean;
		
		private var _decripts:Array = [LanguageManager.getWord("ssztl.club.upgradeClubPrompt1"),
			LanguageManager.getWord("ssztl.club.upgradeClubPrompt2"),
			LanguageManager.getWord("ssztl.club.upgradeClubPrompt3")];
		
//		private var _types:Array = [LanguageManager.getWord("ssztl.club.upgradeClub"),
//			LanguageManager.getWord("ssztl.club.clubFurnace2"),
//			LanguageManager.getWord("ssztl.club.clubStore2")];
		
		
		public function ClubManagerPanel(mediator:ClubMediator)
		{
			_assetsComplete = false;
			_mediator = mediator;
			_mediator.clubInfo.initTryinInfo();
			super();
			
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(5,4,167,353)),				
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(9,10,159,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(9,195,159,26)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,63,159,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,91,159,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,119,159,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,194,159,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,248,159,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(9,276,159,2)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,14,159,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.managerFacility"),MAssetLabel.LABEL_TYPE_TITLE)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,199,159,16),new MAssetLabel(LanguageManager.getWord("ssztl.club.managerFun"),MAssetLabel.LABEL_TYPE_TITLE))
				
			]);
			addChild(_bg as DisplayObject);
			
			_btnText = [];
			_btnArray = [];
			_panels = [];
			
			_labels= [
				LanguageManager.getWord("ssztl.club.facilityClub"),
				LanguageManager.getWord("ssztl.club.facilityChop"),
				LanguageManager.getWord("ssztl.club.facilitySkill"),
				LanguageManager.getWord("ssztl.club.dealApply"),
				LanguageManager.getWord("ssztl.club.mailToMulti"),
			];
			_classes = [FacilityPanel,FacilityPanel,FacilityPanel,ApplyPanel,MailPanel];
			var fixs:Array = [
				new Point(11,36),new Point(11,64),new Point(11,92),new Point(11,221),new Point(11,249)			
				];
			
			for(var i:int = 0;i<_labels.length;i++)
			{				
				var itemText:MAssetLabel = new MAssetLabel(_labels[i],MAssetLabel.LABEL_TYPE5,TextFormatAlign.LEFT);
				itemText.move(fixs[i].x + 15,fixs[i].y+6);
				itemText.setSize(140,16);
				addChild(itemText);
				_btnText.push(itemText);
				var hotspot:Sprite = new Sprite();
				hotspot.graphics.beginFill(0xffffff,0);
				hotspot.graphics.drawRect(0,0,155,23);
				hotspot.graphics.endFill();
				hotspot.x = fixs[i].x;
				hotspot.y = fixs[i].y;
				hotspot.buttonMode = true;
				addChild(hotspot);
				_btnArray.push(hotspot);
			}
			
			_selected = MBackgroundLabel.getDisplayObject(new Rectangle(fixs[0].x,fixs[0].y,155,28),new BorderAsset15()) as Sprite;
			_selected.mouseEnabled = false;
			addChild(_selected);
			initEvent();
			
			setIndex(0);
			updateHandler(null);
			_mediator.getTryinData(1,11);
			tryinUpdateHandler(null);
			
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			for(var i:int = 0; i < _panels.length; i++)
			{
				if(_panels[i] != null)
					(_panels[i] as IClubMainPanel).assetsCompleteHandler();
			}
			
		}
		
		private function initEvent():void
		{
			for(var i:int = 0;i<_btnArray.length;i++)
			{
				_btnArray[i].addEventListener(MouseEvent.CLICK,changeType);
			}
			_mediator.clubInfo.deviceInfo.addEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,updateHandler);
			_mediator.clubInfo.clubDetailInfo.addEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,clubLevelUpdateHandler);
			_mediator.clubInfo.clubTryinInfo.addEventListener(TryinUpdateEvent.TRYIN_UPDATE,tryinUpdateHandler);
		}
		
		private function removeEvent():void
		{
			
			for(var i:int = 0;i<_btnArray.length;i++)
			{
				_btnArray[i].removeEventListener(MouseEvent.CLICK,changeType);
			}
			
			_mediator.clubInfo.deviceInfo.removeEventListener(ClubDeviceUpdateEvent.DEVICE_UPDATE,updateHandler);
			_mediator.clubInfo.clubDetailInfo.removeEventListener(ClubDetailInfoUpdateEvent.DETAILINFO_UPDATE,clubLevelUpdateHandler);
			_mediator.clubInfo.clubTryinInfo.removeEventListener(TryinUpdateEvent.TRYIN_UPDATE,tryinUpdateHandler);
		}
		private function tryinUpdateHandler(e:TryinUpdateEvent):void
		{			
			if(_mediator.clubInfo.clubTryinInfo.totalListNum > 0)
				_btnText[3].htmlText = _labels[3] + "<font color='#ff6600'>[" +  _mediator.clubInfo.clubTryinInfo.totalListNum + "]</font>";
			else
				_btnText[3].htmlText = _labels[3];
		}
		
		/*
		private function btnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var _index:int = _btns.indexOf( evt.target);
			switch (_index)
			{
				case 0:
					_mediator.showApplyPanel();
					break;
				case 1:
					break;
				case 2:
					_mediator.showTeamMailPanel();
					break;
				case 3:
					break;
				
			}
		}
		*/
		
		private function changeType(evt:MouseEvent):void
		{  
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			var index:int = _btnArray.indexOf(evt.currentTarget);
			setIndex(index);
		}
		
		public function setIndex(index:int):void
		{
			if(index==_currentType) return;
			if(_panels[_currentType]) _panels[_currentType].hide();
			_currentType = index;			
			_selected.x = _btnArray[_currentType].x;
			_selected.y = _btnArray[_currentType].y;
			
			if(_currentType < 3){				
				if(_panels[0] == null)
				{
					_panels[0] = new _classes[0](_mediator);
					_panels[0].move(175,4);	
					addChild(_panels[0] as DisplayObject);
				}
				if(_assetsComplete)	(_panels[0] as IClubMainPanel).assetsCompleteHandler();
				_panels[0].setData(_currentType);
				_panels[0].show();
			}else{
				if(_panels[0]) _panels[0].hide();
				if(_panels[_currentType] == null)
				{
					_panels[_currentType] = new _classes[_currentType](_mediator);
					if(_assetsComplete)	(_panels[_currentType] as IClubMainPanel).assetsCompleteHandler();
					_panels[_currentType].move(175,4);
				}
				addChild(_panels[_currentType] as DisplayObject);
				_panels[_currentType].show();
				GetMailNumSocketHandler.send();//获取群发邮件次数
			}			
			
		}
		
		
		private function clubLevelUpdateHandler(evt:ClubDetailInfoUpdateEvent):void
		{
			updateHandler(null);
		}
		private function updateHandler(evt:ClubDeviceUpdateEvent):void
		{
			(_btnText[0] as MAssetLabel).setValue(_labels[0] + "　　lv." + _mediator.clubInfo.clubDetailInfo.clubLevel + "/10");
			(_btnText[1] as MAssetLabel).setValue(_labels[1] + "　　lv." + _mediator.clubInfo.deviceInfo.shopLevel + "/5");
			(_btnText[2] as MAssetLabel).setValue(_labels[2] + "　lv." + _mediator.clubInfo.deviceInfo.furnaceLevel + "/10");
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
			
			if(_icon1)
			{
				_icon1.bitmapData.dispose();
				_icon1 = null;
			}
			if(_icon2)
			{
				_icon2.bitmapData.dispose();
				_icon2 = null;
			}
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			
			if(_panels)
			{
				for each(var panel:IClubMainPanel in _panels)
				{
					if(panel)panel.dispose();
				}
			}
			
			_btnText = null;
			_btnArray = null;
			
			_descriptT = null;
			_curEffectT = null;
			_nextEffectT = null;
			_upgradeConditionT = null;
			_descript = null;
			_curEffect = null;
			_nextEffect = null;
			_need1 = null;
			_need2 = null;
			
			super.dispose();
		}
		
		
	}
}