package com.ui.encrypt {
	import flash.utils.ByteArray;
	
	/**
	 * 加密文件字节格式
	 * @author taojianlong 2014/7/11 0:26
	 */
	public class EncryptByteArray extends ByteArray{
		
		public var key:String;
		public var format:String = "encrypt"; //格式
		public var byte:ByteArray;//要加密二进制文件
		
		public function EncryptByteArray( byte:ByteArray = null , key:String = "" , format:String = "jpg" ) {
			
			super();
			
			encrypt( byte , key , format );				
		}
		
		/**
		 * 加密文件
		 * @param	byte
		 * @param	format
		 */
		public function encrypt( byte:ByteArray = null , key:String = "" , format:String = "jpg" ):ByteArray {
			
			this.byte 	= byte;
			this.format = format;	
			this.key	= key;
			
			if ( byte == null ) {
				return null;
			}
			
			//写入KEY二进制数据
		    var keyBytes:ByteArray = new ByteArray();
		    keyBytes.writeObject( this.key ); //把这串字符转换为二进制数组

			//下面就是加密算法
			//把密码数据跟原始数据做一次运算，
			//即从原始数据中间位置，取跟密码数据相同字节数的数据，他们做一次异或运算，然后把运算结果存储到一个二进制数组中。
			var p:int  = byte.length / 2; //获取原始数据中间的位置索引
			var b1:ByteArray = new ByteArray();
			for( var i:int = 0; i < keyBytes.length; i++ ){
				b1.writeByte( byte[ i + p ] ^ keyBytes[ i ] );
			}			
			
			byte.position = p; //把原始数据位置调整到中间位置
			//byte.writeObject( this.key );
			byte.writeBytes( b1 );//从中间位置，把刚才运算后的数据全部替换进去
			
			//压缩
			byte.compress();
			
			this.writeUTF( key );
			this.writeUTF( format );
			this.writeBytes( byte );
			
			return this;
		}
		
		/**
		 * 解密文件
		 * @param	byte
		 * @param	key
		 * @return
		 */
		public function unEncrypte( byte:ByteArray , key:String ):ByteArray {
			
			this.key 	= byte.readUTF();
			this.format = byte.readUTF();
			var fileByte:ByteArray = new ByteArray();		
			byte.readBytes( fileByte );
			
			fileByte.uncompress();//解压
			
			//下面的解密运算，跟加密运算方式一样，原因是异或运算，逆向运算跟之前的看起来没有任何区别			
			var p:int  = fileByte.length / 2;			
			fileByte.position = p;
			//var t:String = fileByte.readObject();
			//trace( "t: " + t);
			if ( this.key != key ) { // t != this.key && 				
				trace( "解密文件失败,解密Key错误!" );
				fileByte.compress();
				return null;
			}
			
			var keyBytes:ByteArray = new ByteArray();
		    keyBytes.writeObject( this.key );
			
			var b1:ByteArray = new ByteArray();
			for (var i:int = 0; i < keyBytes.length; i++) {
			   b1.writeByte( fileByte[i + p] ^ keyBytes[i] );			  
			}
			
			//b1.position = 0;			
			fileByte.position = p;
			fileByte.writeBytes( b1 );
			
			/*fileByte.position = 0;
			var str1:String = fileByte.readUTFBytes( 1018 );
			fileByte.position = 1018;
			var str2:* = fileByte.readUTFBytes(8);
			fileByte.position = 1026;
			var str3:String = fileByte.readUTFBytes( 1010 );
			var str:String = str1 + str2 + str3;*/
			
			return fileByte;
		}
		
		/**
		 * 读取加密XML二进制数据为字符串
		 * @param	enByte 加密XML二进制文件
		 * @param	key 密钥
		 * @return
		 */
		public function readEncryptXMLByte( enByte:ByteArray , key:String ):String {
			
			var unByte:ByteArray = unEncrypte( enByte , key ); //解密后的ByteArray文件
			
			if ( unByte != null ) {
				
				var keyBytes:ByteArray = new ByteArray();
				keyBytes.writeObject( key );
				
				var p:int = unByte.length / 2;
				
				unByte.position = 0;
				var s1:String 	= unByte.readUTFBytes( p );
				unByte.position = p;
				var s2:String 	= unByte.readUTFBytes( keyBytes.length );
				unByte.position = p + keyBytes.length;
				var s3:String 	= unByte.readUTFBytes( unByte.bytesAvailable );
				
				var s:String = s1 + s2 + s3;
				
				trace( s );
				
				return s;
			}
			
			return "";
		}
	}

}