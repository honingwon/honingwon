package sszt.task.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.task.components.sec.ITaskMainPanel;
	import sszt.task.components.sec.TaskAcceptPanel;
	import sszt.task.components.sec.TaskEntrustPanel;
	import sszt.task.components.sec.TaskListPanel;
	import sszt.task.mediators.TaskMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.task.TaskMainTitleAsset;
	
	public class TaskMainPanel extends MPanel
	{
		private var _mediator:TaskMediator;
		private var _bg:IMovieWrapper;
//		private var _labels:Vector.<String>;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _classes:Vector.<Class>;
//		private var _panels:Vector.<ITaskMainPanel>;
		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		private var _activityBtn:MCacheAsset3Btn;
		
		public function TaskMainPanel(mediator:TaskMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
//			if(GlobalData.domain.hasDefinition("sszt.task.MainPanelTitleAsset"))
//			{
//				title = new Bitmap(AssetUtil.getAsset("mhsm.task.MainPanelTitleAsset") as BitmapData);
//			}
			title = new Bitmap(new TaskMainTitleAsset);
			super(new MCacheTitle1("",title),true,-1,true,false);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(529, 385);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8, 25, 513, 352)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(12, 29, 192,344)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(207, 29, 310, 344)),
			]);
			addContent(_bg as DisplayObject);
			
//			_labels = Vector.<String>(["任务列表","可接任务","委托任务"]);
//			var poses:Vector.<Point> = Vector.<Point>([new Point(16,8),new Point(84,8),new Point(152,8)]);
//			_btns = new Vector.<MCacheTab1Btn>();
			
			_labels = [LanguageManager.getWord("ssztl.task.taskList"),
				LanguageManager.getWord("ssztl.task.acceptableTask"),
				LanguageManager.getWord("ssztl.task.entrustTask")];
			var poses:Array = [
				new Point(15, 0) ,
				new Point(84, 0), 
				new Point(156, 0)];
			_btns = [];
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0, 2, _labels[i]);
				btn.move(poses[i].x,poses[i].y);
				_btns.push(btn);
				addContent(btn);
			}
			(_btns[2] as MCacheTabBtn1).visible = (_btns[2] as MCacheTabBtn1).mouseEnabled = false;
			
//			_classes = Vector.<Class>([TaskListPanel,TaskAcceptPanel,TaskEntrustPanel]);
//			_panels = new Vector.<ITaskMainPanel>(_labels.length);
			_classes = [
				TaskListPanel, 
				TaskAcceptPanel, 
				TaskEntrustPanel];
			_panels = new Array(_labels.length);
			
			_activityBtn = new MCacheAsset3Btn(2,LanguageManager.getWord("ssztl.task.suggestActivity"));
			_activityBtn.move(482,5);
			addContent(_activityBtn);
			_activityBtn.visible = _activityBtn.mouseEnabled = false;
			
			setIndex(0);
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_activityBtn.addEventListener(MouseEvent.CLICK,activityBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			_activityBtn.removeEventListener(MouseEvent.CLICK,activityBtnClickHandler);
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		public function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			if(_currentIndex > -1)
			{
				if(_btns[_currentIndex])
					_btns[_currentIndex].selected = false;
				if(_panels[_currentIndex])
					_panels[_currentIndex].hide();
			}
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(12, 29);
			}
			addContent(_panels[_currentIndex] as DisplayObject);
		}
		
		private function activityBtnClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_activityBtn)
			{
				_activityBtn.dispose();
				_activityBtn = null;
			}
			if(_btns)
			{
				for each(var btn:MCacheTabBtn1 in _btns)
				{
					btn.dispose();
				}
			}
			_btns = null;
			if(_panels)
			{
				for each(var panel:ITaskMainPanel in _panels)
				{
					if(panel)panel.dispose();
				}
			}
			_panels = null;
			_classes = null;
			_labels = null;
			_mediator = null;
		}
	}
}