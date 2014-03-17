/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-8-23 下午3:17:05 
 * 
 */ 
package sszt.core.view.offlineRemind 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.label.MAssetLabel;
	
	public class OfflineRemindView extends Sprite implements IPanel, ITick {
		
		private static var _instance:OfflineRemindView;
		
		private var _offlineBg:Bitmap;
		private var _picPath:String;
		private var _tips:TextField;
		private var _count:int;
		private var _autoLink:TextField;
		private var _txtBreak:MAssetLabel;
		private var _txtReason:MAssetLabel;
		
		public function OfflineRemindView(){
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0, 0.5);
			sp.graphics.drawRect(-1000, -1000, 4000, 4000);
			sp.graphics.endFill();
			addChild(sp);
			_offlineBg = new Bitmap();
			addChild(_offlineBg);
			
			_picPath = GlobalAPI.pathManager.getBannerPath("disconnect.png");
			GlobalAPI.loaderAPI.getPicFile(_picPath, logoAssetCompletHandler,SourceClearType.NEVER);
			
			_txtBreak = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,"left");
			_txtBreak.textColor = 0xff6600;
			_txtBreak.move(80,142);
			addChild(_txtBreak);
			_txtBreak.setHtmlValue("<font size='16'><b>" + LanguageManager.getWord("ssztl.core.offlineTipsBreak") + "</b></font>");
			
			_txtReason = new MAssetLabel(LanguageManager.getWord("ssztl.core.offlineTipsReason"),MAssetLabel.LABEL_TYPE_TAG,"left");
			_txtReason.move(80,196);
			addChild(_txtReason);
//			var bor:BorderAsset5 = new BorderAsset5();
//			addChild(bor);
//			bor.width = 308;
//			bor.height = 131;
//			bor.x = 144;
//			bor.y = 59;
//			var t:BitmapData = (AssetUtil.getAsset("mhsm.logo.RoleBgAsset") as BitmapData);
//			if (t){
//				_offlineBg.bitmapData = t;
//			} else {
//				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.LOGO_ASSET_COMPLETE, logoAssetCompletHandler);
//			};
			
			_tips = new TextField();
			_tips.x = 80;
			_tips.y = 216;
			_tips.width = 260;
			_tips.height = 123;
			addChild(_tips);
			_tips.multiline = true;
			_tips.wordWrap = true;
			_tips.textColor = 0xFFFCCC;
			
			_autoLink = new TextField();
			_autoLink.x = 157;
			_autoLink.y = 160;
			_autoLink.width = 290;
			_autoLink.textColor = 0xFF00;
//			addChild(_autoLink);
			var lostType:int = GlobalData.lostConnectResult;
			var lostStr:String = ""; //LanguageManager.getWord("ssztl.core.offlineTips");
			var urlStr:String = "";
			if (ExternalInterface.available){
				urlStr = ExternalInterface.call("function(){return document.location.href.toString()}");
			};
			if (lostType == 0){
				lostStr = (lostStr + LanguageManager.getWord("ssztl.core.offlineTips1", urlStr));
				autoRefresh();
			} else {
				if (lostType == 1){
					lostStr = (lostStr + LanguageManager.getWord("ssztl.core.offlineTips2", urlStr));
				} else {
					if (lostType == 2){
						lostStr = (lostStr + LanguageManager.getWord("ssztl.core.offlineTips3",urlStr));
					} else {
						if (lostType == 3){
							lostStr = (lostStr + LanguageManager.getWord("ssztl.core.offlineTips4",urlStr));
						} else {
							if (lostType == 4){
								lostStr = (lostStr + LanguageManager.getWord("ssztl.core.offlineTips5", urlStr));
							} else {
								lostStr = (lostStr + LanguageManager.getWord("ssztl.core.offlineTips6", urlStr));
								autoRefresh();
							}
						}
					}
				}
			}
			_tips.htmlText = lostStr;
			initEvent();
			gameSizeHandler(null);
		}
		public static function show():void{
			if (_instance == null){
				_instance = new (OfflineRemindView)();
			}
			GlobalAPI.layerManager.getPopLayer().addChild(_instance);
		}
		
		private function initEvent():void{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeHandler);
		}
		private function removeEvent():void{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeHandler);
		}
		
		private function logoAssetCompletHandler(data:BitmapData):void
		{
			_offlineBg.bitmapData = data;
		}
		private function gameSizeHandler(evt:CommonModuleEvent):void{
			x = ((CommonConfig.GAME_WIDTH - 367) / 2);
			y = ((CommonConfig.GAME_HEIGHT - 315) / 2);
		}
		public function autoRefresh():void{
			_count = 625;
			_autoLink.text = LanguageManager.getWord("ssztl.core.offlineAutoLinkTips", 25);
			if (!(GlobalAPI.tickManager.inTick(this))){
				GlobalAPI.tickManager.addTick(this);
			}
		}
		public function update(time:int, dt:Number=0.04):void{
			_count--;
			if ((_count % 25) == 0){
				_autoLink.text = LanguageManager.getWord("ssztl.core.offlineAutoLinkTips", int((_count / 25)));
			}
			if (_count <= 0){
				if (ExternalInterface.available){
					ExternalInterface.call("location.reload", true);
				}
				if (GlobalAPI.tickManager.inTick(this)){
					GlobalAPI.tickManager.removeTick(this);
				}
			}
		}
		
		public function doEscHandler():void{
			dispose();
		}
		public function dispose():void{
			_tips = null;
			GlobalAPI.loaderAPI.removeAQuote(_picPath,logoAssetCompletHandler);
			if (GlobalAPI.tickManager.inTick(this)){
				GlobalAPI.tickManager.removeTick(this);
			}
			removeEvent();
			if (parent){
				parent.removeChild(this);
			}
			if(_offlineBg)
			{
				_offlineBg = null;
			}
			_txtBreak = null;
			_txtReason = null;
		}
		
	}
}
