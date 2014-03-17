package sszt.scene.components.copyGroup.sec
{
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.display.Sprite;
	
	import sszt.core.manager.LanguageManager;
	import sszt.scene.data.team.BaseTeamInfo;
	import sszt.scene.data.team.UnteamPlayerInfo;
	import sszt.scene.events.NearDataUpdateEvent;
	import sszt.scene.mediators.CopyGroupMediator;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	
	public class TeamStatePanel extends MSprite
	{
		private var _mediator:CopyGroupMediator;
		private var _tile1:MTile;
		private var _tile2:MTile;
//		private var _items1:Vector.<TeamItemView>;
//		private var _items2:Vector.<UnTeamPlayerView>;
		private var _items1:Array;
		private var _items2:Array;
		private var _title:GroupTitleView;
		
		private var _con1:Sprite;
		private var _con2:Sprite;
		private var _tip1:MAssetLabel;
		private var _tip2:MAssetLabel;
		
		public function TeamStatePanel(mediator:CopyGroupMediator)
		{
			_mediator = mediator;
			super();
		}
		
		override protected function configUI():void
		{
			_title = new GroupTitleView();
			
			_con1 = new Sprite();
			addChild(_con1);
			
			_tile1 = new MTile(210,32,1);
			_tile1.setSize(210,192);
			_tile1.itemGapH = _tile1.itemGapW = 0;
			//getContainer().addChild(_tile1);
			_con1.addChild(_tile1);
			
//			getContainer().addChild(_title);
//			_title.y = _tile1.height;
			
			_con2 = new Sprite();
			addChild(_con2);
			
			_tile2 = new MTile(210,32,1);
			_tile2.setSize(210,192);
			_tile2.itemGapH = _tile2.itemGapW = 0;
//			_tile2.y = _tile1.height + _title.height;
//			getContainer().addChild(_tile2);
			_con2.addChild(_tile2);
			_con2.visible = false;
			
//			verticalScrollPolicy = ScrollPolicy.ON;
//			horizontalScrollPolicy =ScrollPolicy.OFF;
			_tile1.verticalScrollBar.lineScrollSize = _tile2.verticalScrollBar.lineScrollSize =  40;
			_tile1.verticalScrollPolicy = _tile2.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile1.horizontalScrollPolicy = _tile2.horizontalScrollPolicy = ScrollPolicy.AUTO;
			
//			_items1 = new Vector.<TeamItemView>();
//			_items2 = new Vector.<UnTeamPlayerView>();	
			_items1 = [];
			_items2 = [];
			
			_tip1 = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_tip1.textColor = 0x827960;
			_tip1.move(105,89);
			_con1.addChild(_tip1);
			_tip1.setHtmlValue(LanguageManager.getWord("ssztl.chat.noNearbyTeam"));
			
			_tip2 = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_tip2.textColor = 0x827960;
			_tip2.move(105,89);
			_con2.addChild(_tip2);
			_tip2.setHtmlValue(LanguageManager.getWord("ssztl.chat.noNearbyPlayer"));
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.nearData.addEventListener(NearDataUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.nearData.removeEventListener(NearDataUpdateEvent.SETDATA_COMPLETE,setDataCompleteHandler);
		}
		
		private function setDataCompleteHandler(evt:NearDataUpdateEvent):void
		{
			initData();
		}
		
		public function getData():void
		{
			_mediator.getNearlyData();
		}
		public function setPage(id:int):void
		{
			if(id == 0)
			{
				_con1.visible = true;
				_con2.visible = false;
			}else{
				_con1.visible = false;
				_con2.visible = true;
			}
		}
		
		private function clearDataView():void
		{
			_tile1.clearItems();
			_tile2.clearItems();
			for(var i:int = 0; i < _items1.length; i++)
			{
				_items1[i].dispose();
			}
//			_items1 = new Vector.<TeamItemView>();
			_items1 = [];
			for(var j:int = 0; j < _items2.length; j++)
			{
				_items2[j].dispose();
			}
//			_items2 = new Vector.<UnTeamPlayerView>();
			_items2 = [];
		}
		
		private function initData():void
		{
			clearDataView();
//			var teams:Vector.<BaseTeamInfo> = _mediator.sceneInfo.nearData.teamList;
			var teams:Array = _mediator.sceneInfo.nearData.teamList;
			for each(var i:BaseTeamInfo in teams)
			{
				var teamItem:TeamItemView = new TeamItemView(i,_mediator);
				_tile1.appendItem(teamItem);
				_items1.push(teamItem);
			}
			if(teams.length == 0) _tip1.visible = true;
			else  _tip1.visible = false;
//			var players:Vector.<UnteamPlayerInfo> = _mediator.sceneInfo.nearData.unteamPlayers;
			var players:Array = _mediator.sceneInfo.nearData.unteamPlayers;
			for each(var j:UnteamPlayerInfo in players)
			{
				var playerItem:UnTeamPlayerView = new UnTeamPlayerView(j,_mediator);
				_tile2.appendItem(playerItem);
				_items2.push(playerItem);
			}
			if(players.length == 0) _tip2.visible = true;
			else  _tip2.visible = false;
			invalidate(InvalidationType.STATE);
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_tile1)
			{
				_tile1.dispose();
				_tile1 = null;
			}
			if(_tile2)
			{
				_tile2.dispose();
				_tile2 = null;
			}
			if(_title)
			{
				_title.dispose();
				_title = null;
			}
			if(_items1)
			{
				for(var i:int = 0;i<_items1.length;i++)
				{
					_items1[i].dispose();
				}
				_items1 = null;
			}
			if(_items2)
			{
				for(i = 0;i<_items2.length;i++)
				{
					_items2[i].dispose();
				}
				_items2 = null;
			}
			_con1 = null;
			_con2 = null;
			super.dispose();
		}
	}
}