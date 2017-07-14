package admin.customer.guanwangbao.weixin;

import java.util.List;
import java.util.Map;
import java.util.Vector;

public class Button {
    private Map data;
    private Vector<Button> subButtons = new Vector<Button>();

	public String getName() {
		return data.get("name") == null ? "" : data.get("name").toString();
	}

	public String getType() {
		return data.get("type") == null ? "" : data.get("type").toString();
	}

    public String getUrl() {
		return data.get("url") == null ? "" : data.get("url").toString();
	}

	public Vector<Button> getSubButtons() {
		return subButtons;
	}

	public void setSubButtons(Vector<Button> subButtons) {
		this.subButtons = subButtons;
	}

	public Map getData() {
		return data;
	}

	public void setData(Map data) {
		this.data = data;
		if (data.get("sub_button") != null) {
			try {
				List datas = (List) data.get("sub_button");
				if (datas == null) {
					return;
				}
				subButtons = new Vector<Button>();
				for (int i = 0; i < datas.size(); i++) {
					Map m2 = (Map) datas.get(i);
					Button b = new Button();
					b.setData(m2);
					subButtons.add(b);
				}
			} catch (Exception e) {
			}
		}
	}  

}
