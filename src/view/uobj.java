package view;

import model.Stringfunc;

public class uobj {
	private String[] items;
	private String name;
	public uobj(String name, String[] items){
		this.items=items;
		this.name=name;
	}
	
	private Object setClass(){
		Object aktobj=null;
		for (int i=0;i<items.length;i++){
			if (items[i].toUpperCase().indexOf("TYPE=")==0) {
				String res[] = Stringfunc.split(items[i],"=");
				if (res.length>1){
					String type = res[1];
					if (type.toUpperCase().equalsIgnoreCase("label")) aktobj = new ObjLabel();
					if (type.toUpperCase().equalsIgnoreCase("edit") || type.toUpperCase().equalsIgnoreCase("text")) aktobj = new ObjText();
					if (type.toUpperCase().equalsIgnoreCase("barcode")) aktobj = new ObjBarcode();
					if (type.toUpperCase().equalsIgnoreCase("panel")) aktobj = new ObjPanel(false,false,false);
					if (type.toUpperCase().equalsIgnoreCase("mainpanel")) aktobj = new ObjPanel(true,false,false);
					if (type.toUpperCase().equalsIgnoreCase("taskpanel")) aktobj = new ObjPanel(true,true,false);
					if (type.toUpperCase().equalsIgnoreCase("menupanel")) aktobj = new ObjPanel(true,false,true);
					if (type.toUpperCase().equalsIgnoreCase("table")) aktobj = new ObjTable();
					if (type.toUpperCase().equalsIgnoreCase("imgbutton")) {
						aktobj = new ObjButton();
						((ObjButton)aktobj).setFunction("custom");
					}
					if (type.toUpperCase().equalsIgnoreCase("custom_button")) {
						aktobj = new ObjButton();
						((ObjButton)aktobj).setFunction("custom");
					}
					if (type.toUpperCase().equalsIgnoreCase("print_button")) {
						aktobj = new ObjButton();
						((ObjButton)aktobj).setFunction("print");
					}
					
				}
				
			}
			
		}
		
//		if (aktobj instanceof objlabel) System.out.println("objlabel");
		return aktobj;
	}
	
	private Object setProperties(){
		Object obj =  setClass();
		if (obj!=null){
			if (obj instanceof ObjDefault) ((ObjDefault)obj).setName(name);
			for (int i=0;i<items.length;i++){
				String[] aktrow = Stringfunc.split(items[i],"=");
				String property = aktrow[0];
				String value = aktrow[1];
//				System.out.println("prop:"+property+" val:"+value);
				if (property.equalsIgnoreCase("height")) ((ObjDefault)obj).setHeight(Integer.parseInt(value));
				else
				if (property.equalsIgnoreCase("width")) ((ObjDefault)obj).setWidth(Integer.parseInt(value));
				else
				if (property.equalsIgnoreCase("top")) ((ObjDefault)obj).setTop(Integer.parseInt(value));
				else
				if (property.equalsIgnoreCase("left")) ((ObjDefault)obj).setLeft(Integer.parseInt(value));
				else
				if (property.equalsIgnoreCase("text")) ((ObjDefault)obj).setText(value);
				else
				if (property.equalsIgnoreCase("visible")) ((ObjDefault)obj).setVisible(value);
				else
				if (property.equalsIgnoreCase("font_color")) ((ObjDefault)obj).setForeColor(value);
				else
				if (property.equalsIgnoreCase("bgcolor")) ((ObjDefault)obj).setBackColor(value);
				else
				if (property.equalsIgnoreCase("font_size")) ((ObjDefault)obj).setFontSize(Integer.parseInt(value));
				else
				if (property.equalsIgnoreCase("font_bold")) ((ObjDefault)obj).setFontBold(value.equalsIgnoreCase("font_bold"));
				else				
				if (property.equalsIgnoreCase("parent")) ((ObjDefault)obj).setParent(value);
					
				if (obj instanceof ObjLabel) {
					if (property.equalsIgnoreCase("align")) ((ObjLabel)obj).setAlign(value);
				}
				if (obj instanceof ObjButton) {
					if (property.equalsIgnoreCase("sql_after_click")) ((ObjButton)obj).setSqlAfterClick(value);
					if (property.equalsIgnoreCase("lua_after_click")) ((ObjButton)obj).setLuaAfterClick(value);
					if (property.equalsIgnoreCase("function")) ((ObjButton)obj).setFunction(value);
					if (property.equalsIgnoreCase("image")) ((ObjButton)obj).setImage(value);
				}
				if (obj instanceof ObjPanel) {
					if (property.equalsIgnoreCase("sql_on_create")) ((ObjPanel)obj).setSqlOnCreate(value);
					if (property.equalsIgnoreCase("lua_on_create")) ((ObjPanel)obj).setLuaOnCreate(value);
					if (property.equalsIgnoreCase("params_to_labels")) ((ObjPanel)obj).setParamsToLabels(value);
					
				}
				if (obj instanceof ObjTable) {
					if (property.equalsIgnoreCase("sql_on_create")) ((ObjTable)obj).setSqlOnCreate(value);
					if (property.equalsIgnoreCase("sql_after_click")) ((ObjTable)obj).setSqlAfterClick(value);
					if (property.equalsIgnoreCase("lua_on_create")) ((ObjTable)obj).setLuaOnCreate(value);
					if (property.equalsIgnoreCase("lua_after_click")) ((ObjTable)obj).setLuaAfterClick(value);
					if (property.indexOf("column")>-1) ((ObjTable)obj).setColumn(property,value);
					if (property.equalsIgnoreCase("valueto")) ((ObjTable)obj).setValueTo(value);
					if (property.equalsIgnoreCase("valuefrom")) ((ObjTable)obj).setValueFrom(value);
					if (property.equalsIgnoreCase("row_height")) ((ObjTable)obj).setRowHeight(Integer.parseInt(value));
						 
				}
				if (obj instanceof ObjBarcode) {
					if (property.equalsIgnoreCase("sql_after_trigger")) ((ObjBarcode)obj).setSqlAfterTrigger(value);
					if (property.equalsIgnoreCase("lua_after_trigger")) ((ObjBarcode)obj).setLuaAfterTrigger(value);
					if (property.equalsIgnoreCase("valueto")) ((ObjBarcode)obj).setValueHolder(value);
				}
				if (obj instanceof ObjText)
				{
					if (property.equalsIgnoreCase("sql_on_change")) ((ObjText)obj).setSqlOnChange(value);
					if (property.equalsIgnoreCase("sql_on_exit")) ((ObjText)obj).setSqlOnExit(value);
					if (property.equalsIgnoreCase("lua_on_change")) ((ObjText)obj).setLuaOnChange(value);
					if (property.equalsIgnoreCase("lua_on_exit")) ((ObjText)obj).setLuaOnExit(value);
				}
				
			}
		}
		
		
		return obj;
	}
	
	public Object create(){
		//type es name kikeresese
		Object obj =  setProperties();
		return obj;


		//		1. objektumból type kikeresése (init)
		//		2. type alapján megfelelõ class létrehozása uobjclass (uobjbutton,uobjlabel, uobjbarcode,uobjedit,uobjcombo)
	}

}
