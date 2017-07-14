package admin.customer.guanwangbao;

import java.io.Serializable;
import java.util.Hashtable;
import java.util.Vector;

public class ProductType implements Serializable {
	private Vector<Hashtable<String, String>> nodes;
	private Hashtable<String, Hashtable<String, String>> nodeHash;
	private Vector<Hashtable<String, String>> rootNodes;
	private Hashtable<String, Vector<Hashtable<String, String>>> nodeChildren;
	
	public ProductType(Vector<Hashtable<String, String>> productTypes) {
		this.nodes = productTypes;
		
		init();
	}
	
	private void init() {
		nodeHash = new Hashtable<String, Hashtable<String,String>>();
		rootNodes = new Vector<Hashtable<String,String>>();
		nodeChildren = new Hashtable<String, Vector<Hashtable<String,String>>>();
		
		for (Hashtable<String, String> data : nodes) {
			nodeHash.put(data.get("siteProductTypeID"), data);//TODO
			
			if ("0".equals(data.get("level"))) {
				rootNodes.add(data);
			} 
			if (!data.get("parentID").equals("")) {
				if (nodeChildren.get(data.get("parentID")) == null) {
					nodeChildren.put(data.get("parentID"), new Vector<Hashtable<String,String>>());
				}
				nodeChildren.get(data.get("parentID")).add(data);
			}
		}
	}
	
	public Vector<Hashtable<String, String>> getRootNodes() {
		return rootNodes;
	}
	
	public Vector<Hashtable<String, String>> getChildren(String productTypeID) {
		return nodeChildren.get(productTypeID) == null ? new Vector<Hashtable<String,String>>() : nodeChildren.get(productTypeID);
	}
	
	public Hashtable<String, String> getNode(String productTypeID) {
		return nodeHash.get(productTypeID) == null ? new Hashtable<String, String>() : nodeHash.get(productTypeID);
	}

	public Vector<Hashtable<String, String>> getNodes() {
		return nodes;
	}
	
	public boolean isEmpty() {
		return nodes.size() == 0;
	}
}
