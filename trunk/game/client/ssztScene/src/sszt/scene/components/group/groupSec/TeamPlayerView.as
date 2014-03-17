package sszt.scene.components.group.groupSec
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.CloseBtn1Asset;
	
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.GroupMediator;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class TeamPlayerView extends Sprite
	{
		private var _nameLabel:MAssetLabel;
		private var _carrerLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _deleteBtn:MCacheAssetBtn1;
		private var _info:TeamScenePlayerInfo;
		private var _mediator:GroupMediator;
		private var _leaderIcon:Bitmap;
		
		public function TeamPlayerView(info:TeamScenePlayerInfo,mediator:GroupMediator)
		{
			_mediator = mediator;
			_info = info;
			super();
			init();
			_info.addEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_LEVEL,levelUpdateHandler);
		}
		
		private function levelUpdateHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
//			_levelLabel.setValue(LanguageManager.getWord("ssztl.common.levelValue",_info.getLevel()));
			_levelLabel.setValue(_info.getLevel().toString());
		}
		
		private function init():void
		{
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,30,266,2),new BackgroundType.LINE_1));
				
			_deleteBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.scene.kickOut"));
			_deleteBtn.move(218,5);
			addChild(_deleteBtn);
			_deleteBtn.addEventListener(MouseEvent.CLICK,deleteClickHandler);
			
			//队长特殊处理			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nameLabel.move(5,7);
			addChild(_nameLabel);
			_nameLabel.setValue(_info.getName());
			
			_carrerLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_carrerLabel.move(175,7);
			addChild(_carrerLabel);
			_carrerLabel.setHtmlValue(CareerType.getNameByCareer(_info.career));
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_levelLabel.move(123,7);
			addChild(_levelLabel);
			_levelLabel.setHtmlValue(_info.getLevel().toString());
			
			if(_info.getObjId() == _mediator.sceneInfo.teamData.leadId)
			{
//				_nameLabel.setValue(_info.getName()+LanguageManager.getWord("ssztl.scene.teamLeader"));
				_leaderIcon = new Bitmap(AssetUtil.getAsset("ssztui.scene.SceneTeamLeaderAsset") as BitmapData);
				_leaderIcon.x = _nameLabel.x + _nameLabel.textWidth + 5;
				_leaderIcon.y = 7;
				addChild(_leaderIcon);
				_deleteBtn.visible = false;
			}
			if(GlobalData.selfPlayer.userId != _mediator.sceneInfo.teamData.leadId)
			{
				_deleteBtn.visible = false;
			}
		}
		
		public function setLeader():void
		{
			if(_info.getObjId() == _mediator.sceneInfo.teamData.leadId) return;
			_deleteBtn.visible = true;
		}
		
		public function get info():TeamScenePlayerInfo
		{
			return _info;
		}
		
		private function deleteClickHandler(evt:MouseEvent):void
		{
			_mediator.kickPlayer(_info.getObjId());
		}																			
		
		public function dispose():void
		{
			_deleteBtn.removeEventListener(MouseEvent.CLICK,deleteClickHandler);
			_nameLabel = null;
			_carrerLabel = null;
			_levelLabel = null;
			if(_deleteBtn)
			{
				_deleteBtn.dispose();
				_deleteBtn = null;
			}
			_info = null;
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
	}
}