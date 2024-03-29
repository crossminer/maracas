// Autogenerated Jamon proxy
// /home/ali-hbase-1.1.3/alihbase-server/src/main/jamon/org/apache/hadoop/hbase/tmpl/master/AssignmentManagerStatusTmpl.jamon

package org.apache.hadoop.hbase.tmpl.master;

// 20, 1
import org.apache.hadoop.hbase.HRegionInfo;
// 21, 1
import org.apache.hadoop.hbase.master.AssignmentManager;
// 22, 1
import org.apache.hadoop.hbase.master.RegionState;
// 23, 1
import org.apache.hadoop.conf.Configuration;
// 24, 1
import org.apache.hadoop.hbase.HBaseConfiguration;
// 25, 1
import org.apache.hadoop.hbase.HConstants;
// 26, 1
import java.util.Iterator;
// 27, 1
import java.util.Map;

@org.jamon.annotations.Template(
  signature = "3C49EE1B6C5A45F59779801683F3057B",
  requiredArguments = {
    @org.jamon.annotations.Argument(name = "assignmentManager", type = "AssignmentManager")},
  optionalArguments = {
    @org.jamon.annotations.Argument(name = "limit", type = "int")})
public class AssignmentManagerStatusTmpl
  extends org.jamon.AbstractTemplateProxy
{
  
  public AssignmentManagerStatusTmpl(org.jamon.TemplateManager p_manager)
  {
     super(p_manager);
  }
  
  public AssignmentManagerStatusTmpl()
  {
     super("/org/apache/hadoop/hbase/tmpl/master/AssignmentManagerStatusTmpl");
  }
  
  protected interface Intf
    extends org.jamon.AbstractTemplateProxy.Intf{
    
    void renderNoFlush(final java.io.Writer jamonWriter) throws java.io.IOException;
    
  }
  public static class ImplData
    extends org.jamon.AbstractTemplateProxy.ImplData
  {
    // 30, 1
    public void setAssignmentManager(AssignmentManager assignmentManager)
    {
      // 30, 1
      m_assignmentManager = assignmentManager;
    }
    public AssignmentManager getAssignmentManager()
    {
      return m_assignmentManager;
    }
    private AssignmentManager m_assignmentManager;
    // 31, 1
    public void setLimit(int limit)
    {
      // 31, 1
      m_limit = limit;
      m_limit__IsNotDefault = true;
    }
    public int getLimit()
    {
      return m_limit;
    }
    private int m_limit;
    public boolean getLimit__IsNotDefault()
    {
      return m_limit__IsNotDefault;
    }
    private boolean m_limit__IsNotDefault;
  }
  @Override
  protected ImplData makeImplData()
  {
    return new ImplData();
  }
  @Override @SuppressWarnings("unchecked") public ImplData getImplData()
  {
    return (ImplData) super.getImplData();
  }
  
  protected int limit;
  public final org.apache.hadoop.hbase.tmpl.master.AssignmentManagerStatusTmpl setLimit(int p_limit)
  {
    (getImplData()).setLimit(p_limit);
    return this;
  }
  
  
  @Override
  public org.jamon.AbstractTemplateImpl constructImpl(Class<? extends org.jamon.AbstractTemplateImpl> p_class){
    try
    {
      return p_class
        .getConstructor(new Class [] { org.jamon.TemplateManager.class, ImplData.class })
        .newInstance(new Object [] { getTemplateManager(), getImplData()});
    }
    catch (RuntimeException e)
    {
      throw e;
    }
    catch (Exception e)
    {
      throw new RuntimeException(e);
    }
  }
  
  @Override
  protected org.jamon.AbstractTemplateImpl constructImpl(){
    return new AssignmentManagerStatusTmplImpl(getTemplateManager(), getImplData());
  }
  public org.jamon.Renderer makeRenderer(final AssignmentManager assignmentManager)
  {
    return new org.jamon.AbstractRenderer() {
      @Override
      public void renderTo(final java.io.Writer jamonWriter)
        throws java.io.IOException
      {
        render(jamonWriter, assignmentManager);
      }
    };
  }
  
  public void render(final java.io.Writer jamonWriter, final AssignmentManager assignmentManager)
    throws java.io.IOException
  {
    renderNoFlush(jamonWriter, assignmentManager);
    jamonWriter.flush();
  }
  public void renderNoFlush(final java.io.Writer jamonWriter, final AssignmentManager assignmentManager)
    throws java.io.IOException
  {
    ImplData implData = getImplData();
    implData.setAssignmentManager(assignmentManager);
    Intf instance = (Intf) getTemplateManager().constructImpl(this);
    instance.renderNoFlush(jamonWriter);
    reset();
  }
  
  
}
