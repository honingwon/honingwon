package sszt.core.view.tips
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.ClubInviteSocketHandler;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.FriendModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class RankPlayerTip extends BaseMenuTip
	{
		private var serverId:int;
		private var id:Number;
		private var nick:String;
		private var _timeoutIndex:int = -1;
		
		private static var instance:RankPlayerTip;
		
		public function RankPlayerTip()
		{
			super();
		}
		
		public static function getInstance():RankPlayerTip
		{
			if(instance == null)
			{
				instance = new RankPlayerTip();
			}
			return instance;
		}
		
		public function show(serverId:int,id:Number,nick:String,pos:Point):void
		{
			this.serverId = serverId;
			this.id = id;
			this.nick = nick;
			var tip:RankPlayerTip = this;
			_timeoutIndex = setTimeout(showHandler,50);
			function showHandler():void
			{
//				var labels:Array = ["发送聊天","邀请队伍","邀请帮会","添加好友","发送邮件","发起交易","拜入师门","招收徒弟","查看资料","复制名字","添加黑名单","个人中心"];
				var labels:Array = [
					LanguageManager.getWord("ssztl.common.sendChat"),
					LanguageManager.getWord("ssztl.common.inviteTeam"),
					LanguageManager.getWord("ssztl.common.inviteClub"),
					LanguageManager.getWord("ssztl.friends.addFriend"),
					LanguageManager.getWord("ssztl.mail.sendMail"),
					LanguageManager.getWord("ssztl.common.inviteExchange"),
					LanguageManager.getWord("ssztl.common.baiRuShiMen"),
					LanguageManager.getWord("ssztl.common.zhaoShouTuDi"),
					LanguageManager.getWord("ssztl.common.checkInfo"),
					LanguageManager.getWord("ssztl.common.copyName"),
					LanguageManager.getWord("ssztl.common.addToBlack"),
					LanguageManager.getWord("ssztl.common.personalCenter")];
				var ids:Array = [1,2,3,4,5,6,7,8,9,10,11,12];
				setLabels(labels,ids);
				
				setPos(pos);
				GlobalAPI.layerManager.getTipLayer().addChild(tip);
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
			switch (item.id)
			{
				case 1:
					ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:serverId,id:id,nick:nick,flag:1}));
					break;
				case 2:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:0,id:id,nick:nick,serverId:serverId}));
					break;
				case 3:
					ClubInviteSocketHandler.send(serverId,nick);
					break;
				case 4:
					FriendUpdateSocketHandler.sendAddFriend(serverId,nick,true);
					break;
				case 5:
					SetModuleUtils.addMail(new ToMailData(true,serverId,nick));
					break;
				case 6:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SEND_TRADEDIRECT,id));
					break;
				case 7:
					break;
				case 8:
					break;
				case 9:
					SetModuleUtils.addRole(id);
					break;
				case 10:
					System.setClipboard(nick)
					break;
				case 11:
					FriendUpdateSocketHandler.sendAddFriend(serverId,nick,false);
					break;
				case 12:
					if(MapTemplateList.isAcrossBossMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
						return;
					}
					SetModuleUtils.addPersonal(id);
					break;
			}
			super.dispose();
		}
	}
}