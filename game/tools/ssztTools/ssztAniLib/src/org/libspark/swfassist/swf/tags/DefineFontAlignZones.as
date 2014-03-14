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
	import org.libspark.swfassist.swf.structures.ZoneRecord;
	
	public class DefineFontAlignZones extends AbstractTag
	{
		public function DefineFontAlignZones(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_DEFINE_FONT_ALIGN_ZONES);
		}
		
		private var _fontId:uint = 0;
		private var _csmTableHint:uint = CSMTableHintConstants.THIN;
		private var _zoneTable:Array = [];
		
		public function get fontId():uint
		{
			return _fontId;
		}
		
		public function set fontId(value:uint):void
		{
			_fontId = value;
		}
		
		public function get csmTableHint():uint
		{
			return _csmTableHint;
		}
		
		public function set csmTableHint(value:uint):void
		{
			_csmTableHint = value;
		}
		
		public function get numZones():uint
		{
			return zoneTable.length;
		}
		
		public function get zoneTable():Array
		{
			return _zoneTable;
		}
		
		public function set zoneTable(value:Array):void
		{
			_zoneTable = value;
		}
		
		public function clearZoneTable():void
		{
			if (numZones > 0) {
				zoneTable.splice(0, numZones);
			}
		}
		
		public function addZoneRecord(zone:ZoneRecord):void
		{
			zoneTable.push(zone);
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitDefineFontAlignZones(this);
		}
	}
}