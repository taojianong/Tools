package com.ui.encrypt {
	
	import com.manager.FileManager;
	import com.manager.UIManager;
	import com.ui.BaseUI;
	import com.ui.componet.Button;
	import com.ui.componet.Label;
	import com.ui.componet.TextInput;
	import com.ui.UIEvent;
	import com.util.FileUtils;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * 加密Swf界面
	 * @author cl 2014/6/16 14:47
	 * 参考网站:http://blog.sina.com.cn/s/blog_71f1fb3701015s29.html
	 */
	public class EncryptUI extends BaseUI {
		
		private var xml:XML =    <data>			
				<Label id="titLab" width="800" height="600" algin="center" color="#00ff00" fontSize="24" />
				<Label id="showLab" x="50" y="50" width="700" height="500" color="#00ff00" selectable="true" />
				<Label id="" x="400" y="200" text="key" width="50" height="500" color="#00ff00" selectable="false" />
				<TextInput id="keyInput" x="450" y="200" width="200" height="20" color="#00ff00" borderColor="#00ff00" />
				
				<Button id="encrypt_btn" x="400" y="100" label="加密文件" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass=""/>	
				<Button id="unencrypt_btn" x="500" y="100" label="解密文件" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass=""/>	
				<Button id="swf_btn" x="400" y="135" label="打开文件" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass=""/>	
				<Button id="save_btn" x="500" y="135" label="保存加密文件" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass=""/>	
				<Button id="show_btn" x="650" y="135" label="显示解密文件" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass=""/>	
				
				<Button id="close_btn" x="730" y="27" label="关闭" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass=""/>	
			</data>
		
		private var titLab:Label;
		private var showLab:Label;
		private var swf_btn:Button;
		private var keyInput:TextInput;
		
		//private var close
		
		public function EncryptUI() {
			
			super(xml, 800, 600, 0, 1);
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
			
			titLab  = this.getElementById("titLab");
			showLab = this.getElementById("showLab");
			keyInput = this.getElementById("keyInput");
			
			titLab.text = "加密SWF文件";			
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			super.clickHandler(event);
			
			var btn:Button = event.target as Button;
			
			switch( btn && btn.id ) {
				
			    //打开加密文件
				case "swf_btn":
					FileManager.Instance.openFile( null , openEncryptFile ); //[ new FileFilter("SWF" , "*.swf") ]
					break;
					
				//加密SWF
				case "encrypt_btn": 
					encryptFile();
					break;
					
				//解密
				case "unencrypt_btn":
					unEncryptFile();
					break;
					
				//保存加密或解密文件
				case "save_btn":
					saveEncryptFile();
					break;
					
				//显示解密加密文件
				case "show_btn":
					showEncrypt();
					break;
					
				//关闭
				case "close_btn":
					UIManager.Instance.closeEncryptUI();
					break;
				
			}
		}
		
		private var loader:Loader;
		//显示加密文件
		private function showEncrypt():void {
			
			if ( fileByte == null ) {
				showInfo( "显示加密文件不能为空" );
				return;
			}
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE , loaded );
			//loader.addEventListener( Event.COMPLETE , loaded );
			var lc:LoaderContext = new LoaderContext( false , ApplicationDomain.currentDomain );
			lc.allowCodeImport   = true;
			loader.loadBytes( fileByte , lc );
			
			showInfo( "加载二进制加密文件..." );
		}
		
		private function loaded(e:Event):void {
			
			showInfo( "加载二进制加密文件完成,并显示." );
			
		   loader.contentLoaderInfo.removeEventListener( Event.COMPLETE , loaded );
		   var mc:DisplayObject = loader.content as DisplayObject;
		   if ( mc ) {
			   this.addChild( mc );
		   }  
		}
		
		private var fileByte:ByteArray;//文件二进制数据
		private var file:File;//当前需要加密的文件
		
		//打开需要加密的文件
		private function openEncryptFile( file:File ):void {
			
			this.file = file;
			fileByte = file.data;
			
			showInfo( "打开"+file.url+"成功!" );
		}		
		
		private var encryptByte:EncryptByteArray;//加密文件
		
		//加密打开的文件
		private function encryptFile():void {
			
			if ( this.file == null || this.file.data == null ) {				
				showInfo( "加密文件不能为空" );
				return;
			}
			
			fileByte = this.file.data;			
			
			showInfo( "开始加密文件..." );
			
			encryptByte = encryptByte || new EncryptByteArray();
			fileByte = encryptByte.encrypt( fileByte , this.key , this.file.extension );
			
			
			/*//写入KEY二进制数据
		    var keyBytes:ByteArray = new ByteArray();
		    keyBytes.writeObject( this.key ); //把这串字符转换为二进制数组

			//下面就是加密算法
			//把密码数据跟原始数据做一次运算，
			//即从原始数据中间位置，取跟密码数据相同字节数的数据，他们做一次异或运算，然后把运算结果存储到一个二进制数组中。
			var p:int  = fileByte.length / 2; //获取原始数据中间的位置索引
			var b1:ByteArray = new ByteArray();
			for( var i:int = 0; i < keyBytes.length; i++ ){
				b1.writeByte( fileByte[ i + p ] ^ keyBytes[ i ] );
			}
			
			fileByte.position = p; //把原始数据位置调整到中间位置
			fileByte.writeBytes( keyBytes );//从中间位置，把刚才运算后的数据全部替换进去
			
			//压缩
			fileByte.compress();*/
			
			showInfo( "加密文件成功." );
		}
		
		//解密加密的Swf文件
		private function unEncryptFile():void {
			
			if ( fileByte == null ) {				
				showInfo( "要解密文件不能为空" );
				return;
			}
			
			showInfo( "开始解密文件..." );
			
			encryptByte = encryptByte || new EncryptByteArray();
			fileByte = encryptByte.unEncrypte( fileByte , this.key );
			
			/*fileByte.uncompress();//解压
			
			//下面的解密运算，跟加密运算方式一样，原因是异或运算，逆向运算跟之前的看起来没有任何区别			
			var p:int  = fileByte.length / 2;			
			fileByte.position = p;
			var t:String = fileByte.readObject();
			trace( "t: " + t);
			if ( t != this.key ) {				
				showInfo( "解密文件失败,解密Key错误!" );
				fileByte.compress();
				return;
			}
			
			fileByte.position = 0;
			var keyBytes:ByteArray = new ByteArray();
		    keyBytes.writeObject( this.key );
			
			var b1:ByteArray = new ByteArray();
			for (var i:int = 0; i < keyBytes.length; i ++) {
			   b1.writeByte( fileByte[i + p] ^ keyBytes[i] );			  
			}
			
			fileByte.position = p;
			fileByte.writeBytes( b1 );
			//上面得到的是解密后的数据，这是完整的数据，跟之前读取的"xx.swf"的数据时一模一样的，因为这个步骤就是还原数据的作用*/
			
			showInfo( "解密文件成功." );
		}
		
		//得到完整数据后，用Loader读取这段二进制数据，注意下面加粗的这几行代码，很重要，否则会报错说不支持swf。
	    //_loader = new Loader();
	    //_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
	    //var lc:LoaderContext = new LoaderContext();
	    //lc.allowCodeImport = true;
	    //_loader.loadBytes(data, lc);
		
		//保存加密的SWF文件
		private function saveEncryptFile():void {
			
			showInfo( "保存加密文件中..." );			
			
			//FileManager.Instance.saveByteFile( fileByte , this.file.extension , saveEncryptFileComplete );
			FileManager.Instance.saveByteFile( fileByte , encryptByte.format , saveEncryptFileComplete );
		}
		
		private function saveEncryptFileComplete():void {
			
			showInfo( "保存加密文件成功." );
		}
		
		private function showInfo( info:String ):void {
			
			showLab.text += info + "\n";
		}
		
		private function get key():String {
			
			return keyInput.text;
		}
		
	}

}