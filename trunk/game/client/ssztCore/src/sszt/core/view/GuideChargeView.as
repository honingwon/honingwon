package sszt.core.view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskItemInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	
	public class GuideChargeView extends Sprite
	{
		public static var instance:GuideChargeView;
		private var _bg:Bitmap;
		private var _task:TaskItemInfo;
		private var _asset:IMovieWrapper;
		
		public function GuideChargeView()
		{
			super();
			initView();
		}
		
		public static function getInstance():GuideChargeView
		{
			if(instance == null)
			{
				instance = new GuideChargeView();
			}
			return instance;
		}
		
		private function initView():void
		{
			buttonMode = true;
			_task = GlobalData.taskInfo.getTask(CategoryType.FIRST_CHARGE_TASK);
			var _asset:IMovieWrapper = GlobalAPI.movieManagerApi.getMovieWrapper(AssetUtil.getAsset("mhsm.common.GuideChargeAsset",MovieClip) as MovieClip,42,57,9);
			_asset.play();
			addChild(_asset as DisplayObject);
		}
		
		public function show():void
		{
			if(!parent) GlobalAPI.layerManager.getPopLayer().addChild(this);
			sizeChangeHandler(null);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			_task.addEventListener(TaskItemInfoUpdateEvent.TASKINFO_UPDATE,updateHandler);
			this.addEventListener(MouseEvent.CLICK,clickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH - 98;
			this.y = CommonConfig.GAME_HEIGHT - 156;
		}
		
		private function updateHandler(evt:TaskItemInfoUpdateEvent):void
		{
			if(_task.isNewFinish) hide();
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.MAIN,4));
		}
		
		private function overHandler(evt:MouseEvent):void
		{
//			TipsUtil.getInstance().show("首次充值可获得丰富的首冲大礼包哦。",null,new Rectangle(evt.stageX,evt.stageY,0,0));
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.common.firstCharge"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public function hide():void
		{
			_task.removeEventListener(TaskItemInfoUpdateEvent.TASKINFO_UPDATE,updateHandler);
			this.removeEventListener(MouseEvent.CLICK,clickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			if(_asset)
			{
				_asset.dispose();
				_asset = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}