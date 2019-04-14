package com.manager {
	
	import com.manager.TopManager;
	import com.Source;
	import com.ui.log.LogData;
	import com.UIGlobal;
	import com.util.DMap;
	import com.util.FileUtils;
	import flash.filesystem.File;
	
	/**
	 * 日志管理
	 * @author taojianlong 2014-3-26 22:18
	 */
	public class LogManager {
		
		private var logMap:DMap = new DMap();
		private var logXML:XML;//当前读取的log.xml数据
		
		public function LogManager() {
		
		}
		
		public function readLogData( xml:XML ):void {
			
			logXML = xml;
			
			if ( xml == null ) {
				return;
			}
			
			var logData:LogData;
			for (var i:int = 0; i < xml.item.length(); i++) {
				
				logData = new LogData( xml.item[i] );	
				logMap.put( logData.id , logData );
			}			
		}
		
		public function addLogData( logData:LogData ):void {
			
			var xml:XML = <item id = { logData.id } title = { logData.title } text = { logData.text } time = { logData.time} /> ;
			if ( logXML == null ) {
				logXML = <data></data>;				
			}
			
			logXML.appendChild( xml );
			
			trace(logXML);
			
			logMap.put( logData.id , logData );
			
			saveLog( logXML , addLogDataComplete );
		}
		
		private function addLogDataComplete():void {
			
			TopManager.Instance.showInfo("保存日志成功");
			
			if ( UIGlobal.logUI != null ) {
				UIGlobal.logUI.updateLogList();
			}
		}
		
		/**
		 * 保存日志数据
		 * @param logXML   要保存的log XML数据
		 * @param complete 保存日志完成事件
		 */
		private function saveLog( logXML:XML , complete:Function = null ):void {
			
			var url:String = File.applicationDirectory.nativePath + "/" + Source.getSourceUrl( Source.SOURCE_LOG );
			//保存日志
			FileUtils.saveUTFFile( url , logXML.toString() , null , complete );
		}
		
		/**
		 * 修改日志数据，并保存
		 * @param logData 日志数据
		 */
		public function modifyLog( logData:LogData ):Boolean {
			
			if ( logData ) {
				
				var list:XMLList = logXML.item.( @id == String(logData.id) );
				var xml:XML;
				for (var i:int = 0; i < list.length();i++ ) {
					xml = list[0];
					if ( xml != null && int(xml.@id) == logData.id ) {
						xml.@title = logData.title;
						xml.@text  = logData.text;
						xml.@time  = logData.time;
					}
				}
				trace( logXML );
				saveLog( logXML );
				return true;
			}
			else {
				return false;
			}		
		}
		
		
		public function get logItems():int {
			
			return logMap.keys;
		}		
		
		/**
		 * 日志列表
		 */
		public function get logList():Array {
			
			var list:Array = logMap.toArray();
			list = list.sortOn("id",Array.NUMERIC);
			return list;
		}
		
		private static var instance:LogManager;		
		public static function get Instance():LogManager {
		
			return instance = instance || new LogManager();
		}
	}

}