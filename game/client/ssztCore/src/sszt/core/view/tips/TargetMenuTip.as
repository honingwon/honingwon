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
	import sszt.core.data.club.ClubDutyType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.ClubInviteSocketHandler;
	import sszt.core.socketHandlers.firework.RosePlaySocketHandler;
	import sszt.core.socketHandlers.im.FriendUpdateSocketHandler;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.FriendModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class TargetMenuTip extends BaseMenuTip
	{
		private var serverId:int;
		private var id:Number;
		private var nick:String;
		private var level:int;
		private var isFriend:Boolean;
		private var isTeam:Boolean;
		private var isLeader:Boolean;
		private var hasClub:Boolean;
		private var _timeoutIndex:int = -1;
			
		public function TargetMenuTip()
		{
	
		}
		
		private static var instance:TargetMenuTip;
		public static function getInstance():TargetMenuTip
		{
			if(instance == null)
			{
				instance = new TargetMenuTip();
			}
			return instance;
		}
		
		/**
		 * @param serverId 服务器ID
		 * @param id  玩家id
		 * @param nick 玩家昵称
		 * @param isFriend 对方是否是好友
		 * @param isTeam  对方是否是队友
		 * @param isLeader 自己是否是队长
		 * @param pos
		 * 
		 */		
		public function show(serverId:int,id:Number,nick:String,level:int,isFriend:Boolean,isTeam:Boolean,isLeader:Boolean,hasClub:Boolean,pos:Point):void
		{
			this.serverId = serverId;
			this.id = id;
			this.nick = nick;
			this.level = level;
			this.hasClub = hasClub;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:TargetMenuTip = this;
			function showHandler():void
			{
				var labels:Array = new Array();
				var ids:Array = [];
				if(isLeader&&isTeam)
				{
//					labels.push("请离队伍");
//					labels.push("转移队长");
					labels.push(LanguageManager.getWord("ssztl.common.requireOutTeam"));
					labels.push(LanguageManager.getWord("ssztl.common.changeTeamLeader"));
					ids.push(1,2);
				}
				if(!isTeam)
				{
//					labels.push("邀请队伍");
					labels.push(LanguageManager.getWord("ssztl.common.inviteTeam"));
					ids.push(3);
				}
				labels.push(LanguageManager.getWord("ssztl.common.checkInfo"));
				ids.push(4);
				if(!isFriend)
				{
					labels.push(LanguageManager.getWord("ssztl.friends.addFriend"));
					ids.push(5);
				}		
				labels.push(LanguageManager.getWord("ssztl.common.sendChat"));
				labels.push(LanguageManager.getWord("ssztl.mail.sendMail"));
				labels.push(LanguageManager.getWord("ssztl.common.inviteExchange"));
				ids.push(6,7,8);
				if(!hasClub && GlobalData.selfPlayer.clubDuty == ClubDutyType.MASTER)
				{
					labels.push(LanguageManager.getWord("ssztl.common.inviteClub"));
					ids.push(9);
				}
//				if(!isTeam)
//				{
//					labels.push(LanguageManager.getWord("ssztl.common.invitePK"));
//					ids.push(10);
//				}
//				labels.push(LanguageManager.getWord("ssztl.common.baiRuShiMen"));
//				labels.push(LanguageManager.getWord("ssztl.common.zhaoShouTuDi"));
				labels.push(LanguageManager.getWord("ssztl.common.autoGoWith"));
				labels.push(LanguageManager.getWord("ssztl.common.copyName"));
				labels.push(LanguageManager.getWord("ssztl.scene.inviteDoubleSit"));
				labels.push(LanguageManager.getWord("ssztl.common.addToBlack"));
				//labels.push(LanguageManager.getWord("ssztl.common.personalCenter"));
				//labels.push(LanguageManager.getWord("ssztl.common.presentRoss"));
				ids.push(11,12,13,14,15,16);
				setLabels(labels,ids);
				setFilter();
				setPos(pos);
				GlobalAPI.layerManager.getTipLayer().addChild(tmp);		
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function setFilter():void
		{
			for(var i:int = 0;i<_menus.length;i++)
			{
//				if(_menus[i].label == "邀请入帮" ||	_menus[i].label == "申请决斗"||_menus[i].label == "申请拜师"||_menus[i].label == "申请收徒"||_menus[i].label == "复制名字")
//				if(_menus[i].id == 11 || _menus[i].id == 12)
//				{
//					_menus[i].enabled = false;
//					_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
//				}
//				if(_menus[i].id == 9 && GlobalData.selfPlayer.clubDuty != ClubDutyType.MASTER)
//				{
//					_menus[i].enabled = false;
//					_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
//				}
//				if(_menus[i].id == 9 && hasClub)
//				{
//					_menus[i].enabled = false;
//					_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
//				}
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
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:3,id:id}));
					break;
				case 2:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:1,id:id}));
					break;
				case 3:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.TEAM_ACTION,{type:0,id:id,nick:nick,serverId:serverId}));
					break;
				case 4: //查看资料
					SetModuleUtils.addRole(id);
					break;
				case 5:
					FriendUpdateSocketHandler.sendAddFriend(serverId,nick,true);
					break;
				case 6: //发送聊天
					ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:serverId,id:id,nick:nick,flag:1,level:level}));				
					break;
				case 7:
					SetModuleUtils.addMail(new ToMailData(true,serverId,nick));
					break;
				case 8: //发起交易
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SEND_TRADEDIRECT,this.id));
//					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SEND_TRADEDIRECT,id));
					break;
				case 9:
					ClubInviteSocketHandler.send(serverId,nick);
					break;
				case 10:
					if(MapTemplateList.getIsPrison())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
						return;
					}
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.PK_INVITE,id));
					break;
				case 11:
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.FOLLOW_PLAYER,id));
					break;
				case 12:
					System.setClipboard(nick);
					break;
				case 13:
					if(MapTemplateList.getIsInSpaMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
					}
					else
					{
						ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.DOUBLESIT_INVITE,{nick:nick,id:id}));
					}
					break;
				case 14:
					FriendUpdateSocketHandler.sendAddFriend(serverId,nick,false);
					break;
				case 15:
					if(MapTemplateList.isAcrossBossMap())
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
						return;
					}
					SetModuleUtils.addPersonal(id);
					break;
				case 16:
					var list:Array = GlobalData.bagInfo.getItemById(CategoryType.ROSE_1_ID);
					if(list.length == 0)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.common.noRoss"));
						return;
					}
//					RosePlaySocketHandler.send(list[0].place,id);
			}
			super.dispose();
		}
	}
}