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

package org.libspark.swfassist.flash.display
{
	import org.libspark.swfassist.swf.structures.Shape;
	import org.libspark.swfassist.swf.structures.ShapeRecord;
	import org.libspark.swfassist.swf.structures.ShapeRecordTypeConstants;
	import org.libspark.swfassist.swf.structures.StyleChangeRecord;
	import org.libspark.swfassist.swf.structures.StraightEdgeRecord;
	import org.libspark.swfassist.swf.structures.CurvedEdgeRecord;

	public class AbstractShapeDrawer implements ShapeDrawer
	{
		public function AbstractShapeDrawer(graphics:VectorGraphics = null)
		{
			if (graphics) {
				this.graphics = graphics;
			}
		}
		
		private var _graphics:VectorGraphics;
		
		public function get graphics():VectorGraphics
		{
			return _graphics;
		}
		
		public function set graphics(value:VectorGraphics):void
		{
			_graphics = value;
		}
		
		public function draw(shape:Shape):void
		{
			for each (var record:ShapeRecord in shape.shapeRecords) {
				switch (record.type) {
					case ShapeRecordTypeConstants.STYLE_CHANGE:
						drawStyleChange(StyleChangeRecord(record));
						break;
					case ShapeRecordTypeConstants.STRAIGHT_EDGE:
						drawStraightEdge(StraightEdgeRecord(record));
						break;
					case ShapeRecordTypeConstants.CURVED_EDGE:
						drawCurvedEdge(CurvedEdgeRecord(record));
						break;
default:
//STDOUT.puts("OHOHOHOOHO");
break;
				}
			}
			drawEnd();
		}
		
		protected function drawStyleChange(record:StyleChangeRecord):void
		{
		}
		
		protected function drawStraightEdge(record:StraightEdgeRecord):void
		{
		}
		
		protected function drawCurvedEdge(record:CurvedEdgeRecord):void
		{
		}
		
		protected function drawEnd():void
		{
		}
	}
}