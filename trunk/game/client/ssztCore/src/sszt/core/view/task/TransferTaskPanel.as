/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-2-4 下午3:28:43 
 * 
 */ 
package sszt.core.view.task
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.GuideTip;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.container.MPanel3;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.WinTitleHintAsset;

	public class TransferTaskPanel extends MPanel3 implements ITick
	{
		private static var instance:TransferTaskPanel;
		
		private var _npc:NpcTemplateInfo;
		private var _btn:MCacheAssetBtn1;
		private var _startTime:int;
		private var _content:MAssetLabel;
		private var _count:int;
		
		public function TransferTaskPanel(){
			this._count = 10;
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())) , true, -1, false);
			this.initView();
			this.initEvent();
//			var obj:DeployEventInfo = new DeployItemInfo();
//			obj.deployType = GuideTipDeployType.TASK_MAIN;
//			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GOTO_NEXT_DEPLOY, obj));
		}
		public static function getInstance():TransferTaskPanel{
			if (instance == null){
				instance = new TransferTaskPanel();
			}
			return instance;
		}
		
		private function initView():void{
			setContentSize(330, 100);
			this._content = new MAssetLabel("" ,MAssetLabel.LABEL_TYPE1);
			this._content.move(165, 23);
			addContent(this._content);
			this._btn = new MCacheAssetBtn1(0,4, LanguageManager.getWord("ssztl.task.transferTaskBtn", this._count));
			this._btn.move(120, 65);
			addContent(this._btn);
		}
		private function initEvent():void{
			this._btn.addEventListener(MouseEvent.CLICK, this.btnClickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP, this.setGuideHandler);
		}
		private function removeEvent():void{
			this._btn.removeEventListener(MouseEvent.CLICK, this.btnClickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP, this.setGuideHandler);
		}
		private function setGuideHandler(evt:CommonModuleEvent):void{
			if (GlobalData.guideTipInfo == null){
				return;
			}
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if (info.param1 == GuideTipDeployType.TASK_TRANSFER_PANEL){
				GuideTip.getInstance().show(info.descript, info.param2, new Point(info.param3, info.param4), addContent);
			}
		}
		private function btnClickHandler(e:MouseEvent):void{
			GlobalData.npcId = this._npc.templateId;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER, {
				sceneId:this._npc.sceneId,
				target:new Point(this._npc.sceneX, this._npc.sceneY),
				checkItem:true
			}));
			this.dispose();
		}
		public function update(times:int, dt:Number=0.04):void{
			var time:Number = getTimer();
			if ((time - this._startTime) >= 1000){
				this._count--;
				this._btn.label = LanguageManager.getWord("ssztl.task.transferTaskBtn", this._count);
				this._startTime = time;
			}
			if (this._count == 0){
				this.btnClickHandler(null);
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		public function show(npcId:int):void{
			this._startTime = getTimer();
			this._npc = NpcTemplateList.getNpc(npcId);
			if (this._npc){
				this._content.setHtmlValue(LanguageManager.getWord("ssztl.task.transferTaskAlert", this._npc.name));
			}
			if (!parent){
				GlobalAPI.layerManager.addPanel(this);
			}
			GlobalAPI.tickManager.addTick(this);
		}
		override public function doEscHandler():void{
		}
		override public function dispose():void{
			GlobalAPI.tickManager.removeTick(this);
			this.removeEvent();
			if (this._btn){
				this._btn.dispose();
				this._btn = null;
			}
			if (_content){
				_content = null;
			}
			this._npc = null;
			super.dispose();
			instance = null;
		}
	}
}