package sszt.consign.components.searchItemTypeView
{
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import sszt.ui.container.MScrollPanel;
	
	import sszt.consign.components.SearchConsignPanel;
	import sszt.consign.components.searchItemTypeView.data.CAccordionGroupData;
	import sszt.consign.mediator.ConsignMediator;
	
	public class CAccordion extends MScrollPanel
	{
		private var _showMutil:Boolean;
//		private var _groups:Vector.<CAccordionGroupView>;
		private var _groups:Array;
		/**
		 * IAccordionGroupData
		 */		
		protected var _groupDatas:Array;
		private var _tmpWidth:int;
		private var _showItemCount:int;
		private var _currentGroup:CAccordionGroupView;
		
		private var _groupSpace:int = 2;
		private var _consigMediator:ConsignMediator;
		public function CAccordion(data:Array,argConsigMediator:ConsignMediator,width:int,showItemCount:int = 5,showMutil:Boolean = false)
		{
			_showMutil = showMutil;
			_groupDatas = data;
			_tmpWidth = width;
			_showItemCount = showItemCount;
//			_groupSpace = 2;
			_consigMediator = argConsigMediator;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.ON;
//			_groups = new Vector.<CAccordionGroupView>();
			_groups = [];
			for each(var i:CAccordionGroupData in _groupDatas)
			{
				var group:CAccordionGroupView = createGroup(i);
				_groups.push(group);
				getContainer().addChild(group as DisplayObject);
				group.addEventListener(CAccordionGroupView.SELECT_CHANGE,selectedChangeHandler);
				group.addEventListener(CAccordionGroupView.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
			}
		}
		
		protected function createGroup(data:CAccordionGroupData):CAccordionGroupView
		{
			return new CAccordionGroupView(data.title,data.accordionItemDataVector,_tmpWidth,_showItemCount,_consigMediator);
		}
		
		private function selectedChangeHandler(evt:Event):void
		{
			var tmpView:CAccordionGroupView = evt.currentTarget as CAccordionGroupView;
			if(!_showMutil)
			{
				if(_currentGroup)
				{
					if(tmpView == _currentGroup)
					{
						_currentGroup.selected = !_currentGroup.selected;
					}
					else
					{
						_currentGroup.selected = false;
						_currentGroup = tmpView;
						_currentGroup.selected = true;
					}
				}
				else
				{
					_currentGroup = tmpView;
					_currentGroup.selected = true;
				}
			}
			else
			{
				_currentGroup = evt.currentTarget as CAccordionGroupView;
				_currentGroup.selected = !_currentGroup.selected;
			}
			invalidate(InvalidationType.STATE);
		}
		
		private function itemSelectedChangeHandler(evt:Event):void
		{
			var tmpView:CAccordionGroupView = evt.currentTarget as CAccordionGroupView;
			_currentGroup = tmpView;
			for each(var i:CAccordionGroupView in _groups)
			{
				if(i != tmpView && i.currentItem)
				{
					i.currentItem.selected = false;
				}
			}
			
			_consigMediator.module.consignPanel.selectItemChange(_currentGroup.currentItem.info.itemCategoryIdVector);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STATE))
			{
				var currentHeight:int = 0;
				for each(var i:CAccordionGroupView in _groups)
				{
					i.y = currentHeight;
					currentHeight += i.height + _groupSpace;
				}
				update(_width,currentHeight + 10);
			}
			super.draw();
		}
		
		public function get currentGroup():CAccordionGroupView
		{
			return _currentGroup;
		}
		
		override public function dispose():void
		{
			_consigMediator = null;
			for each(var i:CAccordionGroupView  in _groups)
			{
				i.removeEventListener(CAccordionGroupView.SELECT_CHANGE,selectedChangeHandler);
				i.removeEventListener(CAccordionGroupView.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
				i.dispose();
				i = null;
			}
			_groups = null;
			_groupDatas = null;
//			if(_currentGroup)
//			{
//				_currentGroup.removeEventListener(CAccordionGroupView.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
//				_currentGroup.removeEventListener(CAccordionGroupView.SELECT_CHANGE,selectedChangeHandler);
//				_currentGroup.dispose();
//				_currentGroup = null;
//			}
			_currentGroup = null;
			super.dispose();
		}
	}
}