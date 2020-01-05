package org.apache.hadoop.hbase.generated.master;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import static org.apache.commons.lang.StringEscapeUtils.escapeXml;
import java.net.URLEncoder;
import java.util.TreeMap;
import java.util.Map;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.Admin;
import org.apache.hadoop.hbase.client.HConnectionManager;
import org.apache.hadoop.hbase.HRegionInfo;
import org.apache.hadoop.hbase.ServerName;
import org.apache.hadoop.hbase.ServerLoad;
import org.apache.hadoop.hbase.RegionLoad;
import org.apache.hadoop.hbase.HConstants;
import org.apache.hadoop.hbase.master.HMaster;
import org.apache.hadoop.hbase.zookeeper.MetaTableLocator;
import org.apache.hadoop.hbase.util.Bytes;
import org.apache.hadoop.hbase.util.FSUtils;
import org.apache.hadoop.hbase.regionserver.compactions.CompactionRequest;
import org.apache.hadoop.hbase.protobuf.generated.AdminProtos.GetRegionInfoResponse.CompactionState;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.RegionReplicaUtil;
import org.apache.hadoop.hbase.HBaseConfiguration;

public final class table_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.Vector _jspx_dependants;

  private org.apache.jasper.runtime.ResourceInjector _jspx_resourceInjector;

  public Object getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.apache.jasper.runtime.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write('\n');
      out.write('\n');

  HMaster master = (HMaster)getServletContext().getAttribute(HMaster.MASTER);
  Configuration conf = master.getConfiguration();
  MetaTableLocator metaTableLocator = new MetaTableLocator();
  String fqtn = request.getParameter("name");
  final String escaped_fqtn = StringEscapeUtils.escapeHtml(fqtn);
  HTable table = null;
  String tableHeader;
  boolean withReplica = false;
  ServerName rl = metaTableLocator.getMetaRegionLocation(master.getZooKeeper());
  boolean showFragmentation = conf.getBoolean("hbase.master.ui.fragmentation.enabled", false);
  boolean readOnly = conf.getBoolean("hbase.master.ui.readonly", false);
  int numMetaReplicas = conf.getInt(HConstants.META_REPLICAS_NUM,
                        HConstants.DEFAULT_META_REPLICA_NUM);
  Map<String, Integer> frags = null;
  if (showFragmentation) {
      frags = FSUtils.getTableFragmentation(master);
  }
  String action = request.getParameter("action");
  String key = request.getParameter("key");

      out.write("\n<!--[if IE]>\n<!DOCTYPE html>\n<![endif]-->\n<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n<html xmlns=\"http://www.w3.org/1999/xhtml\">\n  <head>\n    <meta charset=\"utf-8\">\n    ");
 if ( !readOnly && action != null ) { 
      out.write("\n        <title>HBase Master: ");
      out.print( StringEscapeUtils.escapeHtml(master.getServerName().toString()) );
      out.write("</title>\n    ");
 } else { 
      out.write("\n        <title>Table: ");
      out.print( escaped_fqtn );
      out.write("</title>\n    ");
 } 
      out.write("\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n    <meta name=\"description\" content=\"\">\n    <meta name=\"author\" content=\"\">\n\n\n      <link href=\"/static/css/bootstrap.min.css\" rel=\"stylesheet\">\n      <link href=\"/static/css/bootstrap-theme.min.css\" rel=\"stylesheet\">\n      <link href=\"/static/css/hbase.css\" rel=\"stylesheet\">\n      ");
 if ( ( !readOnly && action != null ) || fqtn == null ) { 
      out.write("\n\t  <script type=\"text/javascript\">\n      <!--\n\t\t  setTimeout(\"history.back()\",5000);\n\t  -->\n\t  </script>\n      ");
 } else { 
      out.write("\n      <!--[if lt IE 9]>\n          <script src=\"/static/js/html5shiv.js\"></script>\n      <![endif]-->\n      ");
 } 
      out.write("\n</head>\n<body>\n<div class=\"navbar  navbar-fixed-top navbar-default\">\n    <div class=\"container\">\n        <div class=\"navbar-header\">\n            <button type=\"button\" class=\"navbar-toggle\" data-toggle=\"collapse\" data-target=\".navbar-collapse\">\n                <span class=\"icon-bar\"></span>\n                <span class=\"icon-bar\"></span>\n                <span class=\"icon-bar\"></span>\n            </button>\n            <a class=\"navbar-brand\" href=\"/master-status\"><img src=\"/static/hbase_logo_small.png\" alt=\"HBase Logo\"/></a>\n        </div>\n        <div class=\"collapse navbar-collapse\">\n            <ul class=\"nav navbar-nav\">\n                <li><a href=\"/master-status\">Home</a></li>\n                <li><a href=\"/tablesDetailed.jsp\">Table Details</a></li>\n                <li><a href=\"/logs/\">Local Logs</a></li>\n                <li><a href=\"/logLevel\">Log Level</a></li>\n                <li><a href=\"/dump\">Debug Dump</a></li>\n                <li><a href=\"/jmx\">Metrics Dump</a></li>\n                ");
 if (HBaseConfiguration.isShowConfInServlet()) { 
      out.write("\n                <li><a href=\"/conf\">HBase Configuration</a></li>\n                ");
 } 
      out.write("\n            </ul>\n        </div><!--/.nav-collapse -->\n    </div>\n</div>\n");
 
if ( fqtn != null ) {
  table = new HTable(conf, fqtn);
  if (table.getTableDescriptor().getRegionReplication() > 1) {
    tableHeader = "<h2>Table Regions</h2><table class=\"table table-striped\" style=\"table-layout: fixed; word-wrap: break-word;\"><tr><th style=\"width:22%\">Name</th><th>Region Server</th><th style=\"width:22%\">Start Key</th><th style=\"width:22%\">End Key</th><th>Locality</th><th>Requests</th><th>ReplicaID</th></tr>";
    withReplica = true;
  } else {
    tableHeader = "<h2>Table Regions</h2><table class=\"table table-striped\" style=\"table-layout: fixed; word-wrap: break-word;\"><tr><th style=\"width:22%\">Name</th><th>Region Server</th><th style=\"width:22%\">Start Key</th><th style=\"width:22%\">End Key</th><th>Locality</th><th>Requests</th></tr>";
  }
  if ( !readOnly && action != null ) { 

      out.write("\n<div class=\"container\">\n\n\n        <div class=\"row inner_header\">\n            <div class=\"page-header\">\n                <h1>Table action request accepted</h1>\n            </div>\n        </div>\n<p><hr><p>\n");

  try (Admin admin = master.getConnection().getAdmin()) {
    if (action.equals("split")) {
      if (key != null && key.length() > 0) {
        admin.splitRegion(Bytes.toBytes(key));
      } else {
        admin.split(TableName.valueOf(fqtn));
      }
    
    
      out.write(" Split request accepted. ");

    } else if (action.equals("compact")) {
      if (key != null && key.length() > 0) {
        admin.compactRegion(Bytes.toBytes(key));
      } else {
        admin.compact(TableName.valueOf(fqtn));
      }
    
      out.write(" Compact request accepted. ");

    }
  }

      out.write("\n<p>Go <a href=\"javascript:history.back()\">Back</a>, or wait for the redirect.\n</div>\n");

  } else {

      out.write("\n<div class=\"container\">\n\n\n\n    <div class=\"row inner_header\">\n        <div class=\"page-header\">\n            <h1>Table <small>");
      out.print( escaped_fqtn );
      out.write("</small></h1>\n        </div>\n    </div>\n    <div class=\"row\">\n");

  if(fqtn.equals(TableName.META_TABLE_NAME.getNameAsString())) {

      out.write('\n');
      out.print( tableHeader );
      out.write('\n');

  // NOTE: Presumes meta with one or more replicas
  for (int j = 0; j < numMetaReplicas; j++) {
    HRegionInfo meta = RegionReplicaUtil.getRegionInfoForReplica(
                            HRegionInfo.FIRST_META_REGIONINFO, j);
    ServerName metaLocation = metaTableLocator.waitMetaRegionLocation(master.getZooKeeper(), j, 1);
    for (int i = 0; i < 1; i++) {
      // The host name portion should be safe, but I don't know how we handle IDNs so err on the side of failing safely.
      String url = "//" + URLEncoder.encode(metaLocation.getHostname()) + ":" +
                   master.getRegionServerInfoPort(metaLocation) + "/";

      out.write("\n<tr>\n  <td>");
      out.print( escapeXml(meta.getRegionNameAsString()) );
      out.write("</td>\n    <td><a href=\"");
      out.print( url );
      out.write('"');
      out.write('>');
      out.print( StringEscapeUtils.escapeHtml(metaLocation.getHostname().toString()) + ":" + master.getRegionServerInfoPort(metaLocation) );
      out.write("</a></td>\n    <td>");
      out.print( escapeXml(Bytes.toString(meta.getStartKey())) );
      out.write("</td>\n    <td>");
      out.print( escapeXml(Bytes.toString(meta.getEndKey())) );
      out.write("</td>\n    <td>-</td>\n    <td>-</td>\n</tr>\n");
  } 
      out.write('\n');
} 
      out.write("\n</table>\n");
} else {
  Admin admin = master.getConnection().getAdmin();
  try { 
      out.write("\n<h2>Table Attributes</h2>\n<table class=\"table table-striped\">\n  <tr>\n      <th>Attribute Name</th>\n      <th>Value</th>\n      <th>Description</th>\n  </tr>\n  <tr>\n      <td>Enabled</td>\n      <td>");
      out.print( admin.isTableEnabled(table.getName()) );
      out.write("</td>\n      <td>Is the table enabled</td>\n  </tr>\n  <tr>\n      <td>Compaction</td>\n      <td>\n");

  try {
    CompactionState compactionState = admin.getCompactionState(table.getName());

      out.write('\n');
      out.print( compactionState );
      out.write('\n');

  } catch (Exception e) {
    // Nothing really to do here
    for(StackTraceElement element : e.getStackTrace()) {
      
      out.print( StringEscapeUtils.escapeHtml(element.toString()) );

    }

      out.write(" Unknown ");

  }

      out.write("\n      </td>\n      <td>Is the table compacting</td>\n  </tr>\n");
  if (showFragmentation) { 
      out.write("\n  <tr>\n      <td>Fragmentation</td>\n      <td>");
      out.print( frags.get(fqtn) != null ? frags.get(fqtn).intValue() + "%" : "n/a" );
      out.write("</td>\n      <td>How fragmented is the table. After a major compaction it is 0%.</td>\n  </tr>\n");
  } 
      out.write("\n</table>\n");

  Map<ServerName, Integer> regDistribution = new TreeMap<ServerName, Integer>();
  Map<HRegionInfo, ServerName> regions = table.getRegionLocations();
  if(regions != null && regions.size() > 0) { 
      out.write('\n');
      out.print(     tableHeader );
      out.write('\n');

  for (Map.Entry<HRegionInfo, ServerName> hriEntry : regions.entrySet()) {
    HRegionInfo regionInfo = hriEntry.getKey();
    ServerName addr = hriEntry.getValue();
    long req = 0;
    float locality = 0.0f;

    if (addr != null) {
      ServerLoad sl = master.getServerManager().getLoad(addr);
      if (sl != null) {
        Map<byte[], RegionLoad> map = sl.getRegionsLoad();
        if (map.containsKey(regionInfo.getRegionName())) {
          req = map.get(regionInfo.getRegionName()).getRequestsCount();
          locality = map.get(regionInfo.getRegionName()).getDataLocality();
        }
        Integer i = regDistribution.get(addr);
        if (null == i) i = Integer.valueOf(0);
        regDistribution.put(addr, i + 1);
      }
    }

      out.write("\n<tr>\n  <td>");
      out.print( escapeXml(Bytes.toStringBinary(regionInfo.getRegionName())) );
      out.write("</td>\n  ");

  if (addr != null) {
    String url = "//" + URLEncoder.encode(addr.getHostname()) + ":" + master.getRegionServerInfoPort(addr) + "/rs-status";
  
      out.write("\n  <td>\n     <a href=\"");
      out.print( url );
      out.write('"');
      out.write('>');
      out.print( StringEscapeUtils.escapeHtml(addr.getHostname().toString()) + ":" + master.getRegionServerInfoPort(addr) );
      out.write("</a>\n  </td>\n  ");

  } else {
  
      out.write("\n  <td class=\"undeployed-region\">not deployed</td>\n  ");

  }
  
      out.write("\n  <td>");
      out.print( escapeXml(Bytes.toStringBinary(regionInfo.getStartKey())) );
      out.write("</td>\n  <td>");
      out.print( escapeXml(Bytes.toStringBinary(regionInfo.getEndKey())) );
      out.write("</td>\n  <td>");
      out.print( locality);
      out.write("</td>\n  <td>");
      out.print( req);
      out.write("</td>\n  ");

  if (withReplica) {
  
      out.write("\n  <td>");
      out.print( regionInfo.getReplicaId() );
      out.write("</td>\n  ");

  }
  
      out.write("\n</tr>\n");
 } 
      out.write("\n</table>\n<h2>Regions by Region Server</h2>\n<table class=\"table table-striped\"><tr><th>Region Server</th><th>Region Count</th></tr>\n");

  for (Map.Entry<ServerName, Integer> rdEntry : regDistribution.entrySet()) {
     ServerName addr = rdEntry.getKey();
     String url = "//" + URLEncoder.encode(addr.getHostname()) + ":" + master.getRegionServerInfoPort(addr) + "/rs-status";

      out.write("\n<tr>\n  <td><a href=\"");
      out.print( url );
      out.write('"');
      out.write('>');
      out.print( StringEscapeUtils.escapeHtml(addr.getHostname().toString()) + ":" + master.getRegionServerInfoPort(addr) );
      out.write("</a></td>\n  <td>");
      out.print( rdEntry.getValue());
      out.write("</td>\n</tr>\n");
 } 
      out.write("\n</table>\n");
 }
} catch(Exception ex) {
  for(StackTraceElement element : ex.getStackTrace()) {
    
      out.print( StringEscapeUtils.escapeHtml(element.toString()) );

  }
} finally {
  admin.close();
}
} // end else

      out.write("\n\n\n");
 if (!readOnly) { 
      out.write("\n<p><hr/></p>\nActions:\n<p>\n<center>\n<table class=\"table\" width=\"95%\" >\n<tr>\n  <form method=\"get\">\n  <input type=\"hidden\" name=\"action\" value=\"compact\">\n  <input type=\"hidden\" name=\"name\" value=\"");
      out.print( escaped_fqtn );
      out.write("\">\n  <td style=\"border-style: none; text-align: center\">\n      <input style=\"font-size: 12pt; width: 10em\" type=\"submit\" value=\"Compact\" class=\"btn\"></td>\n  <td style=\"border-style: none\" width=\"5%\">&nbsp;</td>\n  <td style=\"border-style: none\">Region Key (optional):<input type=\"text\" name=\"key\" size=\"40\"></td>\n  <td style=\"border-style: none\">This action will force a compaction of all\n  regions of the table, or, if a key is supplied, only the region containing the\n  given key.</td>\n  </form>\n</tr>\n<tr><td style=\"border-style: none\" colspan=\"4\">&nbsp;</td></tr>\n<tr>\n  <form method=\"get\">\n  <input type=\"hidden\" name=\"action\" value=\"split\">\n  <input type=\"hidden\" name=\"name\" value=\"");
      out.print( escaped_fqtn );
      out.write("\">\n  <td style=\"border-style: none; text-align: center\">\n      <input style=\"font-size: 12pt; width: 10em\" type=\"submit\" value=\"Split\" class=\"btn\"></td>\n  <td style=\"border-style: none\" width=\"5%\">&nbsp;</td>\n  <td style=\"border-style: none\">Region Key (optional):<input type=\"text\" name=\"key\" size=\"40\"></td>\n  <td style=\"border-style: none\">This action will force a split of all eligible\n  regions of the table, or, if a key is supplied, only the region containing the\n  given key. An eligible region is one that does not contain any references to\n  other regions. Split requests for noneligible regions will be ignored.</td>\n  </form>\n</tr>\n</table>\n</center>\n</p>\n");
 } 
      out.write("\n</div>\n</div>\n");
 }
} else { // handle the case for fqtn is null with error message + redirect

      out.write("\n<div class=\"container\">\n    <div class=\"row inner_header\">\n        <div class=\"page-header\">\n            <h1>Table not ready</h1>\n        </div>\n    </div>\n<p><hr><p>\n<p>Go <a href=\"javascript:history.back()\">Back</a>, or wait for the redirect.\n</div>\n");
 } 
      out.write("\n<script src=\"/static/js/jquery.min.js\" type=\"text/javascript\"></script>\n<script src=\"/static/js/bootstrap.min.js\" type=\"text/javascript\"></script>\n\n</body>\n</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
