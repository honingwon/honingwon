package sszt.common.vip.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.common.vip.VipController;
	import sszt.common.vip.component.sec.MyVipInfoView;
	import sszt.common.vip.component.sec.VipCard1;
	import sszt.common.vip.component.sec.VipCard2;
	import sszt.common.vip.component.sec.VipCard3;
	import sszt.common.vip.component.sec.VipCountDownView;
	import sszt.constData.CareerType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.vip.VipAwardType;
	import sszt.core.data.vip.VipCommonEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.vip.PlayerVipAwardSocketHandler;
	import sszt.core.socketHandlers.vip.PlayerVipDetailSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.SplitCompartLine2;
	import ssztui.vip.BtnDonateAsset;
	import ssztui.vip.BtnGetAsset;
	import ssztui.vip.TitleAsset;
	import ssztui.vip.TitleBarAsset;
	import ssztui.vip.TopInfoBgAsset;
	
	public class VipPanel extends MPanel
	{
		private var _controller:VipController;
		
		private var _bg:IMovieWrapper;
		private var _myVipInfoView:MyVipInfoView;
		private var _avatar:Bitmap;
		private var _txtName:MAssetLabel;
		private var _txtMessage:MAssetLabel;
		private var _btnBuyVip:MAssetButton1;
		private var _btnGetWelfare:MAssetButton1;
		private var _countDownView:VipCountDownView;
		
		private var _tile:MTile;
		private var _classes:Array;
		private var _labels:Array;
		private var _panels:Array;
		private var _btns:Array;
		private var _currentIndex:int = -1;
		
		private var headAssets:Array;
		
		public function VipPanel(controller:VipController)
		{
			_controller = controller;
			super(new MCacheTitle1("",new Bitmap(new TitleAsset())),true,-1,true,true);
			initEvent();
			PlayerVipDetailSocketHandler.send();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(370,440);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,354,430)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,346,110)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,115,346,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,145,346,283)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(21,7,95,100), new Bitmap(new TopInfoBgAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(15,149,340,28), new Bitmap(new TitleBarAsset())),
//				new BackgroundInfo(
//					BackgroundType.DISPLAY, new Rectangle(122,28,80,20),
//					new MAssetLabel(LanguageManager.getWord('ssztl.common.welcome'), MAssetLabel.LABEL_TYPE20, 'left')
//				),
			]);
			addContent(_bg as DisplayObject);
			
//			_containerTag.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,23,344,283), new BackgroundType.BORDER_12()));
			headAssets = [
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset1") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset2") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset3") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset4") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset5") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset6") as BitmapData
			];
			var headID:int = CareerType.getHeadByCareerSex(GlobalData.selfPlayer.career,GlobalData.selfPlayer.sex);
			_avatar = new Bitmap(AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset"+(headID+1)) as BitmapData);
			_avatar.x = 29;
			_avatar.y = 0;
			addContent(_avatar);
			
			_txtName = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,'left');
			_txtName.setLabelType([new TextFormat("Tahoma",12,0xfffccc)]);
			_txtName.move(140,23);
//			_txtName.setHtmlValue("：<font color='#ffcc00'>"+GlobalData.selfPlayer.nick+"</font>");
			addContent(_txtName);
			
			_txtMessage = new MAssetLabel('', MAssetLabel.LABEL_TYPE_TAG,'left');
			_txtMessage.setLabelType([new TextFormat("Tahoma",12,0xd9ad60)]);
			_txtMessage.move(140,44);
			addContent(_txtMessage);
			
			_countDownView = new VipCountDownView();
			_countDownView.setLabelType(new TextFormat("Tahoma",12,0xd9ad60));
			_countDownView.move(220, 44);
			addContent(_countDownView);
			_countDownView.visible = false;
			
			_btnBuyVip = new MAssetButton1(new BtnDonateAsset() as MovieClip);
			_btnBuyVip.label = LanguageManager.getWord("ssztl.common.vipBtnBuy");
			_btnBuyVip.move(139,74);
			
			_btnGetWelfare = new MAssetButton1(new BtnGetAsset() as MovieClip);
			_btnGetWelfare.label = LanguageManager.getWord("ssztl.common.getWelfare");
			_btnGetWelfare.move(228,74);
			addContent(_btnBuyVip);
			addContent(_btnGetWelfare);
			
//			_btnGetWelfare = new Sprite();
//			_btnGetWelfare.buttonMode = true;
//			_btnGetWelfare.graphics.beginFill(0,0);
//			_btnGetWelfare.graphics.drawRect(0,0,60,20);
//			_btnGetWelfare.graphics.endFill();
//			_btnGetWelfare.x = 333;
//			_btnGetWelfare.y = 38;
			
			
//			_tile = new MTile(128, 50, 3);
//			_tile.setSize(384,50);
//			_tile.itemGapW = _tile.itemGapH = 0;
//			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
//			_tile.move(16, 94);
//			addContent(_tile);
//			_tile.appendItem(new VipCardCell(206038));
//			_tile.appendItem(new VipCardCell(206039));
//			_tile.appendItem(new VipCardCell(206040 ));

			
			_labels = [
				LanguageManager.getWord("ssztl.common.vipCard1"),
				LanguageManager.getWord("ssztl.common.vipCard2"),
				LanguageManager.getWord("ssztl.common.vipCard3"),
				LanguageManager.getWord("ssztl.welfare.dayWelfare")
			];
			var _pos:Array = [
				new Point(20,119),
				new Point(105,119),
				new Point(174,119),
				new Point(243,119),
			];
			_classes = [VipCard1,VipCard2,VipCard3];
			_panels = [];
			_btns = [];
			
			for(var i:int = 0;i<_labels.length;i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,i==0?3:2,_labels[i]);
				_btns.push(btn);
				addContent(btn);
				btn.move(_pos[i].x,_pos[i].y);
			}
			
			_myVipInfoView = new MyVipInfoView();
			_myVipInfoView.move(12,145);
			_panels[3] = _myVipInfoView;
			
			setIndex(0);
			stateChangeHandler(null);
		}
		
		private function initEvent():void
		{
			for(var i:int = 0;i<_labels.length;i++)
			{
				MCacheTabBtn1(_btns[i]).addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_btnGetWelfare.addEventListener(MouseEvent.CLICK, getWelfare);
			GlobalData.selfPlayer.addEventListener(VipCommonEvent.VIPSTATECHANGE,stateChangeHandler);
			GlobalData.selfPlayer.addEventListener(VipCommonEvent.AWARD_YUANBAO_STATECHANGE, awardStateChangeHandler);
			GlobalData.selfPlayer.addEventListener(VipCommonEvent.AWARD_COPPER_STATECHANGE, awardStateChangeHandler);
			_btnBuyVip.addEventListener(MouseEvent.CLICK,buyVipClickHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0;i<_labels.length;i++)
			{
				MCacheTabBtn1(_btns[i]).removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_btnGetWelfare.removeEventListener(MouseEvent.CLICK, getWelfare);
			GlobalData.selfPlayer.removeEventListener(VipCommonEvent.VIPSTATECHANGE,stateChangeHandler);
			GlobalData.selfPlayer.removeEventListener(VipCommonEvent.AWARD_YUANBAO_STATECHANGE, awardStateChangeHandler);
			GlobalData.selfPlayer.removeEventListener(VipCommonEvent.AWARD_COPPER_STATECHANGE, awardStateChangeHandler);
			_btnBuyVip.addEventListener(MouseEvent.CLICK,buyVipClickHandler);
		}
		private function buyVipClickHandler(event:MouseEvent):void
		{
			_controller.showBuyVipPanel();
		}
		
		private function getWelfare(e:Event):void
		{
			if(GlobalData.selfPlayer.getVipType() == VipType.NORMAL)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.noVip"));
			}
			else
			{
				if(!GlobalData.selfPlayer.isVipBindYuanbaoGot)
				{
					PlayerVipAwardSocketHandler.send(VipAwardType.BIND_YUANBAO);
				}
				if(!GlobalData.selfPlayer.isVipCopperGot)
				{
					PlayerVipAwardSocketHandler.send(VipAwardType.COPPER);
				}
			}
		}
		
		private function awardStateChangeHandler(evt:VipCommonEvent):void
		{
			if(GlobalData.selfPlayer.isVipBindYuanbaoGot && GlobalData.selfPlayer.isVipCopperGot)
			{
				_btnGetWelfare.enabled = false
			}
		}
		
		private function stateChangeHandler(evt:VipCommonEvent):void
		{
			var message:String;
//			var _aryVipType:Array = [null,VipSortWellcomeAsset1,VipSortWellcomeAsset2,VipSortWellcomeAsset3,VipSortWellcomeAsset1,VipSortWellcomeAsset2];
			var vipType:int = GlobalData.selfPlayer.getVipType();
			if(vipType > VipType.NORMAL)
			{
				if(_myVipInfoView._txtPrivilege.text=="")
				{
					_myVipInfoView.initView();
					_myVipInfoView.initEvent();
				}
//				_imgVipType.bitmapData = new _aryVipType[vipType] as BitmapData;
				_txtName.setHtmlValue(LanguageManager.getWord("ssztl.common.vipTip3") + getVipName(vipType));
				message = LanguageManager.getWord('ssztl.common.vipLeftTime')+'：';
				_btnBuyVip.label = LanguageManager.getWord("ssztl.common.renewalVip");
				setIndex(3);
				_btns[3].visible = true;
				_myVipInfoView.setData(vipType);
				_countDownView.visible = true;
				_countDownView.start(GlobalData.selfPlayer.vipTime);
				_btnGetWelfare.visible = true;
				if(GlobalData.selfPlayer.isVipBindYuanbaoGot && GlobalData.selfPlayer.isVipCopperGot)
				{
					_btnGetWelfare.enabled = false;
				}
				else
				{
					_btnGetWelfare.enabled = true;
				}
			}
			else
			{
//				_imgVipType.bitmapData = null;
				_txtName.setHtmlValue(LanguageManager.getWord("ssztl.common.vipTip1"));
				message = LanguageManager.getWord("ssztl.common.vipTip2");
				_btnBuyVip.label = LanguageManager.getWord("ssztl.common.vipBtnBuy");
				setIndex(0);
				_btns[3].visible = false;
				_countDownView.visible = false;
				_btnGetWelfare.visible = false;
			}
			_txtMessage.setValue(message);
			
//			if(GlobalData.selfPlayer.getVipType() == VipType.NORMAL)
//			{
//				if(_imgVipType.bitmapData){
//					_imgVipType.bitmapData.dispose();
//				}
//			}
//			else
//			{
//				_imgVipType.bitmapData = _aryVipType[];
//				message = VipType.getNameByType(GlobalData.selfPlayer.getVipType());
//			}
//			_txtMessage.setValue(message);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget);
			setIndex(index);
		}
		private function getVipName(value:int):String
		{
			var str:String = "";
			switch(value)
			{
				case 1:
					str = "<font color='#00ff00'>"+LanguageManager.getWord("ssztl.basic.normalVipPlayer")+"</font>";
					break;
				case 2:
					str = "<font color='#00ccff'>"+LanguageManager.getWord("ssztl.basic.hightVipPlayer")+"</font>";
					break;
				case 3:
					str = "<font color='#cc00ff'>"+LanguageManager.getWord("ssztl.basic.superVipPlayer")+"</font>";
					break;
				case 4:
					str = "<font color='#00ff00'>"+LanguageManager.getWord("ssztl.common.vipDayCard")+"</font>";
					break;
				case 5:
					str = "<font color='#00ccff'>"+LanguageManager.getWord("ssztl.common.vipCard5")+"</font>";
					break;				
			}
			return str;
		}
		
		private function setIndex(index:int):void
		{
			//面板会被缓存，切换时不能dispose
			if(_currentIndex == index)return;
			if(_currentIndex != -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex]();
				_panels[_currentIndex].move(12,145);
			}
			addContent(_panels[_currentIndex]);
		}
		
		override public function dispose():void
		{
			removeEvent();
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_avatar && _avatar.bitmapData)
			{
				_avatar.bitmapData.dispose();
				_avatar = null;
			}
			if(_txtName)
			{
				_txtName = null;
			}
			if(_txtMessage)
			{
				_txtMessage = null;
			}
			if(_myVipInfoView)
			{
				_myVipInfoView.dispose();
				_myVipInfoView = null;
			}
			_btnBuyVip = null;
			_btnGetWelfare = null;
			var i:int;
			for(i = 0; i < _panels.length; i++)
			{
				if(_panels[i])
				{
					_panels[i].dispose();
					_panels[i] = null;
				}
			}
			_panels = null;
			for(i = 0; i < _btns.length; i++)
			{
				if(_btns[i])
				{
					_btns[i].dispose();
					_btns[i] = null;
				}
			}
			_btns = null;
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			
			super.dispose();
		}
	}
}