package sszt.task.data
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.constData.CategoryType;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.task.TaskStateTemplateInfo;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.accordionItems.IAccordionItemData;
	import sszt.ui.event.CloseEvent;
	
	public class TaskAcceptItemInfo extends EventDispatcher implements IAccordionItemData
	{
		private var _pattern:RegExp = /{[^}]*}/g;
		
		public var taskId:int;
		private var _template:TaskTemplateInfo;
		
		public function TaskAcceptItemInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function getCurrentState():TaskStateTemplateInfo
		{
			return getTemplate().states[0];
		}
		
		public function getTemplate():TaskTemplateInfo
		{
			if(_template == null)
			{
				_template = TaskTemplateList.getTaskTemplate(taskId);
			}
			return _template;
		}
		
		public function getDeployInfo():DeployItemInfo
		{
			var target:String = getTemplate().target;
			var mes:String = target.slice(target.indexOf("{"),target.indexOf("}")+1);
			var deploy:String = mes.slice(1,mes.length-1);
			var list:Array = deploy.split("#");
			var deployInfo:DeployItemInfo = new DeployItemInfo();
			deployInfo.type = list[0];
			deployInfo.param1 = list[2];
			deployInfo.descript = list[1];
			return deployInfo;
		}
		
		public function getAccordionItem(width:int):DisplayObject
		{
			var sp:Sprite = new Sprite();
			
			var value:String = "";
			value += "[" + getTemplate().minLevel + "]" + getTemplate().title;
//			while(value.length < 12)value += " ";
//			value += "地点：<u><font color='#FFCC00'>" + MapTemplateList.getMapTemplate(NpcTemplateList.getNpc(getTemplate().npc).sceneId).name + "</font></u>";
//			value += LanguageManager.getWord("ssztl.common.place")+":<u><font color='#FFCC00'>" + MapTemplateList.getMapTemplate(NpcTemplateList.getNpc(getTemplate().npc).sceneId).name + "</font></u>";
			
//			while(value.length < 22)value += " ";
//			var target:String = getTemplate().target;
//			var list:Array = target.match(_pattern);
//			var descript:String;
//			for(var i:int = 0; i < list.length; i++)
//			{
//				descript = String(list[i]).split("#")[1];
//				target = target.replace(list[i],"<font color='#FFCC00'><u>" + descript + "</u></font>");
//			}
//			value += "  "+LanguageManager.getWord("ssztl.common.target")+":" + target;
			var field:TextField = new TextField();
			field.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			field.filters = [new GlowFilter(0x17380F,1,2,2,10)];
			field.width = width;
			field.height = 20;
			field.mouseEnabled = false;
			field.htmlText = value;
			sp.addChild(field);
			
//			if(getTemplate().canTransfer)
//			{
//				var rect:Rectangle = getCharBoundaries(field,field.text.length - 1);
//				var btn:MBitmapButton = new MBitmapButton(AssetSource.TaskTransfer);
//				btn.move(rect.x + 20,rect.y - 5);
//				sp.addChild(btn);
//				btn.addEventListener(MouseEvent.CLICK,transferClickHandler);
//			}
			
			return sp;
		}
		
		private function transferClickHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
//			var count:int =  GlobalData.bagInfo.getItemCountById(CategoryType.TRANSFER);
			if(!GlobalData.selfPlayer.canfly())
			{
//				MAlert.show("飞天神靴不足，是否马上购买？","提示",MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
				MAlert.show(LanguageManager.getWord("ssztl.common.transferNotEnough"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,transferCloseHandler);
			}
			else
			{
				var sceneId:int = NpcTemplateList.getNpc(getTemplate().npc).sceneId;
//				var sceneX:int = NpcTemplateList.getNpc(getTemplate().npc).sceneX;
//				var sceneY:int = NpcTemplateList.getNpc(getTemplate().npc).sceneY;
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:sceneId,target:NpcTemplateList.getNpc(getTemplate().npc).getAPoint()}));
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
	}
}