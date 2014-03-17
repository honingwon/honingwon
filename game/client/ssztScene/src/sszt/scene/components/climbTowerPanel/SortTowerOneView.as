package sszt.scene.components.climbTowerPanel
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import sszt.constData.SourceClearType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyEnterNumberList;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.copy.CopyLimitNumResetSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.CopyEnterSocketHandler;
	import sszt.scene.socketHandlers.TeamLeaveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;

	public class SortTowerOneView extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneMediator
		
		private var _copyTemplateInfo:CopyTemplateItem;
		
		private var _timesLabel:MAssetLabel;
		private var _dropMTile:MTile;
		private var _onceAgainBtn:MCacheAssetBtn1;
		private var _enterBtn:MCacheAssetBtn1;
		
		private var _times:int;
		
		private var _txtName:MAssetLabel;
		private var _txtLevel:MAssetLabel;
		private var _txtAbout:MAssetLabel;
		private var _cover:Bitmap;
		private var _picPath:String;
		
		private const SINGLE_CLIMB_TOWER_COPY_ID:int = 4200601;
		
		private const COST:int =  98;
		
		public function SortTowerOneView(mediator:SceneMediator)
		{
			_mediator = mediator;
			_copyTemplateInfo = CopyTemplateList.getCopy(SINGLE_CLIMB_TOWER_COPY_ID);
			
			initView();
			initEvent();
		}
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,39,60,15),new MAssetLabel(LanguageManager.getWord('ssztl.scene.copyName'),MAssetLabel.LABEL_TYPE_TAG,'left')),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,59,60,15),new MAssetLabel(LanguageManager.getWord('ssztl.activity.enterLevel')+"：",MAssetLabel.LABEL_TYPE_TAG,'left')),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,79,60,15),new MAssetLabel(LanguageManager.getWord('ssztl.scene.copyAbout'),MAssetLabel.LABEL_TYPE_TAG,'left')),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(265,293,60,15),new MAssetLabel(LanguageManager.getWord('ssztl.common.towerChallengeAmount'),MAssetLabel.LABEL_TYPE22,'left')),
			]);
			addChild(_bg as DisplayObject);
			
			_cover = new Bitmap();
			_cover.x = _cover.y = 5;
			addChild(_cover);
			
			_picPath = GlobalAPI.pathManager.getBannerPath("coverTowerOne.jpg");
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_txtName = new MAssetLabel(_copyTemplateInfo.name,MAssetLabel.LABEL_TYPE20,"left");
			_txtName.move(325,39);
			addChild(_txtName);
			
			_txtLevel = new MAssetLabel(LanguageManager.getWord("ssztl.common.levelValue",_copyTemplateInfo.minLevel),MAssetLabel.LABEL_TYPE20,"left");
			_txtLevel.textColor = GlobalData.selfPlayer.level<_copyTemplateInfo.minLevel?0xff3300:0xfffccc;
			_txtLevel.move(325,59);
			addChild(_txtLevel);
			
			_txtAbout = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"left");
			_txtAbout.wordWrap = true;
			_txtAbout.setLabelType([new TextFormat("SimSun",12,0xae9b6f,null,null,null,null,null,null,null,null,null,6)]);
			_txtAbout.setSize(275,74);
			_txtAbout.move(265,99);
			addChild(_txtAbout);
			_txtAbout.setHtmlValue(_copyTemplateInfo.descript);
			
			_timesLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,'left');
			_timesLabel.move(351,293);
			addChild(_timesLabel);
			_times = GlobalData.copyEnterCountList.getItemCount(_copyTemplateInfo.id);
			_timesLabel.setValue(_times + "/" + _copyTemplateInfo.dayTimes);
			
			_dropMTile = new MTile(38,38,6);
			_dropMTile.itemGapH = _dropMTile.itemGapW = 1;
			_dropMTile.setSize(234,78);
			_dropMTile.move(283,198);
			addChild(_dropMTile);
			_dropMTile.horizontalScrollPolicy = _dropMTile.verticalScrollPolicy = ScrollPolicy.OFF;
			
			var drop:Array  = _copyTemplateInfo.award;
			var i:int;
			var cell:DropCell;
			for(i = 0;i < drop.length; i++)
			{
				cell = new DropCell();
				cell.info = ItemTemplateList.getTemplate(drop[i]);
				if(cell.info != null)
				{
					_dropMTile.appendItem(cell);
				}
			}
			
			_onceAgainBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.towerChallengeAdd'));
			_onceAgainBtn.move(457,288);
			addChild(_onceAgainBtn);
			var resetCostTime:int = GlobalData.copyEnterCountList.getItemResetCostCount(_copyTemplateInfo.id);
			if(resetCostTime == 1)
			{
				_onceAgainBtn.enabled = false;
			}
			
			_enterBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord('ssztl.challenge.dare'));
			_enterBtn.move(348,329);
			addChild(_enterBtn);
		}
		private function initEvent():void
		{
			_onceAgainBtn.addEventListener(MouseEvent.CLICK,onceAgainHandler);
			_enterBtn.addEventListener(MouseEvent.CLICK,enterHandler);
			GlobalData.copyEnterCountList.addEventListener(CopyEnterNumberList.SETDATACOMPLETE,setDataHandler);
		}
		private function removeEvent():void
		{
			_onceAgainBtn.removeEventListener(MouseEvent.CLICK,onceAgainHandler);
			_enterBtn.removeEventListener(MouseEvent.CLICK,enterHandler);
			GlobalData.copyEnterCountList.removeEventListener(CopyEnterNumberList.SETDATACOMPLETE,setDataHandler);
		}
		private function setDataHandler(e:Event):void
		{
			_times = GlobalData.copyEnterCountList.getItemCount(_copyTemplateInfo.id);
			_timesLabel.setValue(_times + "/" + _copyTemplateInfo.dayTimes);
			
			var resetCostTime:int = GlobalData.copyEnterCountList.getItemResetCostCount(_copyTemplateInfo.id);
			if(resetCostTime == 1)
			{
				_onceAgainBtn.enabled = false;
			}
		}
		
		private function enterHandler(event:MouseEvent):void
		{
			if(GlobalData.selfPlayer.level < _copyTemplateInfo.minLevel) 
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.levelNoAchieveCopyValue",_copyTemplateInfo.minLevel));
				return ;
			}
			if(GlobalData.selfPlayer.level > _copyTemplateInfo.maxLevel)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.overMaxLevelLimited"));
				return ;
			}
			if(_times >= _copyTemplateInfo.dayTimes)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.copyLeftZero"));
				return;
			}
			if(_mediator.sceneModule.sceneInfo.teamData.leadId> 0)
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.isSureEnterCopy1"),
					LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
				function leaveCloseHandler(e:CloseEvent):void
				{
					if(e.detail == MAlert.OK)
					{
						TeamLeaveSocketHandler.sendLeave();
						var ti:Timer = new Timer(1000,1);
						ti.start();
						GlobalData.selfPlayer.scenePath = null;
						GlobalData.selfPlayer.scenePathTarget = null;
						GlobalData.selfPlayer.scenePathCallback = null;
						_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
						CopyEnterSocketHandler.send(_copyTemplateInfo.id);			
						_mediator.showClimbingTowerPanel();
						//dispose();
					}
				}
			}
			else
			{
				GlobalData.selfPlayer.scenePath = null;
				GlobalData.selfPlayer.scenePathTarget = null;
				GlobalData.selfPlayer.scenePathCallback = null;
				_mediator.sceneModule.sceneInit.playerListController.getSelf().stopMoving();
				CopyEnterSocketHandler.send(_copyTemplateInfo.id);			
				_mediator.showClimbingTowerPanel();
			}
		}
		
		private function onceAgainHandler(event:MouseEvent):void
		{
			if(_times == 0)
			{
				QuickTips.show('不需要重置副本');
			}
			else if(GlobalData.selfPlayer.userMoney.yuanBao < COST)
			{
				
				QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
			}
			else
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.copyResetAlert",COST) ,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,resetCloseHandler);
			}
		}
		
		private function resetCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				CopyLimitNumResetSocketHandler.send(SINGLE_CLIMB_TOWER_COPY_ID);
			}
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_cover.bitmapData = data;
		}
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function dispose():void
		{
			removeEvent();
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			_timesLabel = null;
			if(_dropMTile)
			{
				_dropMTile.disposeItems();
				_dropMTile.dispose();
				_dropMTile = null;
			}
			if(_onceAgainBtn)
			{
				_onceAgainBtn.dispose();
				_onceAgainBtn = null;
			}
			if(_enterBtn)
			{
				_enterBtn.dispose();
				_enterBtn = null;
			}
			_txtName = null;
			_txtLevel = null;
		}
	}
}