package sszt.scene.components.acrossServer
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.AcroSerMediator;
	
	public class AcroSerMainPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:AcroSerMediator;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		
		public function AcroSerMainPanel(argAcroSerMediator:AcroSerMediator)
		{
			_mediator = argAcroSerMediator;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.scene.crossServerActivity")),true,-1,true,true);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(641,431);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,641,431)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,30,632,5),new MCacheSplit1Line())
			]);
			
			addContent(_bg as DisplayObject);
			
			var _labels:Array = [LanguageManager.getWord("ssztl.scene.crossServerBoss")];
			
			var tipsLabel:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.serverBossPrompt"),MAssetLabel.LABELTYPE1);
			tipsLabel.move(100,10);
			addContent(tipsLabel);
			
			var _poses:Array = [new Point(12,8)];
			_classes = [AcroBossTabPanel];
			_panels = new Array(_labels.length);
			_btns = new Array(_labels.length);
			
			for(var i:int = 0;i<_labels.length;i++)
			{
				_btns[i] = new MCacheTab1Btn(0,1,_labels[i]);
				_btns[i].move(_poses[i].x,_poses[i].y);
				addContent(_btns[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
			setIndex(0);
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
				_panels[_currentIndex].move(5,34);
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
			super.dispose();
		}

		public function get panels():Array
		{
			return _panels;
		}

		public function set panels(value:Array):void
		{
			_panels = value;
		}

	}
}