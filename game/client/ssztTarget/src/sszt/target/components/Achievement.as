package sszt.target.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.target.events.AchievementEvent;
	import sszt.target.mediator.TargetMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.ui.ProgressBar3Asset;
	
	
	/**
	 * 成就系统 
	 * @author chendong
	 * 
	 */	
	public class Achievement extends Sprite implements ITargetPanelView,IPanel
	{
		private var _mediator:TargetMediator;
		
		private var _bg:IMovieWrapper;
		private var _assetsComplete:Boolean;
		/**
		 * 成就左边分类按钮
		 */		
		private var _achLeft:AchLeft;
		
		/**
		 * 成就显示分类成就 
		 */		
		private var _achMiddle:AchMiddle;
		
		/**
		 * 成就显示总览成就
		 */		
		private var _achOverview:AchOverview;
		
		private var _targetData:ToTargetData;
		
		public function Achievement(mediator:TargetMediator,targetData:ToTargetData =null)
		{
			super();
			_targetData = targetData;
			_mediator = mediator;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,120,383)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(123,0,493,383)),
			]); 
			addChild(_bg as DisplayObject);
			
			// TODO Auto Generated method stub
			_achLeft = new AchLeft(_targetData);
			_achLeft.move(3,3);
			addChild(_achLeft);
			
			_achMiddle = new AchMiddle();
			_achMiddle.move(123,0);
			addChild(_achMiddle);
			_achMiddle.visible = false;
			
			_achOverview = new AchOverview();
			_achOverview.move(123,0);
			addChild(_achOverview);
			
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			showData(_targetData.typeIndex);
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
			ModuleEventDispatcher.addModuleEventListener(AchievementEvent.SELECT_ACH_TYPE_BTN,selectAchType);
		}
		
		private function selectAchType(evt:ModuleEvent):void
		{
			showData(int(evt.data.type));
		}
		
		private function showData(index:int):void
		{
			if(index != 0)
			{
				_achMiddle.visible = true;
				_achMiddle.currentType = index;
				_achOverview.visible = false;
			}
			else
			{
				_achMiddle.visible = false;
				_achOverview.visible = true;
				_achOverview.initData();
			}
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;			
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			ModuleEventDispatcher.removeModuleEventListener(AchievementEvent.SELECT_ACH_TYPE_BTN,selectAchType);
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			if(_achOverview) _achOverview.assetsCompleteHandler();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function show():void
		{
		}
		
		public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_achLeft)
			{
				_achLeft.dispose();
			}
			if(_achMiddle)
			{
				_achMiddle.dispose();
			}
			if(_achOverview)
			{
				_achOverview.dispose();
			}
		}
	}
}