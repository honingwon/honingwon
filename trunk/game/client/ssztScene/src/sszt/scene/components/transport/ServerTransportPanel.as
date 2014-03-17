package sszt.scene.components.transport
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class ServerTransportPanel extends MPanel
	{
		private var _mediator:SceneMediator;
		
		private var _bg:IMovieWrapper;
		private var _autoBtn:MCacheAssetBtn1;
		private var _transferBtn:MCacheAssetBtn1;
		private var _leftTimes:MAssetLabel;
		private var _title1:Bitmap;
		private var _icon:Bitmap;
		
		public function ServerTransportPanel(mediator:SceneMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1(""),true,-1, true, true);
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(256,315);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,240,305)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,232,160)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,167,232,136)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,138,255,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,252,255,25),new MCacheCompartLine2()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(104,162,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.finishLabel") + LanguageManager.getWord("ssztl.common.award") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			]);
			addContent(_bg as DisplayObject);
			
			_title1 = new Bitmap(AssetUtil.getAsset("ssztui.scene.TransportDoneTitleAsset") as BitmapData);
			_title1.x = 50;
			_title1.y = -17;
			addContent(_title1);
			
			_icon = new Bitmap();
			_icon.x = 76;
			_icon.y = 32;
//			addContent(_icon);
			
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(28,24,64,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.startTime"),MAssetLabel.LABELTYPE14)));
//			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(88,24,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.startTimeDetail"),MAssetLabel.LABELTYPE1)));
//			
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,null,null,null,null,8);
			var field:TextField = new TextField();
			field.defaultTextFormat = format;
			field.x = 28;
			field.y = 56;
			field.width = 184;
			field.height = 101;
			field.multiline = true;
			field.wordWrap = true;
			field.mouseEnabled = field.mouseWheelEnabled = false;
			field.text = LanguageManager.getWord("ssztl.scene.serverTransportExplain");
			addContent(field);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(28,172,88,16),new MAssetLabel(LanguageManager.getWord("ssztl.scene.dayLeftTransport"),MAssetLabel.LABELTYPE14)));
			
			_leftTimes = new MAssetLabel(LanguageManager.getWord("ssztl.common.timesValue",getDateLeftCount()),MAssetLabel.LABELTYPE10);
			_leftTimes.move(112,172);
			addContent(_leftTimes);
			
			_autoBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.autoGo"));
			_autoBtn.move(26,204);
			addContent(_autoBtn);
			
			_transferBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.transferRightNow"));
			_transferBtn.move(136,268);
			addContent(_transferBtn);
		}
		
		private function initEvents():void
		{
			_autoBtn.addEventListener(MouseEvent.CLICK,autoGoHandler);
			_transferBtn.addEventListener(MouseEvent.CLICK,transferHandler);
			
			ModuleEventDispatcher.addTaskEventListener(TaskModuleEvent.TASK_ADD,taskUpdateHandler);
		}
		
		private function removeEvents():void
		{
			_autoBtn.removeEventListener(MouseEvent.CLICK,autoGoHandler);
			_transferBtn.removeEventListener(MouseEvent.CLICK,transferHandler);
			
			ModuleEventDispatcher.removeTaskEventListener(TaskModuleEvent.TASK_ADD,taskUpdateHandler);
		}
		
		private function autoGoHandler(evt:MouseEvent):void
		{
			_mediator.walkToNpc(411069);
		}
		
		private function transferHandler(evt:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:1005,target:new Point(5412,1673)}));
		}
		
		private function taskUpdateHandler(evt:TaskModuleEvent):void
		{
//			_leftTimes.setValue(getDateLeftCount()+ "次");
			_leftTimes.setValue(LanguageManager.getWord("ssztl.common.timesValue",getDateLeftCount()));
		}
		
		//当天运镖剩余次数
		public function getDateLeftCount():int
		{
			var list:Array = GlobalData.taskInfo.getAllTransportTask();
			var count:int = 0;
			for(var i:int = 0; i < list.length; i++)
			{
				count += (list[i].getTemplate().repeatCount - list[i].dayLeftCount);
			}
			return (5-count);
		}
		
		
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_autoBtn)
			{
				_autoBtn.dispose();
				_autoBtn = null;
			}
			if(_transferBtn)
			{
				_transferBtn.dispose();
				_transferBtn = null;
			}
			super.dispose();
		}
	}
}


















