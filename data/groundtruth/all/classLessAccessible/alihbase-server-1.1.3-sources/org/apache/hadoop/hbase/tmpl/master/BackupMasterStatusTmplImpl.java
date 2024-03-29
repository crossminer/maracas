// Autogenerated Jamon implementation
// /home/ali-hbase-1.1.3/alihbase-server/src/main/jamon/org/apache/hadoop/hbase/tmpl/master/BackupMasterStatusTmpl.jamon

package org.apache.hadoop.hbase.tmpl.master;

// 23, 1
import java.util.*;
// 24, 1
import org.apache.hadoop.hbase.ServerName;
// 25, 1
import org.apache.hadoop.hbase.ClusterStatus;
// 26, 1
import org.apache.hadoop.hbase.master.HMaster;
// 27, 1
import org.apache.hadoop.hbase.zookeeper.MasterAddressTracker;

public class BackupMasterStatusTmplImpl
  extends org.jamon.AbstractTemplateImpl
  implements org.apache.hadoop.hbase.tmpl.master.BackupMasterStatusTmpl.Intf

{
  private final HMaster master;
  protected static org.apache.hadoop.hbase.tmpl.master.BackupMasterStatusTmpl.ImplData __jamon_setOptionalArguments(org.apache.hadoop.hbase.tmpl.master.BackupMasterStatusTmpl.ImplData p_implData)
  {
    return p_implData;
  }
  public BackupMasterStatusTmplImpl(org.jamon.TemplateManager p_templateManager, org.apache.hadoop.hbase.tmpl.master.BackupMasterStatusTmpl.ImplData p_implData)
  {
    super(p_templateManager, __jamon_setOptionalArguments(p_implData));
    master = p_implData.getMaster();
  }
  
  public void renderNoFlush(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter)
    throws java.io.IOException
  {
    // 29, 1
    
Collection<ServerName> masters = null;
MasterAddressTracker masterAddressTracker = master.getMasterAddressTracker();
if (master.isActiveMaster()) {
  ClusterStatus status = master.getClusterStatus();
  masters = status.getBackupMasters();
} else{
  ServerName sn = masterAddressTracker == null ? null
    : masterAddressTracker.getMasterAddress();
  assert sn != null : "Failed to retreive master's ServerName!";
  masters = Collections.singletonList(sn);
}

    // 43, 1
    
ServerName [] serverNames = masters.toArray(new ServerName[masters.size()]);
int infoPort = masterAddressTracker == null ? 0 : masterAddressTracker.getMasterInfoPort();

    // 47, 1
    if ((!master.isActiveMaster()) )
    {
      // 47, 35
      jamonWriter.write("\n    ");
      // 48, 5
      if (serverNames[0] != null )
      {
        // 48, 35
        jamonWriter.write("\n        <h2>Master</h2>\n        <a href=\"//");
        // 50, 20
        org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(serverNames[0].getHostname()), jamonWriter);
        // 50, 54
        jamonWriter.write(":");
        // 50, 55
        org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(infoPort), jamonWriter);
        // 51, 22
        jamonWriter.write("/master-status\" target=\"_blank\">");
        // 51, 54
        org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(serverNames[0].getHostname()), jamonWriter);
        // 52, 42
        jamonWriter.write("</a>\n    ");
      }
      // 53, 5
      else
      {
        // 53, 12
        jamonWriter.write("\n        Unable to parse master hostname.\n    ");
      }
      // 55, 11
      jamonWriter.write("\n");
    }
    // 56, 1
    else
    {
      // 56, 8
      jamonWriter.write("\n    <h2>Backup Masters</h2>\n\n    <table class=\"table table-striped\">\n    <tr>\n        <th>ServerName</th>\n        <th>Port</th>\n        <th>Start Time</th>\n    </tr>\n    ");
      // 65, 5
      
    Arrays.sort(serverNames);
    for (ServerName serverName : serverNames) {
      infoPort = masterAddressTracker == null ? 0 : masterAddressTracker.getBackupMasterInfoPort(serverName);
    
      // 70, 5
      jamonWriter.write("<tr>\n        <td><a href=\"//");
      // 71, 24
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(serverName.getHostname()), jamonWriter);
      // 71, 54
      jamonWriter.write(":");
      // 71, 55
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(infoPort), jamonWriter);
      // 72, 22
      jamonWriter.write("/master-status\" target=\"_blank\">");
      // 72, 54
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(serverName.getHostname()), jamonWriter);
      // 73, 38
      jamonWriter.write("</a>\n        </td>\n        <td>");
      // 75, 13
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(serverName.getPort()), jamonWriter);
      // 75, 39
      jamonWriter.write("</td>\n        <td>");
      // 76, 13
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(new Date(serverName.getStartcode())), jamonWriter);
      // 76, 54
      jamonWriter.write("</td>\n    </tr>\n    ");
      // 78, 5
      
    }
    
      // 81, 5
      jamonWriter.write("<tr><td>Total:");
      // 81, 19
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf((masters != null) ? masters.size() : 0), jamonWriter);
      // 81, 63
      jamonWriter.write("</td>\n    </table>\n");
    }
    // 83, 7
    jamonWriter.write("\n");
  }
  
  
}
