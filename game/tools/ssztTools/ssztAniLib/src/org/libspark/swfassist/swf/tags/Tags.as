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
	public class Tags implements TagVisitorAcceptor
	{
		private var _tags:Array = [];
		
		public function get numTags():uint
		{
			return tags.length;
		}
		
		public function get tags():Array
		{
			return _tags;
		}
		
		public function set tags(value:Array):void
		{
			_tags = value;
		}
		
		public function clearTags():void
		{
			if (tags.length > 0) {
				tags.splice(0, tags.length);
			}
		}
		
		public function addTag(tag:Tag):void
		{
			tags.push(tag);
		}
		
		public function visit(visitor:TagVisitor):void
		{
			for each (var tag:Tag in tags) {
				tag.visit(visitor);
			}
		}
	}
}