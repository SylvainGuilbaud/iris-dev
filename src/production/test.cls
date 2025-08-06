Class production.test Extends Ens.Production
{

ClassMethod OnStart(pTimeStarted As %String) As %Status
{
  #; do ##class(%File).CopyDir("/data/HL7/test","/data/HL7/in",1)
  #; do ##class(%File).CopyDir("/data/HL7/test","/data/HL7/validate",1)
  do ##class(Ens.Util.Statistics).EnableStatsForProduction()
  do ##class(Ens.Util.Statistics).EnableSAMForNamespace()
  set ^%ISCLOG=5
  for i=1:1:5 {
    set level = i
    set category="start"
    set message= level_"-Production Started SYSLOG"
    set data=level_"-data:"_$zdt($h,3)
    $$$SysLog(level,category,message,data)

  }

  #; Controls tracing overall as follows:
  #; If this node is not set, only user trace elements are enabled. 
  #; In this case, you can enable specific kinds of system tracing by setting subnodes, as described in the rest of this table.
  #; If the value of this node is 0, no tracing is enabled.
  #; If the value of this node is 1, all tracing is enabled, apart from any explicitly disabled kinds of tracing.
  set ^Ens.Debug("TraceCat")=1
  #; Enables or disables system traces from business processes.
  #; For this node and all the rest of the nodes in this table, if the node value is 1, the specified traces are enabled. 
  #; If the node value is 0, these traces are disabled. This node is ignored if the parent node value is 0.
  #; set ^Ens.Debug("TraceCat","bproc")=1 
  #; set ^Ens.Debug("TraceCat","connwait")=1 ; Enables or disables system traces from adapters waiting to connect.
  #; set ^Ens.Debug("TraceCat","exterr")=1 ; Enables or disables system traces showing errors from external systems.
  #; set ^Ens.Debug("TraceCat","file")=1 ; Enables or disables system traces from file read or write operations.
  #; set ^Ens.Debug("TraceCat","ontask")=1 ; Enables or disables system traces from business host framework events.
  #; set ^Ens.Debug("TraceCat","parse")=1 ; Enables or disables system traces from virtual document parsers.
  #; set ^Ens.Debug("TraceCat","protocol")=1 ; Enables or disables system traces of sequence numbers from the MSH segment in HL7 messages.
  #; set ^Ens.Debug("TraceCat","queue")=1 ; Enables or disables system traces related to message queue management.
  #; set ^Ens.Debug("TraceCat","sql")=1 ; Enables or disables system traces from processing events of the SQL adapter.
  #; set ^Ens.Debug("TraceCat","system")=1 ; Enables or disables general system trace elements.
  #; set ^Ens.Debug("TraceCat","timing")=1 ; Enables or disables system traces providing information about duration of calls.
  #; set ^Ens.Debug("TraceCat","transform")=1 ; Enables or disables system traces about DTL data transformations, apart from errors.
  #; set ^Ens.Debug("TraceCat","user")=1 ; Enables or disables user traces.
  #; set ^Ens.Debug("TraceCat","xform")=1 ; Enables or disables system traces about errors in DTL data transformations.

	return $$$OK
}

XData ProductionDefinition
{
<Production Name="production.test" TestingEnabled="true" LogGeneralTraceEvents="true">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="get env" Category="" ClassName="operations.env" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="get secrets" Category="" ClassName="operations.secrets" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
