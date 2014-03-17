package sszt.scene.components.ActivityIcon
{
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class BaseIconView extends Sprite  implements IActivityView
	{

//		private var _xoffs:Array = [-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55,-55];
		
		
		
		protected static var _classes:Array = ["FriendInviteView","GiftView","NewcomerGiftView","AchievementView","WelfareView","BossView",
												"PVPView",	"WorldBossView","YellowBoxView","FirstPayView","QuizView","CityCraftAuctionView","CityCraftView",
												"OpenActivityView","SevenActivityView","ClubActivityRaid","ActivityPatrolView","BankIconView",
												"ActivityPunishView",	"ActivityThievesView","PayTagView","AcceptTransportView",
												"SevenActivityView","ResourceWarView","PvpFirstView","MidAutumnView","MergeServerView","BigBossIconView","PetPVPIconView","GuildPVPIconView","MayaIconView"];		
		protected static var _topIconState:Array =[];
		protected var _index:int = 0;
		
		
		public function BaseIconView()
		{
			config();
		}
		
		protected function config():void
		{
			var className:String = getQualifiedClassName(this);
			var names:Array = className.split("::");
			if(names.length==2)
			{
				_index = _classes.indexOf(names[1]);
			}
			else
			{
				_index = _classes.indexOf(className);
			}
		}
				
		public function show(arg1:int = 0,arg2:Object=null,isDispatcher:Boolean=false):void
		{
			_topIconState[_index] = 1;
			setPosition();
			if(!parent)
			{
				GlobalAPI.layerManager.getModuleLayer().addChild(this);
			}
			if(isDispatcher)
			{
				ModuleEventDispatcher.dispatchSceneEvent( new SceneModuleEvent(SceneModuleEvent.TOP_ICON_UDPATE,this));
			}
		}
			
		public function hide(isDispatcher:Boolean=true):void
		{
			_topIconState[_index] = 0;
			if(parent && parent.contains(this) )
			{
				GlobalAPI.layerManager.getModuleLayer().removeChild(this);
			}
			if(isDispatcher)
			{
				ModuleEventDispatcher.dispatchSceneEvent( new SceneModuleEvent(SceneModuleEvent.TOP_ICON_UDPATE,this));
			}
		}
		
		protected function layout(e:SceneModuleEvent):void
		{
			
		}
		
		protected function setPosition():void
		{
			var vx:int = 0;
			var vy:int = 9;
			var index:int = 0;
			for(var i:int =0; i< _index+1 ;++i)
			{
				if(_topIconState[i] ==1 && _index >= i )
				{
					index++;
					if(index ==9)
					{
						vx = -60;
						vy = 87;
					}
					else
					{
						vx -= 60;
					}
				}
				if(_index == i)
				{
					move(CommonConfig.GAME_WIDTH - 180 + vx, vy);
					break;
				}
			}
			
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			setPosition();
		}
		
		protected function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			ModuleEventDispatcher.addSceneEventListener( SceneModuleEvent.TOP_ICON_UDPATE,layout);
		}
		
		protected function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			ModuleEventDispatcher.removeSceneEventListener( SceneModuleEvent.TOP_ICON_UDPATE,layout);
		}
		
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		
		public function dispose():void
		{
			if(parent && parent.contains(this) )
			{
				GlobalAPI.layerManager.getModuleLayer().removeChild(this);
			}
			_topIconState[_index] = 0;
			removeEvent();
			ModuleEventDispatcher.dispatchSceneEvent( new SceneModuleEvent(SceneModuleEvent.TOP_ICON_UDPATE,this));
		}
		
	}
}