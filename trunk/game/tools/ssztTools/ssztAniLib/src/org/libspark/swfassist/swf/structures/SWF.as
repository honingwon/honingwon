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
	import org.libspark.swfassist.swf.tags.FileAttributes;
	import org.libspark.swfassist.swf.tags.Tags;
	import org.libspark.swfassist.swf.tags.TagVisitorAcceptor;
	import org.libspark.swfassist.swf.tags.TagVisitor;
	
	public class SWF implements TagVisitorAcceptor
	{
		private var _header:Header = new Header();
		private var _fileAttributes:FileAttributes = new FileAttributes();
		private var _tags:Tags = new Tags();
		
		public function get header():Header
		{
			return _header;
		}
		
		public function set header(value:Header):void
		{
			_header = value;
		}
		
		public function get fileAttributes():FileAttributes
		{
			return _fileAttributes;
		}
		
		public function set fileAttributes(value:FileAttributes):void
		{
			_fileAttributes = value;
		}
		
		public function get tags():Tags
		{
			return _tags;
		}
		
		public function set tags(value:Tags):void
		{
			_tags = value;
		}
		
		public function visit(visitor:TagVisitor):void
		{
			tags.visit(visitor);
		}
	}
}