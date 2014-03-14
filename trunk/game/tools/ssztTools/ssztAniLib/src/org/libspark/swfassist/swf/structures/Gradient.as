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
	public class Gradient
	{
		private var _spreadMode:uint = SpreadModeConstants.PAD_MODE;
		private var _interpolationMode:uint = InterpolationModeConstants.NORMAL_RGB_MODE;
		private var _gradientRecords:Array = [];
		
		public function get spreadMode():uint
		{
			return _spreadMode;
		}
		
		public function set spreadMode(value:uint):void
		{
			_spreadMode = value;
		}
		
		public function get interpolationMode():uint
		{
			return _interpolationMode;
		}
		
		public function set interpolationMode(value:uint):void
		{
			_interpolationMode = value;
		}
		
		public function get numGradientRecords():uint
		{
			return gradientRecords.length;
		}
		
		public function get gradientRecords():Array
		{
			return _gradientRecords;
		}
		
		public function set gradientRecords(value:Array):void
		{
			_gradientRecords = value;
		}
	}
}