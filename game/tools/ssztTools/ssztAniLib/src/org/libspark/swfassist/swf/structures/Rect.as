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
	public class Rect
	{
		private var _xMin:int = 0;
		private var _xMax:int = 0;
		private var _yMin:int = 0;
		private var _yMax:int = 0;
		
		// SB
		public function get xMin():Number
		{
			return xMinTwips / 20;
		}
		
		public function set xMin(value:Number):void
		{
			xMinTwips = value * 20;
		}
		
		public function get xMinTwips():int
		{
			return _xMin;
		}
		
		public function set xMinTwips(value:int):void
		{
			_xMin = value;
		}
		
		// SB
		public function get xMax():Number
		{
			return xMaxTwips / 20;
		}
		
		public function set xMax(value:Number):void
		{
			xMaxTwips = value * 20;
		}
		
		public function get xMaxTwips():int
		{
			return _xMax;
		}
		
		public function set xMaxTwips(value:int):void
		{
			_xMax = value;
		}
		
		// SB
		public function get yMin():Number
		{
			return yMinTwips / 20;
		}
		
		public function set yMin(value:Number):void
		{
			yMinTwips = value * 20;
		}
		
		public function get yMinTwips():int
		{
			return _yMin;
		}
		
		public function set yMinTwips(value:int):void
		{
			_yMin = value;
		}
		
		// SB
		public function get yMax():Number
		{
			return yMaxTwips / 20;
		}
		
		public function set yMax(value:Number):void
		{
			yMaxTwips = value * 20;
		}
		
		public function get yMaxTwips():int
		{
			return _yMax;
		}
		
		public function set yMaxTwips(value:int):void
		{
			_yMax = value;
		}
	}
}