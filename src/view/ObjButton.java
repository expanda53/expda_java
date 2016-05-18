package view;

import model.Ini;

public class ObjButton extends ObjDefault {
	private String Function;
	private String SqlAfterClick;
	private String LuaAfterClick;
	private String Image="";


	public String getFunction() {
		return Function;
	}

	public void setFunction(String type) {
		this.Function = type;
	}

	public String getSqlAfterClick() {
		return SqlAfterClick;
	}
	


	public void setSqlAfterClick(String sqlAfterClick) {
		this.SqlAfterClick = sqlAfterClick;
	}

	public String getImage() {
		if (Image!="")	return Ini.getImgDir()+"\\"+Image;
		else return "";
	}

	public void setImage(String image) {
		Image = image;
	}

	public String getLuaAfterClick() {
		return LuaAfterClick;
	}

	public void setLuaAfterClick(String luaAfterClick) {
		LuaAfterClick = luaAfterClick;
	}


}
