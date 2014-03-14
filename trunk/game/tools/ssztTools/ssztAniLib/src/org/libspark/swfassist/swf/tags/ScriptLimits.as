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
	public class ScriptLimits extends AbstractTag
	{
		public function ScriptLimits(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_SCRIPT_LIMITS);
		}
		
		private var _maxRecursionDepth:uint = 256;
		private var _scriptTimeoutSeconds:uint = 15;
		
		public function get maxRecursionDepth():uint
		{
			return _maxRecursionDepth;
		}
		
		public function set maxRecursionDepth(value:uint):void
		{
			_maxRecursionDepth = value;
		}
		
		public function get scriptTimeoutSeconds():uint
		{
			return _scriptTimeoutSeconds;
		}
		
		public function set scriptTimeoutSeconds(value:uint):void
		{
			_scriptTimeoutSeconds = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitScriptLimits(this);
		}
	}
}