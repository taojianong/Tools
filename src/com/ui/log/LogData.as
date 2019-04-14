package com.ui.log {
	
	/**
	 * 日志数据
	 * @author taojianlong 2014-3-26 22:19
	 */
	public class LogData {
		
		private var xml:XML;
		
		public var id:int = 0;
		public var title:String = "";
		public var text:String = "";
		public var time:String = "";
		
		public function LogData( xml:XML = null ) {
			
			this.xml = xml;
			
			if ( xml ) {
				id    = int(xml.@id);
				title = String(xml.@title);
				text  = String(xml.@text);
				time  = String(xml.@time);
				
			}
		}
		
		public function get logXML():XML {
			
			var xml:XML = <item id = { this.id } title = { this.title } text = { this.text } time = { this.time} /> ;
			
			return xml;
		}
	}

}