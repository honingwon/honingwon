package sszt.core.view.chat
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.FaceManager;
	import sszt.core.view.effects.BaseEffect;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	
	public class FaceView extends MSprite
	{
		private var _bgasset:IMovieWrapper;
//		private var _list:Vector.<FaceItem>;
		private var _list:Array
		
		public function FaceView()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			_bgasset = BackgroundUtils.setBackground([new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,236,112))]);
			addChild(_bgasset as DisplayObject);
			
//			_list = new Vector.<FaceItem>();
			_list = [];
			for(var i:int = 1; i < FaceManager.FACES.length + 1; i++)
			{
				var face:FaceItem = new FaceItem(i);
				face.addEventListener(MouseEvent.CLICK,faceClickHandler);
				face.move(25 * ((i - 1) % 9) + 9,25 * Math.floor((i - 1) / 9) + 8);
				addChild(face);
				_list.push(face);
			}
		}
		
		private function faceClickHandler(e:MouseEvent):void
		{
			var face:FaceItem = e.currentTarget as FaceItem;
			dispatchEvent(new CommonModuleEvent(CommonModuleEvent.ADD_FACE,face.index));
		}
		
		public function show():void
		{
			for each(var item:FaceItem in _list)
			{
				item.getEffect();
			}
			GlobalAPI.layerManager.getPopLayer().addChild(this);
			GlobalAPI.layerManager.getPopLayer().stage.addEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		private function hideHandler(e:MouseEvent):void
		{
			hide();
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
			GlobalAPI.layerManager.getPopLayer().stage.removeEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_bgasset)
			{
				_bgasset.dispose();
				_bgasset = null;
			}
			if(_list)
			{
				for each(var face:FaceItem in _list)
				{
					face.removeEventListener(MouseEvent.CLICK,faceClickHandler);
					face.dispose();
				}
			}
			_list = null;
		}
	}
}