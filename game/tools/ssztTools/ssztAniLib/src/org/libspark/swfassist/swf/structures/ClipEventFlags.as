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
	public class ClipEventFlags
	{
		public var eventKeyUp:Boolean = false;
		public var eventKeyDown:Boolean = false;
		public var eventMouseUp:Boolean = false;
		public var eventMouseDown:Boolean = false;
		public var eventMouseMove:Boolean = false;
		public var eventUnload:Boolean = false;
		public var eventEnterFrame:Boolean = false;
		public var eventLoad:Boolean = false;
		public var eventDragOver:Boolean = false;
		public var eventRollOut:Boolean = false;
		public var eventRollOver:Boolean = false;
		public var eventReleaseOutSide:Boolean = false;
		public var eventRelease:Boolean = false;
		public var eventPress:Boolean = false;
		public var eventInitialize:Boolean = false;
		public var eventData:Boolean = false;
		public var eventConstruct:Boolean = false;
		public var eventKeyPress:Boolean = false;
		public var eventDragOut:Boolean = false;
	}
}