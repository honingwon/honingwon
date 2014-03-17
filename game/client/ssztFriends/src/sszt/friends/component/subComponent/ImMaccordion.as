package sszt.friends.component.subComponent
{
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MScrollPanel;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.FriendEvent;
	import sszt.core.data.im.GroupItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.friends.mediator.FriendsMediator;
	
	public class ImMaccordion extends MScrollPanel
	{
		private var _showMutil:Boolean;
//		private var _groups:Vector.<ImAccordionGroup>;
		private var _groups:Array;
		protected var _groupDatas:Array;
		private var _tmpWidth:int;
		private var _showItemCount:int;
		private var _currentGroup:ImAccordionGroup;
		private var _mediator:FriendsMediator;
		
		protected var _groupSpace:int;
		
		public function ImMaccordion(mediator:FriendsMediator,data:Array,width:int,showItemCount:int = 5,showMutil:Boolean = false)
		{
			_mediator = mediator;
			_showMutil = showMutil;
			_groupDatas = data;
			_tmpWidth = width;
			_showItemCount = showItemCount;
			_groupSpace = 2;
			super();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.AUTO;
//			_groups = new Vector.<ImAccordionGroup>();
			_groups = new Array();
			for each(var i:ImAccordionGroupData in _groupDatas)
			{
				var group:ImAccordionGroup = createGroup(i);
				_groups.push(group);
				getContainer().addChild(group as DisplayObject);
				group.addEventListener(ImAccordionGroup.SELECT_CHANGE,selectedChangeHandler);
				group.addEventListener(ImAccordionGroup.ITEM_CHANGE,itemChangeHandler);
			}
		}
		
		private function initEvent():void
		{
			GlobalData.imPlayList.addEventListener(FriendEvent.ADD_GROUP,addGroupHandler);
			GlobalData.imPlayList.addEventListener(FriendEvent.DELETE_GROUP,deleteGroupHandler);
			GlobalData.imPlayList.addEventListener(FriendEvent.GROUP_RENAME,groupRenameHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.imPlayList.removeEventListener(FriendEvent.ADD_GROUP,addGroupHandler);
			GlobalData.imPlayList.removeEventListener(FriendEvent.DELETE_GROUP,deleteGroupHandler);
			GlobalData.imPlayList.removeEventListener(FriendEvent.GROUP_RENAME,groupRenameHandler);
		}
		
		private function groupRenameHandler(evt:FriendEvent):void
		{
			var group:GroupItemInfo = evt.data as GroupItemInfo;
			for(var i:int = 0;i<_groups.length;i++)
			{
				if(_groups[i].getID() == group.gId)
				{
					_groups[i].changeTitle(group.gName);
					invalidate(InvalidationType.STATE);
					break;
				}
			}
		}
		
		private function addGroupHandler(evt:FriendEvent):void
		{
			var data:GroupItemInfo = evt.data as GroupItemInfo;
			var groupData:ImAccordionGroupData = new ImAccordionGroupData(data.gId,data.gName,new Dictionary());
			var group:ImAccordionGroup = createGroup(groupData);
			sortGroup(group);
			getContainer().addChild(group as DisplayObject);
			group.addEventListener(ImAccordionGroup.SELECT_CHANGE,selectedChangeHandler);
			group.addEventListener(ImAccordionGroup.ITEM_CHANGE,itemChangeHandler);
			invalidate(InvalidationType.STATE);	
			QuickTips.show(LanguageManager.getWord("ssztl.friends.addGroupSuccess"));
		}
		
		private function sortGroup(group:ImAccordionGroup):void
		{
//			var tempVector:Vector.<ImAccordionGroup> = _groups.splice(_groups.length-4,4);
			var tempVector:Array = _groups.splice(_groups.length-4,4);
			_groups.push(group);
			for(var i:int = 0;i<4;i++)
			{
				_groups.push(tempVector[i]);
			}
		}
		
		private function deleteGroupHandler(evt:FriendEvent):void
		{
			var index:int = evt.data as Number;
			for(var i:int =0;i<_groups.length;i++)
			{
				if(index == _groups[i].getID())
				{
					getContainer().removeChild(_groups[i]);
					_groups.splice(i,1);
					invalidate(InvalidationType.STATE);
					break;
				}
			}
		}
		
		protected function createGroup(data:ImAccordionGroupData):ImAccordionGroup
		{
			return new ImAccordionGroup(data.getId(),_mediator,data.getImAccordionGroupTitle(),data.getImAccordionGroupData(),_tmpWidth,_showItemCount);
		}
		
		private function itemChangeHandler(evt:Event):void
		{
			invalidate(InvalidationType.STATE);
		}
		
		private function selectedChangeHandler(evt:Event):void
		{
			if(!_showMutil)
			{
				if(_currentGroup)
				{
					_currentGroup.selected = false;
				}
				_currentGroup = evt.currentTarget as ImAccordionGroup;
				_currentGroup.selected = true;
			}
			else
			{
				_currentGroup = evt.currentTarget as ImAccordionGroup;
				_currentGroup.selected = !_currentGroup.selected;
			}
			invalidate(InvalidationType.STATE);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STATE))
			{
				var currentHeight:int = 0;
				for each(var i:ImAccordionGroup in _groups)
				{
					i.y = currentHeight;
					currentHeight += i.height + _groupSpace;
				}
				update(_width,currentHeight);
			}
			super.draw();
		}
		
		override public function dispose():void
		{
			removeEvent();
			for(var i:int = 0;i<_groups.length;i++) 
			{
				_groups[i].dispose();
			}
			_groups = null;
			_groupDatas = null;
			_mediator = null;
			_currentGroup = null;
			super.dispose();
		}
	}
}