package sszt.core.view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;

	public class FriendIconList extends Sprite
	{
		public var list:Array;
//		public static const ICONS:Array = [null,new ShangWuBAsset2(),new ShangWuGAsset2(),new XiaoYaoBAsset2(),new XiaoYaoGAsset2(),new LiuXingBAsset2(),new LiuXingGAsset2()];
	
		public function FriendIconList()
		{
			super();
			list = [];				
			initEvent();
		}
		
		public function show():void
		{
			sizeChangeHandler(null);
			GlobalAPI.layerManager.getPopLayer().addChild(this);
		}
			
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(CommonConfig.GAME_WIDTH + 300 >> 1,CommonConfig.GAME_HEIGHT - 100);
		}
		
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function addItem(icon:FlashIcon):void
		{
			if(hasIcon(icon))
			{
				
			}else
			{
				if(list.length >= 10)
				{
					clear();
					list.splice(0,1)[0].dispose();
					list.push(icon);
					for(var i:int = 0;i<list.length;i++)
					{
						addChild(list[i]);
						var x:int = i % 5 * 25 ;
						y = -(int(i/5)) * 25;
						list[i].move(x,y);
					}
				}else
				{
					list.push(icon);
					addChild(icon);
					x = (list.length - 1) % 5 * 25;
					y = -(int((list.length -1)/5)) * 25;
					icon.move(x,y);		
				}
			}
			show();
		}
		
		public function  hasIcon(icon:FlashIcon):Boolean
		{
			for(var i:int =0;i<list.length;i++)
			{
				if(list[i].id == icon.id)
				{
					list[i].isRead = false;
					return true;
				}
			}
			return false;
		}
		
		public function removeIcon(id:Number):void
		{
			for(var i:int =0;i<list.length;i++)
			{
				if(list[i].id == id)
				{
					list.splice(i,1)[0].dispose();
					break;
				}
			}
			clear();
			for(i = 0;i<list.length;i++)
			{
				addChild(list[i]);
				var x:int = i % 5 * 25 ;
				var y:int = -(int(i/5)) * 25;
				list[i].move(x,y);
			}
			if(list.length == 0)
			{
				dispose();
			}
		}
		
		private function clear():void
		{
			for each(var i:FlashIcon in list)
			{
				if(i && i.parent) i.parent.removeChild(i);
			}
		}
		
		public function dispose():void
		{
			if(parent) parent.removeChild(this);
		}
	}
}