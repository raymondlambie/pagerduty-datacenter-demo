# Network Infrastructure - Incident Runbooks

## 🚨 CRITICAL: Core Switch Failure

### Severity: P1 - Critical
### Response Time: Immediate (< 2 minutes)

#### Symptoms
- Core network switch offline
- Multiple network segments down
- Loss of connectivity to critical systems
- BMS unable to communicate with devices

#### Immediate Actions (First 5 Minutes)
1. **Acknowledge incident** in PagerDuty
2. **Assess impact**
   - Which systems affected?
   - Customer impact?
   - Redundancy available?
3. **Check switch status**
   - Power LED status
   - Console access available?
   - Error messages?
4. **Verify redundant paths**
   - Backup switch operational?
   - Failover occurred?
   - Traffic rerouting?

#### Investigation Steps
1. **Diagnose failure**
   - Power supply failure?
   - Software crash?
   - Hardware failure?
   - Configuration error?
2. **Check logs**
   - System logs
   - SNMP traps
   - Syslog messages
   - Environmental sensors
3. **Test connectivity**
   - Console access
   - Management interface
   - Ping tests
   - Port status

#### Resolution Steps
1. **If power failure:**
   - Check power cables
   - Verify PDU operational
   - Check circuit breakers
   - Test with alternate power source
   - Replace power supply if faulty

2. **If software crash:**
   - Attempt reboot via console
   - Check for core dumps
   - Review recent changes
   - Restore from backup config if needed
   - Contact vendor support

3. **If hardware failure:**
   - Identify failed component
   - Activate spare switch if available
   - Restore configuration
   - Contact vendor for RMA
   - Schedule permanent replacement

4. **If configuration error:**
   - Access via console
   - Review recent config changes
   - Restore last known good config
   - Test connectivity
   - Document error

#### Failover Procedures
1. **If redundant switch available:**
   - Verify backup switch operational
   - Confirm traffic failover
   - Monitor performance
   - Plan primary switch recovery

2. **If no redundancy:**
   - Implement emergency network topology
   - Prioritize critical systems
   - Use backup switches if available
   - Expedite replacement

#### Escalation
- **Immediate:** If no redundancy and customer impact
- **15 minutes:** If unable to restore service
- **Contact:** Network vendor support, escalation engineer

#### Post-Incident
- [ ] Document failure cause
- [ ] Review redundancy design
- [ ] Update network diagrams
- [ ] Test failover procedures
- [ ] Conduct post-mortem
- [ ] Update monitoring
- [ ] Review SLA impact
- [ ] Customer communication

---

## ⚠️ HIGH: BMS Network Connectivity Loss

### Severity: P2 - High
### Response Time: < 5 minutes

#### Symptoms
- BMS unable to communicate with field devices
- Loss of monitoring data
- Control commands not executing
- Niagara server unreachable

#### Immediate Actions
1. **Acknowledge incident**
2. **Check BMS server status**
   - Server powered on?
   - Network interfaces up?
   - IP address correct?
3. **Test network connectivity**
   - Ping BMS server
   - Ping field controllers
   - Check switch port status
4. **Verify physical connections**
   - Cables connected?
   - Link lights active?
   - Switch ports enabled?

#### Investigation Steps
1. **Isolate problem**
   - Server issue?
   - Network issue?
   - Field device issue?
   - Specific segment or all?
2. **Check network infrastructure**
   - Switch configuration
   - VLAN settings
   - Routing tables
   - Firewall rules
3. **Review recent changes**
   - Network maintenance?
   - Configuration changes?
   - New equipment added?

#### Resolution Steps
1. **If server issue:**
   - Restart network services
   - Check firewall settings
   - Verify IP configuration
   - Restart server if necessary

2. **If network issue:**
   - Check switch configuration
   - Verify VLAN assignments
   - Test cable continuity
   - Replace faulty cables/ports

3. **If field device issue:**
   - Check device power
   - Verify device IP settings
   - Test device connectivity
   - Restart devices if needed

#### Post-Incident
- [ ] Document root cause
- [ ] Update network documentation
- [ ] Review BMS network design
- [ ] Implement additional monitoring
- [ ] Test backup communication paths

---

## ⚡ MEDIUM: High Network Latency

### Severity: P3 - Medium
### Response Time: < 15 minutes

#### Symptoms
- Slow network response times
- BMS interface sluggish
- Delayed alarm notifications
- Packet loss detected

#### Immediate Actions
1. **Measure latency**
   - Ping tests
   - Traceroute
   - Bandwidth utilization
2. **Check network load**
   - Switch port utilization
   - Bandwidth graphs
   - Top talkers
3. **Identify bottlenecks**
   - Overloaded links?
   - Broadcast storms?
   - Misconfigured QoS?

#### Investigation Steps
1. **Analyze traffic patterns**
   - Unusual traffic?
   - Bandwidth hogs?
   - Time-based patterns?
2. **Check for issues**
   - Duplex mismatches?
   - Errors on interfaces?
   - Spanning tree problems?
3. **Review configuration**
   - QoS settings
   - Traffic shaping
   - Port speeds

#### Resolution Steps
1. **Immediate relief:**
   - Identify and limit heavy traffic
   - Adjust QoS priorities
   - Load balance if possible
2. **Long-term:**
   - Upgrade bandwidth if needed
   - Optimize network design
   - Implement traffic monitoring
   - Review capacity planning

---

## ℹ️ LOW: Network Device Firmware Update Available

### Severity: P4 - Low
### Response Time: < 1 week

#### Actions
1. Review firmware release notes
2. Check for security patches
3. Schedule maintenance window
4. Backup current configuration
5. Test in lab if possible
6. Plan rollback procedure
7. Schedule update during low-usage period

