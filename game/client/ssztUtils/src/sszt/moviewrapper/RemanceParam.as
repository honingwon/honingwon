package sszt.moviewrapper
{
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import sszt.interfaces.moviewrapper.*;
	
	public class RemanceParam implements IRemanceParam 
	{
		
		private var _height:int;
		private var _width:int;
		private var _defaultHeight:int;
		public var totalFrames:int;
		public var colorTransform:ColorTransform;
		public var remanceMatrix:Matrix;
		public var column:int;
		private var _defaultWidth:int;
		public var sourceMC:MovieClip;
		private var _scale9Grid:Rectangle;
		
		public function RemanceParam(source:Object, column:int, width:Number, height:Number, alpha:Number=1, scaleX:Number=1, scaleY:Number=1, scale9Grid:Rectangle=null)
		{
			if ((source is MovieClip)){
				sourceMC = (source as MovieClip);
			} else {
				if ((source is Class)){
					sourceMC = (new (source)() as MovieClip);
				};
			};
			if (sourceMC == null){
				throw (new Error("Source cann't be null"));
			};
			this.column = column;
			_defaultWidth = Math.ceil(width);
			_defaultHeight = Math.ceil(height);
			totalFrames = sourceMC.totalFrames;
			setMatrix(new Matrix(1, 0, 0, 1, 0, 0));
			remanceMatrix = new Matrix(1, 0, 0, 1, 0, 0);
			colorTransform = new ColorTransform(1, 1, 1, alpha);
			if (((!((scaleX == 1))) || (!((scaleY == 1))))){
				setScaleXY(scaleX, scaleY);
			};
			if (scale9Grid){
				_scale9Grid = scale9Grid;
			};
		}
		public function setMatrix(value:Matrix):void
		{
			remanceMatrix = value;
			_width = Math.ceil((Math.abs(remanceMatrix.a) * _defaultWidth));
			_height = Math.ceil((Math.abs(remanceMatrix.d) * _defaultHeight));
			if (remanceMatrix.a < 0){
				remanceMatrix.tx = ((-1 * remanceMatrix.a) * _defaultWidth);
			};
			if (remanceMatrix.d < 0){
				remanceMatrix.ty = ((-1 * remanceMatrix.d) * _defaultHeight);
			};
		}
		public function get defaultWidth():int
		{
			return (_defaultWidth);
		}
		public function setColorTransform(value:ColorTransform):void
		{
			colorTransform = value;
		}
		public function get width():Number
		{
			return (_width);
		}
		public function get defaultHeight():int
		{
			return (_defaultHeight);
		}
		public function get scale9Grid():Rectangle
		{
			return (_scale9Grid);
		}
		public function setScaleX(n:Number):void
		{
			setMatrix(new Matrix(n, remanceMatrix.b, remanceMatrix.c, remanceMatrix.d, remanceMatrix.tx, remanceMatrix.ty));
		}
		public function setScaleY(n:Number):void
		{
			setMatrix(new Matrix(remanceMatrix.a, remanceMatrix.b, remanceMatrix.c, n, remanceMatrix.tx, remanceMatrix.ty));
		}
		public function setAlpha(n:Number):void
		{
			colorTransform.alphaMultiplier = n;
		}
		public function setScaleXY(x:Number, y:Number):void
		{
			setMatrix(new Matrix(x, remanceMatrix.b, remanceMatrix.c, y, remanceMatrix.tx, remanceMatrix.ty));
		}
		public function dispose():void
		{
			clearMC();
		}
		public function get height():Number
		{
			return (_height);
		}
		public function getMovieWrapperInfo():MovieWrapperInfo
		{
			return (new MovieWrapperInfo(column, _width, _height, totalFrames));
		}
		public function set scale9Grid(value:Rectangle):void
		{
			_scale9Grid = value;
		}
		public function clearMC():void
		{
			if (((sourceMC) && (sourceMC.parent))){
				sourceMC.parent.removeChild(sourceMC);
			};
			sourceMC = null;
		}
		public function get targetMapWidth():Number
		{
			if (remanceMatrix == null){
				return (0);
			};
			return ((column * _width));
		}
		public function get targetMapHeight():Number
		{
			if (remanceMatrix == null){
				return (0);
			};
			return ((Math.ceil((totalFrames / column)) * _height));
		}
		
	}
}