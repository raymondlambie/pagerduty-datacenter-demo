# Physical Security - Incident Runbooks

## 🚨 CRITICAL: Unauthorized Access Detected

### Severity: P1 - Critical
### Response Time: Immediate (< 2 minutes)

#### Symptoms
- Door forced open
- Access granted without valid credential
- Tailgating detected
- Intrusion alarm triggered

#### Immediate Actions (First 2 Minutes)
1. **Acknowledge incident** in PagerDuty
2. **Review security footage**
   - Identify individual(s)
   - Current location
   - Entry method
3. **Assess threat level**
   - Known person or stranger?
   - Suspicious behavior?
   - Equipment tampering?
4. **Secure facility**
   - Lock down affected area if possible
   - Dispatch security personnel
   - Monitor individual's movements

#### Investigation Steps
1. **Verify unauthorized access**
   - Check access logs
   - Review video footage
   - Interview witnesses
   - Confirm no valid authorization
2. **Determine entry method**
   - Forced entry?
   - Stolen credentials?
   - Tailgating?
   - System malfunction?
3. **Assess potential damage**
   - Equipment tampered with?
   - Data accessed?
   - Physical damage?

#### Resolution Steps
1. **If intruder present:**
   - **DO NOT CONFRONT** if safety risk
   - Call police (000) immediately
   - Monitor via cameras
   - Secure other areas
   - Evacuate staff if necessary

2. **If intruder departed:**
   - Secure entry point
   - Review all footage
   - Check for missing equipment
   - Inspect for tampering
   - File police report

3. **System response:**
   - Reset access control system
   - Revoke compromised credentials
   - Update access permissions
   - Test all security systems

#### Post-Incident (Critical)
- [ ] File police report
- [ ] Document complete timeline
- [ ] Preserve all video evidence
- [ ] Conduct security audit
- [ ] Review access control procedures
- [ ] Update security protocols
- [ ] Notify affected customers if data risk
- [ ] Conduct mandatory post-mortem
- [ ] Review insurance coverage

#### Escalation
- **Immediate:** Call 000 if intruder present or threat to safety
- **Immediate:** Notify Security Manager and Director of Operations
- **Within 1 hour:** Notify legal team and insurance
- **Within 4 hours:** Customer notification if data at risk

---

## ⚠️ HIGH: Door Held Open

### Severity: P2 - High
### Response Time: < 5 minutes

#### Symptoms
- Data hall door open > 2 minutes
- Door alarm triggered
- Potential security breach
- Environmental control compromised

#### Immediate Actions
1. **Acknowledge incident**
2. **Check door location**
   - Which door affected?
   - High security area?
3. **Review camera footage**
   - Who opened door?
   - Authorized person?
   - Legitimate reason?
4. **Verify area security**
   - Anyone unauthorized present?
   - Equipment secure?

#### Investigation Steps
1. **Determine reason**
   - Equipment move in progress?
   - Maintenance activity?
   - Forgotten to close?
   - Door malfunction?
2. **Check environmental impact**
   - Temperature affected?
   - Humidity changed?
   - Airflow disrupted?

#### Resolution Steps
1. **If legitimate activity:**
   - Verify authorization
   - Estimate completion time
   - Monitor environmental conditions
   - Ensure door secured when complete
2. **If forgotten/accidental:**
   - Close door immediately
   - Remind staff of procedures
   - Document incident
3. **If door malfunction:**
   - Secure door manually
   - Contact door service provider
   - Post security guard if needed
   - Schedule emergency repair

#### Post-Incident
- [ ] Review door access logs
- [ ] Verify environmental recovery
- [ ] Update staff training if needed
- [ ] Test door closer mechanism
- [ ] Document in security log

---

## ⚡ MEDIUM: Multiple Failed Access Attempts

### Severity: P3 - Medium
### Response Time: < 15 minutes

#### Symptoms
- 3+ failed access attempts in 5 minutes
- Invalid credential used repeatedly
- Potential unauthorized access attempt

#### Immediate Actions
1. **Review access logs**
   - Which credential used?
   - Which door?
   - Time pattern?
2. **Check video footage**
   - Identify person attempting access
   - Known employee?
   - Suspicious behavior?

#### Investigation Steps
1. **Determine cause**
   - Lost/stolen card?
   - Expired credentials?
   - Wrong door for access level?
   - Malicious attempt?
2. **Contact credential holder**
   - Verify they have their card
   - Confirm they were attempting access
   - Check if card reported lost

#### Resolution Steps
1. **If lost/stolen card:**
   - Deactivate credential immediately
   - Issue temporary replacement
   - Monitor for further attempts
   - File security report
2. **If expired/wrong door:**
   - Update access permissions
   - Educate user on proper access
   - No further action needed
3. **If malicious:**
   - Escalate to HIGH priority
   - Increase security monitoring
   - Consider police report
   - Review security procedures

---

## ℹ️ LOW: Access Card Expiring Soon

### Severity: P4 - Low
### Response Time: < 1 hour

#### Actions
1. Notify cardholder of expiration
2. Schedule card renewal
3. Update access control system
4. Issue new card before expiration
5. Deactivate old card after replacement

