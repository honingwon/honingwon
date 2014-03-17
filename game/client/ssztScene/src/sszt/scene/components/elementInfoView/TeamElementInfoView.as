package sszt.scene.components.elementInfoView
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.ColorUtils;
	import sszt.core.view.tips.TeamPlayerTip;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.ElementInfoMediator;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.progress.ProgressBar;
	import sszt.ui.progress.ProgressBar1;
	
	public class TeamElementInfoView extends BaseElementInfoView
	{
		protected var _mpBar:ProgressBar;
		private var _leaderIcon:Bitmap;
		private var _showTip:Boolean;
		
		public function TeamElementInfoView(mediator:ElementInfoMediator)
		{
			super(mediator);
		}
		
		public function get teamPlayerInfo():TeamScenePlayerInfo
		{
			return _info as TeamScenePlayerInfo;
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,leaderChangeHandler);
			if(teamPlayerInfo)
			{
				teamPlayerInfo.addEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_STATE,updateTeamPlayerHandler);
				teamPlayerInfo.addEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_LEVEL,levelUpdateHandler);
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,leaderChangeHandler);
			if(teamPlayerInfo)
			{
				teamPlayerInfo.removeEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_STATE,updateTeamPlayerHandler);
				teamPlayerInfo.removeEventListener(SceneTeamPlayerListUpdateEvent.UPDATE_TEAMPLAYER_LEVEL,levelUpdateHandler);
			}
		}
		
		private function levelUpdateHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			_levelField.setValue(String(teamPlayerInfo.getLevel()));
		}
		
		private function leaderChangeHandler(e:SceneTeamPlayerListUpdateEvent):void
		{
			if(teamPlayerInfo && teamPlayerInfo.getObjId() == _mediator.sceneInfo.teamData.leadId)
			{
//				_leaderIcon = new Bitmap(new SceneTeamLeaderAsset());
				_leaderIcon = new Bitmap(AssetUtil.getAsset("ssztui.scene.SceneTeamLeaderAsset") as BitmapData);
				_leaderIcon.x = -2;
				_leaderIcon.y = 2;
				addChild(_leaderIcon);
			}
			else
			{
				if(_leaderIcon && _leaderIcon.parent)_leaderIcon.parent.removeChild(_leaderIcon);
			}
		}
		
		private function updateTeamPlayerHandler(e:SceneTeamPlayerListUpdateEvent):void
		{
			if(_headAsset != null)
			{
				if(teamPlayerInfo.isNearby)_headAsset.filters = [];
				else ColorUtils.setGray(_headAsset);
			}
		}
		
		override protected function initHead(change:Boolean = true):void
		{
			if(_headAsset && _headAsset.parent) _headAsset.parent.removeChild(_headAsset);
			_headAsset = new Bitmap(headAssets[CareerType.getHeadByCareerSex(teamPlayerInfo.career,teamPlayerInfo.sex)],"auto",true);
			_headAsset.x = 6;
			_headAsset.y = 0;
			_headAsset.width = 50;
			_headAsset.height = 58;
			addChild(_headAsset);
			
//			_headAsset = new Bitmap(headAssets[CareerType.getHeadByCareerSex(teamPlayerInfo.career,teamPlayerInfo.sex)]);
//			_headAsset.width = _headAsset.height = 33;
//			_headAsset.x = 5;
//			_headAsset.y = 7;
//			_headAsset.filters = [new BlurFilter(1.3,1.3)];
//			addChildAt(_headAsset,0);
			if(teamPlayerInfo.isNearby)_headAsset.filters = [];
			else ColorUtils.setGray(_headAsset);
			
			if(teamPlayerInfo.getObjId() == _mediator.sceneInfo.teamData.leadId)
			{
//				_leaderIcon = new Bitmap(new SceneTeamLeaderAsset());
				_leaderIcon = new Bitmap(AssetUtil.getAsset("ssztui.scene.SceneTeamLeaderAsset") as BitmapData);
				_leaderIcon.x = -3;
				_leaderIcon.y = 0;
				addChild(_leaderIcon);
			}
			else
			{
				if(_leaderIcon && _leaderIcon.parent)_leaderIcon.parent.removeChild(_leaderIcon);
			}
		}
		
		override protected function initBg():void
		{
			_bg = new Bitmap();
			addChild(_bg);
			_bg.bitmapData = getBgAsset2();
			_bg.smoothing = true;
			_bg.width = 158;
			_bg.height = 57;
			
			
			_mask = new Sprite();
			addChild(_mask);
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawCircle(0,0,24);
			_mask.graphics.endFill();
			_mask.x = 30;
			_mask.y = 36;
			_mask.buttonMode = true;
			_mask.tabEnabled = false;
			_mask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_mask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			initBitmapdatas();
			
//			_bg = new Bitmap(new SceneTeamInfoBgAsset());
//			_bg = new Bitmap(AssetUtil.getAsset("mhsm.scene.SceneTeamInfoBgAsset") as BitmapData);
//			addChild(_bg);
//			_mask = new Sprite();
//			addChild(_mask);
//			_mask.graphics.beginFill(0,0);
//			_mask.graphics.drawCircle(0,0,17);
//			_mask.graphics.endFill();
//			_mask.x = 20;
//			_mask.y = 22;
//			_mask.buttonMode = true;
//			_mask.addEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
//			_mask.addEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			
//			var hasInit:Boolean = initBitmapdatas();
//			if(hasInit)
//			{
//				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.PLAYERICON_ASSET_COMPLETE,playerIconAssetComplete);
//			}
		}
		/*
		protected function initBitmapdatas():void
		{
			if(headAssets1.length == 0)
			{
				headAssets1.push(AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset1") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset2") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset3") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset4") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset5") as BitmapData,
					AssetUtil.getAsset("ssztui.scene.PlayerHeadSmallAsset6") as BitmapData);
			}
		}
		*/
		
		private function headOverHandler(e:MouseEvent):void
		{
			var mes:String = "";
			mes += "<font color='#FFFF00' size='14'>" + teamPlayerInfo.getName() + "</font>\n"; //[" + teamPlayerInfo.getServerId() + "]
			mes += CareerType.getNameByCareer(teamPlayerInfo.getCareer()) + " " +  "<font color='#00FF00'>" + teamPlayerInfo.getLevel() + "</font> 级\n";
			mes += LanguageManager.getWord("ssztl.common.life") + "：" + teamPlayerInfo.currentHp + "/" + teamPlayerInfo.totalHp + "\n";
			mes += LanguageManager.getWord("ssztl.common.magic") + "：" + teamPlayerInfo.currentMp + "/" + teamPlayerInfo.totalMp + "\n";
			mes += LanguageManager.getWord("ssztl.scene.itemAssignModle") + "：" + getAllocation();
			TeamPlayerTip.getInstance().show(mes,new Point(e.stageX,e.stageY));
			_showTip = true;
			
			if(_headAsset)
				setBrightness(_headAsset,0.15);
		}
		
		private function getAllocation():String
		{
			if(_mediator.sceneInfo.teamData.allocationValue == 0)return LanguageManager.getWord("ssztl.scene.autoPick");
			else if(_mediator.sceneInfo.teamData.allocationValue == 1)return LanguageManager.getWord("ssztl.scene.autoAssign");
			return "";
		}
		
		private function headOutHandler(e:MouseEvent):void
		{
			TeamPlayerTip.getInstance().hide();
			_showTip = false;
			
			if(_headAsset)
				setBrightness(_headAsset,0);
		}
		
		override protected function initProgressBar():void
		{
			_hpBar = new ProgressBar1(new Bitmap(BaseElementInfoView.getHpBgAsset4() as BitmapData),1,1,98,10,true,false);
			addChild(_hpBar);
//			_mpBar = new ProgressBar(new Bitmap(BaseElementInfoView.getMpBgAsset1()),1,1,73,9,true,false);
//			_mpBar.move(39,22);
//			addChild(_mpBar);
		}
		
		override protected function initNameField():void
		{
			_nameField = new MAssetLabel(_info ? _info.getName() : "",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_nameField.mouseEnabled = false;
			addChild(_nameField);
		}
		
		override protected function initLevelField():void
		{
			_levelField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_levelField.setLabelType([new TextFormat("Tahoma",11,0xFFFCCC)]);
			_levelField.mouseEnabled = false;
			addChild(_levelField);
		}
		
		override protected function setValue():void
		{
			super.setValue();
		}
		
		override protected function infoUpdateHandler(e:BaseRoleInfoUpdateEvent):void
		{
			_hpBar.setValue(_info.totalHp,_info.currentHp);
		}
		
		override protected function layout():void
		{
			_bg.y = 5;
			
			_hpBar.move(54,31);
			_levelField.move(59,13);			
			_nameField.move(80,12);
			
		}
		
		
		override public function dispose():void
		{
			_mask.removeEventListener(MouseEvent.MOUSE_OVER,headOverHandler);
			_mask.removeEventListener(MouseEvent.MOUSE_OUT,headOutHandler);
			if(_showTip)TeamPlayerTip.getInstance().hide();
			if(_leaderIcon && _leaderIcon.parent)_leaderIcon.parent.removeChild(_leaderIcon);
			super.dispose();
		}
	}
}