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

package org.libspark.swfassist.swf.tags
{
	public class SetTabIndex extends AbstractTag
	{
		public function SetTabIndex(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_SET_TAB_INDEX);
		}
		
		private var _depth:uint = 0;
		private var _tabIndex:uint = 0;
		
		public function get depth():uint
		{
			return _depth;
		}
		
		public function set depth(value:uint):void
		{
			_depth = value;
		}
		
		public function get tabIndex():uint
		{
			return _tabIndex;
		}
		
		public function set tabIndex(value:uint):void
		{
			_tabIndex = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitSetTabIndex(this);
		}
	}
}