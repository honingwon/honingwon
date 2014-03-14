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
	public class MorphGradientRecord
	{
		private var _startRatio:uint = 0;
		private var _startColor:RGBA = new RGBA();
		private var _endRatio:uint = 0;
		private var _endColor:RGBA = new RGBA();
		
		public function get startRatio():uint
		{
			return _startRatio;
		}
		
		public function set startRatio(value:uint):void
		{
			_startRatio = value;
		}
		
		public function get startColor():RGBA
		{
			return _startColor;
		}
		
		public function set startColor(value:RGBA):void
		{
			_startColor = value;
		}
		
		public function get endRatio():uint
		{
			return _endRatio;
		}
		
		public function set endRatio(value:uint):void
		{
			_endRatio = value;
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