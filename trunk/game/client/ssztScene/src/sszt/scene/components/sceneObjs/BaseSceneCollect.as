package sszt.scene.components.sceneObjs
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import scene.events.BaseSceneObjectEvent;
	import scene.sceneObjs.BaseSceneObj;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.pool.IPoolObj;
	import sszt.scene.data.collects.CollectItemInfo;
	
	public class BaseSceneCollect extends BaseSceneObj
	{
		public static var nameField:TextField;
		private var _character:ICharacter;
		protected var _shadow:Bitmap;
		private var _hideName:Boolean;
		
		public function BaseSceneCollect(info:CollectItemInfo)
		{
			super(info);
		}
		
		override protected function init():void
		{
			super.init();
			
			if(nameField == null)
			{
				nameField = new TextField();
				var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(getCollectItemInfo().getTemplate().quality),null,null,null,null,null,TextFormatAlign.CENTER);
				nameField.setTextFormat(t);
				nameField.defaultTextFormat = t;
				nameField.mouseEnabled = false;
				nameField.filters = [new GlowFilter(0x0,1,2,2,10)];
				nameField.width = 100;
				nameField.height = 20;
				nameField.x = -50;
			}
			
			mouseEnabled = mouseChildren = false;
			tabChildren = tabEnabled = false;
			_hideName = false;
			
			_shadow = new Bitmap(BaseRole.getShadowAsset());
			_shadow.x = -32;
			_shadow.y = -12;
			addChildAt(_shadow,0);
			
			_character = GlobalAPI.characterManager.createCollectCharacter(getCollectItemInfo().getTemplate());
			_character.show();
//			_character.move(-185,-230);
			addChild(_character as DisplayObject);
			
		}
		
		override public function doMouseOver():void
		{
			super.doMouseOver();
			nameField.text = getCollectItemInfo().getName();
			nameField.y = -_character.height - 20;
			if(nameField.parent != this)
				addChild(nameField);
			nameField.visible = !_hideName;
			if(_character)_character.filters = [BaseRole.OVER_EFFECT];
		}
		override public function doMouseOut():void
		{
			super.doMouseOver();
			if(_character)_character.filters = null;
			if(nameField.parent == this)nameField.parent.removeChild(nameField);
		}
		override public function doMouseClick():void
		{
			dispatchEvent(new BaseSceneObjectEvent(BaseSceneObjectEvent.SCENEOBJ_CLICK));
		}
		
		public function getCollectItemInfo():CollectItemInfo
		{
			return _info as CollectItemInfo;
		}
		
		public function hideName(value:Boolean):void
		{
			_hideName = value;
		}
		
		override public function isMouseOver():Boolean
		{
			if(_character)
			{
				return !_character.getIsAlpha((_character as DisplayObject).mouseX,(_character as DisplayObject).mouseY);
			}
			return false;
		}
		
		
		
		override public function dispose():void
		{
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
			if(_shadow && _shadow.parent)_shadow.parent.removeChild(_shadow);
			if(nameField.parent == this)nameField.parent.removeChild(nameField);
			super.dispose();
		}
	}
}