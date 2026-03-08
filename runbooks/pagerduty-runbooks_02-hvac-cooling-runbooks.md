# HVAC & Cooling Systems - Incident Runbooks

## 🚨 CRITICAL: CRAC Unit Failure

### Severity: P1 - Critical
### Response Time: Immediate (< 2 minutes)

#### Symptoms
- CRAC/CRAH unit offline
- Cooling capacity reduced
- Temperature rising in data hall
- Redundancy compromised

#### Immediate Actions (First 5 Minutes)
1. **Acknowledge incident** in PagerDuty
2. **Check data hall temperature**
   - Current temperature
   - Rate of temperature rise
   - Hot spot locations
3. **Verify redundant units operational**
   - Are backup units running?
   - Can they handle full load?
   - Check their capacity utilization
4. **Activate emergency cooling** if available
   - Open emergency ventilation
   - Deploy portable cooling units
   - Increase airflow from operational units

#### Investigation Steps
1. **Diagnose CRAC failure**
   - Check control panel error codes
   - Verify power supply to unit
   - Check refrigerant levels
   - Inspect compressor operation
   - Review alarm history
2. **Assess cooling capacity**
   - Calculate remaining capacity
   - Estimate time to critical temperature
   - Identify most vulnerable equipment

#### Resolution Steps
1. **If temperature rising rapidly (> 2°C per 10 min):**
   - Initiate emergency shutdown of non-critical loads
   - Deploy all available portable cooling
   - Contact HVAC service provider (emergency line)
   - Consider controlled shutdown if temp > 30°C

2. **If temperature stable:**
   - Monitor every 5 minutes
   - Attempt CRAC unit restart
   - Check for simple fixes (tripped breaker, clogged filter)
   - Schedule emergency HVAC service

3. **If redundancy adequate:**
   - Monitor temperature trends
   - Schedule normal HVAC service
   - Update maintenance logs
   - Plan for extended operation on backup units

#### Critical Temperature Thresholds
- **25°C:** Warning - Monitor closely
- **28°C:** High - Prepare for load reduction
- **30°C:** Critical - Begin controlled shutdown
- **32°C:** Emergency - Immediate shutdown required

#### Escalation
- **Immediate:** If temp > 28°C or rising > 2°C/10min
- **15 minutes:** If unable to stabilize temperature
- **Contact:** HVAC service provider 24/7 hotline

#### Post-Incident
- [ ] Document temperature timeline
- [ ] Review cooling redundancy design
- [ ] Schedule preventive maintenance
- [ ] Update emergency procedures
- [ ] Conduct post-mortem if customer impact
- [ ] Review SLA implications

---

## ⚠️ HIGH: High Temperature Alert

### Severity: P2 - High
### Response Time: < 5 minutes

#### Symptoms
- Data hall temperature exceeds threshold (> 24°C)
- Hot spots detected
- Cooling system struggling

#### Immediate Actions
1. **Acknowledge incident**
2. **Check all CRAC/CRAH units**
   - All units operational?
   - Running at full capacity?
   - Any error codes?
3. **Identify hot spots**
   - Which racks affected?
   - Airflow obstructions?
   - Recent equipment changes?
4. **Check external factors**
   - Outside temperature extreme?
   - Building HVAC issues?
   - Increased IT load?

#### Investigation Steps
1. **Review cooling system performance**
   - Supply air temperature
   - Return air temperature
   - Airflow rates
   - Chilled water temperature (if applicable)
2. **Check for airflow issues**
   - Blocked vents or grilles
   - Missing blanking panels
   - Cable management blocking airflow
   - Hot aisle/cold aisle containment intact

#### Resolution Steps
1. **Immediate cooling improvements:**
   - Adjust CRAC setpoints if safe
   - Remove any airflow obstructions
   - Install missing blanking panels
   - Verify containment integrity
2. **Load management:**
   - Identify high-heat equipment
   - Consider redistributing load
   - Shut down non-critical equipment if needed
3. **System optimization:**
   - Balance cooling unit loads
   - Adjust fan speeds
   - Optimize chilled water flow

#### Post-Incident
- [ ] Update temperature monitoring thresholds
- [ ] Review cooling capacity planning
- [ ] Schedule airflow assessment
- [ ] Update hot spot map

---

## ⚡ MEDIUM: Chilled Water Low Flow

### Severity: P3 - Medium
### Response Time: < 15 minutes

#### Symptoms
- Chilled water flow rate below normal
- CRAC units reporting low flow alarms
- Reduced cooling capacity

#### Immediate Actions
1. **Check chilled water system**
   - Pump status
   - Valve positions
   - Pressure readings
   - Filter differential pressure
2. **Verify CRAC unit operation**
   - Are units compensating?
   - Temperature stable?

#### Investigation Steps
1. **Identify flow restriction**
   - Clogged filters?
   - Partially closed valves?
   - Pump performance degraded?
   - Air in system?
2. **Check building chilled water plant**
   - Central plant operating normally?
   - Other zones affected?

#### Resolution Steps
1. **If filters clogged:** Schedule filter replacement
2. **If valve issue:** Verify all valves fully open
3. **If pump issue:** Contact building engineering
4. **If air in system:** Schedule system purge

---

## ℹ️ LOW: Filter Replacement Due

### Severity: P4 - Low
### Response Time: < 1 hour

#### Actions
1. Review filter replacement schedule
2. Order replacement filters if needed
3. Schedule maintenance window
4. Update preventive maintenance log
5. Coordinate with operations team

