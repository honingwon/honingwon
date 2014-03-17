package sszt.target.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.socketHandlers.target.TargetListUpdateSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.target.mediator.TargetMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	
	import ssztui.target.TagNeedTargetAsset;
	
	/**
	 * 目标系统 
	 * @author chendong
	 * 
	 */	
	public class Target extends Sprite implements ITargetPanelView,IPanel
	{
		private var _mediator:TargetMediator;
		
		private var _bg:IMovieWrapper;
		private var _bgImg1:Bitmap;
		private var _bgImg2:Bitmap;
		private var _bgImg3:Bitmap;
		/**
		 *目标类型 
		 */
		private var _targetType:TargetType;
		/**
		 * 需要完成目标
		 */		
		private var _completeTarget:CompleteTarget;
		/**
		 * 目标奖励  
		 */
		private var _targetReward:TargetReward;
		
		public var _currentType:int;
		
		/**
		 * 目标分类总素5 
		 */
		private var _typeNum:int = 5;
		
		public function Target(mediator:TargetMediator,targetData:ToTargetData =null)
		{
			super();
			_mediator = mediator;
//			_currentType = selectCurrentType(GlobalData.selfPlayer.level);
			_currentType = setIndexSelectType();
			initView();
			initEvent();
			initData();
		}
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,616,175)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,177,616,206)),
			]); 
			addChild(_bg as DisplayObject);
			
			_bgImg1 = new Bitmap();
			_bgImg1.x = _bgImg1.y = 1;
			addChild(_bgImg1);
			
			_bgImg2 = new Bitmap();
			_bgImg2.x = 2;
			_bgImg2.y = 179;
			addChild(_bgImg2);
			
			_bgImg3 = new Bitmap();
			_bgImg3.x = 321;
			_bgImg3.y = 182;
			addChild(_bgImg3);
			
			_targetType = new TargetType(_currentType);
			_targetType.move(0,0);
			addChild(_targetType);
			
			_completeTarget = new CompleteTarget(_currentType);
			_completeTarget.move(7,184);
			addChild(_completeTarget);
			
			_targetReward = new TargetReward(_currentType);
			_targetReward.move(365,210);
			addChild(_targetReward);
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			TargetListUpdateSocketHandler.send();
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
		}
		
		private function setIndexSelectType():int
		{
			var index:int = -1;
			for(var i:int=0; i< _typeNum;i++)
			{
				if(TargetUtils.getTabEnabled(i) && TargetUtils.getTargetCompleteNum(i) > 0)
				{
					index = i;
					break;
				}
			}
			if(index == -1)
			{
				index = TargetUtils.getTarType(); 
			}
			return index;
		}
		
		
		
		public function move(x:Number, y:Number):void
		{
			// TODO Auto Generated method stub
			this.x = x;
			this.y = y;
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
		}
		
		
		public function assetsCompleteHandler():void
		{
			_bgImg1.bitmapData = AssetUtil.getAsset("ssztui.target.BgTargetAsset1",BitmapData) as BitmapData;
			_bgImg2.bitmapData = AssetUtil.getAsset("ssztui.target.BgTargetAsset2",BitmapData) as BitmapData;
			_bgImg3.bitmapData = AssetUtil.getAsset("ssztui.target.BgTargetAsset3",BitmapData) as BitmapData;
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
			clearData();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgImg1 && _bgImg1.bitmapData)
			{
				_bgImg1.bitmapData.dispose();
				_bgImg1 = null;
			}
			if(_bgImg2 && _bgImg2.bitmapData)
			{
				_bgImg2.bitmapData.dispose();
				_bgImg2 = null;
			}
			if(_bgImg3 && _bgImg3.bitmapData)
			{
				_bgImg3.bitmapData.dispose();
				_bgImg3 = null;
			}
			if(_targetType)
			{
				_targetType.dispose();
				_targetType = null;
			}
			if(_completeTarget)
			{
				_completeTarget.dispose();
				_completeTarget = null;
			}
			if(_targetReward)
			{
				_targetReward.dispose();
				_targetReward = null;
			}
			
		}
	}
}