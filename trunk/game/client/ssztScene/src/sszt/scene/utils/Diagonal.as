package sszt.scene.utils
{
	import flash.geom.Point;
	
	public class Diagonal
	{
		public function Diagonal() {
		}
		public static function find(start_point:Point, end_point:Point):Array {
			var w:int;
			var h:int;
			var __ox:int;
			var __oy:int;
			var __value:Array = [];
			var __r:Number;
			var __n1:Number;
			var __n2:Number;
			var __b1:Boolean;
			var __b2:Boolean;
			var __m:int;
			var __n:int = 0;
			var __d:Boolean = (start_point.x<end_point.x)==(start_point.y<end_point.y);
			if (start_point.x<end_point.x) {
				__ox = start_point.x;
				__oy = start_point.y;
				w = end_point.x - __ox;
				h = Math.abs(end_point.y - __oy);
			} else {
				__ox = end_point.x;
				__oy = end_point.y;
				w = start_point.x - __ox;
				h = Math.abs(start_point.y - __oy);
			}
			if (w==h) {
				for (__m=0; __m<=w; __m++) {
					__d ? __value.push(new Point(__ox+__m, __oy+__m)):__value.push(new Point(__ox+__m, __oy-__m));
					if (__m>0) {
						__d ? __value.push(new Point(__ox+__m-1, __oy+__m)):__value.push(new Point(__ox+__m-1, __oy-__m));
					}
					if (__m<w) {
						__d ? __value.push(new Point(__ox+__m+1, __oy+__m)):__value.push(new Point(__ox+__m+1, __oy-__m));
					}

				}
			} else if (w>h) {
				__r=h/w;//(h-1)/(w-1);
				__value.push(new Point(__ox, __oy));
				for (__m=1; __m<=w; __m++) {
					__n1 = (__m-.5)*__r;
					__n2 = (__m+.5)*__r;
					__b1 = __n1>__n-.5 && __n1<__n+.5;
					__b2 = __n2>__n-.5 && __n2<__n+.5;
					if (__b1 || __b2) {
						__d ? __value.push(new Point(__ox+__m, __oy+__n)):__value.push(new Point(__ox+__m, __oy-__n));
						if (!__b2) {
							__n++;
							__d ? __value.push(new Point(__ox+__m, __oy+__n)):__value.push(new Point(__ox+__m, __oy-__n));
						}
					}
				}
			} else if (w<h) {
				__r = w/h;//(w-1)/(h-1);
				__value.push(new Point(__ox, __oy));
				for (__m=1; __m<=h; __m++) {
					__n1 = (__m-.5)*__r;
					__n2 = (__m+.5)*__r;
					__b1 = __n1>__n-.5 && __n1<__n+.5;
					__b2 = __n2>__n-.5 && __n2<__n+.5;
					if (__b1 || __b2) {
						__d ? __value.push(new Point(__ox+__n, __oy+__m)):__value.push(new Point(__ox+__n, __oy-__m));
						if (!__b2) {
							__n++;
							__d ? __value.push(new Point(__ox+__n, __oy+__m)):__value.push(new Point(__ox+__n, __oy-__m));
						}
					}
				}
			}
			return __value;
		}

	}
}