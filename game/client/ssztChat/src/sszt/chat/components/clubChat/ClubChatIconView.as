/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午2:01:30 
 * 
 */ 
package sszt.chat.components.clubChat 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sszt.chat.events.ChatMediatorEvent;
	import sszt.chat.mediators.ChatMediator;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	
	public class ClubChatIconView extends Sprite implements ITick {
		
		private var _bg:Bitmap;
		private var _countLabel:TextField;
		private var _mediator:ChatMediator;
		private var _isFlash:Boolean;
		private var _currentIndex:int = 0;
		
		public function ClubChatIconView(mediator:ChatMediator){
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void{
			buttonMode = true;
			tabEnabled = false;
			_bg = new Bitmap();
			var t:BitmapData = (AssetUtil.getAsset("ssztui.common.ImMsgClubAsset") as BitmapData);
			_bg.bitmapData = t;
//			if (t)
//			{
//				_bg.bitmapData = t;
//			}
//			else {
//				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.COMMON_ASSET_COMPLETE, commonCompleteHandler);
//			}
			addChild(_bg);
		}
		public function show(isFlash:Boolean, unReadCount:int=0):void{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, sizeChangeHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			sizeChangeHandler(null);
			flash = isFlash;
			GlobalAPI.layerManager.getPopLayer().addChild(this);
		}
		
		public function setUnReadCount(value:int):void{
			if (value > 0 && GlobalData.clubChatInfo.isFlash)
			{
				flash = true;
			}
		}
		
		public function hide():void{
			flash = false;
			removeEventListener(MouseEvent.CLICK, clickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, sizeChangeHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.COMMON_ASSET_COMPLETE, commonCompleteHandler);
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		private function clickHandler(evt:MouseEvent):void{
			GlobalData.clubChatInfo.unReadCount = 0;
			_mediator.chatModule.facade.sendNotification(ChatMediatorEvent.SHOW_CLUB_CHAT);
			hide();
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void{
			x = ((CommonConfig.GAME_WIDTH / 2));
			y = (CommonConfig.GAME_HEIGHT - 100);
		}
		
		public function set flash(value:Boolean):void{
			if (_isFlash == value){
				return;
			}
			_isFlash = value;
			if (value)
			{
				GlobalAPI.tickManager.addTick(this);
			} else {
				GlobalAPI.tickManager.removeTick(this);
				alpha = 1;
			}
		}
		
		public function update(times:int, dt:Number=0.04):void{
			if (_currentIndex < 12){
				alpha = (alpha - 0.08);
			} else {
				alpha = (alpha + 0.08);
			}
			_currentIndex++;
			if (_currentIndex >= 25){
				alpha = 1;
				_currentIndex = 0;
			}
		}
		
//		private function commonCompleteHandler(evt:CommonModuleEvent):void{
//			_bg.bitmapData = (AssetUtil.getAsset("ssztui.common.ClubIconAsset") as BitmapData);
//		}
		
		public function dispose():void{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, sizeChangeHandler);
//			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.COMMON_ASSET_COMPLETE, commonCompleteHandler);
			removeEventListener(MouseEvent.CLICK, clickHandler);
			_bg = null;
			_countLabel = null;
			if (parent){
				parent.removeChild(this);
			};
		}
		
	}
}
