package sszt.target.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.target.TagNeedTargetAsset;
	
	/**
	 * 需要完成目标 
	 * @author chendong
	 */	
	public class CompleteTarget extends Sprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		
		private var _targetList:Array;
		private var _tile2:MTile;
		
		private var _amount:MAssetLabel;
		
		/**
		 * 当前选择的目标类型 
		 */
		private var _currentType:int
		
		public function CompleteTarget(currentType:int=1)
		{
			super();
			_currentType = currentType;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(0,0,326,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(120,5,102,16),new Bitmap(new TagNeedTargetAsset())),
			]); 
			addChild(_bg as DisplayObject);
			
			_amount = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.RIGHT);
			_amount.move(290,12);
			_amount.textColor = 0xc7ab6f;
//			addChild(_amount);
//			_amount.setHtmlValue("完成数量：1/25");
			
			_targetList = [];
			_tile2 = new MTile(327,26,1);
			_tile2.setSize(327,162);
			_tile2.move(0,29);
			_tile2.itemGapH = 1;
			_tile2.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile2.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tile2.verticalScrollPosition = 24;
			addChild(_tile2);
		}
		
		public function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.CLICK_TARGET_TYPE,clickTargetType);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardCom);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListTCom);
		}
		
		public function initData():void
		{
			clearData();
			var targetArray:Array = [];
			var targetInfo:TargetTemplatInfo;
			var targetView:TargetItemView;
			targetArray = TargetUtils.getTargetArray(_currentType);
			var doneNum:int = 0;
			for each (targetInfo in targetArray)
			{
				targetView = new TargetItemView(targetInfo);
				targetView.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_tile2.appendItem(targetView);
				_targetList.push(targetView);
				
				if(GlobalData.targetInfo.targetByIdDic[targetInfo.target_id]) doneNum ++;
			}
			if(_targetList.length > 0)
			{
				TargetItemView(_targetList[0]).select = true;
			}
			_amount.setHtmlValue(LanguageManager.getWord("ssztl.common.finishLabel") + "：" + doneNum + "/" + targetArray.length);
		}
		
		
//		private function getTargetArray(currentType:int):Array
//		{
//			var targetArray:Array = [];
//			var targetInfo:TargetTemplatInfo;
//			var targetTemplateArray:Array = TargetUtils.getTargetTemplateData(currentType);
//			var targetData:TargetData = null;
//			//完成未领取
//			for each (targetInfo in targetTemplateArray)
//			{
//				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
//				if(targetData && targetData.isFinish && !targetData.isReceive)
//				{
//					targetArray.push(targetInfo);
//				}
//			}
//			
//			//在完成过程当中
//			for each (targetInfo in targetTemplateArray)
//			{
//				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
//				if(targetData && !targetData.isFinish && !targetData.isReceive)
//				{
//					targetArray.push(targetInfo);
//				}
//			}
//			
//			//未完成未领取
//			for each (targetInfo in targetTemplateArray)
//			{
//				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
//				if(!targetData)
//				{
//					targetArray.push(targetInfo);
//				}
//			}
//			
//			//完成已领取
//			for each (targetInfo in targetTemplateArray)
//			{
//				targetData = GlobalData.targetInfo.targetByIdDic[targetInfo.target_id];
//				if(targetData && targetData.isFinish && targetData.isReceive)
//				{
//					targetArray.push(targetInfo);
//				}
//			}
//			return targetArray;
//		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			curItemChange(evt.currentTarget as TargetItemView);
		}
		
		private function clickTargetType(evt:ModuleEvent):void
		{
			_currentType = int(evt.data.type);
			initData()
		}
		
		private function getTargetAwardCom(evt:ModuleEvent):void
		{
			if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == TargetUtils.TARGET_TYPE)
			{
				initData();
			}
		}
		
		private function updateTargetListTCom(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function curItemChange(item:TargetItemView):void
		{
			item.select = true;
			ModuleEventDispatcher.dispatchModuleEvent(new TargetMediaEvents(TargetMediaEvents.CLICK_TARGET,{item:item._info}));
		}
		
		public function removeEvent():void
		{
			var i:int=0;
			for(;i<_targetList.length;i++)
			{
				_targetList[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
			}
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.CLICK_TARGET_TYPE,clickTargetType);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardCom);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListTCom);
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
			var i:int = 0;
			if (_targetList)
			{
				i = 0;
				while (i < _targetList.length)
				{
					
					_targetList[i].dispose();
					i++;
				}
				_targetList = [];
			}
			if(_tile2)
			{
				_tile2.disposeItems()
			}
			
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function dispose():void
		{
			removeEvent();
		}
		
	}
}