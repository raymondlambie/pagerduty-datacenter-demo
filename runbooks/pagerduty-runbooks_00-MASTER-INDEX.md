# PagerDuty Datacenter Runbooks - Master Index

## 📚 Complete Runbook Collection for Niagara BMS Integration

This collection contains detailed incident response runbooks for all datacenter systems monitored by PagerDuty.

---

## 📁 Runbook Files

### 1. Power & Electrical Systems
**File:** `01-power-electrical-runbooks.md`

**Incidents Covered:**
- 🚨 **P1 Critical:** UPS On Battery
- ⚠️ **P2 High:** Generator Failed to Start
- ⚡ **P3 Medium:** PDU Overload Warning
- ℹ️ **P4 Low:** Scheduled Maintenance Reminder

---

### 2. HVAC & Cooling Systems
**File:** `02-hvac-cooling-runbooks.md`

**Incidents Covered:**
- 🚨 **P1 Critical:** CRAC Unit Failure
- ⚠️ **P2 High:** High Temperature Alert
- ⚡ **P3 Medium:** Chilled Water Low Flow
- ℹ️ **P4 Low:** Filter Replacement Due

---

### 3. Environmental Monitoring
**File:** `03-environmental-monitoring-runbooks.md`

**Incidents Covered:**
- 🚨 **P1 Critical:** Water Leak Detected
- ⚠️ **P2 High:** High Humidity Alert
- ⚡ **P3 Medium:** Smoke Detector Activation
- ℹ️ **P4 Low:** Humidity Sensor Offline

---

### 4. Physical Security
**File:** `04-physical-security-runbooks.md`

**Incidents Covered:**
- 🚨 **P1 Critical:** Unauthorized Access Detected
- ⚠️ **P2 High:** Door Held Open
- ⚡ **P3 Medium:** Multiple Failed Access Attempts
- ℹ️ **P4 Low:** Access Card Expiring Soon

---

### 5. Fire Safety Systems
**File:** `05-fire-safety-runbooks.md`

**Incidents Covered:**
- 🚨 **P1 Critical:** Fire Alarm Activated
- ⚠️ **P2 High:** Fire Suppression System Fault
- ⚡ **P3 Medium:** Fire Extinguisher Inspection Overdue
- ℹ️ **P4 Low:** Fire Drill Scheduled

---

### 6. Network Infrastructure
**File:** `06-network-infrastructure-runbooks.md`

**Incidents Covered:**
- 🚨 **P1 Critical:** Core Switch Failure
- ⚠️ **P2 High:** BMS Network Connectivity Loss
- ⚡ **P3 Medium:** High Network Latency
- ℹ️ **P4 Low:** Network Device Firmware Update Available

---

## 🎯 Runbook Structure

Each runbook follows a consistent format:

### Incident Header
- **Severity Level** (P1-P4)
- **Response Time** requirement
- **Symptoms** to identify the incident

### Response Sections
1. **Immediate Actions** - First steps to take
2. **Investigation Steps** - How to diagnose the issue
3. **Resolution Steps** - How to fix the problem
4. **Escalation** - When and who to escalate to
5. **Post-Incident** - Follow-up actions and documentation

---

## 🚨 Priority Levels

| Priority | Response Time | Description |
|----------|--------------|-------------|
| **P1 - Critical** | < 2 minutes | Immediate threat to safety, major service impact |
| **P2 - High** | < 5 minutes | Urgent issue, potential service degradation |
| **P3 - Medium** | < 15 minutes | Important issue, no immediate impact |
| **P4 - Low** | < 1 hour | Informational, scheduled maintenance |

---

## 📞 Emergency Contacts

### Critical Services
- **Emergency Services (Fire/Police/Ambulance):** 000
- **PagerDuty Support:** [Your support number]
- **Facilities Manager:** [Contact info]
- **Director of Operations:** [Contact info]

### Service Providers
- **HVAC Service (24/7):** [Contact info]
- **Generator Service (24/7):** [Contact info]
- **Fire System Service (24/7):** [Contact info]
- **Network Vendor Support:** [Contact info]
- **Building Management:** [Contact info]

### Insurance & Legal
- **Insurance Company (Claims):** [Contact info]
- **Legal Team:** [Contact info]

---

## 🔗 Integration with PagerDuty

These runbooks are designed to integrate with your PagerDuty incident workflow:

1. **Automatic Linking:** Configure PagerDuty services to link to relevant runbooks
2. **Mobile Access:** All runbooks are markdown format for easy mobile viewing
3. **Response Plays:** Use with PagerDuty Response Plays for automated workflows
4. **Incident Workflows:** Trigger specific actions based on runbook procedures

---

## 📝 Customization Guide

To customize these runbooks for your facility:

1. **Update Contact Information**
   - Replace placeholder contacts with actual numbers
   - Add local emergency services
   - Include vendor support contacts

2. **Adjust Thresholds**
   - Temperature limits for your equipment
   - Humidity ranges for your environment
   - Network latency acceptable levels

3. **Add Site-Specific Details**
   - Equipment locations and identifiers
   - Local procedures and policies
   - Customer-specific requirements

4. **Include Diagrams**
   - Facility layout maps
   - Network topology diagrams
   - Equipment location plans

---

## 🔄 Maintenance

**Review Schedule:**
- **Quarterly:** Review all runbooks for accuracy
- **After Major Incidents:** Update based on lessons learned
- **After Equipment Changes:** Update affected runbooks
- **Annually:** Complete runbook audit and update

**Version Control:**
- Store runbooks in version control (Git)
- Track changes and updates
- Maintain change log
- Review and approve updates

---

## 📚 Training

**New Staff Onboarding:**
1. Review all P1 Critical runbooks
2. Walk through facility with runbooks
3. Practice incident scenarios
4. Shadow experienced responders

**Ongoing Training:**
- Monthly runbook review sessions
- Quarterly incident drills
- Annual emergency response training
- Post-incident debriefs

---

## 📊 Metrics & Improvement

**Track These Metrics:**
- Time to acknowledge incidents
- Time to resolution by priority
- Runbook usage frequency
- Escalation rates
- Post-incident action completion

**Continuous Improvement:**
- Collect feedback from responders
- Update based on actual incidents
- Incorporate lessons learned
- Benchmark against industry standards

---

## ✅ Quick Reference Checklist

### For All P1 Critical Incidents:
- [ ] Acknowledge in PagerDuty immediately
- [ ] Assess safety and evacuate if necessary
- [ ] Call emergency services if required (000)
- [ ] Notify management immediately
- [ ] Document all actions taken
- [ ] Conduct post-mortem within 24 hours

### For All Incidents:
- [ ] Follow runbook procedures
- [ ] Document timeline and actions
- [ ] Update incident in PagerDuty
- [ ] Complete post-incident checklist
- [ ] Update runbook if needed

---

**Document Version:** 1.0  
**Last Updated:** 2026-03-08  
**Maintained By:** Datacenter Operations Team  
**Review Frequency:** Quarterly

