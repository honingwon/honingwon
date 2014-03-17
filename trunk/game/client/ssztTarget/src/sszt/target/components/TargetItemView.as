package sszt.target.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.target.TargetData;
	import sszt.core.data.target.TargetTemplatInfo;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.events.ModuleEvent;
	import sszt.events.TargetMediaEvents;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.target.TaskIconOffAsset;
	import ssztui.target.TaskIconOnAsset;
	import ssztui.ui.BarAsset3;
	
	/**
	 * 目标完成项 
	 * @author chendong
	 * 
	 */	
	public class TargetItemView extends Sprite implements IPanel
	{
		protected var _select:Boolean;
		protected static var SELECTED_BITMAP:Sprite;
		{
			SELECTED_BITMAP = MBackgroundLabel.getDisplayObject(new Rectangle(0,0,310,26),new BarAsset3()) as Sprite;
			SELECTED_BITMAP.mouseEnabled = false;
			SELECTED_BITMAP.mouseChildren = false;
		}
		protected static var OVER_BITMAP:Sprite;
		{
			OVER_BITMAP = MBackgroundLabel.getDisplayObject(new Rectangle(0,0,310,26),new BarAsset3()) as Sprite;
			OVER_BITMAP.mouseEnabled = false;
			OVER_BITMAP.mouseChildren = false;
			OVER_BITMAP.alpha = 0.7;
		}
		
		public var _info:TargetTemplatInfo;
		protected var _itemField:MAssetLabel;
		private var _itemState:MAssetLabel;
		
		private var _icon:Bitmap;
		
		public function TargetItemView(info:TargetTemplatInfo)
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
			graphics.drawRect(0,0,275,26);
			graphics.endFill();
			buttonMode = true;
			
			// TODO Auto Generated method stub
			this._itemField = new MAssetLabel("", MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
			this._itemField.move(35,5);
			addChild(this._itemField);
			
			_itemState = new MAssetLabel("",MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
			_itemState.move(200,5);
			addChild(_itemState);
			
			_icon = new Bitmap();
			_icon.x = 12;
			_icon.y = 3;
			addChild(_icon);
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
		}
		
		public function initData():void
		{
			var targetData:TargetData;
			var text:String = "";
			targetData = GlobalData.targetInfo.targetByIdDic[_info.target_id];
			if(!targetData)
			{
				// 未完成
				_itemField.textColor = _itemState.textColor = 0xff9900;
				_icon.bitmapData = new TaskIconOnAsset() as BitmapData;
				text = LanguageManager.getWord("ssztl.common.notFinished");
			}
			else if(targetData)
			{
				if(!targetData.isFinish && !targetData.isReceive)//在完成过程当中
				{
					// 未完成
					_itemField.textColor = _itemState.textColor = 0xff9900;
					_icon.bitmapData = new TaskIconOnAsset() as BitmapData;
					text = LanguageManager.getWord("ssztl.common.notFinished");
				}
				if(targetData.isFinish && targetData.isReceive)
				{
					// 已领取奖励
					_itemField.textColor = _itemState.textColor = 0x7a6b54;
					_icon.bitmapData = new TaskIconOffAsset() as BitmapData;
					text = LanguageManager.getWord("ssztl.activity.hasGotten");
				}
				else if(targetData.isFinish && !targetData.isReceive)
				{
					// 已完成 未领取奖励
					_itemField.textColor = _itemState.textColor = 0x33cc00;
					_icon.bitmapData = new TaskIconOnAsset() as BitmapData;
					text = LanguageManager.getWord("ssztl.common.hasFinished");
				}
			} 
			
			_itemField.setValue(_info.title);
			_itemState.setValue("(" + text + ")");
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
			this.addEventListener(MouseEvent.CLICK, this.linkClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardTA);
			ModuleEventDispatcher.addModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetList);
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			this.removeEventListener(MouseEvent.CLICK, this.linkClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.GET_TARGET_AWARD,getTargetAwardTA);
			ModuleEventDispatcher.removeModuleEventListener(TargetMediaEvents.UPDATE_TARGET_LIST,updateTargetList);
		}
		
		public function move(x:Number, y:Number):void
		{
			// TODO Auto Generated method stub
			this.x = x;
			this.y = y;
		}
		
		
		private function linkClickHandler(event:MouseEvent):void
		{
			this.select = true;;
		}
		
		private function overHandler(e:MouseEvent):void
		{
			addChildAt(OVER_BITMAP,0);
		}
		private function outHandler(e:MouseEvent):void
		{
			if(OVER_BITMAP.parent)
				OVER_BITMAP.parent.removeChild(OVER_BITMAP);
		}
		
		private function getTargetAwardTA(evt:ModuleEvent):void
		{
			if(TargetTemplateList.getTargetByIdTemplate(int(evt.data.targetId)).type == 0)
			{
				if(int(evt.data.targetId) == _info.target_id)
				{
					// 已领取奖励
					_itemField.textColor = 0x7a6b54;
					_icon.bitmapData = new TaskIconOffAsset() as BitmapData;
				}
			}
		}
		
		private function updateTargetList(evt:ModuleEvent):void
		{
			initData();
		}
		
		public function set select(value:Boolean):void
		{
			_select = value;
			if(_select)
			{
				addChildAt(SELECTED_BITMAP,0);
			}
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function dispose():void
		{
			
		}
	}
}