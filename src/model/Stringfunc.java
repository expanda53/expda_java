package model;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.StringTokenizer;

import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;

public class Stringfunc {
	
	public static String[] split(String text){
		if (text==null) text="" ;
		StringTokenizer st = new StringTokenizer(text,";");
		ArrayList res = new ArrayList();
		while (st.hasMoreTokens()){
			res.add(st.nextToken());
		}
		//String[] array = res.toArray(new String[res.size()]);
		
		String[] array = new String[res.size()];

		for (int i = 0; i < res.size(); i++) {
		    array[i] = res.get(i).toString();
		}		
		return array;
	}
	
	public static String[] split(String text, String delimiter){
		if (text==null) text="" ;
		StringTokenizer st = new StringTokenizer(text,delimiter);
		ArrayList res = new ArrayList();
		if (text.indexOf(delimiter)==0) res.add("");
		while (st.hasMoreTokens()){
			res.add(st.nextToken());
		}
		//String[] array = res.toArray(new String[res.size()]);
		
		String[] array = new String[res.size()];

		for (int i = 0; i < res.size(); i++) {
		    array[i] = res.get(i).toString();
		}		
		return array;
	}
	public static String[] split(String text, String delimiter, int limit){
		StringTokenizer st = new StringTokenizer(text,delimiter);
		ArrayList res = new ArrayList();
		if (text.indexOf(delimiter)==0) res.add("");
		if (limit==0) limit=1000;
		int akt=0;
		String strleft="";
		while (st.hasMoreTokens()){
			if (akt<=limit)	res.add(st.nextToken());
			else strleft+=delimiter+st.nextToken();
			akt++;
		}
		if (strleft!="") res.add(strleft);
		
		String[] array = new String[res.size()];

		for (int i = 0; i < res.size(); i++) {
		    array[i] = res.get(i).toString();
		}		
		return array;
	}
	
	public static String replaceAll(String text, String oldpart, String newpart) {
		//String.ReplaceAll is not supported by phoneme advanced
		String target = text;
		while (target.indexOf(oldpart)>-1) {
			int index = target.indexOf(oldpart);
			String temps=target.substring(0,index);
			temps = temps + newpart + target.substring(index + oldpart.length(),target.length());
			target = temps;
		}
		return target;
	}
	
	public static String replaceFirst(String text, String oldpart, String newpart) {
		//String.ReplaceFirst is not supported by phoneme advanced
		String target = text;
		if (target.indexOf(oldpart)>-1) {
			int index = target.indexOf(oldpart);
			String temps=target.substring(0,index);
			temps = temps + newpart + target.substring(index + oldpart.length(),target.length());
			target = temps;
		}
		return target;
	}
	
	public static ArrayList readFiletoArrayList( String file ) throws IOException {
	    BufferedReader reader = new BufferedReader( new FileReader (file));
	    String         line = null;
	    ArrayList res = new ArrayList();
//	    String         ls = System.getProperty("line.separator");

	    while( ( line = reader.readLine() ) != null ) {
	        res.add( line );
//	        res.add( ls );
	    }

	    return res;
	}

	public static String readFiletoString( String file ) throws IOException {
	    BufferedReader reader = new BufferedReader( new FileReader (file));
	    String         line = null;
	    String res = "";
//	    String         ls = System.getProperty("line.separator");

	    while( ( line = reader.readLine() ) != null ) {
	        res+= line.trim();
//	        res.add( ls );
	    }

	    return res;
	}
	
	public static String getFile(String fn,Shell shell){
		String xmlstring2 = "";
		String xmlnev = Ini.getIniDir()+fn;
		if (new File(xmlnev ).exists()) {
			try {
				xmlstring2 = Stringfunc.readFiletoString(xmlnev);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else {
			MessageBox msg = new MessageBox(shell);
			msg.setMessage(xmlnev + " nincs meg.");
			msg.open();			
		}
		return xmlstring2;
	}
	
}
