/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the swfassist.
 *
 * The Initial Developer of the Original Code is
 * the BeInteractive!.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */

package org.libspark.swfassist.inprogress.swf
{
	import flash.utils.Dictionary;
	
	import org.libspark.swfassist.swf.structures.FillStyle;
	import org.libspark.swfassist.swf.structures.Shape;
	import org.libspark.swfassist.swf.tags.AbstractTagVisitor;
	import org.libspark.swfassist.swf.tags.DefineShape;
	import org.libspark.swfassist.swf.tags.DefineShape2;
	import org.libspark.swfassist.swf.tags.DefineShape3;
	import org.libspark.swfassist.swf.tags.DefineSprite;
	import org.libspark.swfassist.swf.tags.PlaceObject2;

	public class ShapeCollector extends AbstractTagVisitor
	{
		private var _shapes:Array = [];
		
		public var shapeToTag:Dictionary = new Dictionary();
		
		public function get shapes():Array
		{
			return _shapes.slice();
		}
		
		
		
		public override function visitDefineShape(tag:DefineShape):void
		{
			if( tag.shapeId == 145 )
			{
				var dummy:* = null;
			}
			collectShapes(tag);
		}
		
		public override function visitDefineShape2(tag:DefineShape2):void
		{
			var fillStyle:FillStyle = tag.shapes.fillStyles.fillStyles[tag.shapes.fillStyles.fillStyles.length-1];
			if( fillStyle.bitmapMatrix.hasRotate == true )
			{
				trace("有旋转");
			}
			collectShapes(tag);
		}
		
		public override function visitDefineShape3(tag:DefineShape3):void
		{
			collectShapes(tag);
		}

		public override function visitDefineSprite(tag:DefineSprite):void
		{
			var po2:PlaceObject2 = tag.tags.tags[0];
			trace("有影片剪辑");
			//collectShapes(tag);
		}
		
//		public override function visitDefineShape2(tag:DefineShape2):void
//		{
//			collectShape(tag.shapes);
//		}
//		
//		public override function visitDefineShape3(tag:DefineShape3):void
//		{
//			collectShape(tag.shapes);
//		}
//		
//		public override function visitDefineShape4(tag:DefineShape4):void
//		{
//			collectShape(tag.shapes);
//		}
//		
//		
//		
//		public override function visitDefineFont(tag:DefineFont):void
//		{
//			collectShapes(tag.glyphShapeTable);
//		}
//		
//		public override function visitDefineFont2(tag:DefineFont2):void
//		{
//			collectShapes(tag.glyphShapeTable);
//		}
//		
//		public override function visitDefineFont3(tag:DefineFont3):void
//		{
//			collectShapes(tag.glyphShapeTable);
//		}
		
		private function collectShapes(tag:DefineShape):void
		{
			collectShape( tag.shapes );
			shapeToTag[tag.shapes] = tag;
		}
		

		
		private function collectShape(shape:Shape):void
		{
			_shapes.push(shape);
		}
	}
}