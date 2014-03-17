package sszt.ui.label
{
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.LanguageType;
	
	/**
	 * 修改：王鸿源 honingwon@gmail.com。
	 * 日期：2012-10-22
	 * */
	public class MAssetLabel extends TextField
	{		
//		#32443A
		//宋体 12 白色 黑边 数字 
		public static const LABELTYPE1:Array = [new TextFormat("SimSun",12,0xFFFFFF),new GlowFilter(0x000000,1,4,4,4.5)];
		//宋体 12 灰色 黑边 
		public static const LABELTYPE2:Array = [new TextFormat("SimSun",12,0xA89572),new GlowFilter(0x000000,1,4,4,4.5)];
		//宋体12黄色,黑边
		public static const LABELTYPE3:Array = [new TextFormat("SimSun",12,0xEDDB60),new GlowFilter(0x1D250E,1,2,2,4.5)];
		//白色12黑边
		public static const LABELTYPE4:Array = [new TextFormat("SimSun",12,0xFFFFFF),new GlowFilter(0x1D250E,1,1,1,4.5)];
		//白色12 黄边
		public static const LABELTYPE5:Array = [new TextFormat("SimSun",12,0xFFFDA5),new GlowFilter(0x1D250E,1,1,1,0,0)];
		//绿色 黑边
		public static const LABELTYPE6:Array = [new TextFormat("SimSun",12,0xb3e5db),new GlowFilter(0x1D250E,1,4,4,4.5)];
		//橙色字，绿边
		public static const LABELTYPE7:Array = [new TextFormat("SimSun",12,0xFF8A00),new GlowFilter(0x314545,1,2,2,10)];
		//黄字，黑边
		public static const LABELTYPE8:Array = [new TextFormat("SimSun",12,0xEDDB60),new GlowFilter(0x1D250E,1,2,2,4.5)];	
		//宋体 14 白色 黑边  
		public static const LABELTYPE9:Array = [new TextFormat("SimSun",14,0xFFFFFF),new GlowFilter(0x1D250E,1,4,4,4.5)];
		//宋体 12 绿色
		public static const LABELTYPE10:Array = [new TextFormat("SimSun",12,0x74c918),new GlowFilter(0x1D250E,1,4,4,4.5)];
		//宋体 12 红色
		public static const LABELTYPE11:Array = [new TextFormat("SimSun",12,0xff3000),new GlowFilter(0x1D250E,1,4,4,4.5)];
		//宋体 12 浅绿色
		public static const LABELTYPE12:Array = [new TextFormat("SimSun",12,0x00ff77),new GlowFilter(0x1D250E,1,4,4,4.5)];
		//宋体 12 蓝绿色
		public static const LABELTYPE13:Array = [new TextFormat("SimSun",12,0x21e7ff),new GlowFilter(0x1D250E,1,4,4,4.5)];
		//浅黄
		public static const LABELTYPE14:Array = [new TextFormat("SimSun",12,0xFFFDA5),new GlowFilter(0x0D240A,1,4,4,4.10)];
		//浅灰
		public static const LABELTYPE15:Array = [new TextFormat("SimSun",11,0x879F99),new GlowFilter(0x2B3D37,1,4,4,4,10)];
		//纯绿色
		public static const LABELTYPE16:Array = [new TextFormat("SimSun",12,0x00ff00),null];
		//绿色11 黑边
		public static const LABELTYPE17:Array = [new TextFormat("SimSun",12,0x00FF00),new GlowFilter(0x333333,1,4,4,4.5)];
		
		//用下面的
		
		//宋体 12 白色 黑边 数字 
		public static const LABEL_TYPE1:Array = [new TextFormat("SimSun",12,0xFFFCCC),new GlowFilter(0x000000,1,2,2,6)];
		//宋体 12 灰色 黑边 
		public static const LABEL_TYPE2:Array = [new TextFormat("SimSun",12,0xA89572),new GlowFilter(0x000000,1,2,2,6)];
		//宋体 13 黄色
		public static const LABEL_TYPE3:Array = [new TextFormat("SimSun",13,0xFFB05B),null];
		//宋体 12  灰色
		public static const LABEL_TYPE4:Array = [new TextFormat("SimSun",12,0xC6B088),null];
		//宋体 12 白色  
		public static const LABEL_TYPE5:Array = [new TextFormat("SimSun",12,0xEEE7C4),null];
		//宋体 12 红色
		public static const LABEL_TYPE6:Array = [new TextFormat("SimSun",12,0xFF0000),null];
		//宋体 12 绿色
		public static const LABEL_TYPE7:Array = [new TextFormat("SimSun",12,0x33ff00),null];
		//宋体 12 黄
		public static const LABEL_TYPE8:Array = [new TextFormat("SimSun",12,0xCC7300),null];
		//宋体 12 蓝
		public static const LABEL_TYPE9:Array = [new TextFormat("SimSun",12,0x0099cc),null];
		
		//宋体12 白色
		public static const LABEL_TYPE20:Array = [new TextFormat("SimSun",12,0xFFfccc),null];
		//宋体 12 橙色#ff9900
		public static const LABEL_TYPE21:Array = [new TextFormat("SimSun",12,0xFF9900),null];
		//宋体 14 橙色#ff9900
		public static const LABEL_TYPE21B:Array = [new TextFormat("SimSun",14,0xFF9900,true),null];
		//宋体 12 黄色#ffcc00
		public static const LABEL_TYPE22:Array = [new TextFormat("SimSun",12,0xFFcc00),null];	
		public static const LABEL_TYPE23:Array = [new TextFormat("SimSun",12,0xFFcc66,true),null];
		public static const LABEL_TYPE24:Array = [new TextFormat("SimSun",12,0xFF6600),null];
		//14号白色加粗字体
		public static const LABEL_TYPE_B14:Array = [new TextFormat("SimSun",14,0xFFFccc,true),null];	
		//标题颜色
		public static const LABEL_TYPE_TITLE:Array = [new TextFormat("SimSun",12,0xd9ad60),new GlowFilter(0x000000,1,2,2,6)];
		public static const LABEL_TYPE_TITLE2:Array = [new TextFormat("SimSun",12,0xffcc66)];
		//标签颜色
		public static const LABEL_TYPE_TAG:Array = [new TextFormat("SimSun",12,0xd9ad60)];//d3b889
		public static const LABEL_TYPE_TAG2:Array = [new TextFormat("SimSun",12,0xffcc67,true)];//d3b889
		//Tahoma 白色描边
		public static const LABEL_TYPE_EN:Array = [new TextFormat("Tahoma",12,0xFFFFFF),new GlowFilter(0x000000,1,2,2,6)];
		//格子样式
		public static const LABEL_TYPE_CELL:Array = [new TextFormat("SimSun",12,0x3f4f4b),new GlowFilter(0x050d0d,1,2,2,6)];
		//剧情文字提示
		public static const LABEL_TYPE_STORY:Array = [new TextFormat("KaiTi",24,0xFFFFFF,true),new GlowFilter(0xff0090,1,15,15,2)];
		//
		public static const LABEL_TYPE_YAHEI:Array = [new TextFormat("Microsoft Yahei",12,0xFFFccc)];
		public static const LABEL_TYPE_YAHEI1:Array = [new TextFormat("Microsoft Yahei",12,0x777164)];
		
		public function MAssetLabel(label:String,labelType:Array,align:String = "center")
		{
			super();
			(labelType[0] as TextFormat).leading = 2;
			this.text = label;
			this.height = textHeight + 4;
			this.mouseEnabled = mouseWheelEnabled = false;
			(labelType[0] as TextFormat).align = align;
			this.setTextFormat(labelType[0]);
			defaultTextFormat = labelType[0];
			this.autoSize = align;
			if(labelType[1]!=null)
			{
				this.filters = [labelType[1]];
			}
		}
		
		public function setLabelType(argLabelType:Array):void
		{
			this.setTextFormat(argLabelType[0]);
			defaultTextFormat = argLabelType[0];
			if(argLabelType[1]!=null)
			{
				this.filters = [argLabelType[1]];
			}
		}
		
		public function setValue(label:String):void
		{
			text = label;
		}
		
		public function setHtmlValue(label:String):void
		{
			htmlText = label;
		}
		
		
		public function setSize(width:int,height:int):void
		{
			this.width = width;
			this.height = height;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
	}
}