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
	public class DefineSprite extends AbstractTag
	{
		public function DefineSprite(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_DEFINE_SPRITE);
		}
		
		private var _spriteId:uint = 0;
		private var _numFrames:uint = 0;
		private var _tags:Tags = new Tags();
		
		public function get spriteId():uint
		{
			return _spriteId;
		}
		
		public function set spriteId(value:uint):void
		{
			_spriteId = value;
		}
		
		public function get numFrames():uint
		{
			return _numFrames;
		}
		
		public function set numFrames(value:uint):void
		{
			_numFrames = value;
		}
		
		public function get tags():Tags
		{
			return _tags;
		}
		
		public function set tags(value:Tags):void
		{
			_tags = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitDefineSprite(this);
		}
	}
}