package sszt.activity.components.itemView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.view.tips.TipsUtil;
	
	public class LinkItemView extends Sprite
	{
		private var id:int;
		private var count:int;
		private var _template:ItemTemplateInfo;
		private var _label:TextField;
		private var _timeoutIndex:int = -1;
		
		public function LinkItemView(id:int,count:int)
		{
			this.id = id;
			this.count = count;
			_template = ItemTemplateList.getTemplate(id);
			super();
			init();
			buttonMode = true;
		}
		
		private function init():void
		{
			_label = new TextField();
			_label.mouseEnabled = _label.mouseWheelEnabled = false;
			_label.width = 103;
			_label.textColor = CategoryType.getQualityColor(_template.quality);
			_label.htmlText ="<u>" + _template.name + "×" + count  +  "</u>" + "，";
			_label.height = 20;
			addChild(_label);
						
			this.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		public function getWidth():int
		{
			return _label.textWidth;
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			_timeoutIndex = setTimeout(showHandler,50);
			function showHandler():void
			{
				TipsUtil.getInstance().show(_template,null,new Rectangle(evt.stageX,evt.stageY,0,0),false,0,false);
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
					_timeoutIndex = -1;
				}
			}
		}
		
		public function dispose():void
		{
			this.removeEventListener(MouseEvent.CLICK,clickHandler);
			_label = null;
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
				_timeoutIndex = -1;
			}
			if(parent) parent.removeChild(this);
		}
		
	}
}