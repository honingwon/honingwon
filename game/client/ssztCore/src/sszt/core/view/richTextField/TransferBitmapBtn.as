/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-15 下午3:15:03 
 * 
 */ 
package sszt.core.view.richTextField
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.button.MBitmapButton;
	
	public class TransferBitmapBtn extends MBitmapButton
	{
		private var _info:DeployItemInfo;
		
		public function TransferBitmapBtn()
		{
			super(AssetSource.getTransferShoes(), "", -1, -1, 1, 1, null);
			this.addEventListener(MouseEvent.CLICK, this.transferBtnClickHandler);
		}
		
		public function set info(value:DeployItemInfo) : void
		{
			this._info = value;
		}
		
		private function transferBtnClickHandler(event:MouseEvent) : void
		{
			GlobalData.npcId = int(this._info.param);
			var vx:Number = Math.floor(this._info.param2 / 10000);
			var vy:Number = this._info.param2 % 10000;
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER, {sceneId:this._info.param1, target:new Point(vx, vy), checkItem:true, type:this._info.param3, targetID:this._info.param}));
		}
		
		override protected function overHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.common.transferBtnTips"), null, new Rectangle(stage.mouseX, stage.mouseY));
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override public function dispose() : void
		{
			this.removeEventListener(MouseEvent.CLICK, this.transferBtnClickHandler);
			super.dispose();
			this._info = null;
		}
	}
}