package sszt.scene.components.elementInfoView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.tips.PetMenuTip;
	import sszt.core.view.tips.SelfMenuTip;
	import sszt.core.view.tips.TargetMenuTip;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneInfoUpdateEvent;
	import sszt.scene.events.ScenePetListUpdateEvent;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.ElementInfoMediator;
	
	public class ElementInfoContainer extends Sprite
	{
		private var _mediator:ElementInfoMediator;
		private var _selfInfo:SelfElementInfoView;
		private var _targetInfo:BaseElementInfoView;
		private var _teamList:Array;
		private var _petInfo:PetElementInfoView;
		
		public function ElementInfoContainer(mediator:ElementInfoMediator)
		{
			_mediator = mediator;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_selfInfo = new SelfElementInfoView(_mediator);
			_selfInfo.getHeadIcon().addEventListener(MouseEvent.CLICK,selfClickHandler);
			addChild(_selfInfo);
			_teamList = [];
		}
		
		public function setInfo(info:BaseRoleInfo):void
		{
			_selfInfo.setInfo(info);
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.addEventListener(SceneInfoUpdateEvent.SELECT_CHANGE,selectedChangeHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,addTeamPlayerHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,removeTeamPlayerHandler);
			_mediator.sceneInfo.petList.addEventListener(ScenePetListUpdateEvent.ADD_PET,addPetHandler);
//			_mediator.sceneInfo.petList.addEventListener(ScenePetListUpdateEvent.REMOVE_PET,removePetHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.removeEventListener(SceneInfoUpdateEvent.SELECT_CHANGE,selectedChangeHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,addTeamPlayerHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,removeTeamPlayerHandler);
			_mediator.sceneInfo.petList.removeEventListener(ScenePetListUpdateEvent.ADD_PET,addPetHandler);
//			_mediator.sceneInfo.petList.removeEventListener(ScenePetListUpdateEvent.REMOVE_PET,removePetHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			
		}
		
		private function selectedChangeHandler(evt:SceneInfoUpdateEvent):void
		{
			var target:BaseRoleInfo = _mediator.sceneInfo.getCurrentSelect();
			if(target == null)
			{
				if(_targetInfo)
				{
					_targetInfo.hide();
				}
			}
			else
			{
				var needCreate:Boolean = false;
				if(_targetInfo == null)
				{
					needCreate = true;	
				}
				else if(_targetInfo.elementType() != target.getObjType() )
				{
					needCreate = true;
				}
				if(needCreate)
				{
					if(_targetInfo)
					{
						_targetInfo.dispose();
						_targetInfo = null;
					}
					if(MapElementType.isPlayer(target.getObjType()))
					{
						_targetInfo = new PlayerElementInfoView(_mediator);
					}
					else if(MapElementType.isMonster(target.getObjType()))
					{
						_targetInfo = new MonsterElementInfoView(_mediator);
					}
					
					gameSizeChangeHandler(null);
				}
				
				_targetInfo.show(this);
				_targetInfo.setInfo(target);
				if(target is BaseScenePlayerInfo)
				{
					_targetInfo.getHeadIcon().buttonMode = true;
					_targetInfo.getHeadIcon().addEventListener(MouseEvent.CLICK,targetClickHandler);
				}
				else
				{
					_targetInfo.getHeadIcon().buttonMode = false;
					_targetInfo.getHeadIcon().removeEventListener(MouseEvent.CLICK,targetClickHandler);
				}	
			}
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			if(_targetInfo)
			{
				_targetInfo.move(CommonConfig.GAME_WIDTH - _targetInfo.width >> 1,0);
			}
		}
		
		
		private function targetClickHandler(evt:MouseEvent):void
		{
			var item:BaseElementInfoView = evt.currentTarget.parent as BaseElementInfoView;
			var isFriend:Boolean = false;
			var hasClub:Boolean = false;
			if((item.getInfo() as BaseScenePlayerInfo).info.clubId > 0) hasClub = true;
			if(GlobalData.imPlayList.getFriend(item.getInfo().getObjId())) isFriend = true;
			TargetMenuTip.getInstance().show((item.getInfo() as BaseScenePlayerInfo).info.serverId,item.getInfo().getObjId(),item.getInfo().getName(),item.getInfo().getLevel(),isFriend,false,true,hasClub,new Point(evt.stageX,evt.stageY));	
		}
		
		private function teamClickHandler(evt:MouseEvent):void
		{
			var item:BaseElementInfoView = evt.currentTarget.parent as BaseElementInfoView;
			var isFriend:Boolean = false;
			var isLeader:Boolean = false;
			var hasClub:Boolean = false;
			if(GlobalData.imPlayList.getFriend(item.getInfo().getObjId())) isFriend = true;		
			var player:BaseScenePlayerInfo =  _mediator.sceneInfo.playerList.getPlayer(item.getInfo().getObjId());
			if(player && player.info.clubId > 0) hasClub = true;
			if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId) isLeader = true;
			TargetMenuTip.getInstance().show(item.getInfo().getServerId(),item.getInfo().getObjId(),item.getInfo().getName(),item.getInfo().getLevel(),isFriend,true,isLeader,hasClub,new Point(evt.stageX,evt.stageY));
		}
		
		private function selfClickHandler(evt:MouseEvent):void
		{
			var item:SelfElementInfoView = evt.currentTarget as SelfElementInfoView;
			var state:int = 0;
			var autoInteam:Boolean = _mediator.sceneInfo.teamData.autoInTeam;
			var allocation:int = _mediator.sceneInfo.teamData.allocationValue;
			if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
		 		state = 2;
			if(_mediator.sceneInfo.teamData.self != null&&_mediator.sceneInfo.teamData.leadId != GlobalData.selfPlayer.userId )
				state = 1;
			SelfMenuTip.getInstance().show(GlobalData.selfPlayer.userId,GlobalData.selfPlayer.nick,state,autoInteam,allocation,new Point(evt.stageX,evt.stageY));
		}
		
		private function addTeamPlayerHandler(e:SceneTeamPlayerListUpdateEvent):void
		{
			if(_teamList.length >= 5) return;
			var item:TeamScenePlayerInfo = e.data as TeamScenePlayerInfo;
			if(item.getObjId() == GlobalData.selfPlayer.userId) return;
			var teamView:TeamElementInfoView = new TeamElementInfoView(_mediator);
			teamView.setInfo(e.data as TeamScenePlayerInfo);
			teamView.getHeadIcon().addEventListener(MouseEvent.CLICK,teamClickHandler);
			teamView.move(12,166 + _teamList.length * 62);
			addChild(teamView);
			_teamList.push(teamView);
		}
		
		private function removeTeamPlayerHandler(e:SceneTeamPlayerListUpdateEvent):void
		{
			var player:TeamScenePlayerInfo = e.data as TeamScenePlayerInfo;
			for(var i:int = 0; i < _teamList.length; i++)
			{
				if(_teamList[i].teamPlayerInfo.getObjId() == player.getObjId())
				{
					_teamList[i].getHeadIcon().removeEventListener(MouseEvent.CLICK,teamClickHandler);
					_teamList[i].dispose();
					_teamList[i] = null;
					_teamList.splice(i,1);
				}
			}
			for(var j:int = 0; j < _teamList.length; j++)
			{
				_teamList[j].move(12, 126 + j * 62);
			}
		}
		
		private function petClickHandler(evt:MouseEvent):void
		{
//			var item:BaseElementInfoView = evt.currentTarget.parent as BaseElementInfoView;
//			PetMenuTip.getInstance().show(item.getInfo().getObjId(),new Point(evt.stageX,evt.stageY));
			SetModuleUtils.addPet();
		}
		
		private function addPetHandler(e:ScenePetListUpdateEvent):void
		{
			var pet:BaseScenePetInfo = e.data as BaseScenePetInfo;
			if(pet.owner == GlobalData.selfPlayer.userId)
			{
				if(_petInfo == null)
				{
					_petInfo = new PetElementInfoView(_mediator);
//					_petInfo.setInfo(pet);
					_petInfo.move(242,83);
					addChild(_petInfo);
				}
				_petInfo.setInfo(e.data as SelfScenePetInfo);
				_petInfo.getHeadIcon().addEventListener(MouseEvent.CLICK,petClickHandler);
			}
		}
		
//		private function removePetHandler(e:ScenePetListUpdateEvent):void
//		{
//			var pet:BaseScenePetInfo = e.data as BaseScenePetInfo;
//			if(_petInfo && pet.owner == GlobalData.selfPlayer.userId)
//			{
//				_petInfo.getHeadIcon().removeEventListener(MouseEvent.CLICK,petClickHandler);
//				_petInfo.dispose();
//				_petInfo = null;
//			}
//		}
		
		public function dispose():void
		{
			if(_selfInfo)
			{
				_selfInfo.dispose();
				_selfInfo = null;
			}
			if(_targetInfo)
			{
				_targetInfo.getHeadIcon().removeEventListener(MouseEvent.CLICK,targetClickHandler);
				_targetInfo.dispose();
				_targetInfo = null;
			}
			if(_petInfo)
			{
				_petInfo.dispose();
				_petInfo = null;
			}
			if(_teamList)
			{
				for(var i:int = 0; i < _teamList.length; i++)
				{
					_teamList[i].dispose();
				}
			}
			_teamList = null;
			_mediator = null;
		}
	}
}