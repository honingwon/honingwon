package scene.sceneObjs{
	import sszt.ui.container.MSprite;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.interfaces.scene.IScene;
	import flash.display.DisplayObject;
	import sszt.interfaces.scene.*;
	
	public class BaseSceneObj extends MSprite implements ISceneObj {
		
		protected var _info:BaseSceneObjInfo;
		public var canSort:Boolean;
		protected var _isMouseOver:Boolean;
		private var _scene:IScene;
		protected var _mouseAvoid:Boolean;
		
		public function BaseSceneObj(info:BaseSceneObjInfo){
			_info = info;
			super();
			init();
			initEvent();
		}
		public function getCanAttack():Boolean{
			if (!_scene){
				return false;
			}
			return (_info.getCanAttack());
		}
		
		public function get sceneX():Number{
			if (!_info){
				return -500;
			}
			return (_info.sceneX);
		}
		
		public function isMouseOver():Boolean{
			return false;
		}
		
		public function setMouseAvoid(value:Boolean):void{
			_mouseAvoid = value;
		}
		
		public function get dir():int{
			return (0);
		}
		
		public function doMouseOver():void
		{
		}
		
		protected function init():void{
			mouseEnabled = false;
		}
		
		public function set scene(s:IScene):void{
			_scene = s;
		}
		
		public function get scene():IScene{
			return (_scene);
		}
		
		public function getFigure():DisplayObject{
			return (this);
		}
		
		public function get selected():Boolean{
			return (_info.selected);
		}
		
		public function doMouseClick():void{
		}
		
		public function doMouseOut():void{
		}
		
		override public function dispose():void{
			removeEvent();
			if (_scene){
				_scene.removeChild(this);
			}
			_scene = null;
			_info = null;
			super.dispose();
		}
		
		protected function initEvent():void{
		}
		
		protected function removeEvent():void{
		}
		
		public function setScenePos(x:Number, y:Number):void{
			_info.setScenePosWhitoutDispath(x, y);
		}
		
		public function get sceneY():Number
		{
			if (!_info){
				return -500;
			}
			return _info.sceneY;
		}
		
		public function getObjId():Number
		{
			if (_info)
			{
				return _info.getObjId();
			}
			return 0;
		}
		public function set selected(value:Boolean):void{
			_info.selected = value;
		}
		
		
	}
}
