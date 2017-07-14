package admin.customer.guanwangbao;

import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import simpleWebFrame.config.AppConfig;
import simpleWebFrame.log.AppLogger;
import simpleWebFrame.util.StringUtil;

public class PropUtil {
	/**
	 * 获取sku属性显示名 如props = 1000:10001,1001:10003
	 * 即可返回如  颜色:红色,尺码:XL
	 * @param props
	 * @param propsAlias 属性值别名  例:100:10001:大红色,1001:10003:XL(加大)
	 * @return
	 */
	public static String getSkuPropName(String props, String propAlias, String propsValueAlias) {
		Hashtable<String, String> propsAliasHash = alias2Hash(propAlias);
		Hashtable<String, String> propsValueAliasHash = alias2Hash(propsValueAlias);
		
		String[] pvArray = StringUtil.split(props, ",");
		StringBuffer s = new StringBuffer();
		for (int i = 0; i < pvArray.length; ++i) {
			String pv = pvArray[i];
			String[] pid_vid = StringUtil.split(pv, ":");
			String skuPropID = pid_vid[0];
			String skuPropValueID = pid_vid[1];
			if (propsAliasHash.get(skuPropID) != null && !propsAliasHash.get(skuPropID).equals("")) {
				s.append(propsAliasHash.get(skuPropID));
			} else {
				s.append(LocalDataCache.getInstance().getTableDataColumnValue("skuProp", skuPropID, "name"));
			}
			s.append(":");
			if (propsValueAliasHash.get(skuPropValueID) != null) {
				s.append(propsValueAliasHash.get(skuPropValueID));
			} else {
				s.append(LocalDataCache.getInstance().getTableDataColumnValue("skuPropValue", skuPropValueID, "name"));
			}
			
			if (i != (pvArray.length - 1)) {
				s.append("-");
			}
		}
		
		return s.toString();
	}
	
	public static String getVName(String tinyTypeID, String tmppid, String props, String propsAlias) {
		String vname = "";
		
		Hashtable<String, String> pid_vids = toPid_VidsHash(props);
		Hashtable<String, String> aliasHash = pvToHash(propsAlias);
		Vector<Hashtable<String, String>> properties = new Vector<Hashtable<String,String>>(); 
		try {
			Hashtable<String, String> tinyType = LocalDataCache.getInstance().getTinyType(tinyTypeID);
			String smallTypeID = "";
			if(tinyType != null && !tinyType.isEmpty()) {
				smallTypeID = tinyType.get("smallTypeID");
			}
			String bigTypeID = "";
			if(!smallTypeID.equals("")) {
				Hashtable<String, String> smallType = LocalDataCache.getInstance().getSmallType(smallTypeID);
				bigTypeID = smallType.get("bigTypeID");
			}
			properties = LocalDataCache.getInstance().getTypeProperties(bigTypeID, smallTypeID, tinyTypeID);
		} catch (Exception e) {
		}
		
		for (int i = 0; i < properties.size(); ++i) {
			Hashtable<String, String> p = properties.get(i);
			String pid = p.get("propertiesID");
			if (!pid.equals(tmppid)) {
				continue;
			}
			
			String vids = pid_vids.get(pid);
			if (vids != null && !vids.equals("")) {
	//			如果是手动输入的属性
				if (p.get("propTypeID").equals("3")) {
					vname = vids;
				} else {
					String[] vidsArray = StringUtil.split(vids, ",");
					StringBuffer vnames = new StringBuffer();
					for (int j = 0; j < vidsArray.length; ++j) {
						String vid = vidsArray[j];
						String tmpvname = "";
						if (aliasHash.get(pid + ":" + vid) != null) {
							tmpvname = aliasHash.get(pid + ":" + vid);
						} else {
							Hashtable<String, String> propertiesValue = LocalDataCache.getInstance().getProperteisValue(vid);
							tmpvname = (propertiesValue.get("name") == null ? "" : propertiesValue.get("name"));
						}
						vnames.append(j == 0 ? "" : ",").append(tmpvname);
					}
					
					vname = vnames.toString();
				}
			}
		}
		
		return vname;
	}
	
	/**
	 * 根据商品所属分类,商品的propertiesInfo以及商品的属性值别名
	 * 获取商品的所有属性,属性值
	 */
	public static Vector<Hashtable<String, String>> getProductPVNames(
			String tinyTypeID, String props, String propsAlias) {
		Vector<Hashtable<String, String>> pvNames = new Vector<Hashtable<String,String>>();
		
		Hashtable<String, String> pid_vids = toPid_VidsHash(props);
		Hashtable<String, String> aliasHash = pvToHash(propsAlias);
		Vector<Hashtable<String, String>> properties = new Vector<Hashtable<String,String>>(); 
		try {
			Hashtable<String, String> tinyType = LocalDataCache.getInstance().getTinyType(tinyTypeID);
			String smallTypeID = "";
			if(tinyType != null && !tinyType.isEmpty()) {
				smallTypeID = tinyType.get("smallTypeID");
			}
			String bigTypeID = "";
			if(!smallTypeID.equals("")) {
				Hashtable<String, String> smallType = LocalDataCache.getInstance().getSmallType(smallTypeID);
				bigTypeID = smallType.get("bigTypeID");
			}
			properties = LocalDataCache.getInstance().getTypeProperties(bigTypeID, smallTypeID, tinyTypeID);
		} catch (Exception e) {
		}
		
		for (int i = 0; i < properties.size(); ++i) {
			Hashtable<String, String> pvName = new Hashtable<String, String>();
			
			Hashtable<String, String> p = properties.get(i);
			String pid = p.get("propertiesID");
			String pname = p.get("name");
			String vids = pid_vids.get(pid);
			if (vids == null) {
//				pvName.put("pname", pname);
//				pvName.put("vnames", "");
				continue;
			} else {
	//			如果是手动输入的属性
				if (p.get("propTypeID").equals("3")) {
					pvName.put("pname", pname);
					pvName.put("vnames", vids);
				} else {
					String[] vidsArray = StringUtil.split(vids, ",");
					StringBuffer vnames = new StringBuffer();
					for (int j = 0; j < vidsArray.length; ++j) {
						String vid = vidsArray[j];
						String vname = "";
						if (aliasHash.get(pid + ":" + vid) != null) {
							vname = aliasHash.get(pid + ":" + vid);
						} else {
							Hashtable<String, String> propertiesValue = LocalDataCache.getInstance().getProperteisValue(vid);
							vname = (propertiesValue.get("name") == null ? "" : propertiesValue.get("name"));
						}
						vnames.append(j == 0 ? "" : ",").append(vname);
					}
					pvName.put("pname", pname);
					pvName.put("vnames", vnames.toString());
				}
			}
			
			pvNames.add(pvName);
		}
		
		return pvNames;
	}
	
	/**
	 * 根据商品所属分类,商品的propertiesInfo以及商品的属性值别名
	 * 获取商品的所有属性,属性值
	 */
	public static Hashtable<String, String> getProductPVNamesHash(
			String tinyTypeID, String props, String propsAlias) {
		Hashtable<String, String> hash = new Hashtable<String,String>();
		
		Vector<Hashtable<String, String>> datas = getProductPVNames(tinyTypeID, props, propsAlias);
		for (int i = 0; i < datas.size(); ++i) {
			Hashtable<String, String> data = datas.get(i);
			String pname = data.get("pname");
			String vnames = data.get("vnames");
			hash.put(pname, vnames);
		}
		
		return hash;
	}
	
	/**
	 * 将1000:10001,1000:10002,1001:10011,1001:10012 之类的属性别名转换成
	 * 1000-->10001,10002
	 * 1001-->10011,10012
	 * @param prop
	 * @return
	 */
	public static Hashtable<String, String> toPid_VidsHash(String prop) {
		Hashtable<String, String> hash = new Hashtable<String, String>();
		
		String[] vArray = StringUtil.split(prop, ",");
		for (int i = 0; i < vArray.length; ++i) {
			String[] a = StringUtil.split(vArray[i], ":");
			String pid = "";
			String vid = "";
			if (a.length == 1) {
				pid = a[0];
			} else if (a.length >= 2) {
				pid = a[0];
				vid = a[1];
			}
			if (pid.equals("")) {
				continue;
			}
			
			if (hash.get(pid) == null) {
				hash.put(pid, vid);
			} else {
				String vids = hash.get(pid) + "," + vid;
				hash.put(pid, vids);
			}
		}
		
		return hash;
	}
	
	/**
	 * 将1000:10001:大红色 之类的属性别名转换成hashtable
	 * key值为1000:10001, value为大红色
	 * @param pvString
	 * @return
	 */
	public static Hashtable<String, String> pvToHash(String pvString) {
		Hashtable<String, String> hash = new Hashtable<String, String>();
		
		String[] vArray = StringUtil.split(pvString, ",");
		for (int i = 0; i < vArray.length; ++i) {
			String[] a = StringUtil.split(vArray[i], ":");
			String key = a[0] + ":" + a[1];
			String value = "";
			if (a.length == 2) {
				value = "";
			} else if (a.length == 3) {
				value = a[2];
			}
			hash.put(key, value);
		}
		
		return hash;
	}
	
	/**
	 * 将1000:大红色 之类的属性别名转换成hashtable
	 * key值为1000, value为大红色
	 * @param pvString
	 * @return
	 */
	public static Hashtable<String, String> alias2Hash(String alias) {
		Hashtable<String, String> hash = new Hashtable<String, String>();
		
		String[] vArray = StringUtil.split(alias, ";");
		for (int i = 0; i < vArray.length; ++i) {
			String[] a = StringUtil.split(vArray[i], ",");
			hash.put(a[0], a[1]);
		}
		
		return hash;
	}
	
	public static String hashToPv(Hashtable<String, String> propHash) {
		Iterator<String> iter = propHash.keySet().iterator();
		StringBuffer s = new StringBuffer();
		while (iter.hasNext()) {
			String key = iter.next();
			s.append(",");
			s.append(key);
			s.append(":");
			s.append(propHash.get(key));
		}
		
		return s.toString().replaceFirst(",", "");
	}
	
	/**
	 * 将pid:vid,pid2:vid2转换成hashtable
	 * 其中key值为pid, value值为vid
	 * @param pid_vids
	 * @return
	 */
	public static Hashtable<String, String> pid_vidToHash(String pid_vids) {
		Hashtable<String, String> hash = new Hashtable<String, String>();
		
		String[] vArray = StringUtil.split(pid_vids, ",");
		for (int i = 0; i < vArray.length; ++i) {
			String[] a = StringUtil.split(vArray[i], ":");
			if (a.length == 0) {
				continue;
			}
			String key = a[0];
			String value = "";
			if (a.length == 2) {
				value = a[1];
			}
			hash.put(key, value);
		}
		
		return hash;
	}
//	
//	/***
//	 * 将属性ID2:属性值ID2,属性ID2:属性值ID3,属性ID5:属性值ID6,属性ID5:属性值ID7转换成如下形式
//	 * key=属性ID2 value中含有属性值ID2,属性值ID3
//	 * key=属性ID5 value中含有属性值ID6,属性值ID7
//	 * 即key为属性ID
//	 * value为该属性ID对应的属性值集合
//	 * @param props
//	 * @return
//	 */
//	public static Hashtable<String, Vector<String>> getPid_vidsHash(String props) {
//		String[] pid_vid_array = StringUtil.split(props, ",");
//		
//		Hashtable<String, Vector<String>> pid_vidsHash = new Hashtable<String, Vector<String>>();
//		for (int i = 0; i < pid_vid_array.length; ++i) {
//			String pid_vid = pid_vid_array[i];
//			String[] a_pid_vid = StringUtil.split(pid_vid, ":");
//			if (a_pid_vid.length == 2) {
//				String pid = a_pid_vid[0];
//				String vid = a_pid_vid[1];
//				if (pid_vidsHash.get(pid) == null) {
//					pid_vidsHash.put(pid, new Vector<String>());
//				}
//				Vector<String> vids = pid_vidsHash.get(pid);
//				if (!vids.contains(vid)) {
//					vids.add(vid);
//				}
//			}
//		}
//		
//		return pid_vidsHash;
//	}
//	
//	public static Vector<Hashtable<String, Object>> getPid_vids(String props) {
//		Hashtable<String, Vector<String>> pid_vidsHash = getPid_vidsHash(props);
//		
//		
//		Comparator<Hashtable<String, String>> com = new SortIndexComparator();
//		
//		Vector<Hashtable<String, String>> pids = new Vector<Hashtable<String, String>>();
//		Hashtable<String, Vector<Hashtable<String, String>>> pid_vHash = 
//			new Hashtable<String, Vector<Hashtable<String,String>>>();
//		Iterator<String> iter = pid_vidsHash.keySet().iterator();
//		while (iter.hasNext()) {
//			String pid = iter.next();
//			Hashtable<String, String> properties = LocalDataCache.getInstance().getProperties(pid);
//			if (properties.isEmpty()) {
//				continue;
//			}
//			Vector<String> vids = pid_vidsHash.get(pid);
//			Vector<Hashtable<String, String>> vidsVector = new Vector<Hashtable<String,String>>();
//			for (int i = 0; i < vids.size(); ++i) {
//				Hashtable<String, String> propertiesValue = LocalDataCache.getInstance().getProperteisValue(vids.get(i));
//				if (!propertiesValue.isEmpty()) {
//					vidsVector.add(propertiesValue);
//				}
//			}
//			Collections.sort(vidsVector, com);
//			pid_vHash.put(pid, vidsVector);
//			pids.add(properties);
//		}
//		
//		Collections.sort(pids, com);
//		
//		
//		Vector<Hashtable<String, Object>> pvsArray = new Vector<Hashtable<String,Object>>();
//		for (int i = 0; i < pids.size(); ++i) {
//			Hashtable<String, Object> tmp = new Hashtable<String, Object>();
//			tmp.put("p", pids.get(i));
//			tmp.put("vs", pid_vHash.get(pids.get(i).get("propertiesID")));
//			pvsArray.add(tmp);
//		}
//		
//		return pvsArray;
//	}
	
	public static void main(String[] args) {
		String appRoot = "E:\\Projects\\duZhanBaoWWW\\applicationRoot";
		try {
			AppLogger.getInstance().init(appRoot);
			AppConfig.getInstance().init(appRoot);

			try {
				LocalDataCache.getInstance().loadData();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		String props = ",10838:246747,10838:246677,12572:245848,12572:245305,";
		String propsAlias = "10838:246677:s别名,10838:246747:XS别名,12572:245848:白色别名,12572:245305:黄色别名";
		Vector<Hashtable<String, String>> pvNames = getProductPVNames("1000", props, propsAlias);
		for (int i = 0; i < pvNames.size(); ++i) {
			Hashtable<String, String> pvName = pvNames.get(i);
			System.out.println(pvName);
		}
	}
}
