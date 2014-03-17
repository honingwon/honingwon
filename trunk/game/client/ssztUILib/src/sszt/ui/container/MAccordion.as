/**
 * 修改：王鸿源(honingwon@gmail.com)
 * 时间：2012-11-22
 */
package sszt.ui.container
{
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import sszt.ui.container.accordionItems.AccordionGroup;
	import sszt.ui.container.accordionItems.AccordionGroupItemView;
	import sszt.ui.container.accordionItems.IAccordionGroupData;
	import sszt.ui.container.accordionItems.IAccordionItemData;

	public class MAccordion extends MScrollPanel
	{
		public static const ITEM_SELECT:String = "itemSelect";
		protected const _groupSpace:int = 2;
		
		/**
		 * IAccordionGroupData类型
		 */	
		protected var _groupDatas:Array;
		protected var _tmpWidth:int;
		protected var _showItemCount:int;
		private var _isShowMutil:Boolean;
		protected var _isShowTitleBg:Boolean;
		protected var _isShowItemSelectedBg:Boolean;
		
		/**
		 * 项目组，AccordionGroup类型。
		 */
		private var _groups:Array;
		/**
		 * 当前项目组
		 */
		private var _currentGroup:AccordionGroup;
		/**
		 * 选中项数据源
		 */
		private var _selectedItemData:IAccordionItemData;
		
		/**
		 * 手风琴组件
		 * @param data 数据源
		 * @param width 每个项目组的宽度
		 * @param showItemCount 项目组个数，默认为5个。
		 * @param isShowMutil 是否支持同时显示多个项目组，默认不支持。
		 * @param isShowTitleBg 标题是否显示背景，默认显示。
		 * @param isShowItemSelectedBg 选中项是否显示背景，默认显示。
		 * 
		 * @todo 支持同时显示多个项目组时，同时只有一个项显示背景
		 */
		public function MAccordion(data:Array, width:int, showItemCount:int = 5, isShowMutil:Boolean = false, isShowTitleBg:Boolean = true, isShowItemSelectedBg:Boolean = true)
		{
			_groupDatas = data;
			_tmpWidth = width;
			_showItemCount = showItemCount;
			_isShowMutil = isShowMutil;
			_isShowTitleBg = isShowTitleBg;
			_isShowItemSelectedBg = isShowItemSelectedBg;
			
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			_groups = [];
			for each(var groupData:IAccordionGroupData in _groupDatas)
			{
				var group:AccordionGroup = createGroup(groupData);
				_groups.push(group);
				getContainer().addChild(group);
				group.addEventListener(AccordionGroup.SELECT_CHANGE,selectedChangeHandler);
				group.addEventListener(AccordionGroup.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
			}
		}
		
		protected function createGroup(data:IAccordionGroupData):AccordionGroup
		{
			return new AccordionGroup(data.getTitleString(), data.getItemDatas(), _tmpWidth, _showItemCount, _isShowTitleBg, _isShowItemSelectedBg);
		}
		
		/**
		 * ?
		 */
		public function appendItem(index:int, data:IAccordionItemData):void
		{
			if(_groups && _groups[index])
			{
				_groups[index].appendItem(data);
				invalidate(InvalidationType.STATE);
			}
		}
		
		public function removeItem(index:int,item:AccordionGroupItemView):void
		{
			if(_groups && _groups[index])
			{
				_groups[index].removeItem(item);
				invalidate(InvalidationType.STATE);
			}
		}
		
		public function clearItems():void
		{
			for each(var group:AccordionGroup in _groups)
			{
				group.clearItems();
			}
			invalidate(InvalidationType.STATE);
		}
		
		private function selectedChangeHandler(evt:Event):void
		{
			if(!_isShowMutil)
			{
				if(_currentGroup)
				{
					_currentGroup.selected = false;
					_currentGroup.setCurrentItemSelected(false);
				}
				_currentGroup = evt.currentTarget as AccordionGroup;
				_currentGroup.selected = true;
			}
			else
			{
				_currentGroup = evt.currentTarget as AccordionGroup;
				//反转selected
				_currentGroup.selected = !_currentGroup.selected;
			}
			invalidate(InvalidationType.STATE);
		}
		
		private function itemSelectedChangeHandler(e:Event):void
		{
			_selectedItemData = _currentGroup.selectedItemData;
			dispatchEvent(new Event(MAccordion.ITEM_SELECT));
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STATE))
			{
				var currentHeight:int = 0;
				for each(var i:AccordionGroup in _groups)
				{
					i.y = currentHeight;
					currentHeight += i.height + _groupSpace;
				}
				update(_width,currentHeight);
			}
			super.draw();
		}
		
		public function setSelectedGroup(index:int):void
		{
			if(!_isShowMutil)
			{
				if(_currentGroup)
				{
					_currentGroup.selected = false;
					_currentGroup.setCurrentItemSelected(false);
				}
				_currentGroup = _groups[index];
				if(_currentGroup)
				{
					_currentGroup.selected = true;
					_currentGroup.setCurrentItemSelected(true);
				}
			}
			else
			{
				_currentGroup = _groups[index];
				_currentGroup.selected = !_currentGroup.selected;
			}
			invalidate(InvalidationType.STATE);
		}
		
		public function get selectedItemData():IAccordionItemData
		{
			return _selectedItemData;
		}
		
		public function get selectedItem():AccordionGroupItemView
		{
			return _currentGroup.selectedItem;
		}
		
		override public function dispose():void
		{
			for each(var i:AccordionGroup in _groups)
			{
				i.removeEventListener(AccordionGroup.SELECT_CHANGE,selectedChangeHandler);
				i.removeEventListener(AccordionGroup.ITEM_SELECT_CHANGE,itemSelectedChangeHandler);
				i.dispose();
			}
			_groups = null;
			_groupDatas = null;
			_currentGroup = null;
			_selectedItemData = null;
			super.dispose();
		}
	}
}