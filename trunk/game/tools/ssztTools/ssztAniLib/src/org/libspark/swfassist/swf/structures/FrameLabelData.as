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
	public class FrameLabelData
	{
		private var _frameNumber:uint = 0;
		private var _frameLabel:String;
		
		public function get frameNumber():uint
		{
			return _frameNumber;
		}
		
		public function set frameNumber(value:uint):void
		{
			_frameNumber = value;
		}
		
		public function get frameLabel():String
		{
			return _frameLabel;
		}
		
		public function set frameLabel(value:String):void
		{
			_frameLabel = value;
		}
	}
}