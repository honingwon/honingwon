package sszt.core.view.chat
{
	import flash.events.MouseEvent;
	
	import sszt.ui.container.MSprite;
	
	import sszt.core.manager.FaceManager;
	import sszt.core.view.effects.BaseEffect;
	
	public class FaceItem extends MSprite
	{
		private var _index:int;
		private var _face:BaseEffect;
		
		public function FaceItem(index:int)
		{
			_index = index;
			super();
			initView();
		}
		
		private function initView():void
		{
			this.buttonMode = true;
			this.tabEnabled = false;
			
			getEffect();
		}
		
		public function getEffect():void
		{
			if(_face)return;
			_face = FaceManager.getFace(FaceManager["FACE" + _index]);
			if(_face)
			{
				addChild(_face);
			}
		}
		
		public function get index():int
		{
			return _index;
		}
		
		override public function dispose():void
		{
			if(_face)
			{
				_face.dispose();
				_face = null;
			}
			super.dispose();
		}
	}
}