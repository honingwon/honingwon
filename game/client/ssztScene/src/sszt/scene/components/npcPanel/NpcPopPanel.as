package sszt.scene.components.npcPanel
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.npcPanel.NpcPopInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.events.SceneInfoUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	
	public class NpcPopPanel extends MPanel
	{
		private var _info:NpcPopInfo;
		private var _mediator:SceneMediator;
		private var _bg:IMovieWrapper;
		private var _detail:MScrollPanel;
		private var _dialogField:TextField;
//		private var _items:Vector.<NpcFuncItem>;
		private var _items:Array;
		private var _tile:MTile;
		
		public function NpcPopPanel(mediator:SceneMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1(),true,-1);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(260,280);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,260,280))
			]);
			addContent(_bg as DisplayObject);
			
			_detail = new MScrollPanel();
			_detail.setSize(245,260);
			_detail.move(10,8);
			addContent(_detail);
			
			_dialogField = new TextField();
			_dialogField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,4);
			_dialogField.width = 230;
			_dialogField.wordWrap = true;
			_dialogField.mouseEnabled = false;
			_detail.getContainer().addChild(_dialogField);
			
//			_items = new Vector.<NpcFuncItem>();
			_items = [];
			_tile = new MTile(180,24);
			_tile.setSize(204,120);
			_tile.move(13,100);
			_detail.getContainer().addChild(_tile);
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.playerList.self.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function changeSceneHandler(e:SceneModuleEvent):void
		{
			dispose();
		}
		
		private function selfMoveHandler(e:BaseSceneObjInfoUpdateEvent):void
		{
			var selfInfo:SelfScenePlayerInfo = e.currentTarget as SelfScenePlayerInfo;
			var npcInfo:NpcTemplateInfo = NpcTemplateList.getNpc(_info.npcId);
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				dispose();
		}
		
		public function setInfo(info:NpcPopInfo):void
		{
			if(_info == info)return;
			_info = info;
			if(_info)
			{
				createList();
				_dialogField.htmlText = _info.descript;
				_dialogField.height = _dialogField.textHeight + 4;
				_tile.move(20,_dialogField.height+30);
				_tile.setSize(204,26 * _items.length);
				
				_detail.getContainer().height = _dialogField.height + _tile.height + 30;
				_detail.update();
			}
			else
			{
				_dialogField.htmlText = "";
				clear();
				
				_detail.getContainer().height = 0;
				_detail.update();
			}
		}
		
		private function createList():void
		{
			clear();
			
//			var list:Vector.<DeployItemInfo> = _info.deployList;
			var list:Array = _info.deployList;
			for(var i:int = 0; i < list.length; i++)
			{
				var item:NpcFuncItem = new NpcFuncItem(list[i]);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
				_tile.appendItem(item);
				_items.push(item);
			}
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			var item:NpcFuncItem = e.currentTarget as NpcFuncItem;
			DeployEventManager.handle(item.info);
			dispose();
		}
		
		private function clear():void
		{
			_tile.clearItems();
			for each(var item:NpcFuncItem in _items)
			{
				item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
				item.dispose();
			}
			_items.length = 0;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			clear();
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			_items = null;
			_info = null;
			_mediator = null;
		}
	}
}