package com {
	
	import com.ui.alert.LogReadAlert;
	import com.ui.alert.LogWriteAlert;
	import com.ui.calendar.CalendarUI;
	import com.ui.componet.Container;
	import com.ui.encrypt.EncryptUI;
	import com.ui.excel.ExcelToolUI;
	import com.ui.gif.GifToolUI;
	import com.ui.log.LogUI;
	import com.ui.swftool.SwfToolUI;
	import com.ui.xml.XMLItemReadUI;
	import com.ui.xml.XMLParserUI;
	
	/**
	 * UI全局变量
	 * @author taojianlong 2013-12-15 23:23
	 */
	public class UIGlobal {
		
		//舞台高宽
		public static const STAGE_WIDTH:Number  = 800;
		public static const STAGE_HEIGHT:Number = 600;
		
		public static const stageWidth:Number  = 800;
		public static const stageHeight:Number = 600;
		
		public static var bottomLayer:Container = new Container();//最低层
		public static var uiLayer:Container  	= new Container();//UI界面层
		public static var topLayer:Container 	= new Container();//最顶层
		public static var alertLayer:Container 	= new Container();//弹框层
		
		public static var swfToolUI:SwfToolUI;	
		public static var gifToolUI:GifToolUI; //gif工具
		public static var logUI:LogUI;//日志界面
		public static var xmlParserUI:XMLParserUI;//XML读取修改保存界面
		public static var xmlItemReadUI:XMLItemReadUI;//XML条目读取界面
		public static var calendarUI:CalendarUI;//时间系统界面
		public static var excelToolUI:ExcelToolUI;//表格处理工具
		public static var encryptUI:EncryptUI;//加密工具
		
		public static var logWriteAlert:LogWriteAlert;//写日志弹框
		public static var logReadAlert:LogReadAlert;//读取日志框
		
	}

}