package sszt.moviewrapper
{
	import flash.geom.Rectangle;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import flash.display.BitmapData;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import flash.utils.Timer;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.events.TimerEvent;
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.*;
	
	public class MovieManager implements IMovieManager 
	{
		
		public static var defaultTick:int = 40;
		
		public function getRemanceParam(source:Object, column:int, width:Number, height:Number, alpha:Number=1, scaleX:Number=1, scaleY:Number=1, scale9Grid:Rectangle=null):IRemanceParam
		{
			return (new RemanceParam(source, column, width, height, alpha, scaleX, scaleY, scale9Grid));
		}
		public function getMovieWrapperByParam(param:IRemanceParam):IMovieWrapper
		{
			var p:RemanceParam = (param as RemanceParam);
			var bd:BitmapData = doRemance(p);
			var info:MovieWrapperInfo = p.getMovieWrapperInfo();
			p.dispose();
			p = null;
			return (new BaseMovieWrapper(bd, info));
		}
		public function doTimeRemance(param:IRemanceParam, tick:int=50, tickFrame:int=10):BitmapData
		{
			var p:RemanceParam;
			var delay:Timer;
			var mc:MovieClip;
			var bd:BitmapData;
			var n:int;
			var colortransform:ColorTransform;
			var matrix:Matrix;
			var tx:Number;
			var ty:Number;
			var currentFrame:int;
			var delayTimerHandler:Function;
			var param:IRemanceParam = param;
			var tick:int = tick;
			var tickFrame:int = tickFrame;
			delayTimerHandler = function (evt:TimerEvent):void
			{
				var rows:Array;
				var cols:Array;
				var drows:Array;
				var dcols:Array;
				var origin:Rectangle;
				var target:Rectangle;
				var mat:Matrix;
				var j:int;
				var k:int;
				var i:int;
				while (i < tickFrame) {
					mc.gotoAndPlay(currentFrame);
					tx = ((currentFrame - 1) % p.column);
					ty = int(((currentFrame - 1) / p.column));
					matrix.tx = (p.remanceMatrix.tx + (tx * p.width));
					matrix.ty = (p.remanceMatrix.ty + (ty * p.height));
					if (p.scale9Grid == null){
						bd.draw(mc, matrix, colortransform);
					} else {
						rows = [0, p.scale9Grid.top, p.scale9Grid.bottom, p.defaultHeight];
						cols = [0, p.scale9Grid.left, p.scale9Grid.right, p.defaultWidth];
						drows = [0, p.scale9Grid.top, (p.height - (p.defaultHeight - p.scale9Grid.bottom)), p.height];
						dcols = [0, p.scale9Grid.left, (p.width - (p.defaultWidth - p.scale9Grid.right)), p.width];
						mat = new Matrix();
						j = 0;
						while (j < 3) {
							k = 0;
							while (k < 3) {
								origin = new Rectangle(cols[j], rows[k], (cols[(j + 1)] - cols[j]), (rows[(k + 1)] - rows[k]));
								target = new Rectangle(dcols[j], drows[k], (dcols[(j + 1)] - dcols[j]), (drows[(k + 1)] - drows[k]));
								mat.identity();
								mat.a = (target.width / origin.width);
								mat.d = (target.height / origin.height);
								mat.tx = ((target.x - (origin.x * mat.a)) + matrix.tx);
								mat.ty = ((target.y - (origin.y * mat.d)) + matrix.ty);
								target.x = (target.x + matrix.tx);
								target.y = (target.y + matrix.ty);
								bd.draw(mc, mat, colortransform, null, target);
								k++;
							};
							j++;
						};
					};
					currentFrame++;
					if (currentFrame > n) break;
					i++;
				};
				if (currentFrame > n){
					delay.stop();
					delay.removeEventListener(TimerEvent.TIMER, delayTimerHandler);
					delay = null;
					bd.unlock();
					mc = null;
					p.clearMC();
				};
			};
			p = (param as RemanceParam);
			if (p == null){
				return (null);
			};
			delay = new Timer(tick);
			delay.addEventListener(TimerEvent.TIMER, delayTimerHandler);
			delay.start();
			mc = p.sourceMC;
			bd = new BitmapData(p.targetMapWidth, p.targetMapHeight, true, 0);
			bd.lock();
			n = p.totalFrames;
			colortransform = p.colorTransform;
			matrix = p.remanceMatrix.clone();
			tx = 0;
			ty = 0;
			currentFrame = 1;
			return (bd);
		}
		public function getBDMovieWrapperFactory(param:IRemanceParam, isTimer:Boolean=false, tick:int=50, tickFrame:int=10):IBDMovieWrapperFactory
		{
			var bd:BitmapData;
			if (isTimer){
				bd = doTimeRemance(param, tick, tickFrame);
			} else {
				bd = doRemance(param);
			};
			var info:MovieWrapperInfo = (param as RemanceParam).getMovieWrapperInfo();
			param = null;
			return (new BDMovieWrapperFactory(bd, info));
		}
		public function createMoviesByParam(count:int, param:IRemanceParam):Array
		{
			var p:RemanceParam = (param as RemanceParam);
			var list:Array = [];
			var bd:BitmapData = doRemance(p);
			var i:int;
			while (i < count) {
				list.push(new BaseMovieWrapper(bd, p.getMovieWrapperInfo()));
				i++;
			};
			return (list);
		}
		public function getMovieWrapper(source:Object, width:Number, height:Number, column:int=1, alpha:Number=1):IMovieWrapper
		{
			var remanceParam:RemanceParam = new RemanceParam(source, column, width, height, alpha);
			var bd:BitmapData = doRemance(remanceParam);
			var info:MovieWrapperInfo = remanceParam.getMovieWrapperInfo();
			remanceParam.dispose();
			remanceParam = null;
			return (new BaseMovieWrapper(bd, info));
		}
		public function setup(tick:int=40):void
		{
			defaultTick = tick;
		}
		public function doRemance(param:IRemanceParam):BitmapData
		{
			var rows:Array;
			var cols:Array;
			var drows:Array;
			var dcols:Array;
			var origin:Rectangle;
			var target:Rectangle;
			var mat:Matrix;
			var j:int;
			var k:int;
			var p:RemanceParam = (param as RemanceParam);
			if (p == null){
				return (null);
			};
			var mc:MovieClip = p.sourceMC;
			var bd:BitmapData = new BitmapData(p.targetMapWidth, p.targetMapHeight, true, 0);
			bd.lock();
			var n:int = p.totalFrames;
			var colortransform:ColorTransform = p.colorTransform;
			var matrix:Matrix = p.remanceMatrix.clone();
			var tx:Number = 0;
			var ty:Number = 0;
			var i:int;
			while (i < n) {
				mc.gotoAndStop((i + 1));
				tx = (i % p.column);
				ty = int((i / p.column));
				matrix.tx = (p.remanceMatrix.tx + (tx * p.width));
				matrix.ty = (p.remanceMatrix.ty + (ty * p.height));
				if (p.scale9Grid == null){
					bd.draw(mc, matrix, colortransform);
				} else {
					rows = [0, p.scale9Grid.top, p.scale9Grid.bottom, p.defaultHeight];
					cols = [0, p.scale9Grid.left, p.scale9Grid.right, p.defaultWidth];
					drows = [0, p.scale9Grid.top, (p.height - (p.defaultHeight - p.scale9Grid.bottom)), p.height];
					dcols = [0, p.scale9Grid.left, (p.width - (p.defaultWidth - p.scale9Grid.right)), p.width];
					mat = new Matrix();
					j = 0;
					while (j < 3) {
						k = 0;
						while (k < 3) {
							origin = new Rectangle(cols[j], rows[k], (cols[(j + 1)] - cols[j]), (rows[(k + 1)] - rows[k]));
							target = new Rectangle(dcols[j], drows[k], (dcols[(j + 1)] - dcols[j]), (drows[(k + 1)] - drows[k]));
							mat.identity();
							mat.a = (target.width / origin.width);
							mat.d = (target.height / origin.height);
							mat.tx = ((target.x - (origin.x * mat.a)) + matrix.tx);
							mat.ty = ((target.y - (origin.y * mat.d)) + matrix.ty);
							target.x = (target.x + matrix.tx);
							target.y = (target.y + matrix.ty);
							bd.draw(mc, mat, colortransform, null, target);
							k++;
						};
						j++;
					};
				};
				i++;
			};
			bd.unlock();
			mc = null;
			p.clearMC();
			return (bd);
		}
		public function createMovies(count:int, cl:Class, width:Number, height:Number, column:int=1, alpha:Number=1):Array
		{
			var list:Array = [];
			var param:RemanceParam = new RemanceParam(cl, column, width, height, alpha);
			var bd:BitmapData = doRemance(param);
			var i:int;
			while (i < count) {
				list.push(new BaseMovieWrapper(bd, param.getMovieWrapperInfo()));
				i++;
			};
			param.dispose();
			return (list);
		}
		
	}
}