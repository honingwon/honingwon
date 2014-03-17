package sszt.character
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.*;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;
	
	import ssztui.character.CharacterLoaderAsset;
	
	public class BaseCharacter extends Sprite implements ICharacter 
	{
		
		private static var _loadingSourceAsset:CharacterLoaderAsset = new CharacterLoaderAsset();
		
		protected var _info:ICharacterInfo;
		protected var _loader:ICharacterLoader;
		protected var _dir:int;
		protected var _loadingAsset:Bitmap;
		protected var _figureVisible:Boolean;
		protected var _loadComplete:Boolean;
		
		public function BaseCharacter(info:ICharacterInfo)
		{
			this._info = info;
			super();
			this._figureVisible = true;
			this.init();
			this.initEvent();
		}
		protected function init():void
		{
		}
		protected function initEvent():void
		{
			if (this.canChange()){
				this._info.addEventListener(CharacterEvent.CHARACTER_UPDATE, this.characterUpdateHandler);
			};
		}
		protected function removeEvent():void
		{
			if (this.canChange()){
				this._info.removeEventListener(CharacterEvent.CHARACTER_UPDATE, this.characterUpdateHandler);
			};
		}
		protected function canChange():Boolean
		{
			return (false);
		}
		protected function characterUpdateHandler(evt:CharacterEvent):void
		{
		}
		public function get characterInfo():ICharacterInfo
		{
			return (this._info);
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function setFigureVisible(value:Boolean):void
		{
			this._figureVisible = value;
			if (this._loadComplete)
			{
				this.removeLoadingAsset();
			}
			else if (this._figureVisible){
				this.initLoadingAsset();
			}
			
//			if (!this._figureVisible){
//				this.initLoadingAsset();
//			} 
//			else 
//			{
//				if (this._loadComplete)
//				{
//					this.removeLoadingAsset();
//				}
//			}
		}
		public function show(dir:int=8):void
		{
			if (this._info == null){
				return;
			}
			if (this._loader != null){
				this._loader.dispose();
			}
			this._loader = this.getLoader();
			this.updateDir(dir);
			this.initLoadingAsset();
			this._loader.load(this.showComplete);
		}
		protected function initLoadingAsset():void
		{
			if (this._loadingAsset == null){
				this._loadingAsset = new Bitmap(_loadingSourceAsset);
				this._loadingAsset.x = -24;
				this._loadingAsset.y = -80;
			}
			addChild(this._loadingAsset);
		}
		protected function removeLoadingAsset():void
		{
			if (this._loadingAsset && this._loadingAsset.parent){
				this._loadingAsset.parent.removeChild(this._loadingAsset);
			}
		}
		protected function showComplete(loader:ICharacterLoader):void
		{
			this._loadComplete = true;
//			if (this._figureVisible){
				this.removeLoadingAsset();
//			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
		public function doAction(action:ICharacterActionInfo):void
		{
		}
		public function doActionType(actionType:int):void
		{
		}
		public function getIsAlpha(x:int, y:int):Boolean
		{
			return (false);
		}
		public function setMouseEnabeld(value:Boolean):void
		{
			mouseChildren = (mouseEnabled = value);
		}
		public function get currentAction():ICharacterActionInfo
		{
			return (null);
		}
		public function actionPlaying(action:ICharacterActionInfo):Boolean
		{
			return (false);
		}
		public function updateDir(dir:int):void
		{
			this._dir = dir;
		}
		public function get dir():int
		{
			return (this._dir);
		}
		protected function getLoader():ICharacterLoader
		{
			return (null);
		}
		public function setFrame(index:int,index1:int=0,index2:int=0):void
		{
		}
		public function dispose():void
		{
			this.removeEvent();
			if (this._loader){
				this._loader.dispose();
				this._loader = null;
			};
			this._info = null;
			if (parent){
				parent.removeChild(this);
			};
		}
		
	}
}
