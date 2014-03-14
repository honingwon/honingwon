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
	public class MorphLineStyle
	{
		private var _startWidth:uint = 0;
		private var _endWidth:uint = 0;
		private var _startColor:RGBA = new RGBA();
		private var _endColor:RGBA = new RGBA();
		
		public function get startWidth():uint
		{
			return _startWidth;
		}
		
		public function set startWidth(value:uint):void
		{
			_startWidth = value;
		}
		
		public function get endWidth():uint
		{
			return _endWidth;
		}
		
		public function set endWidth(value:uint):void
		{
			_endWidth = value;
		}
		
		public function get startColor():RGBA
		{
			return _startColor;
		}
		
		public function set startColor(value:RGBA):void
		{
			_startColor = value;
		}
		
		public function get endColor():RGBA
		{
			return _endColor;
		}
		
		public function set endColor(value:RGBA):void
		{
			_endColor = value;
		}
	}
}