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
	import org.libspark.swfassist.swf.actions.ActionRecords;
	
	public class ClipActionRecord
	{
		private var _eventFlags:ClipEventFlags = new ClipEventFlags();
		private var _keyCode:uint = 0;
		private var _actions:ActionRecords = new ActionRecords();
		
		public function get eventFlags():ClipEventFlags
		{
			return _eventFlags;
		}
		
		public function set eventFlags(value:ClipEventFlags):void
		{
			_eventFlags = value;
		}
		
		public function get keyCode():uint
		{
			return _keyCode;
		}
		
		public function set keyCode(value:uint):void
		{
			_keyCode = value;
		}
		
		public function get actions():ActionRecords
		{
			return _actions;
		}
		
		public function set actions(value:ActionRecords):void
		{
			_actions = value;
		}
	}
}