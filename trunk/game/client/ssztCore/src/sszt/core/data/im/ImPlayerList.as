package sszt.core.data.im
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.ui.container.MAlert;
	
	public class ImPlayerList extends EventDispatcher
	{
		public var friends:Dictionary;              //好友     
		public var blacks:Dictionary;               //黑名单
		public var enemys:Dictionary;               //仇人
		public var strangers:Dictionary;            //陌生人
		public var recents:Dictionary;              //最近联系人
//		public var groups:Vector.<GroupItemInfo>;   //自定义分组信息
		public var groups:Array;   //自定义分组信息
		
		public function ImPlayerList()
		{
			friends = new Dictionary();
			blacks = new Dictionary();
			enemys = new Dictionary();
			strangers = new Dictionary();
			recents = new Dictionary();
//			groups = new Vector.<GroupItemInfo>();
			groups = [];
		}
		
		public function loadData(data:IPackageIn):void
		{
			var groupLen:int = data.readInt();
			for(var t:int =0;t<groupLen;t++)
			{
				var item:GroupItemInfo = new GroupItemInfo();
				item.gId = data.readNumber();
				item.gName = data.readUTF();
				groups.push(item);
			}
			var len:int = data.readInt();
			for(var i:int = 0;i<len;i++)
			{
				var player:ImPlayerInfo = new ImPlayerInfo();
				player.parseData(data);
				if(player.isFriend)
				{
					friends[player.info.userId] = player;
				}
				if(player.isBlack)
				{
					blacks[player.info.userId] = player;
				}
				if(player.isEnemy)
				{
					enemys[player.info.userId] = player;
				}
			}
		}
		
		public function updatePlayer(player:ImPlayerInfo):void
		{
			if(!player.isFriend)
			{
				removeFriend(player.info.userId);
			}else
			{
				addFriend(player);
			}
			if(!player.isEnemy)	
			{
				removeEnemy(player.info.userId);
			}else
			{
				addEnemy(player)
			}
			if(!player.isBlack)
			{
				removeBlack(player.info.userId);
			}else
			{
				addBlack(player);
			}
		}

		public function addFriend(player:ImPlayerInfo):void
		{
			var item:ImPlayerInfo = strangers[player.info.userId] as ImPlayerInfo;
			if(item)
			{
				item.setRead();
				for(var i:int = 0;i<item.records.length;i++)
				{
					player.records.push(item.records[i]);
				}
				removeStranger(player.info.userId);
				dispatchEvent(new FriendEvent(FriendEvent.CHAT_PLAYER_CHANGE,player));
			}	
			if(friends[player.info.userId])
			{
				friends[player.info.userId].friendState = player.friendState;
				friends[player.info.userId].setState();
				return;
			}
			friends[player.info.userId] = player;
			dispatchEvent(new FriendEvent(FriendEvent.ADD_FRIEND,player));
		}
		
		public function removeFriend(id:Number):void
		{
			if(friends[id])
			{
				dispatchEvent(new FriendEvent(FriendEvent.DELETE_CHATPANEL,friends[id]));
				delete friends[id];
				dispatchEvent(new FriendEvent(FriendEvent.DELETE_FRIEND,id));
			}
		}
			
		public function addBlack(player:ImPlayerInfo):void
		{
			var item:ImPlayerInfo = strangers[player.info.userId] as ImPlayerInfo;
			if(item)
			{
				item.setRead();
				for(var i:int = 0;i<item.records.length;i++)
				{
					player.records.push(item.records[i]);
				}
				removeStranger(player.info.userId);
				dispatchEvent(new FriendEvent(FriendEvent.CHAT_PLAYER_CHANGE,player));
			}
			if(blacks[player.info.userId])
			{
				blacks[player.info.userId].friendState = player.friendState;
				blacks[player.info.userId].setState();
				return;
			}
			blacks[player.info.userId] = player;
			dispatchEvent(new FriendEvent(FriendEvent.ADD_BLACK,player));
		}
		
		public function removeBlack(id:Number):void
		{
			if(blacks[id])
			{
				dispatchEvent(new FriendEvent(FriendEvent.DELETE_CHATPANEL,blacks[id]));
				delete blacks[id];
				dispatchEvent(new FriendEvent(FriendEvent.DELETE_BLACK,id));
			}
		}
			
		public function addEnemy(player:ImPlayerInfo):void
		{
			var item:ImPlayerInfo = strangers[player.info.userId] as ImPlayerInfo;
			if(item)
			{
				item.setRead();
				for(var i:int = 0;i<item.records.length;i++)
				{
					player.records.push(item.records[i]);
				}
				removeStranger(player.info.userId);
				dispatchEvent(new FriendEvent(FriendEvent.CHAT_PLAYER_CHANGE,player));
			}
			if(enemys[player.info.userId])
			{
				enemys[player.info.userId].friendState = player.friendState;
				enemys[player.info.userId].setState();
				return ;
			}
			enemys[player.info.userId] = player;
			dispatchEvent(new FriendEvent(FriendEvent.ADD_ENEMY,player));
		}
			
		public function removeEnemy(id:Number):void
		{
			if(enemys[id])
			{
				dispatchEvent(new FriendEvent(FriendEvent.DELETE_CHATPANEL,enemys[id]));
				delete enemys[id];
				dispatchEvent(new FriendEvent(FriendEvent.DELETE_ENEMY,id));
			}
		}
		
		public function getEnemy(id:Number):ImPlayerInfo
		{
			var i:ImPlayerInfo;
			for each(i in enemys)
			{
				if(i.info.userId == id)
					return i;
			}
			return null;
		}
		
		public function addStranger(player:ImPlayerInfo):void
		{
			strangers[player.info.userId] = player;
			dispatchEvent(new FriendEvent(FriendEvent.ADD_STRANGER,player));
		}
		
		public function removeStranger(id:Number):void
		{
			if(strangers[id])
			{
				dispatchEvent(new FriendEvent(FriendEvent.DELETE_CHATPANEL,strangers[id]));
				delete strangers[id];
				dispatchEvent(new FriendEvent(FriendEvent.REMOVE_STRANGER,id));
			}
		}
		
		public function getStranger(id:Number):ImPlayerInfo
		{
			var i:ImPlayerInfo;
			for each(i in strangers)
			{
				if(i.info.userId == id)
					return i;
			}
			return null;
		}
		
		public function addRecent(player:ImPlayerInfo):void
		{
			recents[player.info.userId] = player;
			dispatchEvent(new FriendEvent(FriendEvent.ADD_RECENR,player));
		}
		
		public function removeRecent(id:Number):void
		{
			if(recents[id])
			{
				dispatchEvent(new FriendEvent(FriendEvent.DELETE_CHATPANEL,recents[id]));
				delete recents[id];
				dispatchEvent(new FriendEvent(FriendEvent.REMOVE_RECENT,id));
			}
		}
		
		public function getRecent(id:Number):ImPlayerInfo
		{
			var i:ImPlayerInfo;
			for each(i in recents)
			{
				if(i.info.userId == id)
					return i;
			}
			return null;
		}
		
//		public function search(str:String):Vector.<Number>
		public function search(str:String):Array
		{
//			var result:Vector.<Number> = new Vector.<Number>();
			var result:Array = [];
			var f:String = str.charAt(0);
			for each(var i:ImPlayerInfo in friends)
			{
				if(i.info.nick.search(f)>-1)
					result.push(i.info.userId);
			}
			return result;
		}
		
		public function getFriendByNick(nick:String):ImPlayerInfo
		{
			var i:ImPlayerInfo;
			for each(i in friends)
			{
				if(i.info.nick == nick)
					return i;
			}
			return null;
		}
		
		/**
		 * 移动分组
		 * @param fronId
		 * @param toId
		 * @param userId
		 * 
		 */		
		public function move(fronId:int,toId:int,userId:int):void
		{
			dispatchEvent(new FriendEvent(FriendEvent.DELETE_FRIEND,userId));
			friends[userId].group = toId;
			dispatchEvent(new FriendEvent(FriendEvent.ADD_FRIEND,friends[userId]));

			if(toId == GroupType.FRIEND)
			{
				var toName:String = LanguageManager.getWord("ssztl.common.myFriends");
			}else
			{
				toName = getGroup(toId).gName;
			}
	        var nick:String = "[" + getFriend(userId).info.serverId + "]" + getFriend(userId).info.nick;
			QuickTips.show(LanguageManager.getWord("ssztl.common.friendToGroupSuccess",nick,toName));
		}
		
		public function addGroup(item:GroupItemInfo):void
		{
			groups.push(item);
			dispatchEvent(new FriendEvent(FriendEvent.ADD_GROUP,item));
		}
		
		public function getGroup(id:Number):GroupItemInfo
		{
			for each(var group:GroupItemInfo in groups)
			{
				if(group.gId == id)
				{
					return group;
				}
			}
			return null;
		}
		
		public function reNameGroup(id:Number,name:String):void
		{
			for each(var group:GroupItemInfo in groups)
			{
				if(group.gId == id)
				{
					group.gName = name;
					dispatchEvent(new FriendEvent(FriendEvent.GROUP_RENAME,group));
					break;
				}
			}
		}
		
		public function removeGroup(id:Number):void
		{
			for each(var group:GroupItemInfo in groups)
			{
				if(group.gId == id)
				{
					var index:int = groups.indexOf(group);
					groups.splice(index,1);
					dispatchEvent(new FriendEvent(FriendEvent.DELETE_GROUP,id));
					break;
				}
			}
		}
				
		/**
		 *获取玩家 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getPlayer(id:Number):ImPlayerInfo
		{
			var i:ImPlayerInfo;
			for each(i in friends)
			{
				if(i.info.userId == id)
					return i;
			}
			for each(i in blacks)
			{
				if(i.info.userId == id)
					return i;
			}
			for each(i in enemys)
			{
				if(i.info.userId == id)
					return i;
			}
			for each(i in strangers)
			{
				if(i.info.userId == id)
					return i;
			}
			return null;
		}
		
		public function getFriendAndBlack(id:Number):ImPlayerInfo
		{
			var i:ImPlayerInfo;
			for each(i in friends)
			{
				if(i.info.userId == id)
					return i;
			}
			for each(i in blacks)
			{
				if(i.info.userId == id)
					return i;
			}
			return null;
		}
		
		public function getFriend(id:Number):ImPlayerInfo
		{
			var i:ImPlayerInfo;
			for each(i in friends)
			{
				if(i.info.userId == id)
					return i;
			}
			return null;
		}
		
		public function hasGroup(name:String):Boolean
		{
			var result:Boolean = false;
			if(name == LanguageManager.getWord("ssztl.common.myFriends") 
				|| name == LanguageManager.getWord("ssztl.common.blackList")
				|| name == LanguageManager.getWord("ssztl.common.enemy")
				|| name == LanguageManager.getWord("ssztl.common.stranger")
				|| name == LanguageManager.getWord("ssztl.common.recentLinkman"))
			{
				result = true;
			}
			for(var i:int = 0;i<groups.length;i++)
			{
				if(groups[i].gName == name)
				{
					result = true;
					return result;
				}
			}
			return result;
		}
		
		public function getSelfGroup():Array
		{
			var array:Array = new Array();
			
			var original:Dictionary = new Dictionary();   //默认分组“我的好友”
			for each(var j:ImPlayerInfo in friends)
			{
				if(j.group == GroupType.FRIEND)
				{
					original[j.info.userId] = j;
				}
			}
			array.push(original);
			
			for(var i:int=0;i<groups.length;i++)        //自定义分组
			{
				var groupItem:Dictionary = new Dictionary();
				var player:ImPlayerInfo;
				for each(player in friends)
				{
					if(player.group == groups[i].gId)
					{
						groupItem[player.info.userId] = player;
					}
				}
				array.push(groupItem);
			}
			return array;
		}
		
		public function checkBlackCount():int
		{
			var count:int = 0;
			var i:ImPlayerInfo;
			for each(i in blacks)
			{
				count++;
			}
			return count;
		}
		
		public function checkFriendCount():int
		{
			var count:int = 0;
			var i:ImPlayerInfo;
			for each(i in friends)
			{
				count++;
			}
			return count;	
		}
		
		public function queryResult(data:Object):void
		{
			dispatchEvent(new FriendEvent(FriendEvent.QUERY_RETURN,data));
		}
		
		public function canDeleteGroup(gid:int):Boolean
		{
			var i:ImPlayerInfo;
			for each(i in friends)
			{
				if(i.group == gid)
					return false;
			}
			for each(i in blacks)
			{
				if(i.group == gid)
					return false;
			}
			for each(i in enemys)
			{
				if(i.group == gid)
					return false;
			}
			return true;
		}
	}
}