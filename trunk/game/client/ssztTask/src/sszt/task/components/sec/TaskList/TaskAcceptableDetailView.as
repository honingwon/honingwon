package sszt.task.components.sec.TaskList
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.constData.CareerType;
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.task.TaskAwardTemplateInfo;
	import sszt.core.data.task.TaskConditionType;
	import sszt.core.data.task.TaskItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.task.components.sec.items.TaskAwardCell;
	import sszt.task.data.TaskAcceptItemInfo;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	
	import ssztui.task.TaskDetailTitleAsset;
	import ssztui.task.TaskDetailTitleAsset1;
	import ssztui.task.TaskDetailTitleAsset2;
	
	public class TaskAcceptableDetailView extends MScrollPanel
	{
		private const PLAYER_NAME:String = "<%name%>";
		private const CAREER_NAME:String = "<%career%>";
		
		private var _title:Bitmap;
		private var _title1:Bitmap;
		private var _title2:Bitmap;
		
		private var _info:TaskAcceptItemInfo;
		private var _descriptField:TextField;
		private var _targetField:TextField;
		private var _awardField:TextField;
		private var _tile:MTile;
		//		private var _awardList:Vector.<TaskAwardCell>;
		private var _awardList:Array;
		//		private var _deployList:Vector.<DeployItemInfo>;
		private var _deployList:Array
		private var _transferBtn:MBitmapButton;
		
		public function TaskAcceptableDetailView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			width = 312;
			height = 340;
			verticalScrollPolicy = ScrollPolicy.OFF;
			
			_title = new Bitmap(new TaskDetailTitleAsset());
			_title.x = 18;
			_title.y = 12;
			getContainer().addChild(_title);
			_title1 = new Bitmap(new TaskDetailTitleAsset1());
			_title1.x = 18;
			_title1.y = 96;
			getContainer().addChild(_title1);
			_title2 = new Bitmap(new TaskDetailTitleAsset2());
			_title2.x = 18;
			_title2.y = 166;
			getContainer().addChild(_title2);
			
			//			_deployList = new Vector.<DeployItemInfo>();
			_deployList = [];
			
			_descriptField = createContentField();
			getContainer().addChild(_descriptField);
			_targetField = createContentField();
			getContainer().addChild(_targetField);
			_awardField = createContentField();
			getContainer().addChild(_awardField);
			
			//			_awardList = new Vector.<TaskAwardCell>();
			_awardList = [];
			_tile = new MTile(38, 38, 4);
			_tile.setSize(170,100);
			_tile.itemGapH = 15;
			_tile.itemGapW = 6;
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			getContainer().addChild(_tile);
			
			if(_info == null)getContainer().visible = false;
		}
		
		private function initEvent():void
		{
			addEventListener(TextEvent.LINK,textLinkClickHandler);
			if(_info)_info.addEventListener(TaskItemInfoUpdateEvent.TASKINFO_UPDATE,infoUpdateHandler);
		}
		
		private function removeEvent():void
		{
			removeEventListener(TextEvent.LINK,textLinkClickHandler);
			if(_info)_info.removeEventListener(TaskItemInfoUpdateEvent.TASKINFO_UPDATE,infoUpdateHandler);
		}
		
		private function infoUpdateHandler(e:TaskItemInfoUpdateEvent):void
		{
			var taskInfo:TaskAcceptItemInfo = e.currentTarget as TaskAcceptItemInfo;
//			if(taskInfo.isExist == false)
//			{
//				clearView();
//			}
		}
		
		private function createContentField():TextField
		{
			var textfield:TextField = new TextField();
			textfield.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,null,null,null,null,3);
			textfield.width = 275;
			textfield.x = 10;
			textfield.selectable = false;
			textfield.wordWrap = true;
			return textfield;
		}
		
		public function set info(value:TaskAcceptItemInfo):void
		{
			if(_info == value)return;
			if(_info)
			{
				removeEvent();
				clearView();
			}
			_info = value;
			if(_info)
			{
				setView();
				initEvent();
			}
		}
		
		private function setView():void
		{
			var content:String = _info.getCurrentState().content[_info.getCurrentState().content.length  - 1];
			content = content.split(PLAYER_NAME).join("[" + GlobalData.selfPlayer.serverId + "]" + GlobalData.selfPlayer.nick);
			content = content.split(CAREER_NAME).join(CareerType.getNameByCareer(GlobalData.selfPlayer.career))
			_descriptField.text = content;
			_descriptField.height = _descriptField.textHeight + 5;
			
			var target:String = _info.getCurrentState().target;
			while(target.indexOf("{") != -1 && target.indexOf("{") < target.indexOf("}"))
			{
				var mes:String = target.slice(target.indexOf("{"),target.indexOf("}")+1);
				var deploy:String = mes.slice(1,mes.length-1);
				var list:Array = deploy.split("#");
				var deployInfo:DeployItemInfo = new DeployItemInfo();
				deployInfo.type = list[0];
				deployInfo.param1 = list[2];
				deployInfo.descript = list[1];
				_deployList.push(deployInfo);
				target = target.replace(mes,deployInfo.descript);
			}
			
			var targets:String = "";;
			var condition:int = _info.getCurrentState().condition;
			if(TaskConditionType.getIsFindNpc(condition))
			{
				//				targets += "<a href='event:taskDetailLink" + i + "'>";
				//				targets += "地点：";
				//				targets += "<u><font color='#FFCC00'>" + MapTemplateList.getMapTemplate(NpcTemplateList.getNpc(_info.getCurrentState().npc).sceneId).name + "</font></u>";
				//				targets += "\t\t目标：";
				//				targets += "<u><font color='#FFCC00'>" + NpcTemplateList.getNpc(_info.getCurrentState().npc).name + "</font></u>";
				//				targets += "</a>";
				
				targets += "<a href='event:taskDetailLink" + i + "'>";
				targets += LanguageManager.getWord("ssztl.common.place")+"：";
				targets += "<u><font color='#FFCC00'>" + MapTemplateList.getMapTemplate(NpcTemplateList.getNpc(_info.getCurrentState().npc).sceneId).name + "</font></u>";
				targets += "\t\t"+LanguageManager.getWord("ssztl.common.target")+"：";
				targets += "<u><font color='#FFCC00'>" + NpcTemplateList.getNpc(_info.getCurrentState().npc).name + "</font></u>";
				targets += "</a>";
			}
			else if(TaskConditionType.getIsKillMonster(condition))
			{
				targets += "<a href='event:taskDetailLink" + i + "'>";
				for(var i:int = 0; i < _info.getCurrentState().data.length; i++)
				{
					//					targets += "地点：";
					//					targets += "<u><font color='#FFCC00'>" + MapTemplateList.getMapTemplate(MonsterTemplateList.getMonster(_info.getCurrentState().getObjId(i)).sceneId).name + "</font></u>";
					//					targets += "\t\t目标：";
					//					targets += "<u><font color='#FFCC00'>" + MonsterTemplateList.getMonster(_info.getCurrentState().getObjId(i)).name + "</font></u>";
					//					targets += "\n";
					
					targets += LanguageManager.getWord("ssztl.common.place")+"：";
					targets += "<u><font color='#FFCC00'>" + MapTemplateList.getMapTemplate(MonsterTemplateList.getMonster(_info.getCurrentState().getObjId(i)).sceneId).name + "</font></u>";
					targets += "\t\t"+LanguageManager.getWord("ssztl.common.target")+"：";
					targets += "<u><font color='#FFCC00'>" + MonsterTemplateList.getMonster(_info.getCurrentState().getObjId(i)).name + "</font></u>";
					targets += "\n";
				}
				targets = targets.slice(0,targets.length - 1);
				targets += "</a>";
			}
			else if(TaskConditionType.getIsCollectItemTask(condition))
			{
				targets += "<a href='event:taskDetailLink" + i + "'>";
				for(var j:int = 0; j < _info.getCurrentState().data.length; j++)
				{
					//					targets += "地点：";
					//					targets += "<u><font color='#FFCC00'>" + MapTemplateList.getMapTemplate(CollectTemplateList.getCollect(_info.getCurrentState().getObjId(j)).sceneId).name + "</font></u>";
					//					targets += "\t\t目标：";
					//					targets += "<u><font color='#FFCC00'>" + CollectTemplateList.getCollect(_info.getCurrentState().getObjId(j)).name + "</font></u>";
					
					targets += LanguageManager.getWord("ssztl.common.place")+"：";
					targets += "<u><font color='#FFCC00'>" + MapTemplateList.getMapTemplate(CollectTemplateList.getCollect(_info.getCurrentState().getObjId(j)).sceneId).name + "</font></u>";
					targets += "\t\t"+LanguageManager.getWord("ssztl.common.target")+"：";
					targets += "<u><font color='#FFCC00'>" + CollectTemplateList.getCollect(_info.getCurrentState().getObjId(j)).name + "</font></u>";
				}
				targets = targets.slice(0,targets.length - 1);
				targets += "</a>";
			}
			else
			{
				targets = target;
			}
			_targetField.htmlText = targets;
			_targetField.height = _targetField.textHeight + 5;
			if(_info.getCurrentState().canTransfer)
			{
				var rect:Rectangle = getCharBoundaries(_targetField,_targetField.text.length - 1);
				_transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
				_transferBtn.move(rect.x + _targetField.x + 20,rect.y + _targetField.y - 5);
				addChild(_transferBtn);
				_transferBtn.addEventListener(MouseEvent.CLICK,transferClickHandler);
			}
			
			var awards:String = "";
			//			if(_info.getCurrentState().awardExp > 0)awards += "经验：" + _info.getCurrentState().awardExp + "\n";
			//			if(_info.getCurrentState().awardCopper > 0)awards += "铜币：" + _info.getCurrentState().awardCopper + "\n";
			//			if(_info.getCurrentState().awardBindCopper > 0)awards += "绑定铜币：" + _info.getCurrentState().awardBindCopper + "\n";
			//			if(_info.getCurrentState().awardYuanBao > 0)awards += "元宝：" + _info.getCurrentState().awardYuanBao + "\n";
			//			if(_info.getCurrentState().awardBindYuanBao > 0)awards += "绑定元宝：" + _info.getCurrentState().awardBindYuanBao + "\n";
			//			if(_info.getCurrentState().awardLifeExp > 0)awards += "历练：" + _info.getCurrentState().awardLifeExp + "\n";
			//			if(_info.getCurrentState().contribution > 0)awards += "帮会物资：" + _info.getCurrentState().contribution + "\n";
			//			if(_info.getCurrentState().money > 0)awards += "帮会财富：" + _info.getCurrentState().money + "\n";
			//			if(_info.getCurrentState().active > 0)awards += "帮会繁荣：" + _info.getCurrentState().active + "\n";
			//			if(_info.getCurrentState().exploit > 0)awards += "个人功勋：" + _info.getCurrentState().exploit;
			
			if(_info.getCurrentState().awardExp > 0)awards += LanguageManager.getWord("ssztl.common.experience") + "：<font color='#00cc00'>" + _info.getCurrentState().awardExp + "</font>　　";
			if(_info.getCurrentState().awardCopper > 0)awards +=  LanguageManager.getWord("ssztl.common.copper") + "：<font color='#00cc00'>" + _info.getCurrentState().awardCopper + "</font>　　";
			if(_info.getCurrentState().awardBindCopper > 0)awards +=  LanguageManager.getWord("ssztl.common.bindCopper2") + "：<font color='#00cc00'>" + _info.getCurrentState().awardBindCopper + "</font>　　";
			if(_info.getCurrentState().awardYuanBao > 0)awards +=  LanguageManager.getWord("ssztl.common.yuanBao") + "：" + _info.getCurrentState().awardYuanBao + "</font>　　";
			if(_info.getCurrentState().awardBindYuanBao > 0)awards +=  LanguageManager.getWord("ssztl.common.bindYuanBao2") + "：<font color='#00cc00'>" + _info.getCurrentState().awardBindYuanBao + "</font>　　";
			if(_info.getCurrentState().awardLifeExp > 0)awards +=  LanguageManager.getWord("ssztl.common.liftExp3") + "：<font color='#00cc00'>" + _info.getCurrentState().awardLifeExp + "</font>　　";
			if(_info.getCurrentState().contribution > 0)awards +=  LanguageManager.getWord("ssztl.common.clubMoney2") + "：<font color='#00cc00'>" + _info.getCurrentState().contribution + "</font>　　";
			if(_info.getCurrentState().money > 0)awards +=  LanguageManager.getWord("ssztl.common.clubMoney2") + "：<font color='#00cc00'>" + _info.getCurrentState().money + "</font>　　";
			if(_info.getCurrentState().active > 0)awards +=  LanguageManager.getWord("ssztl.common.clubActiveDegree") + "：<font color='#00cc00'>" + _info.getCurrentState().active + "</font>　　";
			if(_info.getCurrentState().exploit > 0)awards +=  LanguageManager.getWord("ssztl.club.personalContribute2") + "：<font color='#00cc00'>" + _info.getCurrentState().exploit + "</font>";
			
			_awardField.htmlText = awards;
			_awardField.height = _awardField.textHeight + 5;
			
			clearItems();
			for each(var info:TaskAwardTemplateInfo in _info.getCurrentState().getSelfAwardList())
			{
				var item:TaskAwardCell = new TaskAwardCell();
				item.taskAwardInfo = info;
				_tile.appendItem(item);
				_awardList.push(item);
			}
			
			updateSize();
		}
		
		private function transferClickHandler(e:MouseEvent):void
		{
			//			var count:int =  GlobalData.bagInfo.getItemCountById(CategoryType.TRANSFER);
			if(!GlobalData.selfPlayer.canfly())
			{
				//				MAlert.show("飞天神靴不足，是否马上购买？","提示",MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
				MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
			}
			else
			{
				var sceneId:int;
				//				var sceneX:int;
				//				var sceneY:int;
				var point:Point;
				var condition:int = _info.getCurrentState().condition;
				if(condition == TaskConditionType.KILLMONSTER || condition == TaskConditionType.DROP_MONSTER || condition == TaskConditionType.COLLECT_MONSTER || condition == TaskConditionType.HONGMING_KILLMONSTER)
				{
					sceneId = MonsterTemplateList.getMonster(_deployList[0].param1).sceneId;
					//					sceneX = MonsterTemplateList.getMonster(_deployList[0].param1).centerX;
					//					sceneY = MonsterTemplateList.getMonster(_deployList[0].param1).centerY;
					point = MonsterTemplateList.getMonster(_deployList[0].param1).getAPoint();
				}
				else if(condition == TaskConditionType.DIALOG || condition == TaskConditionType.CLIENT_CONTROL || condition == TaskConditionType.COLLECT_NPC || condition == TaskConditionType.JOIN_CLUB)
				{
					sceneId = NpcTemplateList.getNpc(_deployList[0].param1).sceneId;
					//					sceneX = NpcTemplateList.getNpc(_deployList[0].param1).sceneX;
					//					sceneY = NpcTemplateList.getNpc(_deployList[0].param1).sceneY;
					point = NpcTemplateList.getNpc(_deployList[0].param1).getAPoint();
				}
				else if(condition == TaskConditionType.COLLECT_ITEM || condition == TaskConditionType.HONGMING_COLLECT)
				{
					sceneId = CollectTemplateList.getCollect(_deployList[0].param1).sceneId;
					//					sceneX = CollectTemplateList.getCollect(_deployList[0].param1).centerX;
					//					sceneY = CollectTemplateList.getCollect(_deployList[0].param1).centerY;
					point = CollectTemplateList.getCollect(_deployList[0].param1).getAPoint();
				}
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:sceneId,target:point}));
			}
		}
		
		private function transferCloseHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				//				BuyPanel.getInstance().show(Vector.<int>([CategoryType.TRANSFER]),new ToStoreData(1));
				BuyPanel.getInstance().show([CategoryType.TRANSFER],new ToStoreData(ShopID.QUICK_BUY));
			}
		}
		
		private function getCharBoundaries(textField:TextField,index:int):Rectangle
		{
			var result:Rectangle = textField.getCharBoundaries(index);
			if(!result)
			{
				var n:int = textField.getLineIndexOfChar(index);
				if(textField.bottomScrollV < n)
				{
					var t:int = textField.scrollV;
					textField.scrollV = n;
					result = textField.getCharBoundaries(index);
					textField.scrollV = t;
				}
			}
			return result;
		}
		
		private function updateSize():void
		{
			if(_info)
			{
				getContainer().visible = true;
			}
			var currentHeight:int = 33;
			_descriptField.y = currentHeight;
			currentHeight += 83;
			if(_transferBtn)
			{
				_transferBtn.y = _transferBtn.y - _targetField.y + currentHeight;
			}
			_targetField.y = currentHeight;
			currentHeight += 75;
			_awardField.y = currentHeight;
			_tile.move(12, 212);
			update();
		}
		
		private function textLinkClickHandler(e:TextEvent):void
		{
			for(var i:int = 0; i < _deployList.length; i++)
			{
				if(e.text == ("taskDetailLink" + i))
				{
					DeployEventManager.handle(_deployList[i]);
				}
			}
		}
		
		private function clearView():void
		{
			_descriptField.text = "";
			_targetField.text = "";
			_awardField.text = "";
			if(_transferBtn)
			{
				_transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
				_transferBtn.dispose();
				_transferBtn = null;
			}
			clearItems();
			//			_deployList = new Vector.<DeployItemInfo>();
			_deployList = [];
			
			getContainer().height = 0;
			update();
		}
		
		private function clearItems():void
		{
			_tile.clearItems();
			if(_awardList)
			{
				for(var i:int = 0; i < _awardList.length; i++)
				{
					_awardList[i].dispose();
					_awardList[i] = null;
				}
			}
			//			_awardList = new Vector.<TaskAwardCell>();
			_awardList = [];
		}
		
		public function get info():TaskAcceptItemInfo
		{
			return _info;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			clearItems();
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			if(_transferBtn)
			{
				_transferBtn.removeEventListener(MouseEvent.CLICK,transferClickHandler);
				_transferBtn.dispose();
				_transferBtn = null;
			}
			_descriptField = null;
			_targetField = null;
			_awardField = null;
			_info = null;
		}
	}
}