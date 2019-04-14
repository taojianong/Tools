package com.ui.excel {
	
	import com.as3xls.xls.Cell;
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	import com.manager.FileManager;
	import com.manager.UIManager;
	import com.ui.BaseUI;
	import com.ui.componet.Button;
	import com.ui.componet.Label;
	import com.ui.UIEvent;
	import com.util.CommonUtils;
	import com.util.FileUtils;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import mx.collections.ArrayCollection;
	
	/**
	 * Excel表格转换工具
	 * @author taojianlong 2014-5-7 22:31
	 */
	public class ExcelToolUI extends BaseUI {
		
		private var xml:XML =  <data>
			
				<Button id="open_btn" x="50" y="563"  label="打开XML" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass="" />
				<Button id="save_btn" x="150" y="563" label="保存为EXCEL" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass="" />
				<Button id="open_excel_btn" x="280" y="563" label="打开EXCEL" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass="" />
				<Button id="save_xml_btn" x="370" y="563" label="保存XML" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass="" />
				
				<Label id="showLab" x="100" y="100" width="600" height="400" color="#00ff00" />
				<Button id="close_btn" x="700" y="27" label="关闭" outSourceClass="" overSourceClass="" downSourceClass="" disabledSourceClass=""/>	
			</data>
		
		
		private var showLab:Label;
		
		public function ExcelToolUI() {
			
			super( xml , 800 , 600 , 0 , 1 );
		}
		
		override protected function createComplete(event:UIEvent):void {
			
			super.createComplete(event);
			
			showLab = this.getElementById("showLab");
			
		}
		
		override protected function clickHandler(event:MouseEvent):void {
			
			super.clickHandler(event);
			
			clickBtn( event.target as Button );
		}
		
		private function clickBtn(btn:Button):void {
			
			switch (btn && btn.id) {
				
				//打开XML文件
				case "open_btn": 
					FileManager.Instance.openXMLFile(openXMLFile);
					break;
				
				//保存EXCEL文件
				case "save_btn": 
					xmlToExcel(_xml);
					break;
					
				//打开表格xls文件
				case "open_excel_btn":
					FileManager.Instance.openFile( [FileUtils.XLS_FILEFILTER] , excelToXML );
					break;
					
				//保存XML文件
				case "save_xml_btn":
					
					break;
					
				//关闭界面
				case "close_btn": 
					UIManager.Instance.closeExcelToolUI();
					break;
			}
		}
		
		private var _xml:XML; //当前打开的XML文件
		
		private function excelToXML( data:ByteArray ):void {
			
			if ( data ) {
				
				data.position = 0;
				
				var b:ByteArray = new ByteArray();	
				var str:String = data.readMultiByte( data.length , "cn-gb" );
				var byte:ByteArray = new ByteArray();	
				byte.writeMultiByte( str , "cn-gb" );
				byte.position = 0;
				
				var excelFile:ExcelFile = new ExcelFile(); //新建excel文件 
				excelFile.loadFromByteArray( data );
				//excelFile.saveToByteArray(
				
				analysisSheets( excelFile.sheets );
			}
		}
		
		private function analysisSheets( sheets:ArrayCollection ):void {
			
			var xmls:Array = [];
			
			for each( var sheet:Sheet in sheets ) {
				var rows:int = sheet.rows;// CommonUtils.getKeys( data ); //列总数
				var cols:int = sheet.cols;//
				var i:int;
				var j:int;
				var cell:Cell;
				var fields:Array = [];
				var xml:XML = <data></data>;
				for ( i = 0; i < rows; i++ ) {
					var x:XML = <item />;
					for ( j = 0; j < cols; j++ ) {						
						cell = sheet.getCell( i , j );
						if ( i == 0 ) {
							fields[j] = cell.value;
						}
						else {							
							var prop:String = fields[j];
							//obj[ prop ] = cell.value;							
							x.attribute( prop )[0] = cell.value;
						}
					}
					
					if ( i != 0 ) {
						xml.appendChild( x );
					}
				}
				
				trace( sheet.name + " : \n" +  xml );
				//for (var c:int; c < colCont; c++) {
					//var i:int = 0;
					//for each ( var field:String in fields ) {
						//for each (var value:String in data) {
							///**循环判断myDg列名域值record[field]与value是否相等**/
							//if ( data.hasOwnProperty( field ) && data[ field ].toString() == value )
								///**写入表格中**/
								//sheet.setCell(row, i, value);
						//}
						//i++;
					//}
				//}
			}
		}
		
		private function openXMLFile(xml:XML):void {
			
			_xml = xml;
			
			showLab.text = xml.toString();
		
		}
		
		/**
		 * 将XML文件转换为excel表
		 * @param	xml
		 */
		private function xmlToExcel(xml:XML):void {
			
			if ( xml == null ) {
				trace("请选择要转换的XML文件.");
				return;
			}
			
			var data:Array   = [];
			var models:Array = [];//单条条目里的模板字段
			var i:int;
			var col:int = 0; //列数
			var key:String;//字段
			for (i = 0; i < xml.children().length(); i++) {
				var xmlList:XML = xml.children()[i];
				if (xmlList == null) {
					continue;
				}
				var attrs:XML;
				if ( col == 0 ) {
					col = xmlList.attributes().length();
					//for each( xl in xmlList.attributes() ) {
					for each ( attrs in xmlList.attributes()) {
						key = attrs.name().toString();
						//var value:* = attrs;
						models.push( key );
					}
				}
				var obj:Object = {};
				for each ( attrs in xmlList.attributes()) {
					key = attrs.name().toString();
					var val:String = attrs;
					obj[ key ] = val;
					
					if ( key == "id" && val == "xml_en_check|scene_1>check_1>item_describe_1001" ) {
						trace("val" + val);
					}
				}
				
				data.push( obj );
			}
			
			onCreate( data , col , models );
		}
		
		/**
		 * @param data 数据
		 * @param col  列数
		 * @param models 模板{ id , name , text }
		 * 参考
		 * http://www.android100.org/html/201403/20/6029.html
		 */
		private function onCreate( data:Array , col:int , models:Array = null ):void {
			
			var rowCount:int = data.length; //行数
			var colCount:int = col; //列数
			
			var sheet:Sheet = new Sheet();
			sheet.resize( rowCount + 1 , colCount ); //设置表格的范围 
			var fields:Array = new Array(); //用来保存字段 
			var i:int;
			for ( i = 0; i < colCount; i++) {
				sheet.setCell( 0 , i , models[i] ); //表格第0行设置字段名 
				fields.push( models[i] );
			}
			
			for ( i = 0; i < rowCount; i++) {
				if ( i == 134 ) {
					trace( data[i] );
				}
				var record:Object = data[i]; //获取某行 
				insertRecordInSheet( sheet , i + 1 , record , fields );
			}
			
			var excelFile:ExcelFile = new ExcelFile(); //新建excel文件 
			excelFile.sheets.addItem( sheet ); //把表格添加入excel文件中 
			
			var xlsByte:ByteArray = excelFile.saveToByteArray();			
			
			FileManager.Instance.saveXLSFile( xlsByte );			
			
		}
		
		/**
		 * 设置excel单行数据
		 * @param sheet   表
		 * @param row     行
		 * @param data    数据
		 * @param fields  字段
		 */
		private	function insertRecordInSheet( sheet:Sheet , row:int , data:Object , fields:Array ):void {
			
			var colCont:int = CommonUtils.getKeys( data ); //列总数			
			for (var c:int; c < colCont; c++) {
				var i:int = 0;
				for each ( var field:String in fields ) {
					for each (var value:String in data) {
						/**循环判断myDg列名域值record[field]与value是否相等**/
						if ( data.hasOwnProperty( field ) && data[ field ].toString() == value )
							/**写入表格中**/
							sheet.setCell(row, i, value);
					}
					i++;
				}
			}
		}
	}

}