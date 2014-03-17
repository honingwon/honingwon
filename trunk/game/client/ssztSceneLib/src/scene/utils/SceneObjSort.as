package scene.utils{
	import sszt.interfaces.scene.ISceneObj;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class SceneObjSort {
		
		public static function sortFun(a:DisplayObject, b:DisplayObject):int{
			if (a.y > b.y){
				return (1);
			}
			if (a.y < b.y){
				return (-1);
			}
			if (a is ISceneObj && b is ISceneObj)
			{
				var _temp1:int = a["getObjId"]();
				return (_temp1>b["getObjId"]()) ? 1 : -1;
			}
			return 0;
		}
		
		public static function move(par:Sprite):void{
			var a:DisplayObject;
			var b:DisplayObject;
			if (!par)
			{
				return;
			}
			var numchildren:int = par.numChildren;
			var childs:Array = new Array(numchildren);
			var i:int;
			while (i < numchildren) {
				childs[i] = par.getChildAt(i);
				i++;
			}
			childs.sort(sortFun);
			var j:int;
			while (j < childs.length) 
			{
				a = par.getChildAt(j);
				b = childs[j];
				if (a != b){
					par.swapChildren(a, b);
				}
				j++;
			}
		}
		
	}
}
