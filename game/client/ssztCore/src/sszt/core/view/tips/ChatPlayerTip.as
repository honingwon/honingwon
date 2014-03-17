
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
	
	public class ChatPlayerTip extends BaseMenuTip
	{
		private var serverId:int;
		private var nick:String;
		private var id:Number;
		private var career:int;
		private static var instance:ChatPlayerTip;
		private var _timeoutIndex:int = -1;
		
		public function ChatPlayerTip()
		{
			
		}
		
		public static function getInstance():ChatPlayerTip
		{
			if(instance == null)
			{
				instance = new ChatPlayerTip();
			}
			return instance;
		}
		
		/**
		 * 
		 * @param id 
		 * @param nick
		 * @param pos 鼠标点下的位置
		 * 
		 */		
		public function show(serverId:int,id:Number,nick:String,pos:Point,career:int=1):void
		{
			this.serverId = serverId;
			this.id = id;
			this.nick = nick;
			this.career = career;
			_timeoutIndex = setTimeout(showHandler,50);
			var tmp:ChatPlayerTip = this;
			function showHandler():void
			{
				var labels:Array = [
					LanguageManager.getWord("ssztl.common.sendChat"),
					LanguageManager.getWord("ssztl.common.inviteTeam"),
					LanguageManager.getWord("ssztl.common.inviteClub"),
					LanguageManager.getWord("ssztl.friends.addFriend"),
					LanguageManager.getWord("ssztl.mail.sendMail"),
					LanguageManager.getWord("ssztl.common.inviteExchange"),
//					LanguageManager.getWord("ssztl.common.baiRuShiMen"),
//					LanguageManager.getWord("ssztl.common.zhaoShouTuDi"),
					LanguageManager.getWord("ssztl.common.checkInfo"),
					LanguageManager.getWord("ssztl.common.copyName"),
					LanguageManager.getWord("ssztl.common.addToBlack")
//					LanguageManager.getWord("ssztl.common.personalCenter"),
//					LanguageManager.getWord("ssztl.common.presentRoss")
				];
				var ids:Array = [1,2,3,4,5,6,9,10,11];
				setLabels(labels,ids);
				checker();
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
				if(_menus[i].id == 7 || _menus[i].id == 8)
				{
					_menus[i].enabled = false;
					_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
				}
			}
		}
		
		
		public function checker():void
		{
			if(GlobalData.imPlayList.getFriend(id))
			{
				for(var i:int =0;i<_menus.length;i++)
				{ 
					if(_menus[i].id == 4)
					{
						_menus[i].enabled = false;
						_menus[i].removeEventListener(MouseEvent.CLICK,clickHandler);
						break;
					}
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
					ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:serverId,id:id,nick:nick,flag:1,career:career}));
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
				case 13:
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