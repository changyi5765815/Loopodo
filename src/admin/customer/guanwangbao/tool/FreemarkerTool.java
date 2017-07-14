package admin.customer.guanwangbao.tool;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.util.Hashtable;
import java.util.Map;

import freemarker.cache.TemplateLoader;

public class FreemarkerTool {
	public static String crateHTML(Map<String,Object> data, String ftlContent) throws Exception {
//		Configuration freemarkerCfg = new Configuration();
//		//加载模版
//		freemarkerCfg.setTemplateLoader(new StringTemplateLoader(ftlContent));
//		freemarkerCfg.setDefaultEncoding("UTF-8");
//		Template template = freemarkerCfg.getTemplate("");
//		StringWriter stringWriter = new StringWriter();  
//		BufferedWriter writer = new BufferedWriter(stringWriter);  
//		template.setEncoding("UTF-8");  
//		template.process(data, writer);  
//		writer.flush();  
//		writer.close();
//		return stringWriter.getBuffer().toString();
		
		return "";
	}
	
	public static void main(String[] args) throws Exception {
		Map<String,Object> data = new Hashtable<String, Object>();
		Hashtable<String, String> product = new Hashtable<String, String>();
		product.put("productID", "1000");
		data.put("item", product);
		String ftlContent = "<a href=\"/product/${item.productID}.html\" title=\"${item.info}\" class=\"grey\">";
		System.out.println(crateHTML(data, ftlContent));
	}
}

class StringTemplateLoader implements TemplateLoader {  
	  
    private String template;  
      
    public StringTemplateLoader(String template){  
        this.template = template;  
        if(template == null){  
            this.template = "";  
        }  
    }  
      
    public void closeTemplateSource(Object templateSource) throws IOException {  
        ((StringReader) templateSource).close();  
    }  
  
    public Object findTemplateSource(String name) throws IOException {  
        return new StringReader(template);  
    }  
  
    public long getLastModified(Object templateSource) {  
        return 0;  
    }  
  
    public Reader getReader(Object templateSource, String encoding)  
            throws IOException {  
        return (Reader) templateSource;  
    }  
  
}  