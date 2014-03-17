package sszt.scene.components.nearly
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.splits.MCacheSplit4Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.NearlyMediator;
	
	public class NearlyPanel extends MPanel
	{
		private var _mediator:NearlyMediator;
//		private var _labels:Vector.<String>;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _classes:Vector.<Class>;
//		private var _panels:Vector.<INearlyTabView>;
		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int;
		private var _bg:IMovieWrapper;
		public static var SelectBorder:SelectedBorder;
		
		public function NearlyPanel(mediator:NearlyMediator)
		{
			_mediator = mediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.scene.NearlyTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.NearlyTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			SelectBorder = new SelectedBorder();
			SelectBorder.setSize(275,30);
			SelectBorder.mouseEnabled = false;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(312,423);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,312,423)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(4,27,304,322)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(4,27,305,5),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(286,31,2,317),new MCacheSplit4Line())
			]);
			addContent(_bg as DisplayObject);
			
			_currentIndex = -1;
			
//			_labels = Vector.<String>(["快捷组队","附近玩家","附近NPC"]);
//			_btns = new Vector.<MCacheTab1Btn>();
//			var poses:Vector.<Point> = Vector.<Point>([new Point(16,5),new Point(86,5),new Point(156,5)]);
			
			_labels = [LanguageManager.getWord("ssztl.scene.quickOrganizeTeam"),
				LanguageManager.getWord("ssztl.scene.nearPlayer2"),
				LanguageManager.getWord("ssztl.scene.nearNPC")];
			
			_btns = [];
			var poses:Array = [new Point(16,5),new Point(83,5),new Point(150,5)];
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTab1Btn = new MCacheTab1Btn(0,1,_labels[i]);
				_btns.push(btn);
				btn.move(poses[i].x,poses[i].y);
				addContent(btn);
			}
//			_classes = Vector.<Class>([NearlyGroupTabView,NearlyPlayerTabView,NearlyNpcTabView]);
//			_panels = new Vector.<INearlyTabView>(_labels.length);
			_classes = [NearlyGroupTabView,NearlyPlayerTabView,NearlyNpcTabView];
			_panels = new Array(_labels.length);
			initEvent();
			
			setIndex(0);
		}
		
		private function initEvent():void
		{
			for each(var i:MCacheTab1Btn in _btns)
			{
				i.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			for each(var i:MCacheTab1Btn in _btns)
			{
				i.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		private function setIndex(index:int):void
		{
			if(_currentIndex == index)return;
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			if(_currentIndex != -1)
			{
				_btns[_currentIndex].selected = false;
				_panels[_currentIndex].hide();
			}
			_currentIndex = index;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(4,28);
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] is NearlyGroupTabView)
				(_panels[_currentIndex] as NearlyGroupTabView).getData();
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget);
			setIndex(index);
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			_labels = null;
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].dispose();
			}
			_btns = null;
			_classes = null;
			for(i =0;i<_panels.length;i++)
			{
				if(_panels[i])
				{
					_panels[i].dispose();	
				}
			}
			_panels = null;
			_bg.dispose();
			_bg = null;
			super.dispose();
		}
	}
}