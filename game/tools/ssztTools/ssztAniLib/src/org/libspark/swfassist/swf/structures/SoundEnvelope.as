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
	public class SoundEnvelope
	{
		private var _pos44:uint = 0;
		private var _leftLevel:uint = 32768;
		private var _rightLevel:uint = 32768;
		
		public function get pos44():uint
		{
			return _pos44;
		}
		
		public function set pos44(value:uint):void
		{
			_pos44 = value;
		}
		
		public function get leftLevel():uint
		{
			return _leftLevel;
		}
		
		public function set leftLevel(value:uint):void
		{
			_leftLevel = value;
		}
		
		public function get rightLevel():uint
		{
			return _rightLevel;
		}
		
		public function set rightLevel(value:uint):void
		{
			_rightLevel = value;
		}
	}
}