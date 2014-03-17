package sszt.scene.components.group.groupSec
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.constData.CareerType;
	import sszt.constData.DirectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.character.ICharacterWrapper;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import mhsm.ui.BorderAsset4;
	
	public class TeamPlayerItemView extends Sprite
	{
		private var _name:MAssetLabel;
		private var _job:MAssetLabel;
		private var _level:MAssetLabel;
		private var _select:Boolean;
		private var _player:TeamScenePlayerInfo;
		private var _selectedBg:BorderAsset4;
		private var _character:ICharacterWrapper;
		private var _figurePlayer:FigurePlayerInfo;
		private var _leaderIcon:Bitmap;
		
		public function TeamPlayerItemView(player:TeamScenePlayerInfo)
		{
			_player = player;
			_figurePlayer = new FigurePlayerInfo();
			_figurePlayer.sex = _player.sex;
			_figurePlayer.career = _player.career;
//			_figurePlayer.updateStyle(_player.cloth,_player.weapon,0,_player.wing,false);
			_figurePlayer.updateStyle(_player.cloth,_player.weapon,_player.mount,_player.wing,0,0,false);
			super();
			initView();
			initEvent();
		}
		
		public function get player():TeamScenePlayerInfo
		{
			return _player;
		}
		
		private function initView():void
		{
			_selectedBg = new BorderAsset4();
			_selectedBg.width = 118;
			_selectedBg.height = 195;
			addChild(_selectedBg);
			_selectedBg.visible = false;

			_character = GlobalAPI.characterManager.createShowCharacterWrapper(_figurePlayer);
			_character.show(DirectType.RIGHT,this);
			_character.move(-130,-110);
				
			_name = new MAssetLabel("[" + _player.getServerId() + "]" + _player.getName(),MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_name.move(40,137);
			addChild(_name);
			
			_level = new MAssetLabel(String(_player.getLevel()),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_level.move(50,157);
			addChild(_level);

			_job = new MAssetLabel(CareerType.getNameByCareer(_player.career),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT);
			_job.move(50,173);
			addChild(_job);
			
			var _levelP:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.level2") + "：",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_levelP.move(16,157);
			addChild(_levelP);
			
			var _jobP:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer") + "：",MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT);
			_jobP.move(16,173);
			addChild(_jobP);

//			_leaderIcon = new Bitmap(new SceneTeamLeaderAsset());
			_leaderIcon = new Bitmap(AssetUtil.getAsset("mhsm.scene.SceneTeamLeaderAsset") as BitmapData);
			_leaderIcon.x = 6;
			_leaderIcon.y = 6;
			addChild(_leaderIcon);
			_leaderIcon.visible = false;
		}
		
		private function initEvent():void
		{
			_player.addEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_PLAYER_STYLE,updatePlayerStyleHandler);
			_player.addEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_LEVEL,levelUpdateHandler);
		}
		
		private function removeEvent():void
		{
			_player.removeEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_PLAYER_STYLE,updatePlayerStyleHandler);
			_player.removeEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_LEVEL,levelUpdateHandler);
		}
		
		private function levelUpdateHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			_level.setValue(String(_player.getLevel()));
		}
		
		public function updatePlayerStyleHandler(e:SceneTeamPlayerListUpdateEvent):void
		{
			_figurePlayer.updateStyle(_player.cloth,_player.weapon,_player.mount,_player.wing,0,0,false);
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function set select(flag:Boolean):void
		{
			if(_select == flag)return;
			_select = flag;
			_selectedBg.visible = _select;
		}
		
		public function set isLeader(value:Boolean):void
		{
			_leaderIcon.visible = value;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
			_name = null;
			_job = null;
			_level = null;
			_player = null;
			_figurePlayer = null;
			if(parent) parent.removeChild(this);
		}
	}
}