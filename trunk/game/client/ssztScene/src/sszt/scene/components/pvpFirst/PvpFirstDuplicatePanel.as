package sszt.scene.components.pvpFirst
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.pvp.ActivePvpFirstLeaveSocketHandler;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.resourceWar.ResourceWarRewardCell;
	import sszt.scene.events.ScenePvpFirstUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.pvpFirst.ActivePvpFirstInfoSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.scene.FBSideBgTitleAsset;
	import ssztui.scene.IconTipFristAsset;
	
	public class PvpFirstDuplicatePanel extends MSprite
	{
		private const WIDTH:int = 206;
		private const HEIGHT:int = 386;
		private const Y:int = 190;		
		
		private var _bg:IMovieWrapper;
		
		private var _mediator:SceneMediator;
		private var _btnLeave:MCacheAssetBtn1;
		
		private var _firstName:MAssetLabel;		
		private var _countDownView:CountDownView;
		private var _tip:Sprite;
		
		private var _awardCell3:ResourceWarRewardCell;
		private var _awardCell1:ResourceWarRewardCell;
		private var _awardCell2:ResourceWarRewardCell;
		
		public function PvpFirstDuplicatePanel(argMediator:SceneMediator)
		{
			_mediator = argMediator;
			super();
			initEvent();
		}
		override protected function configUI():void
		{
			super.configUI();		
			gameSizeChangeHandler(null);
			
			var _background:Shape = new Shape();
			_background.graphics.beginFill(0x000000,0.5);
			_background.graphics.drawRect(0,0,208,10);
			_background.graphics.endFill();
			
			var pl:int = 22;
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,184,246),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(55,34,15,15),new Bitmap(new IconTipFristAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,4,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.pvpFirstTip"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,33,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.pvpFirstTag1"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(55,99,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.pvpFirstTag2"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,89,184,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,160,184,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,172,184,15),new MAssetLabel(LanguageManager.getWord("ssztl.clubCopy.activityReward"),MAssetLabel.LABEL_TYPE_TAG)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(55,195,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(95,195,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(135,195,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_awardCell3 = new ResourceWarRewardCell();
			_awardCell3.info = ItemTemplateList.getTemplate(15);
			_awardCell3.move(55,195);
			addChild(_awardCell3);
			
			_awardCell1 = new ResourceWarRewardCell();
			_awardCell1.info = ItemTemplateList.getTemplate(292300);
			_awardCell1.move(95,195);
			addChild(_awardCell1);
			
			_awardCell2 = new ResourceWarRewardCell();
			_awardCell2.info = ItemTemplateList.getTemplate(292301);
			_awardCell2.move(135,195);
			addChild(_awardCell2);			
			
			_firstName =new MAssetLabel('',MAssetLabel.LABEL_TYPE_YAHEI);
			_firstName.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),18,0xffcc00,null,null,null,null,null,"center")]);
			_firstName.move(114,50);
			addChild(_firstName);
			
			_tip = new Sprite();
			_tip.graphics.beginFill(0,0);
			_tip.graphics.drawRect(55,34,15,15);
			_tip.graphics.endFill();
			addChild(_tip);
			
			_countDownView = new CountDownView();
			_countDownView.setSize(100,15);
			_countDownView.move(127, 99);
			addChild(_countDownView);
			
			_btnLeave = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.group.leaveTeamWord'));
			_btnLeave.move(79,123);
			addChild(_btnLeave);
			ActivePvpFirstInfoSocketHandler.send();
		}
		
		private function initEvent():void
		{
			_btnLeave.addEventListener(MouseEvent.CLICK,leaveHandler);
			_mediator.sceneModule.pvpFirstInfo.addEventListener(ScenePvpFirstUpdateEvent.PVP_FIRST_INFO_UPDATE, updateInfoHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			
			_tip.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_tip.addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
		}
		private function removeEvent():void
		{
			_btnLeave.removeEventListener(MouseEvent.CLICK,leaveHandler);
			_mediator.sceneModule.pvpFirstInfo.removeEventListener(ScenePvpFirstUpdateEvent.PVP_FIRST_INFO_UPDATE, updateInfoHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			
			_tip.removeEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_tip.removeEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
		}
		private function tipOverHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.pvp.firstDirections2"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function tipOutHandler(eevt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		private function updateInfoHandler(e:ScenePvpFirstUpdateEvent):void
		{
			var time:int = _mediator.sceneModule.pvpFirstInfo.leaveTime;
			var name:String = _mediator.sceneModule.pvpFirstInfo.firstName;
			_firstName.setValue(name);
			_countDownView.start(time);
		}
		
		private function leaveHandler(event:MouseEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.scene.isSureLeaveWarScene") ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveConfirmHandler);
		}
		
		
		private function leaveConfirmHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				ActivePvpFirstLeaveSocketHandler.send();
			}
		}
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - WIDTH;
			y = Y;
		}
//		public function get resourceWarInfo():ResourceWarInfo
//		{
//			return _mediator.sceneModule.resourceWarInfo;
//		}
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(_btnLeave)
			{
				_btnLeave.dispose();
				_btnLeave = null;
			}
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
		}
		
	}
}