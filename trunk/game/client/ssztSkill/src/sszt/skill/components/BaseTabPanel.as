package sszt.skill.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.view.cell.BaseSkillItemCell;
	import sszt.skill.mediators.SkillMediator;
	
	public class BaseTabPanel extends Sprite implements ISkillTabPanel
	{
		
		protected var _mediator:SkillMediator;
		
		public function BaseTabPanel(mediator:SkillMediator)
		{
			_mediator = mediator;
			super();
		}
		
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		
		public function assetsCompleteHandler():void
		{
		}
		
		
		public function dispose():void
		{
			_mediator = null;
			if(parent) parent.removeChild(this);
		}
	}
}