package sszt.scene.components.npcPanel
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskStateType;
	import sszt.core.data.task.TaskTemplateInfo;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.data.task.TaskType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.ui.NpcPanelItemOverAsset;
	
	public class NpcTaskItem extends Sprite implements INPCItem
	{
		private var _hitBg:Shape;
		private var _label:MAssetLabel;
		private var _taskId:int;
		private var _asset:MovieClip;
		private var _bgOver:Bitmap;
		
		public function NpcTaskItem()
		{
			super();
			init();
		}
		
		private function init():void
		{
			buttonMode = true;
			
			_bgOver = new Bitmap(new NpcPanelItemOverAsset());
			addChild(_bgOver);	
			_bgOver.visible = false;
			
			_hitBg = new Shape();
			_hitBg.graphics.beginFill(0xffffff,0);
			_hitBg.graphics.drawRect(0,0,275,22);
			_hitBg.graphics.endFill();
			addChild(_hitBg);
			
			_asset = AssetUtil.getAsset("ssztui.scene.NTalkIconTaskAsset",MovieClip) as MovieClip;
			_asset.gotoAndStop(1);
			_asset.x = 5;
			_asset.y = 2;
			addChild(_asset);
			
			_label = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"left");
			_label.textColor = 0xff9900;
			_label.x = 25;
			_label.y = 3;
			_label.mouseEnabled = false;
			addChild(_label);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
		}
		private function itemOverHandler(evt:MouseEvent):void
		{
			_bgOver.visible = true;
			
		}
		private function itemOutHandler(evt:MouseEvent):void
		{
			_bgOver.visible = false;
		}
		public function setTask(task:TaskItemInfo,state:int):void
		{
//			_label.setValue("[" + TaskType.getNameByType2(task.getTemplate().type) + "]" + task.getTemplate().title);
			_taskId = task.getTemplate().taskId;
			var _state:String = "";
			if(state == TaskStateType.FINISHNOTSUBMIT)
			{
//				_asset.gotoAndStop(2);
				_state = "<font color='#00ff00'>(" + LanguageManager.getWord("ssztl.common.finishLabel") + ")</font>";
			}
			else if(state == TaskStateType.ACCEPTNOTFINISH)
			{
//				_asset.gotoAndStop(4);
				_state = "<font color='#ffffff'>(" + LanguageManager.getWord("ssztl.common.notFinished") + ")</font>";
			}
			
			_label.htmlText = "[" + TaskType.getNameByType2(task.getTemplate().type) + "]" + task.getTemplate().title + _state;
		}
		
		public function setTaskTemplate(task:TaskTemplateInfo):void
		{
			_label.setValue("[" + TaskType.getNameByType2(task.type) + "]" + task.title);
			_taskId = task.taskId;
			_asset.gotoAndStop(3);
		}
		
		public function getTaskId():int
		{
			return _taskId;
		}
		
		public function dispose():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,itemOverHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,itemOutHandler);
			_label = null;
			if(_hitBg)
			{
				_hitBg.graphics.clear();
				_hitBg = null;
			}
			if(parent)parent.removeChild(this);
		}
	}
}