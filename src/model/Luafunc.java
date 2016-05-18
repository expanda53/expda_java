package model;


import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.Date;

import org.eclipse.swt.widgets.Control;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.ZeroArgFunction;
import org.luaj.vm2.lib.OneArgFunction;
import org.luaj.vm2.lib.TwoArgFunction;
import org.luaj.vm2.lib.jse.CoerceJavaToLua;

import view.exPane;
import view.exTable;

public class Luafunc extends TwoArgFunction {
	private static exPane pane = null;
	public Luafunc() {
		
	}
	
	public void addPane(exPane pane){
		Luafunc.pane = pane;
	}

	public LuaValue call(LuaValue modname, LuaValue env) {
		LuaValue library = tableOf();
		library.set("query", new query());
		library.set("query_assoc", new query_assoc());
		library.set("strtotable", new strToTable());
		library.set("refreshtable", new refresh_table());
		library.set("refreshtable_fromstring", new refresh_table_from_string());
		library.set("findFiles", new findFiles());
		library.set("findFilesByDate", new findFilesByDate());
		library.set("ini", new iniGet());
		library.set("getWifiStrength", new getWifiStrength());		
		env.set( "luafunc", library );
		return library;
	}
	static class query extends TwoArgFunction {
		public LuaValue call(LuaValue sql,LuaValue parsing){
//			parsing false esetén nem dolgozza fel a kapott arraylistet, csak visszaadja. true esetén feldolgozza és nilt ad vissza
			/*if (pane.getTcp()==null && pane.getPhpcli()==null) {
				if (pane.showDialog("Üzenetküldés nem sikerült.Kilép?")) System.exit(0);
			}*/
			ArrayList list = pane.sendGetExecute(sql.tojstring(), parsing.toboolean());
			if (list!=null) {
				LuaValue rows = tableOf();
				for(int i=0;i<list.size();i++){
					String row = list.get(i).toString();
					rows.set(i+1,row);
				}
				return rows;
			}
			else return CoerceJavaToLua.coerce( null);
		}
	}

	static class query_assoc extends TwoArgFunction {
		public LuaValue call(LuaValue sql,LuaValue parsing){
//			parsing false esetén nem dolgozza fel a kapott arraylistet, csak visszaadja. true esetén feldolgozza és nilt ad vissza
			ArrayList list = pane.sendGetExecute(sql.tojstring(), parsing.toboolean());
			if (list!=null) {
				LuaValue rows = tableOf();
				for(int i=0;i<list.size();i++){
					LuaValue cols = tableOf();
					String[] row = Stringfunc.split(list.get(i).toString(), "]]");
					for (int j=0;j<row.length;j++){
						String[] field = Stringfunc.split(row[j], "=");
						String val = "";
						if (field.length==1) val = "";
						else val = field[1];
						cols.set(field[0].replace('[', ' ').trim(), val);

					}
					rows.set(i+1, cols);
				}
				return rows;
			}
			else return CoerceJavaToLua.coerce( null);
		}
	}
	
	static class refresh_table extends TwoArgFunction {
		public LuaValue call(LuaValue objName, LuaValue res){
			ArrayList list=new ArrayList();
			for (int i=1;i<=res.length();i++){
				list.add(res.get(i));
			}
			//Object content = CoerceLuaToJava.coerce(res,ArrayList.class );
			Control o = pane.findObject(objName.tojstring());
			if ( o instanceof exTable){
				//	((exTable) o).refresh(((ArrayList)content));
				((exTable) o).refresh(list);

			}
			

			return null;
		}
	}
	static class refresh_table_from_string extends TwoArgFunction {
		public LuaValue call(LuaValue objName, LuaValue res){
			String content = res.tojstring();
//			System.out.println(content);
			ArrayList arrlist = new ArrayList();
			Control o = pane.findObject(objName.tojstring());
			if ( o instanceof exTable){
				String[] rows = Stringfunc.split( content,"\n");
				
				if (rows.length>0){
					for (int j=0; j<rows.length; j++){
						arrlist.add(rows[j] );
					}

				}
				((exTable) o).refresh(arrlist);

			}
			

			return null;
		}
	}
	
	static class findFiles extends TwoArgFunction {
		public LuaValue call(LuaValue lfilter, LuaValue lsubdir) {
			String res = "";
			String fdir = Ini.getExportDir();
			final String subdir = lsubdir.tojstring();
			if (subdir!="") fdir = fdir + "\\" + subdir;
			File dir = new File(fdir);
			final String fn = lfilter.tojstring();
		      FilenameFilter filter = new FilenameFilter() {
		         public boolean accept
		         (File dir, String name) {
		        	 
		            return name.indexOf(fn)>-1;
		        }
		      };
		      String[] children = dir.list(filter);
		      if (children == null) {
		         System.out.println("Either dir does not 		         exist or is not a directory");
		      } 
		      else {
		         for (int i=0; i< children.length; i++) {
		            String filename = children[i];
		            if (res!="") res+=",";
		            res += filename;
//		            System.out.println(filename);
		         }
		      } 
		      
		      return LuaValue.valueOf(res);
		}
	}

	
	static class findFilesByDate extends TwoArgFunction {
		public LuaValue call(LuaValue ldays, LuaValue lsubdir) {
			String res = "";
			String xdir = Ini.getExportDir();
			final String subdir = lsubdir.tojstring();
			if (subdir!="") xdir = xdir + "\\" + subdir;
			final String fdir = xdir;
			File dir = new File(fdir);
			int days = ldays.toint(); 
			Date now = new Date();

			
			final long min = now.getTime() - (days * 24  * 60 * 60 * 1000); //x nap 
		      FilenameFilter filter = new FilenameFilter() {
		         public boolean accept
		         (File dir, String name) {
		        	 File f = new File(fdir + "\\" + name); 
		        	 return f.lastModified()  <min;
		        }
		      };
		      String[] children = dir.list(filter);
		      if (children == null) {
		         System.out.println("Either dir does not 		         exist or is not a directory");
		      } 
		      else {
		         for (int i=0; i< children.length; i++) {
		            String filename = children[i];
		            if (res!="") res+=",";
		            res += filename;
//		            System.out.println(filename);
		         }
		      } 
		      
		      return LuaValue.valueOf(res);
		}
	}

	static class strToTable extends OneArgFunction {
		public LuaValue call(LuaValue content){

			String[] lines = Stringfunc.split(content.tojstring(), "\n");
			
			ArrayList list=new ArrayList();
			for (int i=0;i<lines.length;i++){
				list.add(lines[i]);
			}
			
//			if (list!=null) {
				LuaValue rows = tableOf();
				for(int i=0;i<list.size();i++){
					LuaValue cols = tableOf();
					String[] row = Stringfunc.split(list.get(i).toString(), "]]");
					for (int j=0;j<row.length;j++){
						String[] field = Stringfunc.split(row[j], "=");
						String val = "";
						if (field.length==1) val = "";
						else val = field[1];
						cols.set(field[0].replace('[', ' ').trim(), val);
					}
					rows.set(i+1, cols);
				}
				return rows;
//			}
//			else return CoerceJavaToLua.coerce( null);
		}
	}

	static class iniGet extends OneArgFunction {
		public LuaValue call(LuaValue iniItem) {
			LuaValue res = LuaValue.valueOf("") ;
			if (iniItem.tojstring().equalsIgnoreCase("exportdir")) res = LuaValue.valueOf(Ini.getExportDir());
			if (iniItem.tojstring().equalsIgnoreCase("luadir")) res = LuaValue.valueOf(Ini.getLuaDir());
			if (iniItem.tojstring().equalsIgnoreCase("inidir")) res = LuaValue.valueOf(Ini.getIniDir());
			if (iniItem.tojstring().equalsIgnoreCase("imagesdir")) res = LuaValue.valueOf(Ini.getImgDir());
			return res;
		}
	}

	static class getWifiStrength extends ZeroArgFunction {
		public LuaValue call() {
			return LuaValue.valueOf(Fusion.getWlanStrength());
		}
	}
}
