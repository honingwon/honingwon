package sszt.animeCombo
{
	import com.hurlant.eval.CompiledESC;
	
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import mx.graphics.codec.JPEGEncoder;
	
	import org.libspark.swfassist.swf.structures.Asset;
	import org.libspark.swfassist.swf.structures.SWF;
	import org.libspark.swfassist.swf.tags.DefineBitsJPEG3;
	import org.libspark.swfassist.swf.tags.DoABC;
	import org.libspark.swfassist.swf.tags.SymbolClass;

	public class AnimeComboSwfMaker
	{
		public function AnimeComboSwfMaker()
		{
		}
		
		
		private static function makeSwf():SWF
		{
			var swf:SWF = new SWF();
			swf.header.version        = 9;
			swf.header.frameSize.xMax = 512;
			swf.header.frameSize.yMax = 512;
			swf.header.frameRate      = 25;
			swf.header.numFrames      = 1;            
			swf.fileAttributes.isActionScript3 = true;
			swf.header.isCompressed = true;
			return swf;
		}
		
		
		private static function makeHeaderTagFromCombo(combo:AnimeCombo, comboName:String):String
		{
			var _makeItScript:String = generateMakeItScript(combo);
			var _script:String = new String();
			_script += scriptSec1;
			_script += comboName;
			_script += scriptSec2;
			_script += comboName;
			_script += scriptSec3;
			_script += _makeItScript;
			_script += scriptSec4;
			return _script;
		}
		
		
		private static function generateMakeItScript(combo:AnimeCombo):String
		{
			var _makeItScript:String = "";
			
			_makeItScript += "\t\tcount = " + combo.actionsFrameData.length+";\n";
			
			_makeItScript += "\t\tdirectType = " + combo.directType+";\n";
			
			_makeItScript += "\t\tactions = [";
			var i:int = 0;
			for each(var str:String in  combo.actions)
			{
				if(i != 0)
					_makeItScript += ",";
				_makeItScript += "\""+str+"\"";
				i++;
			}
				
			_makeItScript +="];\n";
			
			_makeItScript += "\t\tactionsFrameSE = [";
			i = 0;
			for each(var obj:Object in  combo.actionsFrameSE)
			{
				if(i != 0)
					_makeItScript += ",";
				_makeItScript += obj.s+","+obj.e;
				i++;
			}
			_makeItScript += "];\n";
			return _makeItScript;
			
		}
		
		
		/**
		 * 打包数据 
		 * @param bitmapDatas 数据源
		 * @param quality
		 * @return 
		 * 
		 */		
		public static function compData(tagName:String,animeCombs:AnimeCombo,quality:Number=80):SWF
		{
			g_IdCounter = 1;
			var swf:SWF= makeSwf();
			
			var __symbolClass:SymbolClass = new SymbolClass();
			var __swfAssets:Asset = new Asset();
			__swfAssets.characterId = 0;
			__swfAssets.name = tagName;
			__symbolClass.symbols.push( __swfAssets );				
			swf.tags.addTag( __symbolClass );
			
			var jpegScript:String = "";
			var script:String     = makeHeaderTagFromCombo(animeCombs, tagName);
			
			
			for(var i:uint = 0; i < animeCombs.actions.length; ++i) {
				for(var frame:int = animeCombs.actionsFrameSE[i].s; frame <= animeCombs.actionsFrameSE[i].e; ++frame) {
					var _frameData:BitmapData = animeCombs.actionsFrameData[frame].bitmapData;
					var type:String = animeCombs.actionsFrameData[frame].type;
					
					if( type == ".png")
					{
						var newObj:Object = handleBitmapData(_frameData);
						script += archiveBitmapData(tagName+"_"+(10000+frame), newObj.bitmapData, (animeCombs.regPoint.x - newObj.xMin), (animeCombs.regPoint.y - newObj.yMin),swf ,quality);
					}
					else
					{
						script += archiveBitmapData(tagName+"_"+(10000+frame), _frameData, (animeCombs.regPoint.x), (animeCombs.regPoint.y ),swf ,quality);
					}
					
				}
			}			
			
			
			var doAbc:DoABC = new DoABC();
			var esc:CompiledESC = new CompiledESC();
			
//			trace("============================");
//			trace(script);
			
			var bytes:ByteArray = esc.eval(script);
			doAbc.abcData = bytes;
			swf.tags.addTag(doAbc);
			
			
			return swf;
			
		}
		
		
		public static function removeGreenAlphaBlending(frameData1:BitmapData):BitmapData{
			var frameData:BitmapData = frameData1.clone();
			for(var y:uint = 0; y < frameData.height; ++y) {
				for(var x:uint = 0; x < frameData.width; ++x) {
					var color:uint = frameData.getPixel32(x, y);
					var alpha:Number = new Number((color >> 24) & 0x000000ff) / 255.0;
					var red  :Number = new Number((color >> 16) & 0x000000ff) / 255.0;
					var green:Number = new Number((color >>  8) & 0x000000ff) / 255.0;
					var blue :Number = new Number((color >>  0) & 0x000000ff) / 255.0;
					if(alpha > 0.0 && alpha < 1.0) {
						
						red   = (  red - 0*(1.0-alpha)) / alpha * 255.0;
						green = (green - 1.0*(1.0-alpha)) / alpha * 255.0;
						blue  = ( blue - 0*(1.0-alpha)) / alpha * 255.0;
						if(red   < 0.0) { red   = 0.0; } else {}
						if(green < 0.0) { green = 0.0; } else {}
						if(blue  < 0.0) { blue  = 0.0; } else {}
						if(red   > 255) { red   = 255; } else {}
						if(green > 255) { green = 255; } else {}
						if(blue  > 255) { blue  = 255; } else {}
						var uiRed  :uint = red;
						var uiGreen:uint = green;
						var uiBlue :uint = blue;
						var uiAlpha:uint = alpha*255;
						color = ((uiAlpha << 24) & 0xff000000) |
							((uiRed   << 16) & 0x00ff0000) |
							((uiGreen <<  8) & 0x0000ff00) |
							((uiBlue  <<  0) & 0x000000ff) ;
						frameData.setPixel32(x, y, color);
					} else {}
				}
			}
			
			return frameData;
		}
		
		
		private static function handleBitmapData(bitmapData:BitmapData):Object
		{
			var timer:int = getTimer();
			var x_min:int=bitmapData.width;
			var x_max:int=0;
			var y_min:int=bitmapData.height;
			var y_max:int=0;
			
			var value:int = 0;
			var i:int;
			var j:int
//			for(i=0; i<bitmapData.width; ++i){
//				for(j=0; j<bitmapData.height; ++j){
//					value = bitmapData.getPixel32(i, j);
//					if(value>0){
//						x_min = i;
//						break;
//					}
//				}
//				if(x_min != 0) break;
//			}
//			
//			if(x_min != 0)
//			{
//				for(i=bitmapData.width; i<0; --i){
//					for(j=bitmapData.height; j<0; --j){
//						value = bitmapData.getPixel32(i, j);
//						if(value>0){
//							x_max = i;
//							break;
//						}
//					}
//					if(x_max != 0) break;
//				}
//				
//				for(i=0; i<bitmapData.height; ++i){
//					for(j=0; j<bitmapData.width; ++j){
//						value = bitmapData.getPixel32(j, i);
//						if(value>0){
//							y_min = j;
//							break;
//						}
//					}
//					if(y_min != 0) break;
//				}
//				
//				for(i=bitmapData.height; i<0; ++i){
//					for(j=bitmapData.width; j<0; ++j){
//						value = bitmapData.getPixel32(j, i);
//						if(value>0){
//							y_max = j;
//							break;
//						}
//					}
//					if(y_max != 0) break;
//				}
//				
//				
//			}
			
			
			for(i=0; i<bitmapData.width; i++){
				for(j=0; j<bitmapData.height; j++){
					value = bitmapData.getPixel32(i, j);
					if(value>0){
						if(i<x_min){
							x_min = i;
						}
						else if(i>x_max){
							x_max = i;
						}
						if(j<y_min){
							y_min = j;
						}
						else if(j>y_max){
							y_max = j;
						}
					}
				}
			}
			
			
			
			var rw:int = x_max - x_min+1;
			var rh:int = y_max - y_min+1;
			if(rw<0 || rh<0){
				rw = 1;
				rh = 1;
				x_min = 0;
				y_min = 0;
			}
			
			var newBitmapData:BitmapData = new BitmapData(rw, rh);
			newBitmapData.copyPixels(bitmapData, new Rectangle(x_min, y_min, rw, rh), new Point(0,0));
			
			trace(getTimer() - timer);
			return {xMin: x_min, yMin: y_min, rw:rw, rh:rh, bitmapData: newBitmapData};
		}
		
		
		private static function archiveBitmapData(name:String, data:BitmapData, xoff:Number, yoff:Number, swf:SWF, quality:uint):String
		{
			var symbolClass:SymbolClass = new SymbolClass();
			var jpgAssets:Asset = new Asset();
			jpgAssets.characterId = g_IdCounter;
			jpgAssets.name = name;
			symbolClass.symbols.push( jpgAssets );
			
			var jpgEncoder:JPEGEncoder = new JPEGEncoder(quality);
			var defineJPEG:DefineBitsJPEG3 = new DefineBitsJPEG3();
			defineJPEG.characterId = g_IdCounter;
			
			var alphaArr:ByteArray = new ByteArray();
			var byteArr:ByteArray = data.getPixels(new Rectangle(0, 0, data.width, data.height));
			byteArr.position = 0;

			alphaArr.compress();
			defineJPEG.jpegData = jpgEncoder.encodeByteArray(byteArr, data.width, data.height, false);
			defineJPEG.bitmapAlphaData = getAlphapixels(byteArr);		
			
			swf.tags.addTag(defineJPEG);
			swf.tags.addTag(symbolClass);
			
			var _script:String = makeJpegScript(name, xoff, yoff);
			g_IdCounter++;
			return _script;
		}
		
		private static function getAlphapixels(pixels:ByteArray):ByteArray{
			var data1:ByteArray = new ByteArray;
			var i:int = 0;
			while(i< pixels.length){
				var alpha:int = (pixels[i]) ; 
				data1.writeByte(alpha); 
				i = i+4;
			}
			data1.compress();
			return data1;
		}
		
		private static function makeJpegScript(name:String, xoff:Number, yoff:Number):String
		{
			var _script:String = "";
			_script += jpegScriptSec1;
			_script += name;
			_script += jpegScriptSec2;
			_script += name;
			_script += jpegScriptSec3;
			_script += "\t\txoff = " + xoff + ";\n";
			_script += "\t\tyoff = " + yoff + ";\n";
			_script += jpegScriptSec4;
			return _script;
		}
		
		
		
		private static var scriptSec1:String = "namespace fu = \"flash.utils\"; \n"
			+ "use namespace fu;\n"  
			+ "namespace fd = \"flash.display\"; \n"
			+ "use namespace fd;\n"  
			+ "public dynamic class ";
		// KeyFrameAnimeComboSwfHeaderTag
		private static var scriptSec2:String = " extends Sprite { \n\tpublic function ";
		// KeyFrameAnimeComboSwfHeaderTag
		private static var scriptSec3:String = "()\n\t{\n";
		// Make It Script
		private static var scriptSec4:String = "\t};\n\tpublic var count:int;\n\tpublic var actions:Array; \n\tpublic var actionsFrameSE:Array; \n\tpublic var directType:int; \n\}\n";
		
		private static var jpegScriptSec1:String = "public class ";
		// JpegAssetTag
		private static var jpegScriptSec2:String = " extends BitmapData\n{\n\tpublic var xoff:Number = 0;\n\tpublic var yoff:Number = 0;\n\n\tprivate function ";
		// JpegAssetTag
		private static var jpegScriptSec3:String = "(width:int, height:int):super(width, height)\n\t{\n\n";
		// Make It Script
		private static var jpegScriptSec4:String = "\t}\n}\n";
		
		private static var g_IdCounter:uint = 1;
		
		
		
		
	}
}