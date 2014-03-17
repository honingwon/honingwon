package sszt.target.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.target.TaskIconOnAsset;
	
	/**
	 * 获得成就 ItemView 
	 * @author chendong
	 * 
	 */	
	public class GetAchItemView extends Sprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		/**
		 * 成就名称
		 */		
		private var _achName:MAssetLabel;
		
		/**
		 * 成就点数
		 */		
		private var _achNum:MAssetLabel;
		
		public var _info:TargetTemplatInfo;
		
		public function GetAchItemView(info:TargetTemplatInfo)
		{
			super();
			_info = info;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,177,30);
			graphics.endFill();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,28,177,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,5,18,18),new Bitmap(new TaskIconOnAsset())),
			]); 
			addChild(_bg as DisplayObject);
			
			_achName = new MAssetLabel("", MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
			_achName.textColor = 0xd4a853;
			_achName.move(28,6);
			addChild(_achName);
			
			_achNum = new MAssetLabel("", MAssetLabel.LABEL_TYPE21, TextFormatAlign.LEFT);
			_achNum.move(139,6);
			addChild(_achNum);
		}
		
		public function initEvent():void
		{
		}
		
		public function initData():void
		{
			_achName.setValue(_info.title);
			_achNum.setValue("+" + _info.achievement.toString());
		}
		
		public function clearData():void
		{
		}
		
		public function removeEvent():void
		{
		}
		
		public function dispose():void
		{
			
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}