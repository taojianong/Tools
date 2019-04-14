package com.ui.xml {
	
	/**
	 * xml解析条目接口
	 * @author taojianlong 2014-4-12 16:54
	 */
	public interface IXMLItem {
		
		function set xml( value:XML ):void;
		function get xml():XML; //条目节点XML信息
		
		function get attributes():Array;//XML属性列表
		function get attrCount():int;//属性数量
		
		function setXMLValue( prop:String , value:String ):void;//设置XML对应值
		function getXMLValueOf( prop:String ):String;//获取对应XML中对应属性的值
	}

}