package sszt.scene.components.climbTowerPanel
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyEnterNumberList;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.copy.CopyLimitNumResetSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.CopyEnterSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.SplitCompartLine2;
	
	public class ClimbTowerPanel extends MPanel
	{
		
		private var _bg:IMovieWrapper;
		
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		
		private var _mediator:SceneMediator;
		private var _copyTemplateInfo:CopyTemplateItem;
		
		public function ClimbTowerPanel(mediator:SceneMediator)
		{
			_mediator = mediator;
			
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.TowerTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.TowerTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(568,410);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,552,377)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,29,247,369)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(260,29,296,369)),
				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(269,309,277,36)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(269,344,277,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(292,45,217,1),new Bitmap(AssetUtil.getAsset("ssztui.common.BgWenTitleAsset") as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(292,209,217,1),new Bitmap(AssetUtil.getAsset("ssztui.common.BgWenTitleAsset") as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(376,39,61,15),new Bitmap(AssetUtil.getAsset("ssztui.common.TagFBInfoAsset") as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(376,203,61,15),new Bitmap(AssetUtil.getAsset("ssztui.common.TagDiaoLuoAsset") as BitmapData)),
			]);
			addContent(_bg as DisplayObject);
			
			var _labels:Array = [
				LanguageManager.getWord("ssztl.rank.copyName1"),
				LanguageManager.getWord("ssztl.rank.copyName5")
			];
			_classes = [SortTowerOneView,SortTowerTwoView];
			_panels = new Array(_labels.length);
			_btns = new Array(_labels.length);
			
			for(var i:int = 0;i<_labels.length;i++)
			{
				_btns[i] = new MCacheTabBtn1(0, 2, _labels[i]);
				_btns[i].move(15+i*69,0);
				addContent(_btns[i]);
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
//			(_btns[1] as MCacheAssetBtn1).enabled = false;
			setIndex(0);
		}
			
		private function initEvent():void
		{
			for(var i:int = 0;i<_btns.length;i++)
			{
				_btns[i].addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
			
		}
		
		private function removeEvent():void
		{
			for(var i:int = 0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnClickHandler);
			}
			
		}
		private function btnClickHandler(e:MouseEvent):void
		{
			var _index:int = _btns.indexOf(e.currentTarget);
			setIndex(_index);
		}
		private function setIndex(argIndex:int):void
		{
			if(_currentIndex == argIndex)return;
//			if(argIndex == 1)
//			{
//				QuickTips.show("狱魔会副本即将开放，敬请期待！");
//				return ;
//			}
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
			super.dispose();
			
			removeEvent();
			
			_mediator = null;
			_copyTemplateInfo = null;
		}
	}
}