package sszt.setting.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.module.changeInfos.ToSettingData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.setting.components.sec.HotKeysListPanel;
	import sszt.setting.components.sec.ISettingPanel;
	import sszt.setting.components.sec.SystemSettingPanel;
	import sszt.setting.mediators.SettingMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.setting.TitleAsset;
	
	public class SettingPanel extends MPanel
	{
		private var _mediator:SettingMediator;
		private var _bg:IMovieWrapper;
//		private var _labels:Vector.<String>;
//		private var _btns:Vector.<MCacheTab1Btn>;
//		private var _classes:Vector.<Class>;
//		private var _panels:Vector.<ISettingPanel>;
		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int;
		private var _toSettingData:ToSettingData;
		
		public function SettingPanel(mediator:SettingMediator,toSettingData:ToSettingData)
		{
			_mediator = mediator;
			_toSettingData = toSettingData;
			super(new MCacheTitle1("",new Bitmap(new TitleAsset())),true,-1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(316,373);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,300,340)),
				//new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(8,30,530,5),new MCacheSplit1Line())
			]);
			addContent(_bg as DisplayObject);
			
//			_labels = Vector.<String>(["系统设置","快捷键列表"]);
//			var poses:Vector.<Point> = Vector.<Point>([new Point(27,7),new Point(94,7)]);
//			_btns = new Vector.<MCacheTab1Btn>();
			
			_labels = [LanguageManager.getWord("ssztl.setting.quickKeyList")]; //LanguageManager.getWord("ssztl.setting.systemSetting"),
			
			var poses:Array = [new Point(15,0),new Point(84,0)];
			_btns = [];
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(poses[i].x,poses[i].y);
				addContent(btn);
				_btns.push(btn);
			}
			
//			_classes = Vector.<Class>([SystemSettingPanel,HotKeysListPanel]);
//			_panels = new Vector.<ISettingPanel>(_labels.length);
			_classes = [HotKeysListPanel];//SystemSettingPanel
			_panels = new Array(_labels.length);
			
			_currentIndex = -1;
			if(_toSettingData) setIndex(_toSettingData.tabIndex);
			else setIndex(0);
		}
		
		private function initEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0; i < _btns.length; i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			setIndex(index);
		}
		
		private function setIndex(index:int):void
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
				_panels[_currentIndex].move(14,31);
			}
			addContent(_panels[_currentIndex] as DisplayObject);
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
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
				for each(var panel:ISettingPanel in _panels)
				{
					if(panel)panel.dispose();
				}
			}
			_toSettingData = null;
			_panels = null;
			_labels = null;
			_classes = null;
			_mediator = null;
		}
	}
}