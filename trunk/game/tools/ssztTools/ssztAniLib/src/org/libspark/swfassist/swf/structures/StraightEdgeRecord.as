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

package org.libspark.swfassist.swf.structures
{
	public class StraightEdgeRecord extends AbstractShapeRecord
	{
		public function StraightEdgeRecord()
		{
			super(ShapeRecordTypeConstants.STRAIGHT_EDGE, true);
		}
		
		private var _generalLine:Boolean = false;
		private var _verticalLine:Boolean = false;
		private var _deltaX:int = 0;
		private var _deltaY:int = 0;
		
		public function get generalLine():Boolean
		{
			return _generalLine;
		}
		
		public function set generalLine(value:Boolean):void
		{
			_generalLine = value;
		}
		
		public function get verticalLine():Boolean
		{
			return _verticalLine;
		}
		
		public function set verticalLine(value:Boolean):void
		{
			_verticalLine = value;
		}
		
		public function get horizontalLine():Boolean
		{
			return !verticalLine;
		}
		
		public function set horizontalLine(value:Boolean):void
		{
			verticalLine = !value;
		}
		
		public function get deltaX():Number
		{
			return deltaXTwips / twipsFactor;
		}
		
		public function set deltaX(value:Number):void
		{
			deltaXTwips = value * twipsFactor;
		}
		
		public function get deltaXTwips():int
		{
			return _deltaX;
		}
		
		public function set deltaXTwips(value:int):void
		{
			_deltaX = value;
		}
		
		public function get deltaY():Number
		{
			return deltaYTwips / twipsFactor;
		}
		
		public function set deltaY(value:Number):void
		{
			deltaYTwips = value * twipsFactor;
		}
		
		public function get deltaYTwips():int
		{
			return _deltaY;
		}
		
		public function set deltaYTwips(value:int):void
		{
			_deltaY = value;
		}
	}
}