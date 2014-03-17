package sszt.scene.components.npcPanel
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.messaging.AbstractConsumer;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskStateType;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.roles.SelfScenePlayerInfo;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.container.MNPCPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	
	import ssztui.ui.NpcPanelItemOverAsset;
	
	public class NpcPanel extends MNPCPanel
	{
		public static const CONTENT_RECT:Rectangle = new Rectangle(159,16,364,171);
		
		private var _mediator:SceneMediator;
		private var _npcInfo:NpcTemplateInfo;
		private var _submitId:int;
		private var _acceptId:int;
		
		private var _containerView:MScrollPanel;
		private var _dialogField:TextField;
		private var _items:Array;
		private var _tile:MTile;
		private var _submitBtn:MCacheAssetBtn1;
		private var _acceptBtn:MCacheAssetBtn1;
		private var _npcAvatar:Bitmap;
		
		private var _bgOver:Bitmap;
		private var _picPath:String;
		public function NpcPanel(mediator:SceneMediator, npcName:String)
		{
			
			super(npcName);
			_mediator = mediator;
			
			initView();
			initEvent();
			
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY,GuideTipDeployType.NPC_TASK));
		}
		
		private function createAvatar():void
		{
			_npcAvatar = new Bitmap();
			_npcAvatar.x = -51;
			_npcAvatar.y = -54;
			_imageLayout.addChild(_npcAvatar);
			_picPath = GlobalAPI.pathManager.getSceneNpcAvatarPath(_npcInfo.iconPath);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.CHANGE_SCENE);
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_npcAvatar.bitmapData = data;
		}		
		
		public function set npcInfo(value:NpcTemplateInfo):void
		{
			if(_npcInfo == value)return;
			if(_npcInfo)
			{
				_dialogField.htmlText = "";
				_dialogField.height = 0;
				_tile.move(20,80);
				_submitBtn.move(130,225);
				_acceptBtn.move(130,225);
				clearList();
				_containerView.getContainer().height = 240;
				_containerView.update();
			}
			_npcInfo = value;
			if(_npcInfo)
			{
				createAvatar();
				
				var namePattern:RegExp = /<%name%>/gi;
				var guildNamePattern:RegExp = /<%guilds_name%>/gi;
				var str:String = _npcInfo.dialog;
				str = str.replace(namePattern, GlobalData.selfPlayer.nick);
				str = str.replace(guildNamePattern, GlobalData.selfPlayer.clubName);
				
				_dialogField.htmlText = str;
				createList();
				_containerView.update();
			}
		}
		
		private function initView():void
		{	
			mouseEnabled = false;
			_containerView = new MScrollPanel();
			_containerView.setSize(CONTENT_RECT.width, CONTENT_RECT.height);
			_containerView.move(CONTENT_RECT.x, CONTENT_RECT.y);
			addChild(_containerView);
			
			_containerView.getContainer().addChild(MBackgroundLabel.getDisplayObject(new Rectangle(0,68,364,11),new MCacheCompartLine2()));
			
			_bgOver = new Bitmap(new NpcPanelItemOverAsset());
//			var matr:Matrix = new Matrix();
//			matr.createGradientBox(275,275,0,0,0);
//			_bgOver.graphics.beginGradientFill(GradientType.LINEAR,[0x265d2b,0x265d2b],[1,0],[0,255],matr,SpreadMethod.PAD);
//			_bgOver.graphics.drawRect(0,0,275,22);	
			_bgOver.x = 0;						
			_containerView.getContainer().addChild(_bgOver);	
			_bgOver.visible = false;
			
			_dialogField = new TextField();
			_dialogField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,4);
			_dialogField.width = 340;
			_dialogField.x = 12;
			_dialogField.y = 12;
			_dialogField.wordWrap = true;
			_dialogField.mouseEnabled = false;
			_containerView.getContainer().addChild(_dialogField);
			
			_items = [];
			_tile = new MTile(275,22);
			_tile.setSize(340,88);
			_tile.move(14,78);
			_tile.itemGapH = _tile.itemGapW = 0;
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_containerView.getContainer().addChild(_tile);
			
			_submitBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.task.finishTask"));
			_submitBtn.move(254,131);
			_containerView.getContainer().addChild(_submitBtn);
			_acceptBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.core.acceptTask"));
			_acceptBtn.move(254,131);
			_containerView.getContainer().addChild(_acceptBtn);
			_submitBtn.visible = _acceptBtn.visible = false;
			
			_containerView.update();
			
			setGuideTipHandler(null);
		}
		
		private function createList():void
		{
//			var result:Vector.<Vector.<TaskItemInfo>> = GlobalData.taskInfo.getTaskNoSubmitByNpcId(_npcInfo.templateId);
//			var canAccepts:Vector.<TaskTemplateInfo> = TaskTemplateList.getCanAcceptTaskByNpcId(_npcInfo.templateId);
			var result:Array = GlobalData.taskInfo.getTaskNoSubmitByNpcId(_npcInfo.templateId);
			var canAccepts:Array = TaskTemplateList.getCanAcceptTaskByNpcId(_npcInfo.templateId);
//			if(result[0].length == 0 && result[1].length == 0 && canAccepts.length == 0 && _npcInfo.deploys.length == 0)
//				return;
			var i:int = 0;
			//添加完成未提交任务
			for(i = 0; i < result[0].length; i++)
			{
				if(result[0][i].getTemplate().condition != TaskConditionType.TRANSPORT)
				{
					var item1:NpcTaskItem = new NpcTaskItem();
					item1.setTask(result[0][i],TaskStateType.FINISHNOTSUBMIT);
					_items.push(item1);
					if(_submitId == 0)
						_submitId = item1.getTaskId();
				}
			}
			//添加可接受任务
			for(i = 0; i < canAccepts.length; i++)
			{
				if(canAccepts[i].condition != TaskConditionType.TRANSPORT)
				{
					var item2:NpcTaskItem = new NpcTaskItem();
					item2.setTaskTemplate(canAccepts[i]);
					_items.push(item2);
					if(_acceptId == 0)
						_acceptId = item2.getTaskId();
				}
			}
			//添加已接未完成任务
			for(i = 0; i < result[1].length; i++)
			{
				if(result[1][i].getTemplate().condition != TaskConditionType.TRANSPORT)
				{
					var item3:NpcTaskItem = new NpcTaskItem();
					item3.setTask(result[1][i],TaskStateType.ACCEPTNOTFINISH);
					_items.push(item3);
				}
			}
			//添加功能性的item
			for(i = 0; i < _npcInfo.deploys.length; i++)
			{
				var item4:NpcFuncItem = new NpcFuncItem(_npcInfo.deploys[i]);
				_items.push(item4);
			}
			//添加返回
			_items.push(new NpcReturnItem());
			
			for each(var j:INPCItem in _items)
			{
				_tile.appendItem(j as DisplayObject);
				j.addEventListener(MouseEvent.CLICK,itemClickHandler);
//				j.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
//				j.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			}
			//_tile.setSize(312, _items.length * 22 + 5);
			
			if(_submitId != 0)
				_submitBtn.visible = true;
			else if(_acceptId != 0)
				_acceptBtn.visible = true;
		}
		
		private function clearList():void
		{
			_tile.clearItems();
			for each(var item:INPCItem in _items)
			{
				item.removeEventListener(MouseEvent.CLICK,itemClickHandler);
//				item.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
//				item.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
				item.dispose();
			}
//			_items = new Vector.<INPCItem>();
			_items = [];
		}
		
		private function initEvent():void
		{
			_submitBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_acceptBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_mediator.sceneInfo.playerList.self.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function removeEvent():void
		{
			_submitBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_acceptBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_mediator.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfMoveHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandler);
		}
		
		private function changeSceneHandler(e:MouseEvent):void
		{
			dispose();
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.NPC_PANEL)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _submitBtn:
					if(!GlobalAPI.checker1 || GlobalAPI.checker1.doCheck({type:"a",param:e}))
					{
						_mediator.showNpcTask(_submitId,_npcInfo.templateId);
					}
					dispose();
					break;
				case _acceptBtn:
					if(!GlobalAPI.checker1 || GlobalAPI.checker1.doCheck({type:"b",param:e}))
					{
						_mediator.showNpcTask(_acceptId,_npcInfo.templateId);
					}
					dispose();
					break;
			}
		}
		
		private function itemClickHandler(evt:MouseEvent):void
		{
			var item:INPCItem = evt.currentTarget as INPCItem;
			if(item is NpcFuncItem)
			{
				if(!(item as NpcFuncItem).copyEnterEnabled)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.scene.copyLeftZero"));
					return;
				}
				var taskInfo:TaskItemInfo = GlobalData.taskInfo.getTask(551007);
				if(taskInfo ==null) taskInfo = GlobalData.taskInfo.getTask(551008);
				if(taskInfo ==null) taskInfo = GlobalData.taskInfo.getTask(551009);
				if(taskInfo != null )
				{
					GlobalData.guideTipInfo = null;
					GuideTip.getInstance().hide();
				}
				
				DeployEventManager.handle((item as NpcFuncItem).info);
			}
			else if(item is NpcTaskItem)
			{
				_mediator.showNpcTask((item as NpcTaskItem).getTaskId(),_npcInfo.templateId);
			}
			else if(item is NpcReturnItem)
			{				
			}
			dispose();
		}
		private function itemOverHandler(evt:MouseEvent):void
		{
			var item:INPCItem = evt.currentTarget as INPCItem;
			if(_bgOver)
			{
				_bgOver.visible = true;
				_bgOver.y = item.y+_tile.y;
			}
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			var item:INPCItem = evt.currentTarget as INPCItem;
			if(_bgOver)
			{
				_bgOver.visible = false;
			}
		}
		
		private function selfMoveHandler(e:BaseSceneObjInfoUpdateEvent):void
		{
			var selfInfo:SelfScenePlayerInfo = e.currentTarget as SelfScenePlayerInfo;
			var dis:Number = Math.sqrt(Math.pow(selfInfo.sceneX - _npcInfo.sceneX,2) + Math.pow(selfInfo.sceneY - _npcInfo.sceneY,2));
			if(dis > CommonConfig.NPC_PANEL_DISTANCE)
				dispose();
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_acceptBtn)
			{
				_acceptBtn.dispose();
				_acceptBtn = null;
			}
			if(_submitBtn)
			{
				_submitBtn.dispose();
				_submitBtn = null;
			}
			if(_bgOver && _bgOver.bitmapData)
			{
//				_bgOver.graphics.clear();
				_bgOver.bitmapData.dispose();
				_bgOver = null;
			}
			for each(var i:INPCItem in _items)
			{
				i.removeEventListener(MouseEvent.CLICK,itemClickHandler);
				i.dispose();
			}
			_items = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_containerView)
			{
				_containerView.dispose();
				_containerView = null;
			}
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
			if(_npcAvatar)
			{
				_npcAvatar = null;
			}
			_npcInfo = null;
			_mediator = null;
		}
	}
}