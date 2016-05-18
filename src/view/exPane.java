package view;
//import java.sql.Connection;
//import java.sql.DriverManager;
//import java.sql.ResultSet;
//import java.sql.Statement;
//import java.net.URLEncoder;
import java.util.ArrayList;

import model.Fusion;
import model.Ini;
import model.Lua;
import model.MScanner;
import model.PHPClient;
import model.Stringfunc;
import model.Tcpclient;

import org.eclipse.swt.SWT;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.MessageBox;
import org.eclipse.swt.widgets.Shell;




public class exPane extends Composite {
	private ObjBarcode AktBCodeObj;
	private Object[] objects;
	private String SqlOnCreate;
	private String LuaOnCreate;
	private Shell shell;
	private boolean teszt;
	private Tcpclient tcp = null;
	private PHPClient phpcli = null;
	private MScanner scanner = null;
	private String xmlparam ="";
	private Display display;
	private String mainPanelName="";
	private ObjPanel p;
	private Lua lua=null;
//	private Label aktlabel;
//	private Date timeStart;
//	private Date timeEnd;
    Shell dialogShell = null; 
	public exPane(Shell shell, Display display){
		super(shell,SWT.CENTER);//shell
		this.setBounds(display.getBounds());
		this.setLayout(null);
		this.setBackground(Display.getCurrent().getSystemColor(SWT.COLOR_DARK_GRAY));
		this.shell=shell;
		this.display = display;
		this.teszt=Ini.isTeszt();
//		this.go(null);
		try {
			if (Ini.getConnectionType().equalsIgnoreCase("PHP")){
				this.phpcli = new PHPClient(Ini.getPhpUrl());
			}
				
			if (this.getPhpcli() == null || Ini.getConnectionType().equalsIgnoreCase("TCP")) this.tcp = new Tcpclient(Ini.getIP(),Ini.getPORT(),"hello");
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			try {
				if (Ini.getConnectionType().equalsIgnoreCase("TCP")) getTcp().reconnect();
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
				this.tcp=null;
//				showMessage("Csatlakozás nem sikerült.");
//				System.exit(0);
			}
			
			
		}

	}
	public void showWaitbox(String title){
		// populate dialogShell
		if (dialogShell==null || dialogShell.isDisposed()) dialogShell = new Shell(display, SWT.CENTER);
		int dwidth= 200;
		int dheight = 30;
		dialogShell.setBounds(this.getShell().getBounds().x + (this.getShell().getBounds().width / 2) - (dwidth/2),this.getShell().getBounds().y + (this.getShell().getBounds().height / 2) - (dheight/2) ,dwidth,dheight);
		dialogShell.setLayout(new FillLayout());
		Label wlabel = new Label(dialogShell,SWT.CENTER);
		if (title=="") title = "Várjon...";
		wlabel.setText(title);
		wlabel.setBackground(Colorfunc.getColor("yellow", 0));
		wlabel.setForeground(Colorfunc.getColor("black", 0));
		
		wlabel.setVisible(true);
		
		dialogShell.open();
	}
	
	public void hideWaitbox(){
		dialogShell.dispose();
	}
	
	public boolean showDialog(String p1){
		  MessageBox messageBox = new MessageBox(shell, SWT.ICON_QUESTION |SWT.YES | SWT.NO);
		  messageBox.setMessage(p1);
		    int rc = messageBox.open();
		    
		    return (rc == SWT.YES);
	}
	public void showMessage(String p1) {
		MessageBox msg = new MessageBox(this.shell);
		msg.setMessage(p1);
		msg.open();
	}
	private void setParamsToLabels(String[] params, String[] labels){
		if (params!=null && labels!=null && params.length>0 && labels.length>0) {
			for (int i=0;i<labels.length;i++){
				Control o = this.findObject(labels[i]);
				if (o != null){
					if (params.length>i) {
						if (o instanceof exLabel){
							((exLabel) o).setText(params[i]);
						}
					}
				}
			}
			
		}
		
	}
	public boolean createPanel(String[] params){
		this.showWaitbox("Panel betöltése...");
		boolean res = false;
		if (objects!=null){
			res=true;
			for (int i=0;i<objects.length;i++){
				Object obj = objects[i];
				Control parent = this;
				if (obj instanceof ObjDefault){
					String parentstr = ((ObjDefault) obj).getParent();
					if (parentstr.equals("")) {
						 parent=this;
					}
					else parent=this.findObject(parentstr);
				}
				if (obj!=null)	{
					if (obj instanceof ObjLabel) {
						if (parent instanceof exPanel)	new exLabel((exPanel)parent, (ObjLabel)obj);
						else new exLabel((exPane)parent, (ObjLabel)obj);
						
					}
					if (obj instanceof ObjButton) {
						if (((ObjButton) obj).getImage()!="") {
							if (parent instanceof exPanel) new exImgButton((exPanel)parent,(ObjButton)obj);
							else new exImgButton((exPane)parent,(ObjButton)obj);
						}
						else {
							if (parent instanceof exPanel) new exButton((exPanel)parent,(ObjButton)obj);
							else new exButton((exPane)parent,(ObjButton)obj);
						}
					}
					if (obj instanceof ObjText) {
						if (parent instanceof exPanel) new exText((exPanel)parent,(ObjText)obj);
						else new exText((exPane)parent,(ObjText)obj);
					}				
					if (obj instanceof ObjPanel) {
						
						if (((ObjPanel) obj).isMainPanel()){
							p=((ObjPanel) obj);
							this.getShell().setText(((ObjPanel) obj).getText());
							this.setMainPanelName(((ObjPanel) obj).getName());
	
							setSqlOnCreate(((ObjPanel) obj).getsqlOnCreate());
							setLuaOnCreate(((ObjPanel) obj).getLuaOnCreate());
							if (((ObjPanel) obj).getBackColor() != null)
								this.getShell().setBackground(((ObjPanel) obj).getBackColor());
							
							
						}
						else {
							Composite p = this;
							if (((ObjPanel) obj).getParent()!=null && ((ObjPanel) obj).getParent()!="") p = (exPanel)findObject( ((ObjPanel) obj).getParent() );  
							new exPanel(p,(ObjPanel)obj);//(exPane)this
						}
					}
					if (obj instanceof ObjBarcode){
						((ObjBarcode)obj).setPane(this);
					}
					if (obj instanceof ObjTable){
						if (parent instanceof exPanel)	new exTable((exPanel)parent,(ObjTable)obj);
						else new exTable((exPane)parent,(ObjTable)obj);
					}
				}
			}
		}
		if (this.p!=null) {
			setParamsToLabels(params,p.getParamsToLabels());
		}
		this.hideWaitbox();
		return res;
	
	}
	
	public Control findObjectAll(String name,Control[] ctrl) {
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
	
	public Control findObject(String name){
		Control back = findObjectAll(name, this.getChildren());
		String objnev;
		if (back == null) {
//			back = findObjectAll(name, this.getParent().getChildren());
		}
		
		if (back == null) {
			//saját mainpanel visszaadása
			objnev=this.getMainPanelName().toUpperCase();
			if (objnev.equalsIgnoreCase(name)){
				back = this;
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
	
	public void valueTo(String objname, String value, boolean hidden){
		Control o = this.findObject(objname);
		if ( o instanceof exLabel){
			((exLabel) o).setText(value);
			((exLabel) o).setVisible(!hidden);
		}
		else
		if ( o instanceof exButton){
			((exButton) o).setText(value);
			((exButton) o).setVisible(!hidden);
		}
		else
		if ( o instanceof exText){
			((exText) o).setText(value);
			((exText) o).setVisible(!hidden);
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
		
		if (curr.length>2)
		{
			for (int ix=2;ix<curr.length;ix++) {
				ertek+="="+curr[ix];
			}
		}
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
	
	public void setScannerOn() throws Exception{
		if (!this.teszt) this.getScanner().scannerOn();
		
	}
	public void setScannerOff() throws Exception{
			if (!this.teszt) this.getScanner().scannerOff();
		
	}

	public void executeCommand(String command, String p1, String p2) throws Exception{
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
				if ( o instanceof exImgButton) {
						((exImgButton) o).setVisible(vis);
				}
				else
					
				if ( o instanceof exPanel){
					((exPanel) o).setVisible(vis);
				}	
				else
				if ( o instanceof exTable){
					((exTable) o).setVisible(vis);
				}
				else
					if ( o instanceof exText){
						((exText) o).setVisible(vis);
					}
				else 
				if (o.equals(this)) {
					this.shell.setVisible(vis);
				}
				
			}
		}
		else if ((command.equalsIgnoreCase("SETFOCUS")) ){
			String[] objlist = Stringfunc.split(p1, ";");
			for (int i=0;i<objlist.length;i++){
				Control o = this.findObject(objlist[i]);
				if ( o instanceof exLabel){
					((exLabel) o).setFocus();
				}
				else
				if ( o instanceof exButton) {
					((exButton) o).setFocus();
				}
				else
				if ( o instanceof exImgButton) {
					((exImgButton) o).setFocus();
				}
				else
				if ( o instanceof exPanel){
					((exPanel) o).setFocus();
				}	
				else
				if ( o instanceof exTable){
					((exTable) o).setFocus();
				}
				else
				if ( o instanceof exText){
					((exText) o).setFocus();
				}
				else 
				if (o.equals(this)) {
					this.shell.setFocus();
				}
				
			}
		}
		else if ((command.equalsIgnoreCase("SETFONTCOLOR")) ){
			String[] objlist = Stringfunc.split(p1, ";");
			for (int i=0;i<objlist.length;i++){
				Control o = this.findObject(objlist[i]);
				if ( o instanceof exLabel){
					((exLabel) o).setFontColor(p2);
				}
				else
				if ( o instanceof exButton) {
					((exButton) o).setFontColor(p2);
				}
				else
				if ( o instanceof exButton) {
					((exImgButton) o).setFontColor(p2);
				}
				else					
				if ( o instanceof exText){
					((exText) o).setFontColor(p2);
				}
				else
				if ( o instanceof exPanel){
					((exPanel) o).setFontColor(p2);
				}
				else
				if ( o instanceof exTable){
					((exTable) o).setFontColor(p2);
				}
				
				
				
			}
		}		
		else if ((command.equalsIgnoreCase("SETBGCOLOR")) ){
			String[] objlist = Stringfunc.split(p1, ";");
			for (int i=0;i<objlist.length;i++){
				Control o = this.findObject(objlist[i]);
				if ( o instanceof exLabel){
					((exLabel) o).setBgColor(p2);
				}
				else
				if ( o instanceof exButton) {
					((exButton) o).setBgColor(p2);
				}
				else
				if ( o instanceof exImgButton) {
					((exImgButton) o).setBgColor(p2);
				}
				else
				if ( o instanceof exText){
					((exText) o).setBgColor(p2);
				}
				else
				if ( o instanceof exPanel){
					((exPanel) o).setBgColor(p2);
				}
				else
				if ( o instanceof exTable){
					((exTable) o).setBgColor(p2);
				}
				
				
			}
		}		
		else if ((command.equalsIgnoreCase("SETWIDTH")) || (command.equalsIgnoreCase("SETHEIGHT")) || (command.equalsIgnoreCase("SETTOP")) || (command.equalsIgnoreCase("SETLEFT"))){
			String[] objlist = Stringfunc.split(p1, ";");
			for (int i=0;i<objlist.length;i++){
				Control o = this.findObject(objlist[i]);
				if ( o instanceof exLabel){
					((exLabel) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
				}
				else
				if ( o instanceof exButton) {
					((exButton) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
				}
				else
				if ( o instanceof exImgButton) {
					((exImgButton) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
				}
				else
				if ( o instanceof exText){
					((exText) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
				}
				else
				if ( o instanceof exPanel){
					((exPanel) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
				}
				else
				if ( o instanceof exTable){
					((exTable) o).setBounds(command.toUpperCase(),Integer.parseInt(p2));
				}
				
				
			}
		}		
		else if (command.equalsIgnoreCase("SETALIGN") ){
			String[] objlist = Stringfunc.split(p1, ";");
			for (int i=0;i<objlist.length;i++){
				Control o = this.findObject(objlist[i]);
				if ( o instanceof exLabel){
					((exLabel) o).setAlign(p2);
				}
			
				
			}
		}		
		else if (command.equalsIgnoreCase("UZENET")){
			showMessage(p1);
		}
		else if (command.equalsIgnoreCase("VALUETO")){
			this.valueTo(p1,p2,false);
	
		}
		else if (command.equalsIgnoreCase("VALUETOHIDDEN")){
			this.valueTo(p1,p2,true);
	
		}
		else if (command.equalsIgnoreCase("AKTBCODEOBJ")){
			this.setAktBCodeObj(p1);
		}
		else if (command.equalsIgnoreCase("SCANNERON")){
			this.setScannerOn();
		}
		else if (command.equalsIgnoreCase("SCANNEROFF")){
			this.setScannerOff();
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
							String msg=((exTable) o).getObj().getLuaOnCreate();
							luaInit(msg); //lua.queryvel refresht kell meghivni (parsing false)
						}
					}
				}
							
		}
		else if (command.equalsIgnoreCase("OPENXML")){
			this.setXmlparam(p1);
			this.showWaitbox("Megnyitás...");
			 new SWTFrame(this.getXmlparam(), display,null,p2);
			 this.hideWaitbox();
		
		}

		else if (command.equalsIgnoreCase("CLOSE")){
			if (lua!=null) {
				lua.stop();
				lua=null;
			}
			try {
				this.getShell().close();
			} catch (Exception e) {
				
			}
			
		
		}
		
		else if (command.equalsIgnoreCase("TCPUZENET")){
			sendGetExecute(p1, true);
			
		}
		else if (command.equalsIgnoreCase("STARTLUA")){
			luaInit(p1 + ' ' +p2);
		}

	}
	
	public void parseTcpResponse(ArrayList response) throws Exception{
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
				if (par[0].equalsIgnoreCase("P1") && (par.length>1)) {
					/*StringBuffer result = new StringBuffer();
					for (int k = 0; k < par.length; k++) {
					   result.append( par[k]+";" );
					}
					String newstr = result.toString();
					*/
					currParam1 = Stringfunc.replaceFirst(temps, "P1;", "");
					
				}
				if (par[0].equalsIgnoreCase("P2") && (par.length>1)) currParam2 = par[1];
				}
			}
			if (currCommand!=""){
				executeCommand(currCommand, currParam1, currParam2);
			}
			
		}
	}
	
	private String replaceValues(String message, String paramPrefix){
		if (paramPrefix=="") paramPrefix=":";
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
			else
			if ( o instanceof exText){
				val=((exText) o).getText();
			}
//			res=res.replaceAll("\\["+part+"\\]", val);
			val=Stringfunc.replaceAll(val, " ", "%20"); //szóköz lecserélése. sqlben majd vissza kell cserélni
			res=Stringfunc.replaceAll(res, "["+part+"]", paramPrefix+val); //tcp uzenetben kuldeshez :-t rakok az érték elejére, mert pl a szóköz vagy üres string nem megy át egyébként. sqlben majd le kell venni az elejéröl

			
		}
		
		return res;
	}
	

	public ArrayList sendGetExecute(String message,boolean parsing){
		
			if (message!=null){
				if (Fusion.getWlanStrength()>0) {
					try {
						message = replaceValues(message,":");
						if (getTcp()!=null) {
							//getTcp().reconnect();
							ArrayList response = getTcp().sendMessage(message);
							if (parsing) {parseTcpResponse(response);return null;}
							else {return response;}
						}
						else if (this.getPhpcli()!=null) {
							ArrayList response = getPhpcli().sendMessage(message);
							if (parsing) {parseTcpResponse(response);return null;}
							else {return response;}
							
						}
						else return null;
					}
					catch (Exception e){
						System.out.println(e.getMessage());
						try {
							if (getTcp()!=null) {
								getTcp().reconnect();
								ArrayList response = getTcp().sendMessage(message);
								if (parsing) {parseTcpResponse(response);return null;}
								else return response;
		
							}
							else if (getPhpcli()!=null) {
								ArrayList response = getPhpcli().sendMessage(message);
								if (parsing) {parseTcpResponse(response);return null;}
								else {return response;}
								
							}
							else return null;
						} catch (Exception e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
							System.out.println(e.getMessage());
							if (showDialog("Üzenetküldés nem sikerült.Kilép?")) {
								try {
									setScannerOff();
								} catch (Exception e2) {
									// TODO Auto-generated catch block
									e2.printStackTrace();
								}
								
								System.exit(0);
							}
						}
						return null;
					}
				
			}
			else {
				showMessage("Wifi nem elérhető!");
				return null;
			}

		}
		else return null;
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
	public String getMainPanelName() {
		return mainPanelName;
	}
	public void setMainPanelName(String mainPanelName) {
		this.mainPanelName = mainPanelName;
	}


	
	    public void luaInit(String params) {
	    	if (params!=null && params!="") {
	    		params = replaceValues(params,"");
		    	String[] p = Stringfunc.split(params, " ");
		    	String[] p2 = {};
		    	String scrName = p[0];
		    	if (p.length>1){
		    		p2 = new String[p.length - 1];
		    		for (int i=1; i<p.length; i++){
		    			p2[i-1]=p[i];
		    		}
	
		    	}
		    	startLua(scrName, p2);
	    	}
	    }
	    private void startLua(String scriptName, String[] params){
	    	String fn = Ini.getLuaDir() + "\\" + scriptName;
	    	try {
	    		lua=new Lua(this);
	    		lua.load(fn);
	    		lua.setParams(params);
	    		lua.run();
	    	}
	    	catch (Exception e1) {
	    		e1.printStackTrace();
	    		if (showDialog("Script betöltés nem sikerült. Kilép?")) {
	    			try {
						setScannerOff();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	    			System.exit(0);
	    		}
	    	}
			
	    	
	    }
		public String getLuaOnCreate() {
			return LuaOnCreate;
		}
		public void setLuaOnCreate(String luaOnCreate) {
			LuaOnCreate = luaOnCreate;
		}
		public PHPClient getPhpcli() {
			return phpcli;
		}

}
