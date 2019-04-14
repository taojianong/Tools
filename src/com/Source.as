package com {	
	import com.customLoader.SourceConst;
	import com.customLoader.SourceLoaderManager;
	
	/**
	 * 资源
	 * @author taojianlong 2014-3-27 21:32
	 */
	public class Source {
		
		//资源池
		private static const source_pool:Object = {
			"log":"xml/log.xml"	, "common":"swf/common.swf"		
		};
		
		//-----------------------------资源ID
		public static const SOURCE_LOG:String = "log"; //日志保存数据
		public static const SOURCE_COMMON:String = "common";
		
		/**
		 * 获取对应资源ID资源地址
		 * @param sourceId 资源ID
		 * @return
		 */
		public static function getSourceUrl( sourceId:String ):String {
			
			return String( source_pool[ sourceId ] );
		}
		
		/**
		 * 根据资源ID获取对应类型资源
		 * @param sourceId 资源ID
		 * @param type     资源类型，见SourceConst
		 * @param linkName 链接名
		 * @return
		 */
		public static function getSource( sourceId:String, type:String="object", linkName:String="" ):*{
			
			return SourceLoaderManager.getSource( sourceId , type , linkName );
		}
		
	}

}