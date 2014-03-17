package sszt.scene.components.transport
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.task.TaskCancelSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.commands.activities.PlayerListController;
	import sszt.scene.data.roles.BaseSceneCarInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class TransportPanel extends MPanel
	{
		private var _mediator:SceneMediator;
		private var _info:TaskItemInfo;
		private var _bg:IMovieWrapper;
		private var _content:TextField;
//		private var _sp1:Sprite,_sp2:Sprite;
		private var _quality:MAssetLabel,_exp:MAssetLabel,_copper:MAssetLabel;
		private var _goBtn:MCacheAssetBtn1;
		
		private var _icon:Bitmap;
		
		public function TransportPanel(mediator:SceneMediator)
		{
			_mediator = mediator;
			_info = GlobalData.taskInfo.getTransportTask();
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.scene.TransportTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.scene.TransportTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1, true, true);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(255,315);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,240,305)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,232,160)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,167,232,136)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,160,255,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,252,255,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(27,178,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.transport.waresType") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(27,200,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.core.expAward"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(27,222,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.core.copperAward"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			_icon = new Bitmap();
			_icon.x = -4;
			_icon.y = 130;
//			addContent(_icon);
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(23,201,52,18),new MAssetLabel("任务奖励",MAssetLabel.LABELTYPE14)));
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(23,201,52,18),new MAssetLabel(LanguageManager.getWord("ssztl.core.taskAward"),MAssetLabel.LABELTYPE14)));
			
			_content = new TextField();
			_content.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,null,null,null,null,5);
			_content.x = 18;
			_content.y = 14;
			_content.width = 220;
			_content.height = 138;
			_content.wordWrap = true;
			_content.mouseEnabled = _content.mouseWheelEnabled = false;
			addContent(_content);

			_content.htmlText = LanguageManager.getWord("ssztl.scene.transportDescript");
//			_sp1 = new Sprite();
//			_sp1.graphics.beginFill(0,0);
//			_sp1.graphics.drawRect(0,0,50,20);
//			_sp1.graphics.endFill();
//			_sp1.x = 71;
//			_sp1.y = 128;
//			_sp1.buttonMode = true;
//			_sp1.tabEnabled = false;
//			addContent(_sp1);
//			_sp2 = new Sprite();
//			_sp2.graphics.beginFill(0,0);
//			_sp2.graphics.drawRect(0,0,50,20);
//			_sp2.graphics.endFill();
//			_sp2.x = 85;
//			_sp2.y = 144;
//			_sp2.buttonMode = true;
//			_sp2.tabEnabled = false;
//			addContent(_sp2);
			
			_quality = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"left");
			_quality.move(87,178);
			addContent(_quality);
			_exp = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,"left");
			_exp.move(87,200);
			addContent(_exp);
			_copper = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,"left");
			_copper.move(87,223);
			addContent(_copper);
			infoUpdateHandler(null);
			
			_goBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.autoGo"));
			_goBtn.move(93,264);
			addContent(_goBtn);
		}
		
		private function initEvent():void
		{
			_info.addEventListener(TaskItemInfoUpdateEvent.TASKINFO_UPDATE,infoUpdateHandler);
//			_sp1.addEventListener(MouseEvent.CLICK,sp1ClickHandler);
//			_sp2.addEventListener(MouseEvent.CLICK,sp2ClickHandler);
			_goBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvent():void
		{
			_info.removeEventListener(TaskItemInfoUpdateEvent.TASKINFO_UPDATE,infoUpdateHandler);
//			_sp1.removeEventListener(MouseEvent.CLICK,sp1ClickHandler);
//			_sp2.removeEventListener(MouseEvent.CLICK,sp2ClickHandler);
			_goBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function infoUpdateHandler(e:TaskItemInfoUpdateEvent):void
		{
			_quality.setValue(getQualityName());
			_quality.textColor = CategoryType.getQualityColor(getCarQuality());
			_icon.bitmapData = AssetUtil.getAsset("ssztui.scene.TransportIconAsset" +(getCarQuality()+1)) as BitmapData;
			_exp.setValue((_info.getCurrentState().awardExp).toString());
			_copper.setValue((_info.getCurrentState().awardCopper).toString());
		}
		
		private function getCarQuality():int
		{
			for each(var info:BaseSceneCarInfo in _mediator.sceneInfo.carList.getCars())
			{
				if(info && info.owner == GlobalData.selfPlayer.userId)
				{
					return info.quality;
				}
			}
			return 0;
		}
		private function getQualityName():String
		{
			switch (getCarQuality())
			{
				case 0:
					return LanguageManager.getWord("ssztl.transport.wares1");
				case 1:
					return LanguageManager.getWord("ssztl.transport.wares2");
				case 2:
					return LanguageManager.getWord("ssztl.transport.wares3");
				case 3:
					return LanguageManager.getWord("ssztl.transport.wares4");
				case 4:
					return LanguageManager.getWord("ssztl.transport.wares5");	
			}
			return LanguageManager.getWord("ssztl.transport.wares1");
			
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
//			_mediator.sceneInfo.playerList.self.isAutoWalk = true;
			_mediator.sceneInfo.playerList.self.state.setFindPath(true);
			_mediator.walkToNpc(_info.getCurrentState().npc);
		}
		
		private function closeHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				if(GlobalData.taskInfo.getTransportTask() != null)
					TaskCancelSocketHandler.sendCancel(_info.taskId);
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_goBtn)
			{
				_goBtn.dispose();
				_goBtn = null;
			}
			_info = null;
			_mediator = null;
			super.dispose();
		}
	}
}