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
	public class KerningRecord
	{
		private var _fontKerningCode1:uint = 0;
		private var _fontKerningCode2:uint = 0;
		private var _fontKerningAdjustment:int = 0;
		
		public function get fontKerningCode1():uint
		{
			return _fontKerningCode1;
		}
		
		public function set fontKerningCode1(value:uint):void
		{
			_fontKerningCode1 = value;
		}
		
		public function get fontKerningCode2():uint
		{
			return _fontKerningCode2;
		}
		
		public function set fontKerningCode2(value:uint):void
		{
			_fontKerningCode2 = value;
		}
		
		public function get fontKerningAdjustment():int
		{
			return _fontKerningAdjustment;
		}
		
		public function set fontKerningAdjustment(value:int):void
		{
			_fontKerningAdjustment = value;
		}
	}
}