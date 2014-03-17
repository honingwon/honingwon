package sszt.target.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
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
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.target.TargetTabAsset1;
	import ssztui.target.TargetTabAsset2;
	import ssztui.target.TargetTabAsset3;
	import ssztui.target.TargetTabAsset4;
	import ssztui.target.TargetTabAsset5;
	
	/**
	 * 目标种类，1-30级，30-50级，50-60级，60-70级，70-80级 
	 * @author chendong
	 */	
	public class TargetType extends Sprite implements IPanel
	{
		private var _tabList:Array;
		/**
		 * 目标类型数量 
		 */
		private var _typeNum:Array;
		/**
		 * 目标完成情况
		 */
		private var _typeDone:Array;
		/**
		 * 当前选择的目标类型 
		 */
		private var _currentType:int = -1;
		private var _index:int;
		
		/**
		 * 目标类型 
		 */
		public var _targetTypePic:Cell;
		
		public function TargetType(currentType:int=0)
		{
			super();
			_index = currentType
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			                     //1-30级                               31-50级                            51-60级                                61-70级                              71-80级
			var tabClass:Array = [TargetTabAsset1,TargetTabAsset2,TargetTabAsset3,TargetTabAsset4,TargetTabAsset5];
			var tabFix:Array = [new Point(21,23)];
			_tabList = [];
			_typeNum = [];
			_typeDone = [];
			for(var i:int =0; i<tabClass.length; i++)
			{
				var tab:MSelectButton = new MSelectButton(new tabClass[i]());
				tab.move(27+i*82,6);
				tab.enabled = TargetUtils.getTabEnabled(i);
				addChild(tab);
				_tabList.push(tab);
				
				var mlb:AmountFlashView = new AmountFlashView();
				mlb.move(57+i*82,17);
				addChild(mlb);
				if(TargetUtils.getTabEnabled(i) && TargetUtils.getTargetCompleteNum(i) > 0)
				{
					mlb.visible = true;
					mlb.setValue(TargetUtils.getTargetCompleteNum(i).toString());
				}
				else
				{
					mlb.visible = false; 
				}
				_typeNum.push(mlb);
				
				var done:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
				done.textColor = 0xc6a86c;
				done.move(66+i*82,143);
				addChild(done);
				if(TargetUtils.getTabEnabled(i))
				{
					done.visible = true;
					done.setValue(TargetUtils.getTargetCompletedNum(i).toString()+"/"+TargetUtils.getTargetTotalNum(i).toString());
				}
				else
				{
					done.visible = false; 
				}
				_typeDone.push(done);
			}
			
			setIndex(_index);
		}
		
		
		private function setIndex(index:int):void
		{
			if(_currentType == index)return;
			if(_currentType > -1)
			{
				_tabList[_currentType].selected = false;
			}
			_currentType = index;
			_tabList[_currentType].selected = true;
			if(TargetUtils.getTabEnabled(_currentType) && TargetUtils.getTargetCompleteNum(_currentType) > 0)
			{
				_typeNum[_currentType].visible = true;
				_typeNum[_currentType].setValue(TargetUtils.getTargetCompleteNum(_currentType));
			}
			else
			{
				_typeNum[_currentType].visible = false;
			}
			_typeDone[_currentType].visible = true;
			_typeDone[_currentType].setValue(TargetUtils.getTargetCompletedNum(_currentType).toString()+"/"+TargetUtils.getTargetTotalNum(_currentType).toString());
		}
				
		public function initData():void
		{
		}
		
		
		private function clickTarget(evt:MouseEvent):void
		{
			var index:int = _tabList.indexOf(evt.currentTarget as MSelectButton);
			setIndex(index);
			initData();
			ModuleEventDispatcher.dispatchModuleEvent(new TargetMediaEvents(TargetMediaEvents.CLICK_TARGET_TYPE,{type:index}));
		}
		
		private function clickTargetType(evt:ModuleEvent):void
		{
			
		}
		
		public function clearData():void
		{
		}
		
		public function initEvent():void
		{
			var i:int=0;
			for(;i<_tabList.length;i++)
			{
				_tabList[i].addEventListener(MouseEvent.CLICK,clickTarget);
			}
			
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardTAR);
		}
		
		private function getTargetAwardTAR(evt:ModuleEvent):void
		{
			var i:int =0
			if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == TargetUtils.TARGET_TYPE)
			{
				for(; i<_typeNum.length; i++)
				{
					if(TargetUtils.getTabEnabled(i) && TargetUtils.getTargetCompleteNum(i) > 0)
					{
						_typeNum[i].visible = true;
						_typeNum[i].setValue(TargetUtils.getTargetCompleteNum(i).toString());
					}
					else
					{
						_typeNum[i].visible = false;
					}
				}
				i = 0;
				for(; i<_typeDone.length; i++)
				{
					if(TargetUtils.getTabEnabled(i))
					{
						_typeDone[i].visible = true;
						_typeDone[i].setValue(TargetUtils.getTargetCompletedNum(i).toString()+"/"+TargetUtils.getTargetTotalNum(i).toString());
					}
					else
					{
						_typeDone[i].visible = false;
					}
				}
			}
		}
		
		public function removeEvent():void
		{
			var i:int=0;
			for(;i<_tabList.length;i++)
			{
				_tabList[i].removeEventListener(MouseEvent.CLICK,clickTarget);
			}
			
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardTAR);
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