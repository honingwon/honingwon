package sszt.friends.component.subComponent
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.BasePlayerInfo;
	import sszt.core.view.tips.BaseMenuTip;
	import sszt.core.view.tips.MenuItem;
	import sszt.friends.mediator.FriendsMediator;
	
	public class SearchBox extends BaseMenuTip
	{
		private static var instance:SearchBox;
		private var _mediator:FriendsMediator;
		private var _timeoutIndex:int = -1;
		
//		private var _results:Vector.<String>;
//		private var _ids:Vector.<Number>;
		private var _results:Array;
		private var _ids:Array;
		
		public function SearchBox()
		{
			super();
//			_results = new Vector.<String>();
			_results = [];
		}
		
		public static function getInstance():SearchBox
		{
			if(instance == null)
			{
				instance = new SearchBox();
			}
			return instance;
		}
		
//		public function show(ids:Vector.<Number>,mediator:FriendsMediator,pos:Point):void
		public function show(ids:Array,mediator:FriendsMediator,pos:Point):void
		{
			_ids = ids;
			_mediator = mediator;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:SearchBox = this;
			function showHandler():void
			{
				var labels:Array = new Array();
				var ids:Array = new Array();
				for(var i:int = 0;i<_ids.length;i++)
				{
					var info:BasePlayerInfo = GlobalData.imPlayList.getFriend(_ids[i]).info;
					var str:String = "[" + info.serverId + "]" + info.nick;
					labels.push(str);
					ids.push(i);
					_results.push(str);
				}
				setLabels(labels,ids);
				setPos(pos);
				GlobalAPI.layerManager.getTipLayer().addChild(tmp);		
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function setPos(pos:Point):void
		{
			if(_bg.height + pos.y > CommonConfig.GAME_HEIGHT)
				this.y =  pos.y - _bg.height;
			else
				this.y = pos.y;
			if(_bg.width + pos.x >CommonConfig.GAME_WIDTH)
				this.x = pos.x - _bg.width;
			else
				this.x = pos.x;
		}
		
		override protected function clickHandler(evt:MouseEvent):void
		{
			var item:MenuItem = evt.currentTarget as MenuItem;
			for(var i:int = 0;i<_results.length;i++)
			{
				if(item.label == _results[i])
				{
					_mediator.showChatPanel(0,_ids[i],1);
					break;
				}		
			}
//			_results = new Vector.<String>();
			_results = [];
		}
		
		
	}
}