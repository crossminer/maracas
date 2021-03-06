// Autogenerated Jamon implementation
// /home/ali-hbase-1.1.3/alihbase-server/src/main/jamon/org/apache/hadoop/hbase/tmpl/master/RegionServerListTmpl.jamon

package org.apache.hadoop.hbase.tmpl.master;

// 27, 9
import java.util.*;
// 28, 9
import org.apache.hadoop.util.StringUtils;
// 29, 9
import org.apache.hadoop.hbase.util.Bytes;
// 30, 9
import org.apache.hadoop.hbase.util.JvmVersion;
// 31, 9
import org.apache.hadoop.hbase.util.FSUtils;
// 32, 9
import org.apache.hadoop.hbase.master.HMaster;
// 33, 9
import org.apache.hadoop.hbase.HConstants;
// 34, 9
import org.apache.hadoop.hbase.ServerLoad;
// 35, 9
import org.apache.hadoop.hbase.ServerName;
// 36, 9
import org.apache.hadoop.hbase.client.HBaseAdmin;
// 37, 9
import org.apache.hadoop.hbase.client.HConnectionManager;
// 38, 9
import org.apache.hadoop.hbase.HTableDescriptor;
// 39, 9
import org.apache.hadoop.hbase.HBaseConfiguration;

public class RegionServerListTmplImpl
  extends org.jamon.AbstractTemplateImpl
  implements org.apache.hadoop.hbase.tmpl.master.RegionServerListTmpl.Intf

{
  private final HMaster master;
  private final List<ServerName> servers;
  protected static org.apache.hadoop.hbase.tmpl.master.RegionServerListTmpl.ImplData __jamon_setOptionalArguments(org.apache.hadoop.hbase.tmpl.master.RegionServerListTmpl.ImplData p_implData)
  {
    if(! p_implData.getServers__IsNotDefault())
    {
      p_implData.setServers(null);
    }
    return p_implData;
  }
  public RegionServerListTmplImpl(org.jamon.TemplateManager p_templateManager, org.apache.hadoop.hbase.tmpl.master.RegionServerListTmpl.ImplData p_implData)
  {
    super(p_templateManager, __jamon_setOptionalArguments(p_implData));
    master = p_implData.getMaster();
    servers = p_implData.getServers();
  }
  
  public void renderNoFlush(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter)
    throws java.io.IOException
  {
    // 43, 1
    if ((servers != null && servers.size() > 0))
    {
      // 43, 47
      jamonWriter.write("\n\n");
      // 45, 1
      
ServerName [] serverNames = servers.toArray(new ServerName[servers.size()]);
Arrays.sort(serverNames);

      // 50, 1
      jamonWriter.write("<div class=\"tabbable\">\n    <ul class=\"nav nav-pills\">\n        <li class=\"active\"><a href=\"#tab_baseStats\" data-toggle=\"tab\">Base Stats</a></li>\n        <li class=\"\"><a href=\"#tab_memoryStats\" data-toggle=\"tab\">Memory</a></li>\n        <li class=\"\"><a href=\"#tab_requestStats\" data-toggle=\"tab\">Requests</a></li>\n        <li class=\"\"><a href=\"#tab_storeStats\" data-toggle=\"tab\">Storefiles</a></li>\n        <li class=\"\"><a href=\"#tab_compactStas\" data-toggle=\"tab\">Compactions</a></li>\n    </ul>\n    <div class=\"tab-content\" style=\"padding-bottom: 9px; border-bottom: 1px solid #ddd;\">\n        <div class=\"tab-pane active\" id=\"tab_baseStats\">\n            ");
      // 60, 13
      {
        // 60, 13
        __jamon_innerUnit__baseStats(jamonWriter, serverNames);
      }
      // 60, 56
      jamonWriter.write("\n        </div>\n        <div class=\"tab-pane\" id=\"tab_memoryStats\">\n            ");
      // 63, 13
      {
        // 63, 13
        __jamon_innerUnit__memoryStats(jamonWriter, serverNames);
      }
      // 63, 58
      jamonWriter.write("\n        </div>\n        <div class=\"tab-pane\" id=\"tab_requestStats\">\n            ");
      // 66, 13
      {
        // 66, 13
        __jamon_innerUnit__requestStats(jamonWriter, serverNames);
      }
      // 66, 59
      jamonWriter.write("\n        </div>\n        <div class=\"tab-pane\" id=\"tab_storeStats\">\n            ");
      // 69, 13
      {
        // 69, 13
        __jamon_innerUnit__storeStats(jamonWriter, serverNames);
      }
      // 69, 57
      jamonWriter.write("\n        </div>\n        <div class=\"tab-pane\" id=\"tab_compactStas\">\n            ");
      // 72, 13
      {
        // 72, 13
        __jamon_innerUnit__compactionStats(jamonWriter, serverNames);
      }
      // 72, 62
      jamonWriter.write("\n        </div>\n    </div>\n</div>\n\n");
    }
    // 77, 7
    jamonWriter.write("\n\n");
  }
  
  
  // 162, 1
  private void __jamon_innerUnit__requestStats(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter, final ServerName[] serverNames)
    throws java.io.IOException
  {
    // 166, 1
    jamonWriter.write("<table class=\"table table-striped\">\n<tr>\n    <th>ServerName</th>\n    <th>Request Per Second</th>\n    <th>Read Request Count</th>\n    <th>Write Request Count</th>\n</tr>\n");
    // 173, 1
    
for (ServerName serverName: serverNames) {

ServerLoad sl = master.getServerManager().getLoad(serverName);
if (sl != null) {

    // 179, 1
    jamonWriter.write("<tr>\n<td>");
    // 180, 5
    {
      // 180, 5
      __jamon_innerUnit__serverNameLink(jamonWriter, serverName, sl);
    }
    // 180, 66
    jamonWriter.write("</td>\n<td>");
    // 181, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(String.format("%.0f", sl.getRequestsPerSecond())), jamonWriter);
    // 181, 59
    jamonWriter.write("</td>\n<td>");
    // 182, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getReadRequestsCount()), jamonWriter);
    // 182, 36
    jamonWriter.write("</td>\n<td>");
    // 183, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getWriteRequestsCount()), jamonWriter);
    // 183, 37
    jamonWriter.write("</td>\n</tr>\n");
    // 185, 1
    
        }  else {
        
    // 188, 1
    {
      // 188, 1
      __jamon_innerUnit__emptyStat(jamonWriter, serverName);
    }
    // 188, 40
    jamonWriter.write("\n");
    // 189, 1
    
        }
}

    // 193, 1
    jamonWriter.write("</table>\n");
  }
  
  
  // 296, 1
  private void __jamon_innerUnit__emptyStat(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter, final ServerName serverName)
    throws java.io.IOException
  {
    // 300, 5
    jamonWriter.write("<tr>\n    <td>");
    // 301, 9
    {
      // 301, 9
      __jamon_innerUnit__serverNameLink(jamonWriter, serverName, null);
    }
    // 301, 72
    jamonWriter.write("</td>\n    <td></td>\n    <td></td>\n    <td></td>\n    <td></td>\n    <td></td>\n    <td></td>\n    </tr>\n");
  }
  
  
  // 279, 1
  private void __jamon_innerUnit__serverNameLink(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter, final ServerName serverName, final ServerLoad serverLoad)
    throws java.io.IOException
  {
    // 284, 9
    
        int infoPort = master.getRegionServerInfoPort(serverName);
        String url = "//" + serverName.getHostname() + ":" + infoPort + "/rs-status";
        
    // 289, 9
    if ((infoPort > 0) )
    {
      // 289, 31
      jamonWriter.write("\n            <a href=\"");
      // 290, 22
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(url), jamonWriter);
      // 290, 31
      jamonWriter.write("\">");
      // 290, 33
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(serverName.getServerName()), jamonWriter);
      // 290, 65
      jamonWriter.write("</a>\n        ");
    }
    // 291, 9
    else
    {
      // 291, 16
      jamonWriter.write("\n            ");
      // 292, 13
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(serverName.getServerName()), jamonWriter);
      // 292, 45
      jamonWriter.write("\n        ");
    }
    // 293, 15
    jamonWriter.write("\n");
  }
  
  
  // 125, 1
  private void __jamon_innerUnit__memoryStats(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter, final ServerName[] serverNames)
    throws java.io.IOException
  {
    // 129, 1
    jamonWriter.write("<table class=\"table table-striped\">\n<tr>\n    <th>ServerName</th>\n    <th>Used Heap</th>\n    <th>Max Heap</th>\n    <th>Memstore Size</th>\n\n</tr>\n");
    // 137, 1
    
for (ServerName serverName: serverNames) {

    ServerLoad sl = master.getServerManager().getLoad(serverName);
    if (sl != null) {

    // 143, 1
    jamonWriter.write("<tr>\n    <td>");
    // 144, 9
    {
      // 144, 9
      __jamon_innerUnit__serverNameLink(jamonWriter, serverName, sl);
    }
    // 144, 70
    jamonWriter.write("</td>\n    <td>");
    // 145, 9
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getUsedHeapMB()), jamonWriter);
    // 145, 33
    jamonWriter.write("m</td>\n    <td>");
    // 146, 9
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getMaxHeapMB()), jamonWriter);
    // 146, 32
    jamonWriter.write("m</td>\n    <td>");
    // 147, 9
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getMemstoreSizeInMB()), jamonWriter);
    // 147, 39
    jamonWriter.write("m</td>\n\n</tr>\n");
    // 150, 1
    
        }  else {

    // 153, 1
    {
      // 153, 1
      __jamon_innerUnit__emptyStat(jamonWriter, serverName);
    }
    // 153, 40
    jamonWriter.write("\n");
    // 154, 1
    
        }
}

    // 158, 1
    jamonWriter.write("</table>\n");
  }
  
  
  // 79, 1
  private void __jamon_innerUnit__baseStats(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter, final ServerName[] serverNames)
    throws java.io.IOException
  {
    // 83, 1
    jamonWriter.write("<table class=\"table table-striped\">\n<tr>\n    <th>ServerName</th>\n    <th>Start time</th>\n    <th>Requests Per Second</th>\n    <th>Num. Regions</th>\n</tr>\n");
    // 90, 1
    
    int totalRegions = 0;
    int totalRequests = 0;
    for (ServerName serverName: serverNames) {

    ServerLoad sl = master.getServerManager().getLoad(serverName);
    double requestsPerSecond = 0.0;
    int numRegionsOnline = 0;

    if (sl != null) {
        requestsPerSecond = sl.getRequestsPerSecond();
        numRegionsOnline = sl.getNumberOfRegions();
        totalRegions += sl.getNumberOfRegions();
        // Is this correct?  Adding a rate to a measure.
        totalRequests += sl.getNumberOfRequests();
    }
    long startcode = serverName.getStartcode();

    // 108, 1
    jamonWriter.write("<tr>\n    <td>");
    // 109, 9
    {
      // 109, 9
      __jamon_innerUnit__serverNameLink(jamonWriter, serverName, sl);
    }
    // 109, 70
    jamonWriter.write("</td>\n    <td>");
    // 110, 9
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(new Date(startcode)), jamonWriter);
    // 110, 34
    jamonWriter.write("</td>\n    <td>");
    // 111, 9
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(String.format("%.0f", requestsPerSecond)), jamonWriter);
    // 111, 55
    jamonWriter.write("</td>\n    <td>");
    // 112, 9
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(numRegionsOnline), jamonWriter);
    // 112, 31
    jamonWriter.write("</td>\n</tr>\n");
    // 114, 1
    
}

    // 117, 1
    jamonWriter.write("<tr><td>Total:");
    // 117, 15
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(servers.size()), jamonWriter);
    // 117, 35
    jamonWriter.write("</td>\n<td></td>\n<td>");
    // 119, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(totalRequests), jamonWriter);
    // 119, 24
    jamonWriter.write("</td>\n<td>");
    // 120, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(totalRegions), jamonWriter);
    // 120, 23
    jamonWriter.write("</td>\n</tr>\n</table>\n");
  }
  
  
  // 237, 1
  private void __jamon_innerUnit__compactionStats(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter, final ServerName[] serverNames)
    throws java.io.IOException
  {
    // 241, 1
    jamonWriter.write("<table class=\"table table-striped\">\n<tr>\n    <th>ServerName</th>\n    <th>Num. Compacting KVs</th>\n    <th>Num. Compacted KVs</th>\n    <th>Remaining KVs</th>\n    <th>Compaction Progress</th>\n</tr>\n");
    // 249, 1
    
for (ServerName serverName: serverNames) {

ServerLoad sl = master.getServerManager().getLoad(serverName);
if (sl != null) {
String percentDone = "";
if  (sl.getTotalCompactingKVs() > 0) {
     percentDone = String.format("%.2f", 100 *
        ((float) sl.getCurrentCompactedKVs() / sl.getTotalCompactingKVs())) + "%";
}

    // 260, 1
    jamonWriter.write("<tr>\n<td>");
    // 261, 5
    {
      // 261, 5
      __jamon_innerUnit__serverNameLink(jamonWriter, serverName, sl);
    }
    // 261, 66
    jamonWriter.write("</td>\n<td>");
    // 262, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getTotalCompactingKVs()), jamonWriter);
    // 262, 37
    jamonWriter.write("</td>\n<td>");
    // 263, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getCurrentCompactedKVs()), jamonWriter);
    // 263, 38
    jamonWriter.write("</td>\n<td>");
    // 264, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getTotalCompactingKVs() - sl.getCurrentCompactedKVs()), jamonWriter);
    // 264, 67
    jamonWriter.write("</td>\n<td>");
    // 265, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(percentDone), jamonWriter);
    // 265, 22
    jamonWriter.write("</td>\n</tr>\n");
    // 267, 1
    
        }  else {
        
    // 270, 1
    {
      // 270, 1
      __jamon_innerUnit__emptyStat(jamonWriter, serverName);
    }
    // 270, 40
    jamonWriter.write("\n");
    // 271, 1
    
    }
}

    // 275, 1
    jamonWriter.write("</table>\n");
  }
  
  
  // 197, 1
  private void __jamon_innerUnit__storeStats(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter, final ServerName[] serverNames)
    throws java.io.IOException
  {
    // 201, 1
    jamonWriter.write("<table class=\"table table-striped\">\n<tr>\n    <th>ServerName</th>\n    <th>Num. Stores</th>\n    <th>Num. Storefiles</th>\n    <th>Storefile Size Uncompressed</th>\n    <th>Storefile Size</th>\n    <th>Index Size</th>\n    <th>Bloom Size</th>\n</tr>\n");
    // 211, 1
    
for (ServerName serverName: serverNames) {

ServerLoad sl = master.getServerManager().getLoad(serverName);
if (sl != null) {

    // 217, 1
    jamonWriter.write("<tr>\n<td>");
    // 218, 5
    {
      // 218, 5
      __jamon_innerUnit__serverNameLink(jamonWriter, serverName, sl);
    }
    // 218, 66
    jamonWriter.write("</td>\n<td>");
    // 219, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getStores()), jamonWriter);
    // 219, 25
    jamonWriter.write("</td>\n<td>");
    // 220, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getStorefiles()), jamonWriter);
    // 220, 29
    jamonWriter.write("</td>\n<td>");
    // 221, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getStoreUncompressedSizeMB()), jamonWriter);
    // 221, 42
    jamonWriter.write("m</td>\n<td>");
    // 222, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getStorefileSizeInMB()), jamonWriter);
    // 222, 36
    jamonWriter.write("mb</td>\n<td>");
    // 223, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getTotalStaticIndexSizeKB()), jamonWriter);
    // 223, 41
    jamonWriter.write("k</td>\n<td>");
    // 224, 5
    org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(sl.getTotalStaticBloomSizeKB()), jamonWriter);
    // 224, 41
    jamonWriter.write("k</td>\n</tr>\n");
    // 226, 1
    
        }  else {
        
    // 229, 1
    {
      // 229, 1
      __jamon_innerUnit__emptyStat(jamonWriter, serverName);
    }
    // 229, 40
    jamonWriter.write("\n");
    // 230, 1
    
    }
}

    // 234, 1
    jamonWriter.write("</table>\n");
  }
  
  
}
