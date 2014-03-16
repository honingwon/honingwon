package sszt.character
{
	import flash.display.Bitmap;
	
	import sszt.character.actions.BaseActionController;
	import sszt.constData.ActionType;
	import sszt.constData.DirectType;
	import sszt.constData.LayerType;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterLoader;
	
	public class LayerCharacter extends BaseCharacter 
	{
		
		protected var _layers:Array;
		protected var _datas:Array;
		protected var _currentFrame:int = -1;
		protected var _actionController:BaseActionController;
		protected var _dirUpdate:Boolean;
//		protected var _picWidth:Number;
		
		public function LayerCharacter(info:ICharacterInfo)
		{
			super(info);
			
//			this._picWidth = info.getPicWidth(this.getLayerType());
		}
		override protected function init():void
		{
			super.init();
			this._actionController = new BaseActionController(this,SceneCharacterActions.DEFAULT);
		}
		
		protected function getLayerType():String
		{
			return "";
		}
		
		
		/**
		 * 加载完成 
		 * @param loader
		 * 
		 */		
		override protected function showComplete(loader:ICharacterLoader):void
		{
			this._datas = loader.getContent();
			this._currentFrame = -1;
			this.setFrame(0);
			
			var type:int = _info.getDefaultActionType(this.getLayerType());
			actionControllerStart(type);
			super.showComplete(loader);
		}
		
		protected function actionControllerStart(type:int):void
		{
			var obj:Object = ActionType.getActionObj(type,this._datas[0]);
			var frameRate:int = _info.getFrameRate(type);
			var obj1:Object = {};
			var obj2:Object = {};
			
			if(this._datas[3] != null)
			{
				obj1 = ActionType.getActionObj(ActionType.STAND,this._datas[3]);
			}
			
//			if(this._datas[3] != null)
//			{
//				obj2 = ActionType.getActionObj(ActionType.STAND,this._datas[3]);
//			}
			this._actionController.setDefaultAction(
				SceneCharacterActions.createActionInfo(this.getLayerType(),type,obj.start,obj.end,obj.directType,frameRate),
				SceneCharacterActions.createActionInfo(this.getLayerType(),ActionType.STAND,obj1.start,obj1.end,obj1.directType,frameRate)
			);
			
//			
//			if(this._datas[3] != null && 
//				(getLayerType() == LayerType.MOUNTS_RUN || getLayerType() == LayerType.SHOW_MOUNTS) )
//			{
//				var obj1:Object = ActionType.getActionObj(type,this._datas[3]);
//				this._actionController.setDefaultAction(
//					SceneCharacterActions.createActionInfo(this.getLayerType(),type,obj.start,obj.end,obj.directType,frameRate),
//					SceneCharacterActions.createActionInfo(this.getLayerType(),ActionType.STAND,obj1.start,obj1.end,obj1.directType,frameRate)
//				);
//			}
//			else
//			{
//				this._actionController.setDefaultAction(SceneCharacterActions.createActionInfo(this.getLayerType(),type,obj.start,obj.end,obj.directType,frameRate));
//			}
			this._actionController.start();
		}
		
		protected function clearDatas():void
		{
			if (_loader)
			{
				_loader.clearContent();
			}
			this._datas = null;
			this.setFrame(100000);
		}
		override public function setFrame(frame:int,frame1:int=0,frame2:int=0):void
		{
			var b:Bitmap;
			var list:Array;
			var i:int;
			if (frame == 100000){
				for each (b in this._layers) {
					b.bitmapData = null;
				}
				return;
			}
			if (frame < 0 || frame >= this.getFrameLen()){
				frame = 0;
			}
			if (frame != this._currentFrame || this._dirUpdate)
			{
				this._dirUpdate = false;
				this._currentFrame = frame;
				if (_figureVisible){
					list = this.getFrameDatas(frame,frame1,frame2);
					i = 0;
					if (list.length > 0){
						i = 0;
						while (i < list[0].length) {
							if (this._layers[i] != null || this._layers[i].bitmapData == null && list[1][i] == null)
							{
								this._layers[i].bitmapData = list[1][i];
								this._layers[i].y = -list[0][i].y;
								this._layers[i].scaleX = this.getDirScale();
								if (this._layers[i].scaleX == -1){
									this._layers[i].x = list[0][i].x ;
								} 
								else {
									this._layers[i].x = -list[0][i].x;
								}
							}
							i++;
						}
					}
					while (i < this._layers.length) 
					{
						if (this._layers[i] != null && this._layers[i].bitmapData != null){
							this._layers[i].bitmapData = null;
						}
						i++;
					}
				}
			}
		}
		
		override public function setFigureVisible(value:Boolean):void
		{
			var c:Bitmap;
			super.setFigureVisible(value);
			if (!_figureVisible){
				for each (c in this._layers) {
					if (c && c.bitmapData){
						c.bitmapData = null;
					}
				}
			} 
			else {
				this._currentFrame = -1;
			}
		}
		override public function getIsAlpha(x:int, y:int):Boolean
		{
			var i:Bitmap;
			var tmpX:int;
			var tmpXX:int;
			if (_loadingAsset && _loadingAsset.stage){
				return !_loadingAsset.hitTestPoint(stage.mouseX, stage.mouseY);
			}
			for each (i in this._layers) {
				if (i && i.bitmapData){
					if (i.scaleX == -1){
						tmpX = x + 2 * ( i.x - x);
						tmpXX = i.x;
					} 
					else {
						tmpX = x;
						tmpXX = i.x;
					}
					if (i.bitmapData.getPixel32(tmpX - tmpXX, y - i.y) >> 24 != 0){
						return (false);
					}
				}
			}
			return true;
		}
		protected function getFrameDatas(frame:int,frame1:int=0,frame2:int=0):Array
		{
			return null;
		}
		protected function getFrameLen():int
		{
			if(this._datas.length > 0)
			{
				return this._datas[0].count;
			}
			return 0;
		}
		override public function updateDir(dir:int):void
		{
			super.updateDir(dir);
			this._dirUpdate = true;
			this._actionController.setDir(dir);
		}
		override public function doAction(action:ICharacterActionInfo):void
		{
			this._actionController.doAction(action);
		}
		
		
		override public function doActionType(actionType:int):void
		{
			if( !this._actionController.getCurrentAction() || actionType == this._actionController.getCurrentAction().actionType)
			{
				return;
			}
			if(_datas==null || _datas.length == 0)
				return;
			
			var frameRate:int = _info.getFrameRate(actionType);
			var obj:Object = ActionType.getActionObj(actionType, _datas[0]);
			var obj1:Object ={};
			var obj2:Object ={};
			if(this._datas[3] != null)
			{
				obj1 = ActionType.getActionObj(ActionType.STAND,this._datas[3]);
			}
			

			this._actionController.doAction(
				SceneCharacterActions.createActionInfo(this.getLayerType(),actionType,obj.start,obj.end,obj.directType,frameRate),
				SceneCharacterActions.createActionInfo(this.getLayerType(),ActionType.STAND,obj1.start,obj1.end,obj1.directType,frameRate) 
			);
			
//			if(getLayerType() == LayerType.MOUNTS_RUN)
//			{
//				var obj1:Object = this._datas[3];
//				var start:int = (obj1.actionSE[0]);
//				var end:int = (obj1.actionSE[1]);
//				
//				this._actionController.doAction(
//					SceneCharacterActions.createActionInfo(this.getLayerType(),actionType,obj.start,obj.end,obj.directType,frameRate),
//					SceneCharacterActions.createActionInfo(this.getLayerType(),ActionType.STAND,start,end,obj1.directType,frameRate)
//				);
//			}
//			else
//			{
//				this._actionController.doAction(SceneCharacterActions.createActionInfo(getLayerType(),actionType,obj.start,obj.end,obj.directType,frameRate));
//			}
		}
		
		protected function getDirScale():int
		{
			return DirectType.isLeft(_dir) ? -1 : 1;
		}
		public function actionComplete(action:ICharacterActionInfo):void
		{
		}
		override public function get currentAction():ICharacterActionInfo
		{
			return (this._actionController.getCurrentAction());
		}
		override public function dispose():void
		{
			var i:Bitmap;
			if (this._layers){
				for each (i in this._layers) {
					if (i && i.parent)
					{
						i.parent.removeChild(i);
					}
				}
				this._layers = null;
			}
			if (this._datas){
				this._datas = null;
			}
			if (this._actionController){
				this._actionController.dispose();
				this._actionController = null;
			}
			super.dispose();
		}
		
	}
}
