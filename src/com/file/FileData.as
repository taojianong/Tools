package com.file {
	
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.manager.FileManager;
	import com.util.FileUtils;
	import flash.display.Bitmap;
	
	/**
	 * 加载文件数据 2013-3-31 16:51
	 * @author taojianlong
	 */
	public class FileData {
		
		private static const loaderMax:LoaderMax = new LoaderMax({onProgress: progressHandler, onComplete: completeHandler});
		
		private static function progressHandler(event:LoaderEvent):void {
			
			//1.var kbps:Number = (loader.bytesLoaded / loader.loadTime) / 1024; //下载数据
			//1.var secondsLeft:Number = (1 / loader.progress) * loader.loadTime;//下载需要时间
			
			var loader:DisplayObjectLoader = event.target as DisplayObjectLoader;
			if (loader) {
				
				var per:Number = loader.bytesLoaded / loader.bytesTotal;
				trace("load url: " + loader.url + " per: " + per);
			}
		}
		
		private static function completeHandler(event:LoaderEvent):void {
			
			var displayObjectLoader:DisplayObjectLoader = event.target as DisplayObjectLoader;
			if (displayObjectLoader) {
				//var obj:Object = LoaderMax.getContent( displayObjectLoader.url );				
				var fileData:FileData = FileManager.fdMap.get(displayObjectLoader.url) as FileData;
				fileData.data = displayObjectLoader.rawContent as Bitmap;
				displayObjectLoader.dispose();
				displayObjectLoader = null;
			}
		}
		
		private static function loadFile(url:String):void {
			
			var displayObjectLoader:DisplayObjectLoader;
			if (FileUtils.getFileExtension(url) == FileUtils.FILE_JPG || FileUtils.getFileExtension(url) == FileUtils.FILE_PNG) {
				
				//{width:200, height:100, container:this}//让video/image/swf 的大小适应区域
				displayObjectLoader = new ImageLoader(url, {width: 200, height: 100, onProgress: progressHandler, onComplete: completeHandler, scaleMode: "proportionalInside", bgColor: 0xFF0000});
			}
			
			//1.LoaderMax.activate([ImageLoader]); //这一句其实是为了引入ImageLoader这个类			
			displayObjectLoader.load();
		}
		
		private var _data:*;
		private var _path:String; //文件路径
		private var _load:Boolean = false; //是否开始加载
		private var _linkName:String = ""; //连接名字
		private var _quality:String = ""; //品质
		
		public function FileData( path:String=null , load:Boolean = true) {
			_path = path;
			_load = load;
			
			if (load) {
				startLoad();
			}
		}
		
		public function get path():String {
			
			return _path;
		}
		
		public function set quality(value:String):void {
			
			_quality = value;
		}
		
		/**
		 * 质量
		 */
		public function get quality():String {
			
			return _quality;
		}
		
		public function set linkName(value:String):void {
			
			_linkName = value;
		}
		
		/**
		 * 连接名.即SWF中对应图片的链接名
		 * 打包时设置
		 */
		public function get linkName():String {
			
			return _linkName;
		}
		
		/**
		 * 获取文件类型
		 */
		public function get extension():String {
			
			return FileUtils.getFileExtension(_path);
		}
		
		public function startLoad():void {
			
			loadFile(_path);
		}
		
		public function set data(value:*):void {
			
			_data = value;
		}
		
		public function get data():* {
			
			return _data;
		}
	}
}