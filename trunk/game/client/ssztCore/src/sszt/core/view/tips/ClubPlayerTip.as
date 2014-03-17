package sszt.core.view.tips
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.firework.RosePlaySocketHandler;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ClubModuleEvent;
	import sszt.events.FriendModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class ClubPlayerTip extends BaseMenuTip
	{
		private var serverId:int;
		private var id:Number;
		private var nick:String;
		private var level:int;
		private var _timeoutIndex:int = -1;
		
		public function ClubPlayerTip()
		{
			super();
		}
		
		private static var instance:ClubPlayerTip;
		public static function getInstance():ClubPlayerTip
		{
			if(instance == null)
			{
				instance = new ClubPlayerTip();
			}
			return instance;
		}
		
		public function show(serverId:int,id:Number,nick:String,pos:Point,level:int):void
		{
			this.serverId = serverId;
			this.id = id;
			this.nick = nick;
			this.level = level;
			var tip:ClubPlayerTip = this;
			_timeoutIndex = setTimeout(showHandler,50);
			function showHandler():void
			{
				var labels:Array = new Array();
				var ids:Array = [];
//				labels.push("查看资料");
//				labels.push("发送聊天");
//				labels.push("加为好友");
//				labels.push("申请交易");
//				labels.push("发送邮件");
//				labels.push("复制名称");
//				labels.push("转让帮主");
//				labels.push("踢出帮会");
//				labels.push("赠送玫瑰");
				labels.push(LanguageManager.getWord("ssztl.common.checkInfo"));
				labels.push(LanguageManager.getWord("ssztl.common.sendChat"));
				labels.push(LanguageManager.getWord("ssztl.common.addToFriend"));
				labels.push(LanguageManager.getWord("ssztl.scene.applyTrade"));
				labels.push(LanguageManager.getWord("ssztl.mail.sendMail"));
				labels.push(LanguageManager.getWord("ssztl.common.copyName"));
				labels.push(LanguageManager.getWord("ssztl.common.transClubLeader"));
//				labels.push(LanguageManager.getWord("ssztl.common.kickOutClub"));
				labels.push(LanguageManager.getWord("ssztl.common.presentRoss"));
				labels.push(LanguageManager.getWord("ssztl.scene.inviteTeam2"));
				ids.push(1,2,3,4,5,6,7,8,9);
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
			switch(item.id)
			{
				case 1:
					SetModuleUtils.addRole(id);
					break;
				case 2:
					ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:serverId,id:id,nick:nick,flag:1,level:level}));
					break;
				case 3:
					FriendUpdateSocketHandler.sendAddFriend(serverId,nick,true);
					break;
				case 4:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SEND_TRADEDIRECT,id));
					break;
				case 5:
					SetModuleUtils.addMail(new ToMailData(true,serverId,nick));
					break;
				case 6:
					System.setClipboard(nick);
					break;
				case 7:
					MAlert.show(LanguageManager.getWord("ssztl.club.makeSureTransfer",nick),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
					break;
//				case 8:
//					ModuleEventDispatcher.dispatchClubEvent(new ClubModuleEvent(ClubModuleEvent.CLUB_KICK,id));
//					break;
				case 9:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:0,id:id,nick:nick,serverId:serverId}));
			}
		}
		
		private function closeHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				ModuleEventDispatcher.dispatchClubEvent(new ClubModuleEvent(ClubModuleEvent.CLUB_TRANSFER,id));
			}
		}
	}
}