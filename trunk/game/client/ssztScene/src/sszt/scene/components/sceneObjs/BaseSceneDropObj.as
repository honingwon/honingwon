package sszt.scene.components.sceneObjs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.scene.data.dropItem.DropItemInfo;
	
	public class BaseSceneDropObj extends BaseSceneObj {
		
		private var _asset:Bitmap;
		private var _goldEffect:BaseLoadEffect;
		private var _template:ItemTemplateInfo;
		private var _nameField:TextField;
		private var _path:String;
		private var _shadow:Bitmap;
		private var _isGold:Boolean;
		
		public function BaseSceneDropObj(info:DropItemInfo){
			this._template = ItemTemplateList.getTemplate(info.templateId);
			super(info);
		}
		override protected function init():void{
			var t:TextFormat;
			super.init();
			mouseEnabled = mouseChildren = tabChildren = tabEnabled = false;
			if (this._template.templateId == CategoryType.DROP_GOLD 
				|| this._template.templateId == CategoryType.DROP_YUANBAO_GOLD 
				|| this._template.templateId == CategoryType.DROP_BIND_GOLD)
			{
				if (this._template.templateId == CategoryType.DROP_YUANBAO_GOLD){
					this._goldEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.GOLD_YUANBAO_EFFECT));
				} 
				else {
					this._goldEffect =  new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.GOLD_EFFECT));
				}
				this._goldEffect.move(0, 0);
				this._goldEffect.play(SourceClearType.CHANGESCENE_AND_TIME, 180000);
				addChild(this._goldEffect);
				this._shadow = new Bitmap(BaseRole.getShadowAsset());
				_shadow.x = -32;
				_shadow.y = -12;
				addChildAt(this._shadow, 0);
				this._isGold = true;
			} 
			else 
			{
				this._path = GlobalAPI.pathManager.getDisplayItemPath(this._template.iconPath, LayerType.SCENE_ICON);
				GlobalAPI.loaderAPI.getPicFile(this._path, this.createPicComplete, SourceClearType.CHANGE_SCENE);
			}
			if (this._nameField == null){
				this._nameField = new TextField();
				t = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"), 12, CategoryType.getQualityColor(this._template.quality), null, null, null, null, null, null, null, null, null, -(parseInt(LanguageManager.getWord("mhsm.common.wordSize"))));
				this._nameField.setTextFormat(t);
				this._nameField.defaultTextFormat = t;
				this._nameField.mouseEnabled = false;
				this._nameField.filters = [new GlowFilter(0, 1, 2, 2, 10)];
				this._nameField.width = 100;
				this._nameField.height = 20;
				if (this._isGold){
					this._nameField.text = this._template.name;
					this._nameField.x = -16;
					this._nameField.y = -160;
					addChild(this._nameField);
				}
			}
		}
		override protected function removeEvent():void{
			super.removeEvent();
		}
		private function goldComplete():void{
		}
		private function createPicComplete(value:BitmapData):void{
			this._asset = new Bitmap(value);
			addChild(this._asset);
		}
		public function getDropItemInfo():DropItemInfo{
			return ((_info as DropItemInfo));
		}
		override public function doMouseOut():void{
			super.doMouseOut();
			if (!this._isGold && this._nameField.parent == this){
				this._nameField.parent.removeChild(this._nameField);
			}
		}
		/**
		 * 
		 * 
		 */
		override public function doMouseOver():void{
			super.doMouseOver();
			if (!this._isGold){
				this._nameField.text = this._template.name;
				this._nameField.y = -20;
				if (this._nameField.parent != this){
					addChild(this._nameField);
				}
			}
		}
		override public function doMouseClick():void{
			super.doMouseClick();
			dispatchEvent(new BaseSceneObjectEvent(BaseSceneObjectEvent.SCENEOBJ_CLICK));
		}
		override public function isMouseOver():Boolean{
			var color:uint;
			if(_goldEffect && _goldEffect.stage && _goldEffect.hitTestPoint(stage.mouseX,stage.mouseY))return true;
			if (this._asset && this._asset.bitmapData){
				color = this._asset.bitmapData.getPixel32(this._asset.mouseX, this._asset.mouseY);
				return color > 0;
			}
			return false;
		}
		override public function dispose():void{
			if (this._nameField.parent == this){
				this._nameField.parent.removeChild(this._nameField);
			}
			if ( this._path != "" &&  this._path != null)
			{
				GlobalAPI.loaderAPI.removeAQuote(_path,createPicComplete);
			}
			if (this._goldEffect){
				this._goldEffect.dispose();
				this._goldEffect = null;
			}
			if (this._shadow && this._shadow.parent){
				this._shadow.parent.removeChild(this._shadow);
			}
			this._shadow = null;
			this._template = null;
			super.dispose();
		}
		
	}
	
	
//	public class BaseSceneDropObj extends BaseSceneObj
//	{
//		public static var _nameField:TextField;
//		
//		private var _asset:Bitmap;
//		private var _nameField:TextField;
//		private var _path:String;
//		
//		protected var _character:ICharacter;
//		
//		public function BaseSceneDropObj(info:DropItemInfo)
//		{
//			super(info);
//		}
//		
//		
//		override protected function init():void
//		{
//			super.init();
//			mouseEnabled = mouseChildren = tabChildren = tabEnabled = false;
//			initCharacter();
//			
//			if(_nameField == null)
//			{
//				_nameField = new TextField();
//				var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,CategoryType.getQualityColor(getDropTempalte().quality),null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,4);
//				_nameField.setTextFormat(t);
//				_nameField.defaultTextFormat = t;
//				_nameField.mouseEnabled = false;
//				_nameField.filters = [new GlowFilter(0x0,1,2,2,10)];
//				_nameField.width = 100;
//				_nameField.height = 20;
//			}
//		}
//		
//		protected function initCharacter():void
//		{
//			if(CategoryType.isMoneyItem(getDropTempalte().categoryId))
//			{
//				_character = GlobalAPI.characterManager.createSceneDropCharacter(getDropItemInfo());
//				_character.addEventListener(Event.COMPLETE,characterLoadCompleteHandler);
//				_character.show();
//				addChild(_character as DisplayObject);
//			}
//			else
//			{
//				_path = GlobalAPI.pathManager.getDisplayItemPath(getDropTempalte().iconPath,LayerType.SCENE_ICON);
//				GlobalAPI.loaderAPI.getPicFile(_path,createPicComplete,SourceClearType.CHANGE_SCENE);
//			}
//			
//		}
//		
//		private function characterLoadCompleteHandler(evt:Event):void
//		{
//			_character.removeEventListener(Event.COMPLETE,characterLoadCompleteHandler);
//		}
//		
//		
//		
//		override protected function removeEvent():void
//		{
//			super.removeEvent();
//		}
//		
//		private function createPicComplete(value:BitmapData):void
//		{
//			_asset = new Bitmap(value);
//			_asset.x = - _asset.width >>1;
//			_asset.y = - _asset.height >>1;
//			addChild(_asset);
//		}
//		
//		public function getDropItemInfo():DropItemInfo
//		{
//			return _info as DropItemInfo;
//		}
//		
//		public function getDropTempalte():ItemTemplateInfo
//		{
//			return getDropItemInfo().getTemplate();
//		}
//		
//	
//				
//		override public function doMouseOut():void
//		{
//			super.doMouseOut();
//			if(_nameField.parent == this)_nameField.parent.removeChild(_nameField);
//		}
//		override public function doMouseOver():void
//		{
//			super.doMouseOver();
//			_nameField.text = getDropTempalte().name;
//			_nameField.x = - _nameField.width >> 1;
//			if(CategoryType.isMoneyItem(getDropTempalte().categoryId))
//			{
//				_nameField.y = -60;
//			}
//			else
//			{
//				_nameField.y = -20;
//			}
//			if(_nameField.parent != this)
//				addChild(_nameField);
//		}
//		override public function doMouseClick():void
//		{
//			super.doMouseClick();
//			dispatchEvent(new BaseSceneObjectEvent(BaseSceneObjectEvent.SCENEOBJ_CLICK));
//		}
//		
//		override public function isMouseOver():Boolean
//		{
//			if(_asset && _asset.bitmapData)
//			{
//				var color:uint = _asset.bitmapData.getPixel32(_asset.mouseX,_asset.mouseY);
//				return color > 0;
//			}
//			if(_character)
//			{
//				return !_character.getIsAlpha((_character as DisplayObject).mouseX,(_character as DisplayObject).mouseY);
//			}
//			return false;
//		}
//		
//		override public function dispose():void
//		{
//			if(_nameField.parent == this)_nameField.parent.removeChild(_nameField);
//			GlobalAPI.loaderAPI.removeAQuote(_path);
//			if(_character)
//				_character.removeEventListener(Event.COMPLETE,characterLoadCompleteHandler);
////			removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
////			removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
//			super.dispose();
//		}
//}
}