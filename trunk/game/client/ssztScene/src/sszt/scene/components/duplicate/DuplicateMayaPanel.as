package sszt.scene.components.duplicate
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.duplicate.DuplicateMayaInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.CopyInfoSocketHandler;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MTextButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.scene.FBSideBgTitleAsset;
	
	public class DuplicateMayaPanel extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _background:Shape;
		private var _mediator:SceneMediator;
		private var _leaveBtn:MCacheAssetBtn1;
		private var _countDownView:CountDownView;
		private var _container:Sprite;
		private var _tip:MTextButton;
		private var _tipText:MAssetLabel;
		
		public function DuplicateMayaPanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();
			CopyInfoSocketHandler.send();
		}
		
		private function initialView():void
		{
			x = CommonConfig.GAME_WIDTH - 208;
			y = 190;
			mouseEnabled = false;
			
			_container = new Sprite();
			addChild(_container);
			_container.mouseEnabled = false;
			
			_background = new Shape();
			_background.graphics.beginFill(0x000000,0.5);
			_background.graphics.drawRect(0,0,186,10);
			_background.graphics.endFill();
			_container.addChild(_background);
			
			var pl:int = 22;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,186,255),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,4,182,17),new MAssetLabel(duplicateInfo.duplicateName ,MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,36,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.leftTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,62,160,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.mayaTip"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,105,160,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.mayaTip1"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,145,160,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.mayaTip2"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
			]);
			_container.addChild(_bg as DisplayObject);
			
			_countDownView = new CountDownView();
			_countDownView.setColor(0xffcc00);
			_countDownView.move(pl+73,36);
			_container.addChild(_countDownView);
			
			_tip = new MTextButton(LanguageManager.getWord("ssztl.common.ruleIntro"),0xffcc00);
			_tip.move(pl+12,185);
//			_container.addChild(_tip);
			
			_tipText = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_tipText.wordWrap = true;
			_tipText.setSize(170,200);
			_tipText.move(pl+12,62);
			_container.addChild(_tipText);
			_tipText.setHtmlValue("1.圣地的怪物会随着世界等级的提升而增强。\n2.击杀一定数量的小怪，圣地的精英怪会来为部下们复仇。\n3.鬼武者、影剑士、狂刀客被击败后过段时间即会卷土重来。\n4.圣地之主邪王阎摩会在每天的13：30-14:00前来巡视圣地，伺机向他发起挑战吧。");
			
			_leaveBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.quitCopy"));
			_leaveBtn.x = 90;
			_leaveBtn.y = 220;
			_container.addChild(_leaveBtn);
		}
		
		private function initialEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			_leaveBtn.addEventListener(MouseEvent.CLICK,quitDuplicate);
			
			_tip.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_tip.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			_leaveBtn.removeEventListener(MouseEvent.CLICK,quitDuplicate);
			
			_tip.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_tip.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show("1.圣地的怪物会随着世界等级的提升而增强。\n2.击杀一定数量的小怪，圣地的精英怪会来为部下们复仇。\n3.鬼武者、影剑士、狂刀客被击败后过段时间即会卷土重来。\n4.圣地之主邪王阎摩会在每天的13：30-14:00前来巡视圣地，伺机向他发起挑战吧。",null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 208;
			y = 190;
		}
		
		private function updateCopyInfo(e:CommonModuleEvent):void
		{
			var data:IPackageIn = e.data as IPackageIn;
			var type:int = data.readShort();
			var missionId:int = data.readShort();
			var startTime:Number = data.readNumber();
			var time:Number =	int(GlobalData.systemDate.getSystemDate().getTime() / 1000);
			duplicateInfo.leftTime = duplicateInfo.leftTime - (time - startTime);
			_countDownView.stop();
			_countDownView.start(duplicateInfo.leftTime);
		}
		
		private function quitDuplicate(evt:Event):void
		{
			var message:String;
			if(GlobalData.copyEnterCountList.isPKCopy()&& GlobalData.selfPlayer.pkState == 0) message = LanguageManager.getWord("ssztl.scene.isSureBeLoser");
			else message = LanguageManager.getWord("ssztl.scene.isSureLeaveCopy");
			MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
			function leaveAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{	
					_mediator.sceneInfo.playerList.self.setKillOne();
					CopyLeaveSocketHandler.send();
				}
			}
		}
		
		public function get duplicateInfo():DuplicateMayaInfo
		{
			return _mediator.duplicateMayaInfo;
		}
		
		override public function dispose():void
		{
			removeEvents();
			duplicateInfo.clearData();
			if(_leaveBtn)
			{
				_leaveBtn.dispose();
				_leaveBtn = null;
			}
			if(_countDownView)
			{
				_countDownView.dispose();
				_countDownView = null;
			}
			_background = null;
			_mediator = null;
			_container = null;	
			if(parent)parent.removeChild(this);
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
		}
	}
}