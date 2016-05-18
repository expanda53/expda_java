package model;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.eclipse.swt.widgets.Shell;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class Ini {
	
	private static String iniDir = "application\\expda\\ini";
	private static String luaDir = "application\\expda\\lua";
	private static String imgDir = "application\\expda\\images";
	private static String exportDir = "application\\expda\\export";
	private static String IP;
	private static String PORT;
	private static boolean teszt = false;
	private static String connectionType = "tcp";
	private static String phpUrl = "";
	public static void Create(Shell shell){
		if (System.getProperty("expda.dir")!=null) Ini.setIniDir("" + System.getProperty("expda.dir")+"\\ini");
		new File(Ini.getIniDir() ).mkdirs();
		Ini.setIniDir(Ini.getIniDir() + "\\");
		String appconfig = Stringfunc.getFile("AppConfig.xml", shell);
		parsing(appconfig);
		
	}
	
	public static String getIniDir() {
		return iniDir;
	}
	public static void setIniDir(String iniDir) {
		Ini.iniDir = iniDir;
	}
	
	private static String domParsing(String xmltext, String findItem,String Root) throws ParserConfigurationException, SAXException, IOException {
		String result="";
		DocumentBuilder dBuilder=DocumentBuilderFactory.newInstance().newDocumentBuilder();
		Document doc=dBuilder.parse(new InputSource(new StringReader(xmltext)));
		NodeList nList = doc.getElementsByTagName(Root);
		for (int i = 0; i < nList.getLength(); i++) {
			Node node= nList.item(i);
			if(node.getNodeType()==Node.ELEMENT_NODE){
				Element e=(Element)node;
				for (int j=0;j<e.getElementsByTagName(findItem).getLength();j++){
					if (e.getElementsByTagName(findItem).item(j).getFirstChild().hasChildNodes()) {
						for (int k=0;k<e.getElementsByTagName(findItem).item(j).getChildNodes().getLength();k++) {
							String childname = e.getElementsByTagName(findItem).item(j).getChildNodes().item(k).getNodeName();
							String aktitem = childname+"="+domParsing(xmltext, childname, findItem);
//							System.out.println("childname:"+childname+" finditem:"+findItem+" aktitem:"+aktitem);
							result+=aktitem;
						}
					}
					else {
						String aktitem = e.getElementsByTagName(findItem).item(j).getFirstChild().getNodeValue();
						result+=aktitem;
					}
					
				}
			}
		}
		return result;
	}
	
	private static void parsing(String xml){
		try {
			Ini.setIP(domParsing(xml,"tcpserver_ip","Root"));
			Ini.setPORT(domParsing(xml,"tcpserver_port","Root"));
			Ini.setImgDir(domParsing(xml,"images_folder","Root"));
			Ini.setLuaDir(domParsing(xml,"lua_folder","Root"));
			Ini.setExportDir(domParsing(xml,"export_folder","Root"));
			Ini.setConnectionType(domParsing(xml,"connection_type","Root"));
			Ini.setPhpUrl(domParsing(xml,"php_url","Root"));
			Ini.setTeszt(domParsing(xml,"vkod_teszt","Root").equalsIgnoreCase("true"));
			
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}

	public static String getIP() {
		return IP;
	}

	public static void setIP(String iP) {
		IP = iP;
	}

	public static String getPORT() {
		return PORT;
	}

	public static void setPORT(String pORT) {
		PORT = pORT;
	}

	public static String getImgDir() {
		return imgDir;
	}

	public static void setImgDir(String imgDir) {
		Ini.imgDir = imgDir;
	}

	public static boolean isTeszt() {
		return teszt;
	}

	public static void setTeszt(boolean teszt) {
		Ini.teszt = teszt;
	}

	public static String getLuaDir() {
		return luaDir;
	}

	public static void setLuaDir(String luaDir) {
		Ini.luaDir = luaDir;
	}

	public static String getExportDir() {
		return exportDir;
	}

	public static void setExportDir(String exportDir) {
		Ini.exportDir = exportDir;
	}

	public static String getConnectionType() {
		return connectionType;
	}

	public static void setConnectionType(String connectionType) {
		Ini.connectionType = connectionType.toUpperCase();
	}

	public static String getPhpUrl() {
		return phpUrl;
	}

	public static void setPhpUrl(String phpUrl) {
		Ini.phpUrl = phpUrl;
	}
		

}
