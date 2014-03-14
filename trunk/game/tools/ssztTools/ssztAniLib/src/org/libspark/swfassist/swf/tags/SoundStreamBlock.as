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
	import org.libspark.swfassist.swf.structures.SoundData;
	
	public class SoundStreamBlock extends AbstractTag
	{
		public function SoundStreamBlock(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_SOUND_STREAM_BLOCK);
		}
		
		private var _streamSoundData:SoundData = null;
		
		public function get streamSoundData():SoundData
		{
			return _streamSoundData;
		}
		
		public function set streamSoundData(value:SoundData):void
		{
			_streamSoundData = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitSoundStreamBlock(this);
		}
	}
}