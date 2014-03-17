package sszt.core.manager
{
	import flash.net.SharedObject;
	
	import sszt.core.data.SharedObjectInfo;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class SharedObjectManager
	{
		/**
		 * 音效音量
		 */		
		public static const soundVolumn:SharedObjectInfo = new SharedObjectInfo("soundVolumn",0.6);
		public static function setSoundVolumn(value:Number):void
		{
			if(soundVolumn.value == value)return;
			soundVolumn.value = value;
		}
		/**
		 * 背景音乐音量
		 */		
		public static const musicVolumn:SharedObjectInfo = new SharedObjectInfo("musicVolumn",0.6);
		public static function setMusicVolumn(value:Number):void
		{
			if(musicVolumn.value == value)return;
			musicVolumn.value = value;
		}
		/**
		 * 背景音乐开关
		 */		
		public static const musicEnable:SharedObjectInfo = new SharedObjectInfo("musicEnable",true);
		public static function setMusicEnable(value:Boolean):void
		{
//			if(musicEnable.value == value)return;
			musicEnable.value = value;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.VOICE_CHANGE));
		}
		/**
		 * 音效开关
		 */		
		public static const soundEnable:SharedObjectInfo = new SharedObjectInfo("soundEnable",true);
		public static function setSoundEnable(value:Boolean):void
		{
//			if(soundEnable.value == value)return;
			soundEnable.value = value;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.VOICE_CHANGE));
		}
		
		/**
		 * 屏蔽他人造型 
		 */		
		public static const hidePlayerCharacter:SharedObjectInfo = new SharedObjectInfo("hidePlayerCharacter",false);
		public static function setHidePlayerCharacter(value:Boolean):void
		{
			if(hidePlayerCharacter.value == value)return;
			hidePlayerCharacter.value = value;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.UPDATE_PLAYER_FIGURE));
		}
		/**
		 * 屏蔽他人名字
		 */		
		public static const hidePlayerName:SharedObjectInfo = new SharedObjectInfo("hidePlayerName",false);
		public static function setHidePlayerName(value:Boolean):void
		{
			if(hidePlayerName.value == value)return;
			hidePlayerName.value = value;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.UPDATE_PLAYER_NAME));
		}
		/**
		 * 屏蔽他人称号
		 */		
		public static const hidePlayerTitle:SharedObjectInfo = new SharedObjectInfo("hidePlayerTitle",false);
		public static function setHidePlayerTitle(value:Boolean):void
		{
			if(hidePlayerTitle.value == value)return;
			hidePlayerTitle.value = value;
		}
		/**
		 * 屏蔽怪物造型 
		 */		
		public static const hideMonsterCharacter:SharedObjectInfo = new SharedObjectInfo("hideMonsterCharacter",false);
		public static function setHideMonsterCharacter(value:Boolean):void
		{
			if(hideMonsterCharacter.value == value)return;
			hideMonsterCharacter.value = value;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.UPDATE_MONSTER_FIGURE));
		}
		/**
		 * 最低同屏人数限制 
		 */		
		public static const playerCharacterLimit:SharedObjectInfo = new SharedObjectInfo("playerCharacterLimit",false);
		public static function setPlayerCharacterLimit(value:Boolean):void
		{
			if(playerCharacterLimit.value == value)return;
			playerCharacterLimit.value = value;
		}
		/**
		 * 屏蔽技能特效
		 */		
		public static const hideSkillEffect:SharedObjectInfo = new SharedObjectInfo("hideSkillEffect",false);
		public static function setHideSkillEffect(value:Boolean):void
		{
			if(hideSkillEffect.value == value)return;
			hideSkillEffect.value = value;
		}
		
		
		
//		/**
//		 * 单击攻击怪
//		 */		
//		public static const singleClickAttack:SharedObjectInfo = new SharedObjectInfo("singleClickAttack",true);
//		/**
//		 * 开启世界聊天频道
//		 */		
//		public static const chatWorldChannel:SharedObjectInfo = new SharedObjectInfo("chatWorldChannel");
//		/**
//		 * 开启阵营聊天频道
//		 */		
//		public static const chatCampChannel:SharedObjectInfo = new SharedObjectInfo("chatCampChannel");
//		/**
//		 * 开启帮会聊天频道
//		 */		
//		public static const chatClubChannel:SharedObjectInfo = new SharedObjectInfo("chatClubChannel");
//		/**
//		 * 开启队伍聊天频道
//		 */		
//		public static const chatGroupChannel:SharedObjectInfo = new SharedObjectInfo("chatGroupChannel");
//		/**
//		 * 开启私聊聊天频道
//		 */		
//		public static const chatPrivateChannel:SharedObjectInfo = new SharedObjectInfo("chatPrivateChannel");
//		/**
//		 * 开启中央广播
//		 */		
//		public static const centerBoardCast:SharedObjectInfo = new SharedObjectInfo("centerBoardCast");
//		
//		/**
//		 * 显示角色阵营名
//		 */		
//		public static const showCampName:SharedObjectInfo = new SharedObjectInfo("showCampName");
//		
		
		
		
		
		/**
		 * 交易请求
		 */		
		public static const tradeUnable:SharedObjectInfo = new SharedObjectInfo("tradeUnable",false);
		/**
		 * 好友请求 
		 */		
		public static const friendUnable:SharedObjectInfo = new SharedObjectInfo("friendUnable",false);
		/**
		 * 私聊请求
		 */		
		public static const privateChatUnable:SharedObjectInfo = new SharedObjectInfo("privateChatUnable",false);
		/**
		 * 组队邀请
		 */		
		public static const groupInviteUnable:SharedObjectInfo = new SharedObjectInfo("groupInviteUnable",false);
		/**
		 * 帮会邀请
		 */		
		public static const clubInviteUnable:SharedObjectInfo = new SharedObjectInfo("clubInviteUnable",false);
		/**
		 * 切磋邀请
		 */		
		public static const frightInviteUnable:SharedObjectInfo = new SharedObjectInfo("frightInviteUnable",false);
		
		/**
		 * 不提示窗口
		 */		
		public static const noAlertSO:SharedObjectInfo = new SharedObjectInfo("noAlertTypeSetting", "");
		
		
		public static function setup():void
		{
			try
			{
				var so:SharedObject = SharedObject.getLocal("ssztsetting");
				if(so && so.data)
				{
					if(so.data[soundVolumn.key] != undefined)soundVolumn.value = so.data[soundVolumn.key];
					if(so.data[musicVolumn.key] != undefined)musicVolumn.value = so.data[musicVolumn.key];
					if(so.data[musicEnable.key] != undefined)musicEnable.value = so.data[musicEnable.key];
					else musicEnable.value = true;
					if(so.data[soundEnable.key] != undefined)soundEnable.value = so.data[soundEnable.key];
					else soundEnable.value = true;
					if(so.data[hidePlayerCharacter.key] != undefined)hidePlayerCharacter.value = so.data[hidePlayerCharacter.key];
					if(so.data[hidePlayerName.key] != undefined)hidePlayerName.value = so.data[hidePlayerName.key];
					if(so.data[hidePlayerTitle.key] != undefined)hidePlayerTitle.value = so.data[hidePlayerTitle.key];
					if(so.data[hideMonsterCharacter.key] != undefined)hideMonsterCharacter.value = so.data[hideMonsterCharacter.key];
					if(so.data[playerCharacterLimit.key] != undefined)playerCharacterLimit.value = so.data[playerCharacterLimit.key];
					if(so.data[hideSkillEffect.key] != undefined)hideSkillEffect.value = so.data[hideSkillEffect.key];
					if (so.data[noAlertSO.key] != undefined)noAlertSO.value = so.data[noAlertSO.key];
					
					SoundManager.instance.setMusicMute(!musicEnable.value);
					SoundManager.instance.setSoundMute(!soundEnable.value);
					SoundManager.instance.setMusicVolumn(musicVolumn.value);
					SoundManager.instance.setSoundVolumn(soundVolumn.value);
				}
			}
			catch(e:Error)
			{
			}
			
		}
		
		/**
		 * 设置面板数据
		 * 
		 */		
		public static function save():void
		{
			try
			{
				var so:SharedObject = SharedObject.getLocal("ssztsetting");
				so.data[soundVolumn.key] = soundVolumn.value;
				so.data[musicVolumn.key] = musicVolumn.value;
				so.data[soundEnable.key] = soundEnable.value;
				so.data[musicEnable.key] = musicEnable.value;
				so.data[hidePlayerCharacter.key] = hidePlayerCharacter.value;
				so.data[hidePlayerName.key] = hidePlayerName.value;
				so.data[hidePlayerTitle.key] = hidePlayerTitle.value;
				so.data[hideMonsterCharacter.key] = hideMonsterCharacter.value;
				so.data[playerCharacterLimit.key] = playerCharacterLimit.value;
				so.data[hideSkillEffect.key] = hideSkillEffect.value;
				so.data[noAlertSO.key] = noAlertSO.value;
			}
			catch(e:Error)
			{}
		}
		
		public static function resetSystemSetting():void
		{
			setHidePlayerCharacter(false);
			setHidePlayerName(false);
			setHidePlayerTitle(false);
			setHideMonsterCharacter(false);
			setPlayerCharacterLimit(false);
			setHideSkillEffect(false);
			tradeUnable.value = false;
			friendUnable.value = false;
			privateChatUnable.value = false;
			groupInviteUnable.value = false;
			clubInviteUnable.value = false;
			frightInviteUnable.value = false;
			musicEnable.value = true;
			soundEnable.value = true;
			musicVolumn.value = 0.6;
			soundVolumn.value = 0.6;
		}
	}
}