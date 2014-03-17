package sszt.scene.components.shenMoWar
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.tabBtns.MCacheTab1Btn;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.components.shenMoWar.clubWar.ClubPointWarScorePanel;
	import sszt.scene.components.shenMoWar.members.ShenMoWarMapTabPanel;
	import sszt.scene.components.shenMoWar.members.ShenMoWarMemberTabPanel;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarLeaveSocketHandler;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarMemberListUpdateSocketHandler;
	
	public class ShenMoRewardsPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		private var _btns:Array;
		private var _panels:Array;
		private var _classes:Array;
		private var _currentIndex:int = -1;
		
		public function ShenMoRewardsPanel(argMediator:SceneWarMediator)
		{
			_mediator = argMediator;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.scene.ShenMoWarRewardAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.scene.ShenMoWarRewardAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			initialEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(635,432);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,635,432)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(5,30,625,5),new MCacheSplit1Line())
			]);
			addContent(_bg as DisplayObject);
			
			var nameList:Array = [LanguageManager.getWord("ssztl.scene.shenMoWar")];
			_btns = [];
			_classes = [ShenMoWarMemberTabPanel];
			_panels = [];
			var tmpBtn:MCacheTab1Btn;
			for(var i:int = 0;i < nameList.length;i++)
			{
				tmpBtn = new MCacheTab1Btn(0,1,nameList[i]);
				tmpBtn.move(i*67 + 23,8);
				_btns.push(tmpBtn);
				addContent(tmpBtn);
				tmpBtn.addEventListener(MouseEvent.CLICK,tabBtnClickHandler);
			}
			
			var label2:MAssetLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			label2.move(500,402);
			addContent(label2);
			label2.htmlText = LanguageManager.getWord("ssztl.scene.leaveWarAttention");
			
			index(0);
		}
		
		private function tabBtnClickHandler(e:MouseEvent):void
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
		
		private function initialEvents():void
		{

		}
		
		private function removeEvents():void
		{

		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			for each(var i:MCacheTab1Btn in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,tabBtnClickHandler);
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