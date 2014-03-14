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
	public class FileAttributes extends AbstractTag
	{
		public function FileAttributes(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_FILE_ATTRIBUTES);
		}
		
		private var _hasMetadata:Boolean = false;
		private var _isActionScript3:Boolean = false;
		private var _useNetwork:Boolean = false;
		
		public function get hasMetadata():Boolean
		{
			return _hasMetadata;
		}
		
		public function set hasMetadata(value:Boolean):void
		{
			_hasMetadata = value;
		}
		
		public function get isActionScript3():Boolean
		{
			return _isActionScript3;
		}
		
		public function set isActionScript3(value:Boolean):void
		{
			_isActionScript3 = value;
		}
		
		public function get useNetwork():Boolean
		{
			return _useNetwork;
		}
		
		public function set useNetwork(value:Boolean):void
		{
			_useNetwork = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitFileAttributes(this);
		}
	}
}