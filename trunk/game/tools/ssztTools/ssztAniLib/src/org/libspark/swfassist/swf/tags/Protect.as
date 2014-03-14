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
	public class Protect extends AbstractTag
	{
		public function Protect(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_PROTECT);
		}
		
		private var _hasPassword:Boolean = false;
		private var _password:String;
		
		public function get hasPassword():Boolean
		{
			return _hasPassword;
		}
		
		public function set hasPassword(value:Boolean):void
		{
			_hasPassword = value;
		}
		
		public function get password():String
		{
			return _password;
		}
		
		public function set password(value:String):void
		{
			_password = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitProtect(this);
		}
	}
}