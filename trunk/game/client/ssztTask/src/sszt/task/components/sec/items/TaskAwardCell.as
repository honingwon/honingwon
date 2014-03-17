package sszt.task.components.sec.items
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.mcache.cells.CellCaches;
	
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.task.TaskAwardTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	
	public class TaskAwardCell extends BaseCell
	{
		private var _taskAwardInfo:TaskAwardTemplateInfo;
		private var _countField:TextField;
		private var _bg:Bitmap;
		
		public function TaskAwardCell(info:ILayerInfo=null, showLoading:Boolean=true, autoDisposeLoader:Boolean=true, fillBg:int=-1)
		{
			super(info, showLoading, autoDisposeLoader, fillBg);
			initView();
		}
		
		private function initView():void
		{
			_bg = new Bitmap(CellCaches.getCellBg());
			addChildAt(_bg,0);
			
			_countField = new TextField();
			_countField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,true,null,null,null,null,TextFormatAlign.RIGHT);
			_countField.width = 22;
			_countField.height = 18;
			_countField.x = 14;
			_countField.y = 21;
			_countField.mouseEnabled = false;
			addChild(_countField);
		}
		
		public function set taskAwardInfo(value:TaskAwardTemplateInfo):void
		{
			if(value == null)return;
			if(_taskAwardInfo == value)return;
			_taskAwardInfo = value;
			super.info = ItemTemplateList.getTemplate(_taskAwardInfo.templateId);
			if(_taskAwardInfo.count > 0)_countField.text = String(_taskAwardInfo.count);
			else _countField.text = "";
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,32,32);
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().show(ItemTemplateInfo(info),null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(info)TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
			super.dispose();
			_countField = null;
			_taskAwardInfo = null;
			_bg = null;
		}
	}
}