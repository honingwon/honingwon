package sszt.scene.components.group.groupSec
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.TeamPlayerList;
	import sszt.scene.data.roles.TeamScenePlayerInfo;
	import sszt.scene.events.SceneTeamPlayerListUpdateEvent;
	import sszt.scene.mediators.GroupMediator;
	import sszt.scene.socketHandlers.TeamCreateSocketHandler;
	import sszt.scene.socketHandlers.TeamDisbandSocketHandler;
	import sszt.scene.socketHandlers.TeamInviteMsgSocketHandler;
	import sszt.scene.socketHandlers.TeamKickSocketHandler;
	import sszt.scene.socketHandlers.TeamLeaderChangeSocketHandler;
	import sszt.scene.socketHandlers.TeamLeaveSocketHandler;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class GroupStateTabView extends Sprite implements IgroupTabView
	{
		private var _mediator:GroupMediator;
		private var _bg:IMovieWrapper;
		private var _createBtn:MCacheAsset1Btn;
		private var _changeLeaderBtn:MCacheAsset1Btn;
		private var _disposeTeamBtn:MCacheAsset1Btn;
		private var _outTeamBtn:MCacheAsset1Btn;
		private var _leaveTeamBtn:MCacheAsset1Btn;
		private var _tile:MTile;
//		private var _items:Vector.<TeamPlayerItemView>;
		private var _items:Array;
		
		public function GroupStateTabView(mediator:GroupMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(0,0,583,203)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(7,6,110,191)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(122,6,110,191)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(237,6,110,191)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(352,6,110,191)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(467,6,110,191)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,138,105,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(124,138,105,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(239,138,105,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(354,138,105,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(469,138,105,2),new MCacheSplit2Line())
				]);
			addChild(_bg as DisplayObject);
			
			_createBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.createTeam"));
			_createBtn.move(6,210);
			addChild(_createBtn);
			_createBtn.enabled = false;
			
			_changeLeaderBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.changeLeader"));
			_changeLeaderBtn.move(103,210);
			addChild(_changeLeaderBtn);
			_changeLeaderBtn.enabled = false;
			
			_disposeTeamBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.disposeTeam"));
			_disposeTeamBtn.move(200,210);
			addChild(_disposeTeamBtn);
			_disposeTeamBtn.enabled = false;
			
			_outTeamBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.moveOutTeam"));
			_outTeamBtn.move(297,210);
			addChild(_outTeamBtn);
			_outTeamBtn.enabled = false;
			
			_leaveTeamBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.scene.leaveTeam"));
			_leaveTeamBtn.move(486,210);
			addChild(_leaveTeamBtn);
			_leaveTeamBtn.enabled = false;
			
			_tile = new MTile(116,197,5);
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.setSize(580,200);
			_tile.itemGapW = -1;
			_tile.move(3,3);
			addChild(_tile);
				
//			_items = new Vector.<TeamPlayerItemView>();	
			_items = [];
			initData();
		}
		
		private function initData():void
		{
//			var list:Vector.<TeamScenePlayerInfo> = _mediator.sceneInfo.teamData.teamPlayers;
			var list:Array = _mediator.sceneInfo.teamData.teamPlayers;
			for(var i:int = 0; i < list.length; i++)
			{
				addItem(list[i]);
			}
			
			if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
			{
				_createBtn.enabled = false;
				_changeLeaderBtn.enabled = true;
				_disposeTeamBtn.enabled = true;
				_outTeamBtn.enabled = true;
				_leaveTeamBtn.enabled = true;
			}
			else if(list.length == 0)
			{
				_createBtn.enabled = true;
			}
		}
		
		private function compareFunction(item1:TeamPlayerItemView,item2:TeamPlayerItemView):int
		{
			if(item1.player.getLevel()>=item2.player.getLevel())
				return -1;
			else
				return 1;
		}
		
		private function addItem(item:TeamScenePlayerInfo):void
		{
			var itemView:TeamPlayerItemView = new TeamPlayerItemView(item);
			itemView.addEventListener(MouseEvent.CLICK,itemClickHandler);
			_items.push(itemView);
			_items.sort(compareFunction);
			var index:int = _items.indexOf(itemView);
			_tile.appendItemAt(itemView,index);
			_leaveTeamBtn.enabled = true;
			if(_mediator.sceneInfo.teamData.leadId == item.getObjId())itemView.isLeader = true;
			else itemView.isLeader = false;
			
//			if(_mediator.sceneInfo.teamData.leadId == GlobalData.selfPlayer.userId)
//			{
//				_changeLeaderBtn.enabled = true;
//				_disposeTeamBtn.enabled = true;
//				_outTeamBtn.enabled = true;
//			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			for(var i:int =0;i<_items.length;i++)
			{
				_items[i].select = false;
			}
			evt.currentTarget.select = true;
		}
		
		private function initEvent():void
		{
			_createBtn.addEventListener(MouseEvent.CLICK,createBtnHandler);
			_changeLeaderBtn.addEventListener(MouseEvent.CLICK,changeBtnHandler);
			_disposeTeamBtn.addEventListener(MouseEvent.CLICK,disposeTeamHandler);
			_outTeamBtn.addEventListener(MouseEvent.CLICK,outBtnHandler);
			_leaveTeamBtn.addEventListener(MouseEvent.CLICK,leaveHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,addPlayerHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,leaderChangeHandler);
			_mediator.sceneInfo.teamData.addEventListener(SceneTeamPlayerListUpdateEvent.DISBAND,disBandHandler);
		}
		
		private function removeEvent():void	
		{
			_createBtn.removeEventListener(MouseEvent.CLICK,createBtnHandler);
			_changeLeaderBtn.removeEventListener(MouseEvent.CLICK,changeBtnHandler);
			_disposeTeamBtn.removeEventListener(MouseEvent.CLICK,disposeTeamHandler);
			_outTeamBtn.removeEventListener(MouseEvent.CLICK,outBtnHandler);
			_leaveTeamBtn.removeEventListener(MouseEvent.CLICK,leaveHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.ADDPlAYER,addPlayerHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.REMOVEPLAYER,removePlayerHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.CHANGELEADER,leaderChangeHandler);
			_mediator.sceneInfo.teamData.removeEventListener(SceneTeamPlayerListUpdateEvent.DISBAND,disBandHandler);
		}
		
		private function createBtnHandler(e:MouseEvent):void
		{
			if(MapTemplateList.getIsPrison())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.cannotDoInPrison"));
				return;
			}
			TeamCreateSocketHandler.send();
		}
		
		private function disBandHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			_leaveTeamBtn.enabled = false;
		}
		
		private function leaderChangeHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var id:Number = evt.data as Number;
			if(id == GlobalData.selfPlayer.userId)
			{
				_createBtn.enabled = false;
				_changeLeaderBtn.enabled = true;
				_disposeTeamBtn.enabled = true;
				_outTeamBtn.enabled = true;
			}
			else
			{
				if(id == 0)_createBtn.enabled = true;
				else _createBtn.enabled = false;
				_changeLeaderBtn.enabled = false;
				_disposeTeamBtn.enabled = false;
				_outTeamBtn.enabled = false;	
			}
			for each(var itemView:TeamPlayerItemView in _items)
			{
				if(itemView.player.getObjId() == id)itemView.isLeader = true;
				else itemView.isLeader = false;
			}
		}
			
		private function addPlayerHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			addItem(evt.data as TeamScenePlayerInfo);
		}
		
		private function removePlayerHandler(evt:SceneTeamPlayerListUpdateEvent):void
		{
			var player:TeamScenePlayerInfo = evt.data as TeamScenePlayerInfo;
			for(var i:int =0;i<_items.length;i++)
			{
				if(player == _items[i].player)
				{
					_tile.removeItem(_items[i]);
					_items[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
					_items.splice(i,1);
					break;
				}
			}
		}
		
		private function changeBtnHandler(evt:MouseEvent):void
		{
			var id:Number = 0;
			for each(var i:TeamPlayerItemView in _items)
			{
				if(i.select == true)
				{
					id = i.player.getObjId();
					break;
				}
			}
			if(id == 0)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.selectNewTeamLeader"));
			}else
			{
				if(GlobalData.copyEnterCountList.isInCopy  && !MapTemplateList.isGuildMap())
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
					return;
				}
				TeamLeaderChangeSocketHandler.sendLeaderChange(id);
			}
		}
		
		private function disposeTeamHandler(evt:MouseEvent):void
		{
			if(GlobalData.copyEnterCountList.isInCopy  && !MapTemplateList.isGuildMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
			MAlert.show(LanguageManager.getWord("ssztl.common.isSureDisposeTeam"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,disposeCloseHandler);
		}
		
		private function disposeCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				TeamDisbandSocketHandler.sendDisband();
			}
		}
		
		private function outBtnHandler(evt:MouseEvent):void
		{
			for each(var i:TeamPlayerItemView in _items)
			{
				if(i.select == true)
				{
					if(i.player.getServerId() == GlobalData.selfPlayer.serverId && i.player.getName() == GlobalData.selfPlayer.nick)
					{
						QuickTips.show(LanguageManager.getWord("ssztl.scene.cannotMoveOutSelf"));
					}
					else
					{
						if(GlobalData.copyEnterCountList.isInCopy  && !MapTemplateList.isGuildMap())
						{
							QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
							return;
						}
						TeamKickSocketHandler.sendTeamKick(i.player.getObjId());
					}
					break;
				}
			}
		}
		
		private function leaveHandler(evt:MouseEvent):void
		{
			if(GlobalData.copyEnterCountList.isInCopy && !MapTemplateList.isGuildMap())
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.isSureExitTeam"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
			}else
			{
				MAlert.show(LanguageManager.getWord("ssztl.common.noExtendAddExitTeam"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,leaveCloseHandler);
			}	
		}
		
		private function leaveCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				TeamLeaveSocketHandler.sendLeave();
			}
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_createBtn)
			{
				_createBtn.dispose();
				_createBtn = null;
			}
			if(_changeLeaderBtn)
			{
				_changeLeaderBtn.dispose();
				_changeLeaderBtn = null;
			}
			if(_disposeTeamBtn)
			{
				_disposeTeamBtn.dispose();
				_disposeTeamBtn = null;
			}
			if(_outTeamBtn)
			{
				_outTeamBtn.dispose();
				_outTeamBtn = null;
			}
			if(_leaveTeamBtn)
			{
				_leaveTeamBtn.dispose();
				_leaveTeamBtn = null;
			}
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_items)
			{
				for(var i:int =0;i<_items.length;i++)
				{
					_items[i].dispose();
				}
				_items = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}