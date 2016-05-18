package view;

import java.util.ArrayList;

import model.Stringfunc;


public class ObjTable extends ObjDefault {
	private String sqlOnCreate;
	private String sqlAfterClick;
	private String luaOnCreate;
	private String luaAfterClick;
	private ArrayList<> columns;
	private String[] valueFrom;
	private String[] valueTo;
	private int rowHeight;
	public ObjTable(){
		setText("...");
		//columns = new ObjColumn[10];
		columns = new ArrayList();
	}
	public String getsqlOnCreate() {
		return sqlOnCreate;
	}

	public void setSqlOnCreate(String sqlOnCreate) {
		this.sqlOnCreate = sqlOnCreate;
	}
	public String[] getTitles() {
		String res = "";
			for (int i=0;i<columns.size();i++){
				
				 res += ((ObjColumn)columns.get(i)).getTitle()+";";
				
			}
			return Stringfunc.split(res,";") ;
	
	}
	
	public int getColumnIndexByName(String name){
		int res = -1;
		if ((columns==null) || (columns.size()==0)) return res;
		else {
			for (int i=0;i<columns.size();i++){
				
				if (((ObjColumn)columns.get(i)).getName().equalsIgnoreCase(name)){
					res=i;
				}
			}
			return res;
		}
	}
	
	public ObjColumn getColumnByName(String name){
		ObjColumn res = null;
		if ((columns==null) || (columns.size()==0)) return res;
		else {
			for (int i=0;i<columns.size();i++){
				
				if (((ObjColumn)columns.get(i)).getName().equalsIgnoreCase(name)){
					res=(ObjColumn)columns.get(i);
				}
			}
			return res;
		}
	}
	
	public void setColumn(String property, String value){
		String[] prop = Stringfunc.split(property, "_");
		String aktprop = prop[1];
		String colname=prop[2];
		int colIndex = this.getColumnIndexByName(colname);
		if (colIndex==-1) {
			ObjColumn col = new ObjColumn();
			col.setName(colname);
			colIndex=columns.size();
			columns.add(col);
		}
		ObjColumn col = this.getColumnByName(colname);
		if (aktprop.equalsIgnoreCase("width")) col.setWidth(  Integer.parseInt(value));
		if (aktprop.equalsIgnoreCase("title")) col.setTitle(  value);
		columns.set(colIndex, col);
//		System.out.println(property+" "+value);
	}
	
	public Object[] getColumns(){
		return columns.toArray();
	}
	public String[] getValueTo() {
		return valueTo;
	}
	public void setValueTo(String valueTo) {
		this.valueTo = Stringfunc.split(valueTo,";");
	}
	public String[] getValueFrom() {
		return valueFrom;
	}
	public void setValueFrom(String valueFrom) {
		this.valueFrom = Stringfunc.split(valueFrom,";");
	}
	public String getSqlAfterClick() {
		return sqlAfterClick;
	}
	public void setSqlAfterClick(String sqlAfterClick) {
		this.sqlAfterClick = sqlAfterClick;
	}
	public String getLuaOnCreate() {
		return luaOnCreate;
	}
	public void setLuaOnCreate(String luaOnCreate) {
		this.luaOnCreate = luaOnCreate;
	}
	public String getLuaAfterClick() {
		return luaAfterClick;
	}
	public void setLuaAfterClick(String luaAfterClick) {
		this.luaAfterClick = luaAfterClick;
	}
	public int getRowHeight() {
		return rowHeight;
	}
	public void setRowHeight(int rowHeight) {
		this.rowHeight = rowHeight;
	}

}
