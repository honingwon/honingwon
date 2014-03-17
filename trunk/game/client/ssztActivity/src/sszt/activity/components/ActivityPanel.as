package sszt.activity.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.activity.mediators.ActivityMediator;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.SelectedBorder;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.activity.WinTitleAsset;
	
	public class ActivityPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:ActivityMediator;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		private var _toData:ToActivityData;
		public static var SelectBorder:SelectedBorder;
		public static var EVEN_COLOR:int = 0x172527;
		
		public function ActivityPanel(argActivityMediator:ActivityMediator,data:Object)
		{
			if(data) 
			{
				_toData = data as ToActivityData;
			}
			_mediator = argActivityMediator;
			super(new MCacheTitle1("",new Bitmap(new WinTitleAsset())),true,-1,true,true);
		}
		
		override protected function configUI():void
		{
			SelectBorder = new SelectedBorder();
			SelectBorder.mouseEnabled = false;
			SelectBorder.setSize(420,33);
			super.configUI();
			setContentSize(624,421);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,608,388)),								
			]);
			addContent(_bg as DisplayObject);
			
			var _labels:Array = [LanguageManager.getWord("ssztl.activity.activityDegree"),
				LanguageManager.getWord("ssztl.activity.activity"),
				LanguageManager.getWord("ssztl.activity.dailyTask"),
				LanguageManager.getWord("ssztl.activity.copy"),
				LanguageManager.getWord("ssztl.activity.pvp"),
				];
			_classes = [ActiveTabPanel, ActivityTabPanel, TaskTabPanel, CopyTabPanel, ActivityPvPTabPanel];
			_panels = new Array(_labels.length);
			_btns = new Array(_labels.length);
			
			var posX:int = 15;
			for(var i:int = 0;i<_labels.length;i++)
			{
				_btns[i] = new MCacheTabBtn1(0, 2, _labels[i]);
				_btns[i].move(posX,0);
				addContent(_btns[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
				posX += 69;
			}
			
			if(_toData)
			{
				setIndex(_toData.tabIndex);
			}
			else
			{
				setIndex(0);
			}
//			UserInfoSocketHandler.send();//获取江湖令接受发布数据
		}
		
		
				
		private function btnClickHandler(e:MouseEvent):void
		{
			var _index:int = _btns.indexOf(e.currentTarget);
			setIndex(_index);
		}
		
		private function setIndex(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
			if(_currentIndex != -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = argIndex;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(9,26);
			}
			addContent(_panels[_currentIndex]);
			_panels[_currentIndex].show();
		}
		
		override public function dispose():void
		{
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			for(var i:int = 0;i<_btns.length;i++)
			{
				_btns[i].dispose();
				_btns[i] = null;
			}
			_btns[i] = null;
			_classes = null;
			for(var j:int = 0;j<_panels.length;j++)
			{
				if(_panels[j])
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			_panels = null;
			SelectBorder = null;
			super.dispose();
		}
			
	}
}