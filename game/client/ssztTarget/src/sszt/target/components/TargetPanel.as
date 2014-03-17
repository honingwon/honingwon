package sszt.target.components
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.target.TargetListUpdateSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.AmountFlashView;
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.target.mediator.TargetMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.target.TitleAsset;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	public class TargetPanel extends MPanel implements ITick
	{
		private var _bg:IMovieWrapper;
		private var _mediator:TargetMediator;
		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		private var _assetsComplete:Boolean;
		private var _index:int = 0;
		
		private var _amount:Array;
		
		private var _toTD:ToTargetData;
		
		public function TargetPanel(mediator:TargetMediator,toTD:ToTargetData)
		{
			super(new MCacheTitle1("",new Bitmap(new TitleAsset())),true,-1,true,true);
			_mediator = mediator;
			_toTD = toTD;
			_index = _toTD.tabIndex;
			initialTab(_index);
			initView();
			initEvent();
			initData();
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			
		}
		
		override protected function configUI():void
		{
			// TODO Auto Generated method stub
			super.configUI();
			setContentSize(642,426);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,25,626,393)),
			]); 
			addContent(_bg as DisplayObject);
			
		}
		
		private function initView():void
		{
			
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListTar);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardTar);
		}
		
		private function initData():void
		{
			TargetListUpdateSocketHandler.send();
		}
		
		private function initialTab(selectIndex:int):void
		{
			_amount = [];
			_labels = [LanguageManager.getWord("ssztl.common.target"),LanguageManager.getWord("ssztl.achieve.achieveLabel")];			
			
			var poses:Array = [new Point(15,0),new Point(100,0)];
			_btns = new Array();
			
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,3,_labels[i]);
				btn.move(poses[i].x,poses[i].y);
				addContent(btn);
				_btns.push(btn);
				btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
				
				var amt:AmountFlashView = new AmountFlashView();
				amt.move(poses[i].x-2,poses[i].y-3);
				addContent(amt);
				_amount.push(amt);
				amt.visible = false;
			}
			
			_classes = [Target,Achievement];
			if(selectIndex >= _classes.length || selectIndex < 0)
				selectIndex = 0;
			_panels = new Array();
			setIndex(selectIndex);
		}
		
		private function updateTargetListTar(evt:ModuleEvent):void
		{
			if(_amount.length > 1)
			{
				var tarNum:int=0;
				var achNum:int=0;
				var i:int=0;
				for(;i<TargetUtils.TARGET_TYPE_NUM;i++)
				{
					tarNum += TargetUtils.getTargetCompleteNum(i);
				}
				if(tarNum > 0)
				{
					_amount[0].visible = true;
					_amount[0].setValue(String(tarNum));
				}else
				{
					_amount[0].visible = false;
				}
				
				i = 1;
				for(;i<=TargetUtils.ACH_TYPE_NUM;i++)
				{
					achNum += TargetUtils.getAchCompleteNum(i);
				}
				
				if(achNum > 0)
				{
					_amount[1].visible = true;
					_amount[1].setValue(String(achNum));
				}else
				{
					_amount[1].visible = false;
				}
			}
		}
		
		private function getTargetAwardTar(evt:ModuleEvent):void
		{
			var i:int=0;
			if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == TargetUtils.TARGET_TYPE)
			{
				if(_amount.length > 1)
				{
					var tarNum:int=0;
					for(;i<TargetUtils.TARGET_TYPE_NUM;i++)
					{
						tarNum += TargetUtils.getTargetCompleteNum(i);
					}
					if(tarNum > 0)
					{
						_amount[0].visible = true;
						_amount[0].setValue(String(tarNum));
					}else
					{
						_amount[0].visible = false;
					}
				}
			}
			else if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == TargetUtils.ACH_TYPE)
			{
				i = 1;
				if(_amount.length > 1)
				{
					var achNum:int=0;
					for(;i<=TargetUtils.ACH_TYPE_NUM;i++)
					{
						achNum += TargetUtils.getAchCompleteNum(i);
					}
					
					if(achNum > 0)
					{
						_amount[1].visible = true;
						_amount[1].setValue(String(achNum));
					}else
					{
						_amount[1].visible = false;
					}
				}
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
			if(_currentIndex > -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_mediator,_toTD);
				_panels[_currentIndex].move(13,30);
				if(_assetsComplete)
				{
					(_panels[_currentIndex] as ITargetPanelView).assetsCompleteHandler();
				}
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
		}
		
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListTar);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardTar);
		}
		
		override public function dispose():void
		{
			// TODO Auto Generated method stub
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
//			_classes = null;
//			_amount = null;
//			_btns = null;
			for(var i:int=0; i<_classes.length;i++)
			{
				if(_panels[i] != null)
				{
					(_panels[i] as ITargetPanelView).dispose();
				}
			}
			super.dispose();
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			if(_currentIndex != -1 && _panels[_currentIndex])
			{
				(_panels[_currentIndex] as ITargetPanelView).assetsCompleteHandler();
			}
		}
	}
}