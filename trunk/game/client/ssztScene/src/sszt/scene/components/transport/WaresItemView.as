package sszt.scene.components.transport
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.task.TaskStateTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.ui.label.MAssetLabel;

	public class WaresItemView extends Sprite
	{
		private var _bg:Bitmap;
		private var _icon:Bitmap;
		private var _name:MAssetLabel;
		private var _reward:MAssetLabel;
		
		private var _taskStateInfo:TaskStateTemplateInfo;
		private var _quality:int;
		
		public function WaresItemView(taskStateInfo:TaskStateTemplateInfo,quality:int)
		{
			_taskStateInfo = taskStateInfo;
			_quality = quality;
			
			initView();
			initEvent();
		}
		private function initView():void
		{
			_bg = new Bitmap(AssetUtil.getAsset("ssztui.scene.TransportItemBgAsset") as BitmapData);
			addChild(_bg);
			
			_icon = new Bitmap(AssetUtil.getAsset("ssztui.scene.TransportIconAsset" +( _quality+1)) as BitmapData);
			_icon.x = 7;
			_icon.y = 54;
			addChild(_icon);
			
			_name = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_name.textColor = CategoryType.getQualityColor(_quality);
			_name.move(53,18);
			addChild(_name);
			_name.setHtmlValue(getQualityName());
			
			_reward = new MAssetLabel("",MAssetLabel.LABEL_TYPE_TITLE2,TextFormatAlign.LEFT);
			_reward.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffff99,null,null,null,null,null,null,null,null,null,6)]);
			_reward.move(14,192);
			addChild(_reward);			
			_reward.setHtmlValue(
				LanguageManager.getWord("ssztl.common.experience") + "：+" + _taskStateInfo.awardExp.toString() + "\n" +
				LanguageManager.getWord("ssztl.common.copper") + "：+" + _taskStateInfo.awardCopper.toString() 
			);
			
		}
		
		private function initEvent():void
		{
			
		}
		private function removeEvent():void
		{
			
		}
		private function getQualityName():String
		{
			switch (_quality)
			{
				case 0:
					return LanguageManager.getWord("ssztl.transport.wares1");
				case 1:
					return LanguageManager.getWord("ssztl.transport.wares2");
				case 2:
					return LanguageManager.getWord("ssztl.transport.wares3");
				case 3:
					return LanguageManager.getWord("ssztl.transport.wares4");
				case 4:
					return LanguageManager.getWord("ssztl.transport.wares5");	
			}
			return LanguageManager.getWord("ssztl.transport.wares1");
			
		}
		public function set selected(value:Boolean):void
		{
			if(value)
			{
				_bg.bitmapData = AssetUtil.getAsset("ssztui.scene.TransportItemBgOverAsset") as BitmapData
			}else{
				_bg.bitmapData = AssetUtil.getAsset("ssztui.scene.TransportItemBgAsset") as BitmapData
			}
		}
		public function move(x:Number,y:Number):void
		{
			this.x = x; 
			this.y = y;
		}
		public function dispose():void
		{
			removeEvent();
		}
		
	}
}