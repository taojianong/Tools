package com.manager {
	
	import com.customLoader.event.LoaderEvent;
	import com.customLoader.LoaderSource;
	import com.customLoader.SourceLoaderManager;
	import com.file.FileData;
	import com.greensock.loading.LoaderMax;
	import com.UIGlobal;
	import com.util.DMap;
	import com.util.FileUtils;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	/**
	 * 文件管理 2013-3-30 23:58
	 * @author taojianlong
	 */
	public class FileManager {
		
		public static var fdMap:DMap = new DMap; //用于存储加载的FildData数据
		
		private var sp:Sprite = new Sprite;
		private var file:File;
		private var loaderSource:LoaderSource;
		
		public function FileManager() {
			
			file = new File;
		}
		
		//-------------------------加载SWF文件----------------------------		
		private var _loadSwfComplete:Function = null;
		
		public function openSwf( complete:Function = null ):void {
			
			_loadSwfComplete = complete;			
			
			this.extensions = extensions;
			file.browse( [new FileFilter("打开SWF文件", "*.swf")]);
			file.addEventListener( Event.SELECT , selectSwfHandler );
			file.addEventListener( Event.CANCEL , cancelSwfHandler );
		}
		
		private function selectSwfHandler(event:Event):void {
			
			cancelSwfHandler();
			
			loaderSource = loaderSource || new LoaderSource();
			loaderSource.add( file.url );
			loaderSource.addEventListener(LoaderEvent.LOAD_COMPLETE, loadSWFCompleteHandler);
			loaderSource.start();
		}
		
		private function loadSWFCompleteHandler(event:LoaderEvent):void {
			
			loaderSource.removeEventListener( LoaderEvent.LOAD_COMPLETE, loadSWFCompleteHandler );
			loaderSource = null;
			
			var names:Vector.<String> ;		
			var app:ApplicationDomain = SourceLoaderManager.getApp( file.url );
			if ( app != null ) {
				names = app.getQualifiedDefinitionNames();
			}
			
			var libs:Array = [];			
			var s:*;
			for each( var className:String in names ) {
				s = getSource( className , app );
				s.name = className;
				libs.push( s );
			}
			
			if ( _loadSwfComplete != null ) {
				_loadSwfComplete( libs );
			}
		}
		
		private function cancelSwfHandler( event:Event = null ):void {
			
			file.removeEventListener( Event.SELECT, selectSwfHandler );
			file.removeEventListener( Event.CANCEL , cancelSwfHandler );
		}
		
		//-------------------------------------------
		
		/**
		 * 获取SWF中资源，可能是BitmapData,Bitmap,MovieClip,SimpleButton,Shape等
		 * @param	className
		 * @param	app
		 * @return
		 */
		public function getSource( className:String , app:ApplicationDomain ):* {
			
			var cls:Class = getClass( className , app );
			var bit:* = cls != null ? new cls : null;
			
			return bit is BitmapData ? new Bitmap(bit) : bit;
		}
		
		public function getClass( className:String , app:ApplicationDomain ):Class {
			
			if ( app && app.hasDefinition(className) && className.indexOf("::") == -1 ) {
				
				return app.getDefinition(className) as Class;
			}
			return null;			
		}
		
		
		/**********************************保存bat文件**************************************
		 * @param	fileName bat文件名
		 * @param	swfPath 保存swf的路径及名字
		 */
		public function saveBat(fileName:String, swfPath:String = "", complete:Function = null):void {
			
			if (swfPath)
				swfPath = swfPath.split(".")[0];
			trace("swfPath: " + swfPath);
			var reg:RegExp = new RegExp;
			var nativePath:String = File.applicationDirectory.nativePath.replace(/\\/g, "/");
			var data:String = "java -jar " + nativePath + "/Swift.jar xml2lib " + nativePath + "/xml/" + fileName + " " + (swfPath == "" ? fileName : swfPath) + ".swf ";
			var url:String = File.applicationDirectory.nativePath + "/runSwift." + FileUtils.FILE_BAT;			
			FileUtils.saveUTFFile( url , data , null );
			if (complete != null) {
				complete();
			}
		}
		
		
		/**
		 * 保存生成的XML数据
		 */
		public function saveFileXML(complete:Function = null):void {
			
			if (UIGlobal.swfToolUI == null)
				return;
			
			var url:String = File.applicationDirectory.nativePath + "/xml/" + oFile.name + "." + FileUtils.FILE_XML;
			var data:String = UIGlobal.swfToolUI.filePlate.getFileDataXML().toString();
			
			FileUtils.saveUTFFile( url, data, file, complete );
		}
		
		/**
		 * 保存文件
		 * @param	data		文件数据
		 * @param	path		文件地址
		 * @param	extension 	文件类型
		 */
		public function saveFile( data:String , path:String = "" , extension:String = "txt" , complete:Function = null ):void {
		
			var url:String = path + "." + extension;			
			file.nativePath = url;
			FileUtils.saveUTFFile( url , data , file , complete );
		}
		
		//------------------打开文件保存界面并保存XML文件-----------------
		private var _saveXMLComplete:Function = null;
		
		public function openFileAndSaveXML( xml:XML , complete:Function = null ):void {
			
			oXml = xml;
			_saveXMLComplete = complete;
			
			file.browseForSave("保存XML文件");
			file.addEventListener( Event.SELECT, saveXMLHandler );
			file.addEventListener( Event.CANCEL, cancelSaveXMLHandler);
		}
		
		private function saveXMLHandler( event:Event ):void {
			
			var oFile:File = event.target as File;
			if (oFile == null) {
				cancelSaveXMLHandler();
				return;
			}
			oUrl = oFile.nativePath + "." + FileUtils.FILE_XML;
			//保存XML文件,在swfit.jar可编译的文件夹下
			//var url:String = File.applicationDirectory.nativePath + "/xml/" + oFile.name + "." + FileUtils.FILE_XML;
			
			FileUtils.saveUTFFile( oUrl , oXml , file , _saveXMLComplete );
			cancelSaveXMLHandler();
		}
		
		private function cancelSaveXMLHandler( event:Event = null ):void {
			
			file.removeEventListener( Event.SELECT, saveXMLHandler );
			file.removeEventListener( Event.CANCEL, cancelSaveXMLHandler);
			
			oXml = null;
			_saveXMLComplete = null;
		}
		
		//------------------------------------
		private var _saveByte:ByteArray;
		private var _format:String ;
		private var _saveByteComplete:Function;
		
		public function saveByteFile( swfByte:ByteArray , format:String = FileUtils.FILE_SWF , saveByteComplete:Function = null ):void {
			
			_saveByte 			= swfByte;
			_format 			= format;
			_saveByteComplete 	= saveByteComplete;
			
			file.browseForSave(	"保存ByteArray数据" );
			file.addEventListener( Event.SELECT, saveByteHandler );
			file.addEventListener( Event.CANCEL, cancelSaveByteHandler);
			
			function saveByteHandler( event:Event ):void {
				
				var oFile:File = event.target as File;
				if (oFile == null) {
					cancelSaveByteHandler();
					return;
				}
				
				oUrl = oFile.nativePath + "." + format;
			
				FileUtils.saveByte( _saveByte , oUrl , file , _saveByteComplete );
			}
			
			function cancelSaveByteHandler( event:Event = null ):void {
				
				file.removeEventListener( Event.SELECT, saveByteHandler );
				file.removeEventListener( Event.CANCEL, cancelSaveByteHandler);
				
				_saveByte 			= null;
				_format 			= null;
				_saveByteComplete 	= null;
			}
		}
		
		
		
		/*****************************保存打包SWF文件***********************************/
		public function saveSwf():void {
			
			file.browseForSave("保存swf路径");
			file.addEventListener(Event.SELECT, saveSwfFile);
			file.addEventListener(Event.CANCEL, cancelSwfFileComplete);
		}
		private var oFile:File;
		private var oUrl:String;
		private var oXml:String;
		
		private function saveSwfFile(event:Event):void {
			
			cancelSwfFileComplete();			
			
			oFile = event.target as File;
			if (oFile == null)
				return;
			oUrl = oFile.nativePath + "." + FileUtils.FILE_XML;
			//保存XML文件,在swfit.jar可编译的文件夹下
			var url:String = File.applicationDirectory.nativePath + "/xml/" + oFile.name + "." + FileUtils.FILE_XML;
			oXml = UIGlobal.swfToolUI.filePlate.getFileDataXML().toString();
			FileUtils.saveUTFFile( url, oXml , file , saveSwfFileComplete );
		}
		
		private function saveSwfFileComplete():void {
			
			saveBat(oFile.name, oUrl, runBat);
			oFile = null;
			FileUtils.saveUTFFile(oUrl, oXml,file); //保存一份XML在对应SWF文件夹下面方便查阅
			oUrl = "";
			oXml = "";
		}
		
		private function cancelSwfFileComplete( event:Event = null ):void {
			
			file.removeEventListener(Event.SELECT, saveSwfFile);
			file.removeEventListener(Event.CANCEL, cancelSwfFileComplete);
		}
		
		//运行时记得在AIR配置文件里加上这个！<!-- desktop extendedDesktop -->
	    //<supportedProfiles>extendedDesktop desktop</supportedProfiles>
		private function runBat():void {
			
			file.nativePath = File.applicationDirectory.nativePath + "/runSwift." + FileUtils.FILE_BAT;
			trace(file.nativePath);
			file.openWithDefaultApplication();
		}
		
		/*****************************关闭文件***********************************/
		public function closeFile():void {
			
			//打开exe
			var cmdFile:File = new File();
			cmdFile = cmdFile.resolvePath("C:/Windows/System32/cmd.exe");
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = cmdFile;
			
			var processArgs:Vector.<String> = new Vector.<String>();
			processArgs[0] = "/c " + file.url;
			//上面执行批处理的方式方法
			nativeProcessStartupInfo.arguments = processArgs;
			var process:NativeProcess = new NativeProcess();
			process.start(nativeProcessStartupInfo);
		}
		
		private var extensions:Array; //要打开的文件类型["jpg","png"]
		private var openList:Array = [];
		
		//------------------------------------------------------------------
		private var _openXMLFileComplete:Function = null;
		
		public function openXMLFile( complete:Function = null ):void {
			
			_openXMLFileComplete = complete;
			
			/*if ( file.data ) {
				file.data.clear();
			}*/			
			file.browseForOpen("打开XML文件", [new FileFilter("XML", "*.xml")]);
			file.addEventListener( Event.SELECT , selectXMLHandler );
			file.addEventListener( Event.SELECT , cancelSelectXMLHandler );
		}
		
		private function selectXMLHandler( event:Event ):void {
			
			cancelSelectXMLHandler();
			
			var oFile:File = event.target as File;
			
			if ( oFile && oFile.extension == FileUtils.FILE_XML ) {
				
				oFile.load();
				oFile.addEventListener( Event.COMPLETE , loadXMLComplete );
			}
			
			function loadXMLComplete( event:Event ):void {
				
				event.target.removeEventListener( Event.COMPLETE , loadXMLComplete );
				var bytearray:ByteArray = event.target.data as ByteArray;
				if ( bytearray ) {
					
					bytearray.position = 0;
					var xmlStr:String = bytearray.readUTFBytes( bytearray.length );
					var xml:XML = XML(xmlStr);
					
					if ( _openXMLFileComplete != null) {
						
						_openXMLFileComplete.apply( null , [ xml ] );
					}
				}
			}			
		}
		
		private function cancelSelectXMLHandler( event:Event = null ):void {
			
			file.removeEventListener( Event.SELECT , selectXMLHandler );
			file.removeEventListener( Event.SELECT , cancelSelectXMLHandler );
		}
		
		//------------------------------------------------------------		
		
		private var _saveXLSComplete:Function = null;
		private var _xlsCompleteArgs:Array = null;
		private var _xlsByte:ByteArray;
		/**
		 * 保存xls文件
		 * @param	xls
		 * @param	complete
		 * @param	args
		 */
		public function saveXLSFile( xls:ByteArray , complete:Function = null , args:Array = null ):void {
			
			_xlsByte = xls;
			_saveXLSComplete = complete;
			_xlsCompleteArgs = args ;
			
			file.browseForSave("保存XLS文件");
			file.addEventListener( Event.SELECT, saveXLSHandler );			
		}
		
		private function saveXLSHandler( event:Event ):void {
			
			file.removeEventListener( Event.SELECT , saveXLSHandler );
			
			var url:String = FileUtils.toFileName( file.url , FileUtils.FILE_XLS );
			
			FileUtils.saveByte( _xlsByte , url , file , _saveXLSComplete , _xlsCompleteArgs );
			
			/*if ( _saveXLSComplete != null ) {
				_saveXLSComplete.apply( null , _xlsCompleteArgs );
			}*/
			
			trace("保存xls成功");
		}
		
		//------------------------------------------------------------------
		
		private var _openFileComplete:Function = null;
		
		/**
		 * 打开文件
		 * @param	typeFilter 文件类型
		 * 如 [ new FileFilter("Images", "*.jpg;*.gif;*.png") ];
		 */
		public function openFile( typeFilter:Array = null , complete:Function = null ):void {
			
			_openFileComplete = complete;
			
			file.browse(typeFilter);
			file.addEventListener(Event.SELECT, selectFileHandler );
		}
		
		private function selectFileHandler( event:Event ):void {
			
			file.removeEventListener(Event.SELECT, selectFileHandler );
			
			file.load();
			file.addEventListener( Event.COMPLETE , loadSelectComplete );
		}
		
		private function loadSelectComplete( event:Event ):void {
			
			file.removeEventListener( Event.COMPLETE , loadSelectComplete );
			
			if ( _openFileComplete != null ) {
				_openFileComplete.apply( null , [ file ] );
			}
		}
		
		//-------------------------------------------------------------------
		
		/**
		 * 批量打开文件
		 * @param	extstion
		 */
		public function openMultiFile(extensions:Array = null):void {
			
			this.extensions = extensions;
			file.browseForOpenMultiple("批量打开文件", [new FileFilter("Images(jpg,png)", "*.jpg;*.png")]);
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, filesSelected);
		}
		
		private var queue:LoaderMax;
		
		private function filesSelected(event:FileListEvent):void {
			
			file.removeEventListener(FileListEvent.SELECT_MULTIPLE, filesSelected);
			var files:Array = event.files;
			var openFile:File;
			fdMap.clear();
			for each (openFile in files) {
				
				if (this.extensions && this.extensions.indexOf(openFile.extension) != -1 && (openFile.extension == FileUtils.FILE_JPG || openFile.extension == FileUtils.FILE_PNG)) {
					
					var fileData:FileData = new FileData(openFile.nativePath);
					fileData.linkName = openFile.name.split(".")[0];
					fdMap.put(openFile.nativePath, fileData);
				}
			}
			sp.addEventListener(Event.ENTER_FRAME, enterFrame);
		}
		
		private function enterFrame(event:Event):void {
			
			if (this.loadedAll) {				
				sp.removeEventListener(Event.ENTER_FRAME, enterFrame);
				UIGlobal.swfToolUI.filePlate.fileItemList = fdMap.toArray();
				fdMap.clear();
			}
		}
		
		/**
		 * 选择数据是否加载完成
		 */
		private function get loadedAll():Boolean {
			
			var i:int;
			var fileData:FileData;
			for each (fileData in fdMap.d) {
				if (fileData.data) {
					i++;
				}
			}
			return i == fdMap.keys;
		}
		
		
		/**
         * 打开并执行bat文件
         * @param value
         */
        public function openBatFile(value:String):void {
            //exe路径，经过测试，直接从system32下复制到程序的目录下也是没有问题的，前提是你的程序都是默认安装的。环境变量也没变
            var exePath:String = "C:/Windows/system32/cmd.exe";

            var file:File      = new File(File.applicationDirectory.nativePath);
            file = file.resolvePath(value);
            trace("file.url: " + file.url + " file.nativePath: " + file.nativePath);
            var shellPath:String              = file.nativePath; // "C:/test.bat";
            var info:NativeProcessStartupInfo = new NativeProcessStartupInfo(); //启动参数
            info.executable = new File(exePath);
            var processArg:Vector.<String> = new Vector.<String>();
            processArg[0] = "/c"; //加上/c，是cmd的参数
            processArg[1] = shellPath; //shellPath是你的bat的路径，建议用绝对路径，如果是相对的，可以用File转一下
            info.arguments = processArg;

            //判断当前的配置文件中是否支持运行本机进程
            trace("NativeProcess.isSupported: " + NativeProcess.isSupported);
            if (NativeProcess.isSupported) {
                var process:NativeProcess = new NativeProcess();
                process.addEventListener(NativeProcessExitEvent.EXIT, packageOverHandler);
                process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, outputHandler);
                process.start(info);
            }
			
			function packageOverHandler(event:NativeProcessExitEvent):void {
				trace("退出进程时，由 NativeProcess 对象调度此事件");
			}

			function outputHandler(event:ProgressEvent):void {
				trace("--------STANDARD_OUTPUT_DATA---------");
			}
        }
		
		
		private static var instance:FileManager;		
		public static function get Instance():FileManager {			
			return instance = instance || new FileManager;
		}
	
	}

}