package view;

import java.util.ArrayList;

import model.Ini;
import model.MScanner;
import model.Stringfunc;
import model.Tcpclient;

import org.eclipse.swt.SWT;
import org.eclipse.swt.custom.CTabFolder;
import org.eclipse.swt.custom.CTabItem;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;



public class exTabbed extends CTabFolder {
	private ObjBarcode AktBCodeObj;
	private Object[] objects;
	private String SqlOnCreate;
	private String LuaOnCreate;	
	private Shell shell;
	private boolean teszt =true;
	private Tcpclient tcp;
	private MScanner scanner = null;
	private String xmlparam ="";
	 private CTabItem citem;
	public exTabbed(Shell shell, Display display){
		super(shell,SWT.CENTER);
		this.setBounds(display.getBounds());
		this.setLayout(null);
		this.setBackground(Display.getCurrent().getSystemColor(SWT.COLOR_DARK_GRAY));
		this.shell=shell;
		
		
	    
	    
	    this.setBorderVisible(true);
//	    tabFolder.setLayoutData(new GridData(GridData.FILL_BOTH));
	    this.setLayoutData(null);
	    // Set up a gradient background for the selected tab
	    this.setSelectionBackground(new Color[] {
	        display.getSystemColor(SWT.COLOR_WIDGET_DARK_SHADOW),
	        display.getSystemColor(SWT.COLOR_WIDGET_NORMAL_SHADOW),
	        display.getSystemColor(SWT.COLOR_WIDGET_LIGHT_SHADOW)}, new int[] { 50,
	        100});
		
	   citem = new CTabItem(this, SWT.NONE,0);
	//    
	    citem.setText("Tab tab tab tab tab tab tab ");
		
		try {
			this.tcp = new Tcpclient(Ini.getIP(),Ini.getPORT(),"hello");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}

	}
	public void createPanel(){
		for (int i=0;i<objects.length;i++){
			Object obj = objects[i];
			Control parent = this;
			if (obj instanceof ObjDefault){
				String parentstr = ((ObjDefault) obj).getParent();
				if (parentstr.equals("")) parent=this;
				else parent=this.findObject(parentstr);
			}
			if (obj!=null)	{
				if (obj instanceof ObjLabel) {
					new exLabel((Composite)parent, (ObjLabel)obj);
					
				}
				if (obj instanceof ObjButton) {
					new exButton((Composite)parent,(ObjButton)obj);
				}
				if (obj instanceof ObjPanel) {
					
					if (((ObjPanel) obj).isMainPanel()){
						this.getShell().setText(((ObjPanel) obj).getText());
						setSqlOnCreate(((ObjPanel) obj).getsqlOnCreate());
						setLuaOnCreate(((ObjPanel) obj).getLuaOnCreate());
						if (((ObjPanel) obj).getBackColor() != null)
						  this.setBackground(((ObjPanel) obj).getBackColor());
						
					}
					else {
						new exPanel((exTabbed)this,(ObjPanel)obj);
					}
				}
				if (obj instanceof ObjBarcode){
					((ObjBarcode)obj).setPane(this);
				}
				if (obj instanceof ObjTable){
					new exTable((Composite)parent,(ObjTable)obj);
				}
			}
		}
		
//		Control o = findObject(pane, "label2");
//		if ( o instanceof exLabel){
//			((exLabel) o).setText(param);
//		}
		
	
	}	
	public Control findObject(String name){
		Control[] ctrl = this.getChildren();
		Control back = null;
		String objnev;
		for (int i=0;i<ctrl.length;i++){
			if (back==null){
			Control o = ctrl[i];
			if (o instanceof exPanel){
				back=this.findObject((exPanel)o,name);
			}
			if (o.getData("NAME")!=null   ){
				objnev=o.getData("NAME").toString().toUpperCase();
				if (objnev.equalsIgnoreCase(name)){
					back = o;
//					System.out.println(o.getClass().toString()+":"+name);
				}
			}
			}
		}
		return back;
	}

	public Control findObject(Composite panel, String name){
		Control[] ctrl = panel.getChildren();
		Control back = null;
		String objnev;
		for (int i=0;i<ctrl.length;i++){
			if (back==null){
			Control o = ctrl[i];
			if (o instanceof exPanel){
				back=this.findObject((exPanel)o,name);
			}
			if (o.getData("NAME")!=null){
				objnev=o.getData("NAME").toString().toUpperCase();
				if (objnev.equalsIgnoreCase(name)){
					back = o;
//					System.out.println(o.getClass().toString()+":"+name);
				}
			}
			}
		}
		return back;
	}
	
	public void valueTo(String objname, String value){
		Control o = this.findObject(objname);
		if ( o instanceof exLabel){
			((exLabel) o).setText(value);
		}
		else
		if ( o instanceof exButton){
			((exButton) o).setText(value);
		}
		else System.out.println(objname+":"+value);
		
	}

	public ObjBarcode getAktBCodeObj() {
		return AktBCodeObj;
	}

	public void setAktBCodeObj(String AktBCodeObjName) {
		for (int i=0;i<this.objects.length;i++){
			Object obj = this.objects[i];
			if (obj instanceof ObjBarcode){
				if (((ObjBarcode)obj).getName().equalsIgnoreCase(AktBCodeObjName)) {
					this.AktBCodeObj=((ObjBarcode)obj);
				}
			}
		}
		
	}
	public String getSqlOnCreate() {
		return SqlOnCreate;
	}
	public void setSqlOnCreate(String sqlOnCreate) {
		this.SqlOnCreate = sqlOnCreate;
	}

	public String getObjects() {
		return SqlOnCreate;
	}
	public void setObjects(Object[] objects) {
		this.objects = objects;
	}
	
	
	private String parseResponse(String row){
		String res ="";
		String[] curr = Stringfunc.split( row.replace('[', ' ').trim(),"=");
		String mezo="";
		if (curr.length>0) mezo=curr[0];
		String ertek="";
		if (curr.length>1) ertek=curr[1];
//		System.out.println(mezo+" "+ertek);
		if (mezo.equalsIgnoreCase("TIPUS")){
			res="C;" + ertek.toUpperCase();
		}
		if (mezo.equalsIgnoreCase("PARAM1")){
			res="P1;" + ertek;
		}
		if (mezo.equalsIgnoreCase("PARAM2")){
			res="P2;" + ertek;
		}
		return res;
	}

	private void executeCommand(String command, String p1, String p2){
		if ((command.equalsIgnoreCase("SHOWOBJ")) || (command.equalsIgnoreCase("HIDEOBJ"))){
			String[] objlist = Stringfunc.split(p1, ";");
			for (int i=0;i<objlist.length;i++){
				Control o = this.findObject(objlist[i]);
				boolean vis = (command.equalsIgnoreCase("SHOWOBJ"));
				if ( o instanceof exLabel){
					((exLabel) o).setVisible(vis);
				}
				else
				if ( o instanceof exButton) {
					((exButton) o).setVisible(vis);
				}
				else
				if ( o instanceof exPanel){
					((exPanel) o).setVisible(vis);
				}	
				else
				if ( o instanceof exTable){
					((exTable) o).setVisible(vis);
				}	
				
			}
		}
		else if (command.equalsIgnoreCase("UZENET")){
			MessageBox msg = new MessageBox(shell);
			msg.setMessage(p1);
			msg.open();
		}
		else if (command.equalsIgnoreCase("VALUETO")){
			this.valueTo(p1,p2);
	
		}
		else if (command.equalsIgnoreCase("AKTBCODEOBJ")){
			this.setAktBCodeObj(p1);
		}
		else if (command.equalsIgnoreCase("SCANNERON")){
			if (!teszt)
				try {
					this.scanner.scannerOn();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
		else if (command.equalsIgnoreCase("SCANNEROFF")){
			if (!teszt)
				try {
					this.scanner.scannerOff();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
		else if (command.equalsIgnoreCase("REFRESH")) {
				String[] objlist = Stringfunc.split(p1,";");
				for (int i=0;i<objlist.length;i++){
					Control o = this.findObject(objlist[i]);
					if ( o instanceof exTable){
						if (((exTable) o).getObj().getsqlOnCreate()!=null) {
							String msg=((exTable) o).getObj().getsqlOnCreate();
							((exTable) o).refresh(sendGetExecute(msg,false));
						}
						if (((exTable) o).getObj().getLuaOnCreate()!=null) {
//							String msg=((exTable) o).getObj().getLuaOnCreate();
//							luaInit(msg); //refresht kell meghivni arraylist parameterrel
//							((exTable) o).refresh(sendGetExecute(msg,false));//ide még nincs átvezetve
						}
						
					}	
					
				}
		}
		else if (command.equalsIgnoreCase("OPENXML")){
			this.setXmlparam(p1);
		
		}
		else if (command.equalsIgnoreCase("CLOSE")){
			this.getShell().close();
		
		}
		
		else if (command.equalsIgnoreCase("TCPUZENET")){
			sendGetExecute(p1, true);
			
		}

	}
	
	private void parseTcpResponse(ArrayList response){
		for(int i=0;i<response.size();i++){
			String[] row = Stringfunc.split(response.get(i).toString(), "]]");
			String currCommand="";
			String currParam1="";
			String currParam2="";
			for (int j=0;j<row.length ;j++){
				String temps = parseResponse(row[j]);
				if (temps!=""){
				String[] par = Stringfunc.split(temps, ";");
				if (par[0].equalsIgnoreCase("C") && (par.length>1)) currCommand = par[1];
				if (par[0].equalsIgnoreCase("P1") && (par.length>1)) currParam1 = par[1];
				if (par[0].equalsIgnoreCase("P2") && (par.length>1)) currParam2 = par[1];
				}
			}
			if (currCommand!=""){
				executeCommand(currCommand, currParam1, currParam2);
			}
			
		}
	}
	
	private String replaceValues(String message){
		String res=message;
		while (res.indexOf("[")>0) {
			int start = res.indexOf("[")+1;
			int end = res.indexOf("]");
			String part = res.substring(start, end);
			Control o = this.findObject(part);
			String val="";
			if ( o instanceof exLabel){
				val=((exLabel) o).getText();
			}
			else
			if ( o instanceof exButton){
				val=((exButton) o).getText();
			}
//			res=res.replaceAll("\\["+part+"\\]", val);
			res=Stringfunc.replaceAll(res, "["+part+"]", val);
			
		}
		return res;
	}
	

	public ArrayList sendGetExecute(String message,boolean parsing){
		try {
		message = replaceValues(message);
		ArrayList response = getTcp().sendMessage(message);
		if (parsing) {parseTcpResponse(response);return null;}
		else return response;
		}
		catch (Exception e){
			System.out.println(e.getMessage());
			return null;
		
		}
	}
	public Tcpclient getTcp() {
		return tcp;
	}
	public MScanner getScanner() {
		return scanner;
	}
	public void setScanner(MScanner scanner) {
		this.scanner = scanner;
	}
	public String getXmlparam() {
		return xmlparam;
	}
	public void setXmlparam(String xmlparam) {
		this.xmlparam = xmlparam;
	}
	public String getLuaOnCreate() {
		return LuaOnCreate;
	}
	public void setLuaOnCreate(String luaOnCreate) {
		LuaOnCreate = luaOnCreate;
	}

	

}
