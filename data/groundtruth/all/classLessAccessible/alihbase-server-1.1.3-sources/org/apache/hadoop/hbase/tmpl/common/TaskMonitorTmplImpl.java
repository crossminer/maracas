// Autogenerated Jamon implementation
// /home/ali-hbase-1.1.3/alihbase-server/src/main/jamon/org/apache/hadoop/hbase/tmpl/common/TaskMonitorTmpl.jamon

package org.apache.hadoop.hbase.tmpl.common;

// 20, 1
import java.util.*;
// 21, 1
import org.apache.hadoop.hbase.monitoring.*;
// 22, 1
import org.apache.hadoop.util.StringUtils;

public class TaskMonitorTmplImpl
  extends org.jamon.AbstractTemplateImpl
  implements org.apache.hadoop.hbase.tmpl.common.TaskMonitorTmpl.Intf

{
  private final String filter;
  private final String format;
  private final TaskMonitor taskMonitor;
  protected static org.apache.hadoop.hbase.tmpl.common.TaskMonitorTmpl.ImplData __jamon_setOptionalArguments(org.apache.hadoop.hbase.tmpl.common.TaskMonitorTmpl.ImplData p_implData)
  {
    if(! p_implData.getFilter__IsNotDefault())
    {
      p_implData.setFilter("general");
    }
    if(! p_implData.getFormat__IsNotDefault())
    {
      p_implData.setFormat("html");
    }
    if(! p_implData.getTaskMonitor__IsNotDefault())
    {
      p_implData.setTaskMonitor(TaskMonitor.get());
    }
    return p_implData;
  }
  public TaskMonitorTmplImpl(org.jamon.TemplateManager p_templateManager, org.apache.hadoop.hbase.tmpl.common.TaskMonitorTmpl.ImplData p_implData)
  {
    super(p_templateManager, __jamon_setOptionalArguments(p_implData));
    filter = p_implData.getFilter();
    format = p_implData.getFormat();
    taskMonitor = p_implData.getTaskMonitor();
  }
  
  public void renderNoFlush(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter)
    throws java.io.IOException
  {
    // 29, 1
    
List<? extends MonitoredTask> tasks = taskMonitor.getTasks();
Iterator<? extends MonitoredTask> iter = tasks.iterator();
// apply requested filter
while (iter.hasNext()) {
  MonitoredTask t = iter.next();
  if (filter.equals("general")) {
    if (t instanceof MonitoredRPCHandler)
      iter.remove();
  } else if (filter.equals("handler")) {
    if (!(t instanceof MonitoredRPCHandler))
      iter.remove();
  } else if (filter.equals("rpc")) {
    if (!(t instanceof MonitoredRPCHandler) || 
        !((MonitoredRPCHandler) t).isRPCRunning())
      iter.remove();
  } else if (filter.equals("operation")) {
    if (!(t instanceof MonitoredRPCHandler) || 
        !((MonitoredRPCHandler) t).isOperationRunning())
      iter.remove();
  }
}
long now = System.currentTimeMillis();
Collections.reverse(tasks);
boolean first = true;

    // 55, 1
    if (format.equals("json"))
    {
      // 55, 29
      jamonWriter.write("\n[");
      // 56, 2
      for (MonitoredTask task : tasks)
      {
        // 56, 36
        if (first)
        {
          // 56, 48
          first = false;
        }
        // 56, 77
        else
        {
          // 56, 84
          jamonWriter.write(",");
        }
        // 56, 91
        org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(task.toJSON()), jamonWriter);
      }
      // 56, 117
      jamonWriter.write("]\n");
    }
    // 57, 1
    else
    {
      // 57, 8
      jamonWriter.write("\n<h2>Tasks</h2>\n  <ul class=\"nav nav-pills\">\n    <li ");
      // 60, 9
      if (filter.equals("all"))
      {
        // 60, 36
        jamonWriter.write("class=\"active\"");
      }
      // 60, 56
      jamonWriter.write("><a href=\"?filter=all\">Show All Monitored Tasks</a></li>\n    <li ");
      // 61, 9
      if (filter.equals("general"))
      {
        // 61, 40
        jamonWriter.write("class=\"active\"");
      }
      // 61, 60
      jamonWriter.write("><a href=\"?filter=general\">Show non-RPC Tasks</a></li>\n    <li ");
      // 62, 9
      if (filter.equals("handler"))
      {
        // 62, 40
        jamonWriter.write("class=\"active\"");
      }
      // 62, 60
      jamonWriter.write("><a href=\"?filter=handler\">Show All RPC Handler Tasks</a></li>\n    <li ");
      // 63, 9
      if (filter.equals("rpc"))
      {
        // 63, 36
        jamonWriter.write("class=\"active\"");
      }
      // 63, 56
      jamonWriter.write("><a href=\"?filter=rpc\">Show Active RPC Calls</a></li>\n    <li ");
      // 64, 9
      if (filter.equals("operation"))
      {
        // 64, 42
        jamonWriter.write("class=\"active\"");
      }
      // 64, 62
      jamonWriter.write("><a href=\"?filter=operation\">Show Client Operations</a></li>\n    <li><a href=\"?format=json&filter=");
      // 65, 38
      org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(filter), jamonWriter);
      // 65, 50
      jamonWriter.write("\">View as JSON</a></li>\n  </ul>\n  ");
      // 67, 3
      if (tasks.isEmpty())
      {
        // 67, 25
        jamonWriter.write("\n    <p>No tasks currently running on this node.</p>\n  ");
      }
      // 69, 3
      else
      {
        // 69, 10
        jamonWriter.write("\n    <table class=\"table\">\n    <tr>\n      <th>Start Time</th>\n      <th>Description</th>\n      <th>State</th>\n      <th>Status</th>\n    </tr>\n    ");
        // 77, 5
        for (MonitoredTask task : tasks )
        {
          // 77, 40
          jamonWriter.write("\n    <tr class=\"");
          // 78, 16
          {
            // 78, 16
            __jamon_innerUnit__stateCss(jamonWriter, task.getState() );
          }
          // 78, 55
          jamonWriter.write("\">\n      <td>");
          // 79, 11
          org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(new Date(task.getStartTime())), jamonWriter);
          // 79, 46
          jamonWriter.write("</td>\n      <td>");
          // 80, 11
          org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(task.getDescription()), jamonWriter);
          // 80, 38
          jamonWriter.write("</td>\n      <td>");
          // 81, 11
          org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(task.getState()), jamonWriter);
          // 81, 32
          jamonWriter.write("\n          (since ");
          // 82, 18
          org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(StringUtils.formatTimeDiff(now, task.getStateTime())), jamonWriter);
          // 82, 76
          jamonWriter.write(" ago)\n      </td>\n      <td>");
          // 84, 11
          org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(task.getStatus()), jamonWriter);
          // 84, 33
          jamonWriter.write("\n          (since ");
          // 85, 18
          org.jamon.escaping.Escaping.HTML.write(org.jamon.emit.StandardEmitter.valueOf(StringUtils.formatTimeDiff(now, task.getStatusTime())), jamonWriter);
          // 85, 77
          jamonWriter.write(" \n          ago)</td>\n    </tr>\n    ");
        }
        // 88, 12
        jamonWriter.write("\n    </table>\n\n  ");
      }
      // 91, 9
      jamonWriter.write("\n");
    }
    // 92, 7
    jamonWriter.write("\n\n\n");
  }
  
  
  // 95, 1
  private void __jamon_innerUnit__stateCss(@SuppressWarnings({"unused","hiding"}) final java.io.Writer jamonWriter, final MonitoredTask.State state)
    throws java.io.IOException
  {
    // 99, 1
           if (state == MonitoredTask.State.COMPLETE) { 
    // 99, 68
    jamonWriter.write("alert alert-success");
    // 99, 87
     } 
    // 100, 1
      else if (state == MonitoredTask.State.ABORTED)  { 
    // 100, 68
    jamonWriter.write("alert alert-error");
    // 100, 85
       } 
  }
  
  
}
