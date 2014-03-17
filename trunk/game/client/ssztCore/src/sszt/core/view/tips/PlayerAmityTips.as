package sszt.core.view.tips
{
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.GroupType;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.manager.LanguageManager;

	public class PlayerAmityTips extends BaseMenuTip
	{
		private var serverId:int;
		private var id:Number;
		private var gid:Number;
		private var nick:String;
		private static var instance:PlayerAmityTips;
		private var _timeoutIndex:int = -1;
		
		public function PlayerAmityTips()
		{
			
		}
		
		public static function getInstance():PlayerAmityTips
		{
			if(instance == null)
			{
				instance = new PlayerAmityTips();
			}
			return instance;
		}
		
		public function show(serverId:int,id:Number,nick:String,pos:Point):void
		{
			this.serverId = serverId;
			this.id = id;
			this.nick = nick;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:PlayerAmityTips = this;
			function showHandler():void
			{
				var player:ImPlayerInfo = GlobalData.imPlayList.getPlayer(id);
				var labels:Array = new Array();
				var ids:Array = [];
				labels.push("等级:"+player.info.level);
				labels.push("好友度:"+player.amity);
				labels.push("好友度等级:10");
				ids.push(1,2,3);
				setLabels(labels,ids);
				GlobalAPI.layerManager.getTipLayer().addChild(tmp);
				setPos(pos);
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
		
		override protected function initEvent():void
		{
			super.initEvent();
		}
	}
}