package sszt.activity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	import sszt.activity.components.cell.WelfFareCell;
	import sszt.activity.components.itemView.FirstChargeItemView;
	import sszt.activity.components.itemView.LuckItemView;
	import sszt.activity.components.itemView.WelfareItemView;
	import sszt.activity.data.GiftType;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.WelfareTemplateInfo;
	import sszt.core.data.activity.WelfareTemplateInfoList;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class WelfareTabPanel extends Sprite implements IActivityTabPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:ActivityMediator;
		private var _mTile:MTile;
		private var _list:Array;
		
		public function WelfareTabPanel(argMediator:ActivityMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initEvent();
			_mediator.loadData();
		}
		
		private function initialView():void
		{
			_mTile = new MTile(291,100);
			_mTile.setSize(612,340);
			_mTile.move(0,0);
			addChild(_mTile);
			_mTile.itemGapH = 3;
			_mTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_mTile.verticalScrollPolicy = ScrollPolicy.ON;
			_list = [];
		}
		
		private function initEvent():void
		{
			_mediator.moduel.activityInfo.addEventListener(ActivityInfoEvents.LOAD_COMPLETE,loadCompleteHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.moduel.activityInfo.removeEventListener(ActivityInfoEvents.LOAD_COMPLETE,loadCompleteHandler);
		}
		
		private function loadCompleteHandler(evt:ActivityInfoEvents):void
		{
			var list:Array = _mediator.moduel.activityInfo.giftList;
			for(var i:int = 0;i<list.length;i++)
			{
				if(list[i].canShow())
				{
					if(list[i].type == GiftType.FIRST_CHARGE_GIFT)
					{
						var item1:FirstChargeItemView = new FirstChargeItemView(list[i],_mediator);
						_mTile.appendItem(item1);
					}
					else if(list[i].type == GiftType.NEW_PLAYER_GIFT)
					{
						var item2:WelfareItemView = new WelfareItemView(list[i],_mediator);
						_mTile.appendItem(item2);
					}else
					{
						var item3:LuckItemView = new LuckItemView(list[i],_mediator);
						_mTile.appendItem(item3);
					}
				}
			}
		}
		
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_list)
			{
				for(var i:int = 0;i<_list.length;i++)
				{
					_list[i].dispose();
				}
				_list = null;
			}
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}