package viewmodel;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import model.Stringfunc;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import view.SWTFrame;
import view.uobj;

public class Xmlpanel {
	private String xmlnev;
	private SWTFrame parent;
	private String splitChar="@@";
	private ArrayList<> objects=new ArrayList();
	
	public Xmlpanel(String xmlnev, SWTFrame parent){
		this.xmlnev = xmlnev;
		this.parent = parent;
	}
	
	
	
	private String domParsing(String xmltext, String findItem,String Root) throws ParserConfigurationException, SAXException, IOException {
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
							if (!aktitem.trim().equalsIgnoreCase(""))	result+=aktitem;
						}
					}
					else {
						String aktitem = e.getElementsByTagName(findItem).item(j).getFirstChild().getNodeValue();
						if (!aktitem.trim().equalsIgnoreCase(""))	result+=aktitem+splitChar;
					}
					
				}
			}
		}
		return result;
	}
	
	private void parsing(String xml){
		try {
			String obj = Stringfunc.replaceAll( domParsing(xml,"obj","Root") ,  ";",splitChar);
//			System.out.println(obj);
			if (obj !=""){
				
				
				String[] items = Stringfunc.split(obj,splitChar);//obj.split(";");
				for (int i=0;i<items.length;i++){
					if (items[i]!="") {
						String aktitem = items[i];
						
//						System.out.println(aktitem);
						String res = domParsing(xml,aktitem,"Root");
						if (res!=""){
							if (res.toUpperCase().indexOf("FILE=")!=-1) {
								res = Stringfunc.replaceAll(res.toUpperCase(), "FILE=", "");
								res = Stringfunc.replaceAll(res.toUpperCase(), splitChar, "");
								//files.add(res);
								String xmls=Stringfunc.getFile(res,parent.getShell());
								parsing(xmls);
							}
							else {
								uobj uo = new uobj(aktitem, Stringfunc.split(res,splitChar));  //res.split(";")
								Object o = uo.create();
								if (o != null)	{
									objects.add(o);
								}
							}
						}
						
					}
				}
				
			}
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
	

	public Object[] panelBeolvas(){
		String xmlstring = "";
		xmlstring = Stringfunc.getFile(xmlnev,parent.getShell());
		Object[] tomb = null;
		if (xmlstring!="") {
			parsing(xmlstring);
			tomb = objects.toArray();
		}
		return tomb;
	}

}
