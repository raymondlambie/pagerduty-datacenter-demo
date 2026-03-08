# Power & Electrical Systems - Incident Runbooks

## 🚨 CRITICAL: UPS On Battery

### Severity: P1 - Critical
### Response Time: Immediate (< 2 minutes)

#### Symptoms
- UPS has switched to battery power
- Mains power failure detected
- Battery runtime countdown active

#### Immediate Actions (First 5 Minutes)
1. **Acknowledge incident** in PagerDuty
2. **Check UPS status** via BMS dashboard
   - Battery charge level
   - Estimated runtime remaining
   - Load percentage
3. **Verify generator status**
   - Auto-start sequence initiated?
   - Fuel level adequate?
   - Transfer switch position
4. **Notify stakeholders** via MS Teams
   - Facilities Manager
   - NOC Lead
   - Customer Success (if runtime < 15 min)

#### Investigation Steps
1. **Determine root cause**
   - Check utility power status
   - Review electrical panel alerts
   - Contact utility provider if widespread outage
2. **Assess impact**
   - Which racks/equipment affected?
   - Customer impact assessment
   - SLA implications
3. **Monitor battery runtime**
   - If < 10 minutes: Initiate emergency shutdown procedures
   - If < 5 minutes: Execute graceful shutdown of non-critical systems

#### Resolution Steps
1. **If generator available:**
   - Verify generator running and stable
   - Monitor transfer switch operation
   - Confirm load transfer successful
   - Allow UPS to recharge (minimum 30 minutes)

2. **If utility power restored:**
   - Verify stable power for 5 minutes
   - Check voltage/frequency within spec
   - Monitor UPS return to normal mode
   - Verify battery charging

3. **If neither available:**
   - Execute emergency shutdown plan
   - Prioritize critical systems
   - Document all actions taken

#### Post-Incident
- [ ] Document incident timeline
- [ ] Update CMMS with maintenance records
- [ ] Schedule UPS battery test
- [ ] Review generator auto-start logs
- [ ] Conduct post-mortem if runtime < 5 minutes
- [ ] Update customer communications

#### Escalation
- **15 minutes:** Escalate to Facilities Manager
- **30 minutes:** Escalate to Director of Operations
- **If customer impact:** Notify Account Management immediately

#### Related Alerts
- Generator Failed to Start
- Battery Low Voltage
- UPS Overload
- Transfer Switch Failure

---

## ⚠️ HIGH: Generator Failed to Start

### Severity: P2 - High
### Response Time: < 5 minutes

#### Symptoms
- Generator auto-start sequence failed
- UPS on battery with no backup
- Generator control panel errors

#### Immediate Actions
1. **Acknowledge incident**
2. **Verify UPS battery runtime** (critical if on battery)
3. **Attempt manual generator start**
   - Check emergency stop button not engaged
   - Verify fuel valve open
   - Check battery connections
   - Attempt manual start sequence

#### Investigation Steps
1. **Check generator control panel**
   - Error codes displayed?
   - Fuel level adequate?
   - Coolant temperature normal?
   - Battery voltage sufficient?
2. **Review maintenance logs**
   - Last successful test?
   - Recent maintenance performed?
   - Known issues?

#### Resolution Steps
1. **If manual start successful:**
   - Monitor for 10 minutes
   - Check auto-start system
   - Schedule control system repair
2. **If manual start fails:**
   - Contact generator service provider (24/7 number in CMMS)
   - Prepare for extended UPS battery operation
   - Consider load shedding if necessary

#### Escalation
- **Immediate:** If UPS on battery
- **10 minutes:** If manual start unsuccessful
- **Contact:** Generator service provider (see contact list)

---

## ⚡ MEDIUM: PDU Overload Warning

### Severity: P3 - Medium
### Response Time: < 15 minutes

#### Symptoms
- PDU load exceeds 80% capacity
- Potential circuit breaker trip risk
- Power distribution imbalance

#### Immediate Actions
1. **Acknowledge incident**
2. **Check PDU load levels** via BMS
   - Current load percentage
   - Which circuits affected
   - Trend over last hour
3. **Identify high-load equipment**
   - Review recent changes
   - Check for stuck cooling fans
   - Verify no unauthorized equipment

#### Investigation Steps
1. **Review capacity planning**
   - Is this expected growth?
   - Recent equipment additions?
   - Seasonal load variations?
2. **Check for anomalies**
   - Equipment malfunction causing high draw?
   - Cooling system running continuously?
   - Failed power supplies drawing excess current?

#### Resolution Steps
1. **Short-term (if > 90% load):**
   - Redistribute load to alternate PDU
   - Shut down non-critical equipment
   - Schedule emergency load balancing
2. **Long-term:**
   - Update capacity planning
   - Schedule PDU upgrade/addition
   - Implement load monitoring alerts
   - Review with customer if dedicated equipment

#### Post-Incident
- [ ] Update capacity management database
- [ ] Review power distribution design
- [ ] Schedule infrastructure upgrade if needed
- [ ] Update monitoring thresholds

---

## ℹ️ LOW: Scheduled Maintenance Reminder

### Severity: P4 - Low
### Response Time: < 1 hour

#### Actions
1. Review maintenance schedule in CMMS
2. Confirm maintenance window with stakeholders
3. Prepare maintenance checklist
4. Notify affected customers (if applicable)
5. Schedule maintenance team

