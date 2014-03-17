package sszt.core.view.tips
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.GroupType;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.ClubInviteSocketHandler;
	import sszt.core.socketHandlers.firework.RosePlaySocketHandler;
	import sszt.core.socketHandlers.im.FriendDeleteSocketHandler;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.FriendModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class PlayerTip extends BaseMenuTip
	{
		private var serverId:int;
		private var id:Number;
		private var gid:Number;
		private var nick:String;
		private static var instance:PlayerTip;
		private var _timeoutIndex:int = -1;
		
		public function PlayerTip()
		{
			
		}
		
		public static function getInstance():PlayerTip
		{
			if(instance == null)
			{
				instance = new PlayerTip();
			}
			return instance;
		}
		
		public function show(serverId:int,id:Number,nick:String,gid:Number,pos:Point):void
		{
			this.serverId = serverId;
			this.id = id;
			this.nick = nick;
			this.gid = gid;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:PlayerTip = this;
			function showHandler():void
			{
				var labels:Array = new Array();
				var ids:Array = [];
//				labels.push("发送聊天");
//				labels.push("查看资料");
//				labels.push("发送邮件");
//				labels.push("发起交易");
//				labels.push("邀请帮会");
//				labels.push("邀请队伍");
//				labels.push("复制名称");
//				labels.push("删除名单");
				labels.push(LanguageManager.getWord("ssztl.common.sendChat"));
				labels.push(LanguageManager.getWord("ssztl.common.checkInfo"));
				labels.push(LanguageManager.getWord("ssztl.mail.sendMail"));
				labels.push(LanguageManager.getWord("ssztl.common.inviteExchange"));
				labels.push(LanguageManager.getWord("ssztl.common.inviteClub"));
				labels.push(LanguageManager.getWord("ssztl.common.inviteTeam"));
				labels.push(LanguageManager.getWord("ssztl.common.copyName"));
				labels.push(LanguageManager.getWord("ssztl.common.deleteNameList"));
				ids.push(1,3,4,5,6,7,8,9);
				var player:ImPlayerInfo = GlobalData.imPlayList.getPlayer(id);
				if(gid >= GroupType.FRIEND)
				{
					labels.push(LanguageManager.getWord("ssztl.common.moveSplitGroup"));
					ids.push(10);
					
				}else
				{
					labels.push(LanguageManager.getWord("ssztl.common.addToFriend"));
					ids.push(11);
				}
				labels.push(LanguageManager.getWord("ssztl.common.addToBlack"));
				ids.push(2);
//				labels.push(LanguageManager.getWord("ssztl.common.personalCenter"));
//				ids.push(12);
				labels.push(LanguageManager.getWord("ssztl.common.presentRoss"));
				ids.push(13);
				setLabels(labels,ids);
				GlobalAPI.layerManager.getTipLayer().addChild(tmp);
				setPos(pos);
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		

		
//		private function setFilter():void
//		{
//			for(var i:int = 0;i<_menus.length;i++)
//			{
//				if(	_menus[i].id == 6)
//				{
//					_menus[i].enabled = false;
//					_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
//				}
//			}
//		}
		
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
			function confirmHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					FriendUpdateSocketHandler.sendAddFriend(serverId,nick,false);
				}
			}
			var item:MenuItem = evt.currentTarget as MenuItem;
			switch (item.id)
			{
				case 1:
					ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:serverId,id:id,nick:nick,flag:1}));
					break;
				case 2:
					MAlert.show('您确定将对方拉入黑名单？',LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,confirmHandler);
					break;
				case 3:
					if(GlobalData.imPlayList.getPlayer(id).online == 0)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.playerNotOnline"));
						return ;
					}
					SetModuleUtils.addRole(id);
					break;
				case 4:
					SetModuleUtils.addMail(new ToMailData(true,serverId,nick));
					break;
				case 5:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SEND_TRADEDIRECT,id));
					break;
				case 6:
					ClubInviteSocketHandler.send(serverId,nick);
					break;
				case 7:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:0,id:id,nick:nick,serverId:serverId}));
					break;
				case 8:
					System.setClipboard(nick);
					break;
				case 9:
					var type:int;
					if(gid == GroupType.STRANGER)
					{
						GlobalData.imPlayList.removeStranger(id);
						return;
					}
					if(gid == GroupType.RECENT)
					{
						GlobalData.imPlayList.removeRecent(id);
						return;
					}
					if(gid == GroupType.BLACK)
					{
						type= int(1<<13);
					}
					if(gid == GroupType.ENEMY)
					{
						type = int(1<<12);
					}
					if(gid >= 0)
					{
						type = int(1<<14);
					}
					FriendDeleteSocketHandler.sendDelete(id,type);
					break;
				case 10:
					ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_MOVE_PANEL,{gid:gid,id:id}));
					break;
				case 11:
					var player:ImPlayerInfo = GlobalData.imPlayList.getFriend(id);
					if(player)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.isAlreadyYourFriend"));
						return ;
					}
					FriendUpdateSocketHandler.sendAddFriend(serverId,nick,true);
					break;
				case 12:
					if(MapTemplateList.isAcrossBossMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
						return;
					}
					SetModuleUtils.addPersonal(id);
					break;
				case 13:
//					var haveBoolean:Boolean = false;
//					var list:Array;
//					var roseIdArray:Array = [CategoryType.ROSE_1_ID,CategoryType.ROSE_2_ID,CategoryType.ROSE_3_ID,CategoryType.ROSE_4_ID];
//					for(var i:int=0; i<roseIdArray.length;i++)
//					{
//						list = GlobalData.bagInfo.getItemById(roseIdArray[i]);
//						if(list.length > 0)
//						{
//							haveBoolean = true;
//							break;
//						}
//					}
//					if(haveBoolean)
//					{
						//打开赠送鲜花的界面
						ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_GIVE_FLOWERS_PANEL,{id:this.id,nick:this.nick}));
//					}
//					else
//					{
//						QuickTips.show(LanguageManager.getWord("ssztl.common.noRoss"));
//					}
					break;
//					RosePlaySocketHandler.send(list[0].place,id);
			}
		}
		
	}
}