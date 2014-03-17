package sszt.scene.components.shenMoWar.myWar
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarMyWarInfoUpdateSocketHandler;
	
	public class ShenMoMyWarInfoPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		private var _btns:Array;
		private var _panels:Array;
		private var _classes:Array;
		private var _currentIndex:int = -1;
		
		public function ShenMoMyWarInfoPanel(argMediator:SceneWarMediator)
		{
			_mediator = argMediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.scene.ShenMoMyWarInfoAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.ShenMoMyWarInfoAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(369,397);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,369,397)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,30,360,5),new MCacheSplit1Line())
			]);
			addContent(_bg as DisplayObject);
			
			var nameList:Array = [LanguageManager.getWord("ssztl.scene.killList"),LanguageManager.getWord("ssztl.scene.beKilledList")];
			_btns = [];
			_classes = [ShenMoAttackInfoTabPanel,ShenMoBeAttackedInfoTabPanel];
			_panels = [];
			var tmpBtn:MCacheTab1Btn;
			for(var i:int = 0;i < nameList.length;i++)
			{
				tmpBtn = new MCacheTab1Btn(0,1,nameList[i]);
				tmpBtn.move(i*67 + 12,8);
				_btns.push(tmpBtn);
				addContent(tmpBtn);
				tmpBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			index(0);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			var argIndex:int = _btns.indexOf(e.currentTarget as MCacheTab1Btn);
			index(argIndex);
		}
		
		private function index(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
			if(_currentIndex != -1)
			{
				_btns[_currentIndex].selected = false;
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
			}
			_currentIndex = argIndex;
			_btns[_currentIndex].selected = true;
			if(!_panels[_currentIndex])
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator);
				_panels[_currentIndex].move(5,33);
			}
			addContent(_panels[_currentIndex]);
			_panels[_currentIndex].show();
		}
		
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			for each(var i:MCacheTab1Btn in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				i.dispose();
				i = null;
			}
			_btns = null;
			for(var j:int = 0;j < _panels.length;j++)
			{
				if(_panels[j])
				{
					_panels[j].dispose();
					_panels[j] = null;
				}
			}
			_panels = null;
			_classes = null;
			super.dispose();
		}
	}
}