package sszt.target.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToTargetData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.target.TargetUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.AmountFlashView;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.target.events.AchievementEvent;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	
	/**
	 * 成就分类,成就总览,任务、神器、角色、骑宠、战场 
	 * @author chendong
	 * 
	 */	
	public class AchLeft extends Sprite implements IPanel
	{
		private var _cellList:Array;
		private var _tile:MTile;
		private var _PAGESIZE:int = 5;
		/**
		 * 当前选择的目标类型 0：成就总览，1：任务成就,2:神器成就,3：角色成就,4:骑宠成就,5:战场成就
		 */
		private var _currentType:int = -1;
		private var _index:int;
		
		private var _btnNameArray:Array = [LanguageManager.getWord("ssztl.target.achT"),LanguageManager.getWord("ssztl.target.ach1"),
			LanguageManager.getWord("ssztl.target.ach2"),LanguageManager.getWord("ssztl.target.ach3"),
			LanguageManager.getWord("ssztl.target.ach4"),LanguageManager.getWord("ssztl.target.ach5"),
			LanguageManager.getWord("ssztl.target.ach6"),LanguageManager.getWord("ssztl.target.ach7"),
			LanguageManager.getWord("ssztl.target.ach8")];
		private var _amount:Array;
		
		private var _toTD:ToTargetData;
		
		public function AchLeft(toTD:ToTargetData)
		{
			super();
			_toTD = toTD;
			_index = _toTD.typeIndex;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_tile = new MTile(114,30,1);
			_tile.itemGapW = 0;
			_tile.itemGapH = 1;
			_tile.setSize(114,377);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addChild(_tile);
			
			_cellList = [];
			_amount = [];
			var btn:MCacheTabBtn1;
			for(var i:int = 0;i< _btnNameArray.length;i++)
			{
				btn = new MCacheTabBtn1(2,1,_btnNameArray[i]);
				_tile.appendItem(btn);
				_cellList.push(btn);
				
				if(i != 0)
				{
					var amt:AmountFlashView = new AmountFlashView();
					amt.move(2,i*31+7);
					addChild(amt);
					_amount.push(amt);
					amt.visible = false;
					if(TargetUtils.getAchCompleteNum(i) > 0)
					{
						amt.visible = true;
						amt.setValue(TargetUtils.getAchCompleteNum(i).toString());
					}
				}
			}
			setIndex(_index);
		}
		
		private function setIndex(index:int):void
		{
			if(_currentType == index)return;
			if(_currentType > -1)
			{
				_cellList[_currentType].selected = false;
			}
			_currentType = index;
			_cellList[_currentType].selected = true;
		}
		
		public function initEvent():void
		{
			var i:int=0;
			for(;i<_cellList.length;i++)
			{
				_cellList[i].addEventListener(MouseEvent.CLICK,handleClick);
			}
			
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getAchAwardAchLe);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListAch);
		}
		
		public function initData():void
		{
		}
		
		private function handleClick(evt:MouseEvent):void
		{
			var index:int = _cellList.indexOf(evt.currentTarget as MCacheTabBtn1);
			setIndex(index);
			ModuleEventDispatcher.dispatchModuleEvent(new AchievementEvent(AchievementEvent.SELECT_ACH_TYPE_BTN,{type:index}));
		}
		
		private function getAchAwardAchLe(evt:ModuleEvent):void
		{
			if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == TargetUtils.ACH_TYPE)
			{
				updateData();
			}
		}
		
		private function updateTargetListAch(evt:ModuleEvent):void
		{
			updateData();
		}
		
		private function updateData():void
		{
			for(var i:int = 1;i<= _amount.length;i++)
			{
				if(TargetUtils.getAchCompleteNum(i) > 0)
				{
					_amount[(i-1)].visible = true;
					_amount[(i-1)].setValue(TargetUtils.getAchCompleteNum(i).toString());
				}
				else
				{
					_amount[(i-1)].visible = false;
				}
			}
		}
		
		public function clearData():void
		{
		}
		
		public function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getAchAwardAchLe);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetListAch);
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