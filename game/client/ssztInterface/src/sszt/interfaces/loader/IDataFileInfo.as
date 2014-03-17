package sszt.interfaces.loader
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public interface IDataFileInfo
	{
		function get path():String;
//		function get rects():Vector.<Rectangle>;
		function get rects():Array;
//		function set rects(value:Vector.<Rectangle>):void;
		function set rects(value:Array):void;
//		function get datas():Vector.<BitmapData>;
		function get datas():Array;
//		function set datas(value:Vector.<BitmapData>):void;
		function set datas(value:Array):void;
		function getSourceData():ByteArray;
		
		function dispose():void;
	}
}