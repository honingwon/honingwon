package sszt.scene.components.nearly
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import sszt.core.data.GlobalData;
	import sszt.core.doubleClicks.IDoubleClick;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.scene.data.roles.NpcRoleInfo;
	import sszt.scene.mediators.NearlyMediator;
	
	public class NearlyNpcItemView extends Sprite implements IDoubleClick
	{
		private var _info:NpcRoleInfo;
		private var _nameField:TextField;
		private var _posField:TextField;
		private var _selected:Boolean;
		private var _shape:Shape;
		private var _mediator:NearlyMediator;
		
		public function NearlyNpcItemView(info:NpcRoleInfo,mediator:NearlyMediator)
		{
			_info = info;
			_mediator = mediator;
			super();
			init();
		}
		
		public function click():void
		{
			
		}
		
		public function doubleClick():void
		{
			if(GlobalData.copyEnterCountList.isInCopy || _mediator.sceneInfo.mapInfo.isSpaScene())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.specialScene"));
				return;
			}
//			_mediator.sceneModule.sceneInit.walkToNpc(_info.template.templateId);
		}
		
		private function init():void
		{
			buttonMode = true;
			
			graphics.beginFill(0,0);
			graphics.drawRect(2,0,280,22);
			graphics.endFill();
			
			_shape = new Shape();
			_shape.graphics.lineStyle(1,0xffffff,2);
			_shape.graphics.drawRect(2,0,280,22);
			_shape.visible = false;
			addChild(_shape);

			_nameField = new TextField();
			_nameField.height = 20;
			_nameField.width = 150;
			_nameField.x = 15;
			_nameField.mouseEnabled = _nameField.mouseWheelEnabled = false;
			_nameField.textColor = 0xffffff;
			_nameField.text = _info.getName();
			addChild(_nameField);
			
			_posField = new TextField();
			_posField.height = 20;
			_posField.width = 71;
			_posField.x = 198;
			_posField.mouseEnabled = _posField.mouseWheelEnabled = false;
			_posField.textColor = 0xffffff;
			_posField.htmlText = "<u>"+"("+_info.sceneX+","+_info.sceneY+")"+"</u>";
			addChild(_posField);
			
		}
				
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(_selected)
			{
				_nameField.textColor = 0xffde00;
				_posField.textColor = 0xffde00;
			}else
			{
				_nameField.textColor = 0xffffff;
				_posField.textColor = 0xffffff;
			}
		}
		
		public function get info():NpcRoleInfo
		{
			return _info;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function dispose():void
		{
			_mediator = null;
			if(_shape)
			{
				removeChild(_shape);
				_shape = null;
			}
			_nameField = null;
			_posField = null;
			_info = null;
		}
	}
}