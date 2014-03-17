package sszt.core.manager
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	
	public class SoundManager
	{
		/**
		 * 普通按钮
		 */		
		public static const COMMON_BTN:String = "1001";
		/**
		 * 选项卡按钮
		 */		
		public static const TAB_BTN:String = "1002";
		/**
		 * 神炉成功
		 */		
		public static const FURNACE_SUCCESS:String = "1003";
		/**
		 * 升级
		 */		
		public static const UPGRADE:String = "1004";
		/**
		 * 物品拿起放下
		 */		
		public static const ITEM_DRAG:String = "1005";
		/**
		 * 尚五攻击
		 */		
		public static const SANWU_ATTACK:String = "2001";
		/**
		 * 流星攻击
		 */		
		public static const LIUXING_ATTACK:String = "2002";
		/**
		 * 逍遥攻击
		 */		
		public static const XIAOYAO_ATTACK:String = "2003";
		
		private static var _soundDict:Dictionary;
		
		public static function getAttackSound():String
		{
			switch(GlobalData.selfPlayer.career)
			{
				case CareerType.SANWU:return SANWU_ATTACK;
				case CareerType.XIAOYAO:return XIAOYAO_ATTACK;
				case CareerType.LIUXING:return LIUXING_ATTACK;
			}
			return "";
		}
		
		private static var _instance:SoundManager;
		
		public static function get instance():SoundManager
		{
			if(_instance == null)
			{
				_instance = new SoundManager();
			}
			return _instance;
		}
		
		private var _isSoundMute:Boolean;
		private var _isMusicMute:Boolean;
		private var _soundTransform:SoundTransform;
		private var _musicTrnasform:SoundTransform;
		private var _soundList:Dictionary;
		private var _musicChannel:SoundChannel;
		private var _currentMusic:int;
		
		public function SoundManager()
		{
			_currentMusic = -1;
			_soundList = new Dictionary();
			_soundDict = new Dictionary();
			_soundTransform = new SoundTransform(SharedObjectManager.soundVolumn.value);
			_musicTrnasform = new SoundTransform(SharedObjectManager.musicVolumn.value);
//			_soundTransform = new SoundTransform(0);
//			_musicTrnasform = new SoundTransform(0);
		}
		
		public function playSound(s:String,loops:int = 0,stopOther:Boolean = true):void
		{
			if(_isSoundMute)return;
			try
			{
				if(stopOther)stopAllSound();
				if(_soundDict[s] == null)
				{
					var ss:Sound = GlobalAPI.loaderAPI.getObjectByClassPath(GlobalAPI.pathManager.getSoundClassPath(s)) as Sound;
					_soundDict[s] = ss;
				}
				if(_soundDict[s])
				{
					if(loops == -1)loops = int.MAX_VALUE;
					var c:SoundChannel = _soundDict[s].play(0,loops,_soundTransform);
					c.addEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
					_soundList[s] = c;
				}
			}
			catch(e:Error)
			{
				trace(e.message);
			}
		}
		
		private function stopAllSound():void
		{
			for(var i:String in _soundList)
			{
				stopSound(i);
			}
		}
		
		public function stopSound(s:String):void
		{
			if(_soundList[s] != null)
			{
				_soundList[s].removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
				_soundList[s].stop();
				_soundList[s] = null;
			}
		}
		
		private function soundCompleteHandler(evt:Event):void
		{
			var c:SoundChannel = evt.currentTarget as SoundChannel;
			c.removeEventListener(Event.SOUND_COMPLETE,soundCompleteHandler);
			c.stop();
			for(var i:String in _soundList)
			{
				if(_soundList[i] == c)
				{
					_soundList[i] = null;
					return;
				}
			}
		}
		
		public function playBackgroup(id:int):void
		{
			if(_currentMusic == id)return;
			_currentMusic = id;
			if(_isMusicMute)return;			
			if(_musicChannel)_musicChannel.stop();
			try
			{
				var ss:Sound = new Sound(new URLRequest(GlobalAPI.pathManager.getMusicPath(id)));
				var c:SoundChannel = ss.play(0,1000000,_musicTrnasform);
				ss.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler,false,0,true);
				_musicChannel = c;
			}
			catch(e:Error){trace(e.message);}
		}
		
		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			trace(evt.text);
		}
		
		public function setMusicVolumn(value:Number):void
		{
			_musicTrnasform.volume = value;
		}
		public function setSoundVolumn(value:Number):void
		{
			_soundTransform.volume = value;
		}
		public function setMusicMute(value:Boolean):void
		{
			if(_isMusicMute == value)return;
			_isMusicMute = value;
			if(_isMusicMute)
			{
				if(_musicChannel)
					_musicChannel.stop();
			}
			else
			{
				if(_currentMusic != 0)
				{
					var t:int = _currentMusic;
					_currentMusic = 0;
					playBackgroup(t);
				}
			}
		}
		public function setSoundMute(value:Boolean):void
		{
			if(_isSoundMute == value)return;
			_isSoundMute = value;
			if(_isSoundMute)
			{
				stopAllSound();
			}
		}
	}
}