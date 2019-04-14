package com.manager {
	import com.customLoader.event.LoaderEvent;
	import com.customLoader.loader.SourceLoader;
	import com.customLoader.LoaderSource;
	import com.customLoader.SourceLoaderManager;
	import com.Source;
	
	/**
	 * 资源管理
	 * @author taojianlong 2014-3-26 22:22
	 */
	public class SourceManager {
		
		private var loaderSource:LoaderSource;
		private var _complete:Function = null;
		
		public function SourceManager() {
			
		}
		
		/**
		 * 启动时加载数据
		 */
		public function startLoad( complete:Function = null ):void {
			
			_complete = complete;
			
			loaderSource = loaderSource || new LoaderSource();
			loaderSource.add( Source.getSourceUrl( Source.SOURCE_LOG ) , true , Source.SOURCE_LOG );
			loaderSource.add( Source.getSourceUrl( Source.SOURCE_COMMON ) , true , Source.SOURCE_COMMON );			
			loaderSource.addEventListener( LoaderEvent.LOAD_COMPLETE , startLoadCompleteHandler );
			loaderSource.start();
		}
		
		private function startLoadCompleteHandler( event:LoaderEvent ):void {
			
			loaderSource.removeEventListener( LoaderEvent.LOAD_COMPLETE , startLoadCompleteHandler );
			
			var logXML:XML = Source.getSource( Source.SOURCE_LOG , "xml" ) ;
			LogManager.Instance.readLogData( logXML );
			
			if ( _complete != null ) {
				_complete();
			}
		}
		
		private static var instance:SourceManager;
		public static function get Instance():SourceManager {
		
			return instance = instance || new SourceManager();
		}
	}

}