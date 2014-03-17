package sszt.scene.components.elementInfoView
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.constData.CategoryType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.PK.PKType;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.buff.BuffItemInfoUpdateEvent;
	import sszt.core.data.module.changeInfos.ToVipData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.vip.VipCommonEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.cell.BaseBuffCell;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.FightModeTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.ElementInfoMediator;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.progress.ProgressBar1;
	
	public class SelfElementInfoView extends BaseElementInfoView
	{
		private var _fangBtn:MBitmapButton;
		private var _sitBtn:MBitmapButton;
		private var _stateBg:Bitmap;
		private var _stateField:MAssetLabel;
		private var _stateMask:Sprite;
		private var _disposeTime:Number;
		private var _mutiExpStartBtn:MBitmapButton;
		private var _mutiExpPauseBtn:MBitmapButton;
		private var _bbsBtn:MBitmapButton;
		private var _officeBtn:MBitmapButton;
		private var _storeBtn:MBitmapButton;
		private var _faceBookBtn:MBitmapButton;
		private var _facebookLoader:URLLoader;
		private var _vipBtn:MAssetButton1;
		private var _vipOpenEffect:MovieClip;
		private var _yellowVipBtn:MAssetButton1;
		private var _luxuryVipBtn:MAssetButton1;
		private var _yellowLevel:MAssetLabel;
		private var _payBtn:MAssetButton1;
		private var _payEffect:MovieClip;
		private var _link:String;
		private var _mpBar:ProgressBar1;
		private var _spBar:ProgressBar1;
		private var _leaderIcon:Bitmap;
		
		private var _hpMask:MSprite;
		private var _mpMask:MSprite;
		
		private var _vipCountdownView:CountDownView;
		private var _vipView:Bitmap;
		
		public function SelfElementInfoView(mediator:ElementInfoMediator)
		{
			super(mediator);
//			MonsterDebugger.initialize(this);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SHOW_ONE_HOUR_VIP_COUNTDOW,showVipCountdownHandler);
		}
		
		override protected function init():void
		{
			super.init();
			
			_mediator.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.SETSELF_COMPLETE,setSelfCompleteHandler);
			_stateBg = new Bitmap;
			_stateBg.x = 10;
			_stateBg.y = 64;
			addChild(_stateBg);
			
			_stateField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_stateField.multiline = true;
			_stateField.autoSize = TextFieldAutoSize.LEFT;
			_stateField.wordWrap = true;
			_stateField.move(15,65);
			_stateField.setSize(16,30);
			_stateField.mouseEnabled = false;
			addChild(_stateField);
			
			_stateMask = new Sprite();
			_stateMask.graphics.beginFill(0,0);
			_stateMask.graphics.drawRect(10,64,25,37);
			_stateMask.graphics.endFill();
			_stateMask.buttonMode = true;
			_stateMask.tabEnabled = false;
			addChild(_stateMask);
			
		}
		
		override protected function initOthers():void
		{
			super.initOthers();
			
			_vipBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.SceneVipBtnAsset") as MovieClip);
			_vipBtn.move(34,96);
			addChild(_vipBtn);
			
			_yellowVipBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.SceneYellowVipBtnAsset") as MovieClip);
			_yellowVipBtn.move(248,40);
			if(GlobalData.functionYellowEnabled)
			{
				addChild(_yellowVipBtn);
			}
			
			if(GlobalData.tmpIsYellowVip)
			{
				_yellowLevel = new MAssetLabel("",MAssetLabel.LABEL_TYPE1);
				_yellowLevel.setLabelType([new TextFormat("Verdana",10,0xfbd503),new GlowFilter(0x6e3c00,1,2,2,5)]);
				_yellowLevel.move(264,56);
				if(GlobalData.functionYellowEnabled)
				{
					addChild(_yellowLevel);
				}
				_yellowLevel.setHtmlValue("Lv."+GlobalData.tmpYellowVipLevel);
				_yellowVipBtn.filters = [];
			}else
			{
				_yellowVipBtn.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}
			
			_luxuryVipBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.SceneLuxuryVipBtnAsset") as MovieClip);
			_luxuryVipBtn.move(282,40);
			if(GlobalData.functionYellowEnabled)
			{
				addChild(_luxuryVipBtn);
			}
			_luxuryVipBtn.filters = GlobalData.tmpIsYellowHighVip?[]:[new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			
			_payBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.ScenePayBtnAsset") as MovieClip);
			_payBtn.move(230,4);
			addChild(_payBtn);
			
			_payEffect = AssetUtil.getAsset("ssztui.scene.ScenePayBtnLightAsset") as MovieClip;
			_payEffect.x = _payBtn.x;
			_payEffect.y = _payBtn.y;
			addChild(_payEffect);
			_payEffect.blendMode = "add";
			_payEffect.mouseEnabled = _payEffect.mouseChildren = false;
			
			stateChangeHandler(null);
		}
		
		override protected function initBg():void
		{
			_bg = new Bitmap();
			addChild(_bg);
			
			_bg.bitmapData = getBgAsset1();
			
			_mask = new Sprite();
			addChild(_mask);
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawCircle(0,0,42);
			_mask.graphics.endFill();
			_mask.x = 68;
			_mask.y = 60;
			_mask.buttonMode = true;
			_mask.tabEnabled = false;
			_mask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_mask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			
			_hpMask = new MSprite();
			_mpMask = new MSprite();
			_mpMask.tabEnabled = _hpMask.tabEnabled = false;
			
			_hpMask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_hpMask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			_mpMask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_mpMask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			
			initBitmapdatas();
		}
		
		/*
		protected function initBitmapdatas():void
		{
			if(headAssets.length == 0)
			{
				headAssets.push(AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset1") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset2") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset3") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset4") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset5") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset6") as BitmapData);
			}
		}
		*/
		
		private function headOverHandler(e:MouseEvent):void
		{
			var ob:Object = e.currentTarget;
			switch(ob)
			{
				case _mask:
					if(_headAsset) setBrightness(_headAsset,0.15);
					return;
				case _hpMask:
				{
					TipsUtil.getInstance().show(
						LanguageManager.getWord("ssztl.common.life")+"："+GlobalData.selfPlayer.currentHP+"/"+ GlobalData.selfPlayer.totalHP,
						null,new Rectangle(e.stageX,e.stageY,0,0));
					if(_hpBar) setBrightness(_hpBar,0.3);
					return;
				}
				case _mpMask:
				{
					TipsUtil.getInstance().show(
						LanguageManager.getWord("ssztl.common.magic")+"："+GlobalData.selfPlayer.currentMP+"/"+GlobalData.selfPlayer.totalMP,
						null,new Rectangle(e.stageX,e.stageY,0,0));
					if(_mpBar) setBrightness(_mpBar,0.3);
					return;
				}
			}
			
		}
		private function headOutHandler(e:MouseEvent):void
		{
			var ob:Object = e.currentTarget;
			switch(ob)
			{
				case _mask:
					if(_headAsset) setBrightness(_headAsset,0);
					return;
				case _hpMask:
				{
					TipsUtil.getInstance().hide();
					if(_hpBar) setBrightness(_hpBar,0);
					return;
				}
				case _mpMask:
				{
					TipsUtil.getInstance().hide();
					if(_mpBar) setBrightness(_mpBar,0);
					return;
				}
			}
//			if(_headAsset)
//				setBrightness(_headAsset,0);
		}
		private function toPay(evt:MouseEvent):void
		{
			if(GlobalData.functionYellowEnabled)
				JSUtils.gotoFill();
			else
				JSUtils.gotoPage(GlobalData.fillPath2);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_hpBar.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_hpBar.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.PK_MODE_CHANGE,pkModeChangeHandler);
//			_mutiExpStartBtn.addEventListener(MouseEvent.CLICK,startClickHandler);
//			_mutiExpStartBtn.addEventListener(MouseEvent.MOUSE_OVER,startOverHandler);
//			_mutiExpStartBtn.addEventListener(MouseEvent.MOUSE_OUT,startOutHandler);
//			_mutiExpPauseBtn.addEventListener(MouseEvent.CLICK,pauseClickHandler);
//			_mutiExpPauseBtn.addEventListener(MouseEvent.MOUSE_OVER,pauseOverHandler);
//			_mutiExpPauseBtn.addEventListener(MouseEvent.MOUSE_OUT,pauseOutHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.UPDATE_HPMP,hpMpUpdateHandler);
//			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			GlobalData.selfPlayer.addEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,levelUpdateHandler);
			
			_stateMask.addEventListener(MouseEvent.CLICK,stateClickHandler);
			
//			_officeBtn.addEventListener(MouseEvent.CLICK,officeClickHandler);
//			_bbsBtn.addEventListener(MouseEvent.CLICK,bbsClickHandler);
//			_storeBtn.addEventListener(MouseEvent.CLICK,storeClickHandler);
//			if(_faceBookBtn)
//			{
//				_faceBookBtn.addEventListener(MouseEvent.CLICK,faceBookClickHandler);
//			}
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,leaderChangeHandler);
			
			_vipBtn.addEventListener(MouseEvent.CLICK, btnVipClickHandler);
			_yellowVipBtn.addEventListener(MouseEvent.MOUSE_OVER,yellowVipOverHandler);
			_yellowVipBtn.addEventListener(MouseEvent.MOUSE_OUT,yellowVipOutHandler);
			_yellowVipBtn.addEventListener(MouseEvent.CLICK,onYellowVipClick);
			
			_luxuryVipBtn.addEventListener(MouseEvent.MOUSE_OVER,yellowVipOverHandler);
			_luxuryVipBtn.addEventListener(MouseEvent.MOUSE_OUT,yellowVipOutHandler);
			GlobalData.selfPlayer.addEventListener(VipCommonEvent.VIPSTATECHANGE,stateChangeHandler);
			_payBtn.addEventListener(MouseEvent.CLICK,toPay);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_hpBar.removeEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_hpBar.removeEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.PK_MODE_CHANGE,pkModeChangeHandler);
//			_mutiExpStartBtn.removeEventListener(MouseEvent.CLICK,startClickHandler);
//			_mutiExpStartBtn.removeEventListener(MouseEvent.MOUSE_OVER,startOverHandler);
//			_mutiExpStartBtn.removeEventListener(MouseEvent.MOUSE_OUT,startOutHandler);
//			_mutiExpPauseBtn.removeEventListener(MouseEvent.CLICK,pauseClickHandler);
//			_mutiExpPauseBtn.removeEventListener(MouseEvent.MOUSE_OVER,pauseOverHandler);
//			_mutiExpPauseBtn.removeEventListener(MouseEvent.MOUSE_OUT,pauseOutHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.UPDATE_HPMP,hpMpUpdateHandler);
			GlobalData.selfPlayer.removeEventListener(SelfPlayerInfoUpdateEvent.PROPERTYUPDATE,levelUpdateHandler);
			_stateMask.removeEventListener(MouseEvent.CLICK,stateClickHandler);
//			_officeBtn.removeEventListener(MouseEvent.CLICK,officeClickHandler);
//			_bbsBtn.removeEventListener(MouseEvent.CLICK,bbsClickHandler);
//			_storeBtn.removeEventListener(MouseEvent.CLICK,storeClickHandler);
//			if(_faceBookBtn)
//			{
//				_faceBookBtn.removeEventListener(MouseEvent.CLICK,faceBookClickHandler);
//			}
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,leaderChangeHandler);
			_vipBtn.removeEventListener(MouseEvent.CLICK, btnVipClickHandler);
			_yellowVipBtn.removeEventListener(MouseEvent.MOUSE_OVER,yellowVipOverHandler);
			_yellowVipBtn.removeEventListener(MouseEvent.MOUSE_OUT,yellowVipOutHandler);
			_yellowVipBtn.removeEventListener(MouseEvent.CLICK,onYellowVipClick);
			_luxuryVipBtn.removeEventListener(MouseEvent.MOUSE_OVER,yellowVipOverHandler);
			_luxuryVipBtn.removeEventListener(MouseEvent.MOUSE_OUT,yellowVipOutHandler);
			GlobalData.selfPlayer.removeEventListener(VipCommonEvent.VIPSTATECHANGE,stateChangeHandler);
			_payBtn.removeEventListener(MouseEvent.CLICK,toPay);
		}
		
		private function showVipCountdownHandler(e:CommonModuleEvent):void
		{
			if(_vipCountdownView) return;
			var vipTime:int = e.data as int;
			
			_vipView = new Bitmap(AssetUtil.getAsset("ssztui.scene.ExperienceVipBgAsset") as BitmapData);
			_vipView.x = 3;
			_vipView.y = 120;
			addChild(_vipView);
			
			_vipCountdownView = new CountDownView();
			_vipCountdownView.setLabelType(new TextFormat("Tahoma",17,0x48ff00,false));
			_vipCountdownView.move(78,118);
			_vipCountdownView.setSize(85,25);
			addChild(_vipCountdownView);
			
			_vipCountdownView.addEventListener(Event.COMPLETE,vipcountdownCompleteHandle);
			_vipCountdownView.start(vipTime);
		}
		
		private function vipcountdownCompleteHandle(event:Event):void
		{
			if(_vipView && _vipView.bitmapData)
			{
				_vipView.bitmapData.dispose();
				_vipView = null;
			}
			_vipCountdownView.removeEventListener(Event.COMPLETE,vipcountdownCompleteHandle);
			_vipCountdownView.dispose();
			_vipCountdownView = null;
		}
		
		private function stateChangeHandler(evt:VipCommonEvent):void
		{
			var vipType:int = GlobalData.selfPlayer.getVipType();
			if(vipType > VipType.NORMAL)
			{
				if(_vipOpenEffect == null)
				{
					_vipOpenEffect = AssetUtil.getAsset("ssztui.scene.SceneBtnLightAsset") as MovieClip;
					_vipOpenEffect.x = _vipBtn.x;
					_vipOpenEffect.y = _vipBtn.y;
					addChild(_vipOpenEffect);
					_vipOpenEffect.blendMode = "add";
					_vipOpenEffect.mouseEnabled = _vipOpenEffect.mouseChildren = false;
				}
			}
			else
			{
				if(_vipOpenEffect && _vipOpenEffect.parent)
				{
					_vipOpenEffect.parent.removeChild(_vipOpenEffect);
					_vipOpenEffect = null;
				}
			}
		}
		private function onYellowVipClick(e:MouseEvent):void
		{
			SetModuleUtils.addYellowBox();
		}
		private function yellowVipOverHandler(evt:MouseEvent):void
		{
			var str:String = "";
			if(_yellowVipBtn == evt.target)
			{
				str = LanguageManager.getWord("ssztl.scene.yellowVipTip");
			}else
			{
				str = "<font color='#" + (GlobalData.tmpIsYellowHighVip?"33cc00":"fffccc") +"'>" + LanguageManager.getWord("ssztl.scene.luxuryVipTip",LanguageManager.getWord("ssztl.yellowBox.luxGifDesc")) + "</font>";
			}
			TipsUtil.getInstance().show(str,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function yellowVipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function pkModeChangeHandler(e:SceneModuleEvent):void
		{
			_stateField.setValue(PKType.getModeName(GlobalData.selfPlayer.PKMode));
			updateStateBg();
		}
		
		
		private function btnVipClickHandler(e:Event):void
		{
			SetModuleUtils.addVip(new ToVipData(0));
		}
		

		
//		override protected function initBuff():void
//		{
//			_buffTile = new MTile(22,22,6);
//			_buffTile.move(103,90);
//			_buffTile.setSize(140,50);
//			_buffTile.itemGapW = 1;
//			_buffTile.verticalScrollPolicy = _buffTile.horizontalScrollPolicy = ScrollPolicy.OFF;
//			addChild(_buffTile);
//			
////			_buffBorder = new MTile(22,22,6);
////			_buffBorder.move(103,90);
////			_buffBorder.setSize(140,50);
////			_buffBorder.itemGapW = 1;
////			_buffBorder.verticalScrollPolicy = _buffBorder.horizontalScrollPolicy = ScrollPolicy.OFF;
////			_buffBorder.mouseEnabled = false;
////			_buffBorder.mouseChildren = false;
////			addChild(_buffBorder);
////			_buffBorderArray = [];
//		}
		
		
		
		private function hpMpUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_info.updateHPMP(GlobalData.selfPlayer.currentHP,GlobalData.selfPlayer.currentMP,GlobalData.selfPlayer.totalHP,GlobalData.selfPlayer.totalMP);
			_hpBar.setValue(GlobalData.selfPlayer.totalHP,GlobalData.selfPlayer.currentHP);
			_mpBar.setValue(GlobalData.selfPlayer.totalMP,GlobalData.selfPlayer.currentMP);
		}
		
		private function levelUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
//			_levelField.setValue(String(GlobalData.selfPlayer.level.toString()));
//			if(_levelField)_levelField.setValue(String(_info.getLevel()));
			hpMpUpdateHandler(null);
			upgradeHandler(null);
		}
		

		
//		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
//		{
//			_buffTile.move(110,70);
//		}
		
//		override protected function addBuff(data:BuffItemInfo):void
//		{
//			var buff:BaseBuffCell = createBuff(data);
//			_buffItems.push(buff);
//			_buffTile.appendItem(buff);
//			
//			var border:Bitmap = new Bitmap(AssetUtil.getAsset("ssztui.scene.BuffBorderImgAsset") as BitmapData);
////			_buffBorderArray.push(border);
////			_buffBorder.appendItem(border);
//		}
		
		override protected function initBuffData():void
		{
			super.initBuffData();
			checkMutiExp();
		}
		
		override protected function addBuffHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			super.addBuffHandler(evt);
			checkMutiExp();
		}
		
		override protected function removeBuffHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			super.removeBuffHandler(evt);
			
//			var info:BuffItemInfo = evt.data as BuffItemInfo;
//			var buff:BaseBuffCell;
//			var border:Bitmap;
//			for(var i:int = 0; i < _buffItems.length; i++)
//			{
//				if(_buffItems[i].buffItemInfo == info)
//				{
//					buff = _buffItems.splice(i,1)[0];
//				}
//			}
//			if(buff)
//			{
//				_buffTile.removeItem(buff);
////				_buffBorder.removeItem(border);
//			}
			
			checkMutiExp();
		}
		
		
		private function stateClickHandler(evt:MouseEvent):void
		{
			FightModeTip.getInstance().show(new Point(evt.stageX,evt.stageY));
		}
		
		private function checkMutiExp():void
		{
			var buff:BuffItemInfo = _info.getBuff(CategoryType.MUTIEXP_BUFF);
//			_mutiExpStartBtn.visible = _mutiExpPauseBtn.visible = false;
			if(buff)
			{
//				if(buff.isPause)_mutiExpStartBtn.visible = true;
//				else _mutiExpPauseBtn.visible = true;
				buff.removeEventListener(BuffItemInfoUpdateEvent.PAUSE_UPDATE,pauseUpdateHandler);
				buff.addEventListener(BuffItemInfoUpdateEvent.PAUSE_UPDATE,pauseUpdateHandler,false,0,true);
			}
		}
		
		private function pauseUpdateHandler(evt:BuffItemInfoUpdateEvent):void
		{
			checkMutiExp();
		}
		
		private function leaderChangeHandler(e:SceneTeamPlayerListUpdateEvent):void
		{
			if(GlobalData.selfPlayer.userId == _mediator.sceneInfo.teamData.leadId)
			{
				if(_leaderIcon && _leaderIcon.parent)return;//防止切换场景的时候再画一次
				_leaderIcon = new Bitmap(AssetUtil.getAsset("ssztui.scene.SceneTeamLeaderAsset") as BitmapData);
				_leaderIcon.x = 10;
				_leaderIcon.y = 34;
				addChild(_leaderIcon);
			}
			else
			{
				if(_leaderIcon && _leaderIcon.parent)_leaderIcon.parent.removeChild(_leaderIcon);
			}
		}
		
		override protected function initHead(change:Boolean = true):void
		{
			if(_headAsset && _headAsset.parent) _headAsset.parent.removeChild(_headAsset);
			_headAsset = new Bitmap(headAssets[CareerType.getHeadByCareerSex(GlobalData.selfPlayer.career,GlobalData.selfPlayer.sex)]);
			_headAsset.x = 25;
			_headAsset.y = 0;
			addChild(_headAsset);
			
			leaderChangeHandler(null);
		}
		
		override protected function initNameField():void
		{
			_nameField = new MAssetLabel(_info ? _info.getName() : "",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_nameField.textColor = 0xffcc00;
			_nameField.selectable = false;
			_nameField.setSize(90,18);
			_nameField.mouseEnabled = false;
			addChild(_nameField);
		}
		
		override protected function initLevelField():void
		{
			_levelField = new MAssetLabel(String(_info ? _info.getLevel() : ""),MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
//			_levelField.move(38,65);
			//_levelField.setSize(24,18);
			_levelField.setLabelType([new TextFormat("Tahoma",11,0xFFFCCC)]);
			_levelField.selectable = false;
			_levelField.mouseEnabled = false;
			addChild(_levelField);
		}
		
		override protected function initProgressBar():void
		{
//			_hpBar = new ProgressBar1(BaseElementInfoView.getHpBarAsset(141),1,1,141,11,true,false);
			_hpBar = new ProgressBar1(new Bitmap(BaseElementInfoView.getHpBgAsset1()),1,1,136,13,true,false);
			addChild(_hpBar);
			_mpBar = new ProgressBar1(new Bitmap(BaseElementInfoView.getMpBgAsset1()),1,1,138,13,true,false);
			addChild(_mpBar);
			_spBar = new ProgressBar1(new Bitmap(BaseElementInfoView.getSpBgAsset1()),0,1,104,3,false,false);
			addChild(_spBar);
			
		}
		
		private function setSelfCompleteHandler(evt:ScenePlayerListUpdateEvent):void
		{
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.SETSELF_COMPLETE,setSelfCompleteHandler);
			setInfo(_mediator.sceneInfo.playerList.self);
			_mpBar.setValue(_mediator.sceneInfo.playerList.self.totalMp,_mediator.sceneInfo.playerList.self.currentMp);
			_stateField.setValue(PKType.getModeName(GlobalData.selfPlayer.PKMode));
			updateStateBg();
		}
		
		private function updateStateBg():void
		{
			if(GlobalData.selfPlayer.PKMode == PKType.PEACE)
			{
				_stateBg.bitmapData = AssetUtil.getAsset("ssztui.scene.SelfFightStateBGAsset") as BitmapData;
			}
			else
			{
				_stateBg.bitmapData = AssetUtil.getAsset("ssztui.scene.SelfFightStateBGAsset1") as BitmapData;
			}
		}
		
		override protected function upgradeHandler(e:BaseRoleInfoUpdateEvent):void
		{
			super.upgradeHandler(e);
		}
		
		override protected function layout():void
		{
			_bg.x = 17;
			_bg.y = 7;
			
			_hpBar.move(109,49);
			_mpBar.move(107,63);
			_spBar.move(102,79);
			_levelField.move(114,30);			
			_nameField.move(140,29);
			
			_hpMask.graphics.beginFill(0,0);
			_hpMask.graphics.drawRect(109,49,136,13);
			_hpMask.graphics.endFill();
			addChild(_hpMask);
			
			_mpMask.graphics.beginFill(0,0);
			_mpMask.graphics.drawRect(107,63,138,13);
			_mpMask.graphics.endFill();
			addChild(_mpMask);
			
		}
		
		override public function dispose():void
		{
			_mediator.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.SETSELF_COMPLETE,setSelfCompleteHandler);
		}
	}
}