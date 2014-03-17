/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-3-7 上午9:57:38 
 * 
 */ 
package sszt.scene.components
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.DescriptManager;
	import sszt.core.utils.FontTextFieldCreator;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MAlert;
	import sszt.ui.label.MAssetLabel;
	
	public class SceenShowWordView extends Sprite {
		
		private static var _instance:SceenShowWordView;
		
		private var _wordContentLabel:TextField;
		private var _timer:Timer;
		
		public function SceenShowWordView(){
			this.initView();
			this.initEvent();
		}
		
		public static function getInstance():SceenShowWordView{
			if (_instance == null){
				_instance = new (SceenShowWordView)();
			}
			return (_instance);
		}
		
		private function initView():void{
			mouseChildren = (mouseEnabled = false);
			var tf:Array = MAssetLabel.LABEL_TYPE_STORY;
			tf[0].align = TextFormatAlign.CENTER;
			this._wordContentLabel = FontTextFieldCreator.getFontTextField();
			this._wordContentLabel.defaultTextFormat = tf[0];
			this._wordContentLabel.setTextFormat(tf[0]);
			this._wordContentLabel.filters = [tf[1]];
			this._wordContentLabel.height = 60;
			this._wordContentLabel.width = 800;
			addChild(this._wordContentLabel);
			this.gameSizeHandler(null);
			this._timer = new Timer(10000);
			this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
		}
		
		private function timerHandler(e:TimerEvent):void{
			this.dispose();
		}
		
		public function initEvent():void{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, this.gameSizeHandler);
		}
		
		public function removeEvent():void{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, this.gameSizeHandler);
		}
		
		private function gameSizeHandler(e:CommonModuleEvent):void{
			x = ((CommonConfig.GAME_WIDTH - this._wordContentLabel.width) / 2 + 60);
			y = (CommonConfig.GAME_HEIGHT - 155);
		}
		
		public function show(argDescriptionId:int):void{
			var str:String = DescriptManager.getDescription(argDescriptionId.toString());
			if (str == null || str == "")
			{
				return;
			}
			this._wordContentLabel.text = str;
			this.gameSizeHandler(null);
			this._timer.reset();
			this._timer.start();
			if (parent == null){
				GlobalAPI.layerManager.getTipLayer().addChild(this);
			}
		}
		
		public function showDescription(argDes:String):void{
			var str:String = argDes;
			if (str == null || str == ""){
				return;
			}
			this._wordContentLabel.text = str;
			this.gameSizeHandler(null);
			this._timer.reset();
			this._timer.start();
			if (parent == null){
				GlobalAPI.layerManager.getTipLayer().addChild(this);
			}
		}
		
		public function dispose():void{
			this.removeEvent();
			if (this._timer){
				this._timer.stop();
				this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
				this._timer = null;
			}
			this._wordContentLabel = null;
			_instance = null;
			if (parent){
				parent.removeChild(this);
			}
		}
		
		
	}
}
