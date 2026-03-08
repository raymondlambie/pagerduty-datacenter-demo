# Environmental Monitoring - Incident Runbooks

## 🚨 CRITICAL: Water Leak Detected

### Severity: P1 - Critical
### Response Time: Immediate (< 2 minutes)

#### Symptoms
- Water detection sensor triggered
- Moisture detected under raised floor
- Potential equipment damage risk

#### Immediate Actions (First 5 Minutes)
1. **Acknowledge incident** in PagerDuty
2. **Locate leak source**
   - Check sensor location on BMS
   - Visual inspection of area
   - Identify affected equipment
3. **Assess severity**
   - Active water flow or residual moisture?
   - How much water present?
   - Spreading or contained?
4. **Protect equipment**
   - Power down affected equipment if safe
   - Deploy water barriers/absorbent materials
   - Move portable equipment if possible

#### Investigation Steps
1. **Identify water source**
   - Chilled water piping?
   - Condensate drain?
   - CRAC unit drip pan?
   - Roof/building leak?
   - Fire suppression system?
2. **Determine leak severity**
   - Active leak or past event?
   - Flow rate if active
   - Total volume estimate
3. **Check for equipment damage**
   - Any equipment in water?
   - Electrical hazards present?
   - Cable trays affected?

#### Resolution Steps
1. **If active leak:**
   - Shut off water source if possible
   - Contact building maintenance/plumber
   - Deploy wet vacuum/extraction equipment
   - Set up temporary barriers
   - Monitor for equipment damage

2. **If condensate issue:**
   - Check CRAC unit drain pans
   - Verify condensate pumps working
   - Clear any drain blockages
   - Schedule preventive maintenance

3. **If building leak:**
   - Contact building management immediately
   - Document for insurance/SLA purposes
   - Consider temporary relocation of equipment
   - Deploy dehumidifiers

#### Equipment Protection Priority
1. **Immediate shutdown:** Equipment in standing water
2. **Monitor closely:** Equipment within 2m of leak
3. **Inspect after resolution:** All equipment in affected area

#### Escalation
- **Immediate:** If active leak with equipment at risk
- **5 minutes:** If unable to locate/stop leak
- **Contact:** Building maintenance, plumber, insurance

#### Post-Incident
- [ ] Document leak location and cause
- [ ] Inspect all affected equipment
- [ ] Test equipment before returning to service
- [ ] Update water detection sensor coverage
- [ ] Review with building management
- [ ] File insurance claim if applicable
- [ ] Conduct post-mortem
- [ ] Update emergency procedures

---

## ⚠️ HIGH: High Humidity Alert

### Severity: P2 - High
### Response Time: < 5 minutes

#### Symptoms
- Relative humidity > 60%
- Condensation risk
- Potential equipment corrosion

#### Immediate Actions
1. **Acknowledge incident**
2. **Check humidity levels**
   - Current RH percentage
   - Trend over last hour
   - Multiple sensors affected?
3. **Check HVAC dehumidification**
   - CRAC units in dehumidify mode?
   - Condensate removal working?
   - Chilled water temperature adequate?

#### Investigation Steps
1. **Identify humidity source**
   - Outside air infiltration?
   - Water leak/spill?
   - HVAC system malfunction?
   - Recent maintenance activity?
2. **Check environmental controls**
   - Setpoints correct?
   - Sensors calibrated?
   - Control system responding?

#### Resolution Steps
1. **Immediate actions:**
   - Increase dehumidification if possible
   - Deploy portable dehumidifiers
   - Seal any air infiltration points
   - Increase air circulation
2. **HVAC adjustments:**
   - Lower chilled water temperature
   - Adjust CRAC unit setpoints
   - Verify condensate removal
3. **Long-term:**
   - Schedule HVAC system review
   - Consider additional dehumidification capacity
   - Review building envelope integrity

#### Post-Incident
- [ ] Review humidity control strategy
- [ ] Calibrate humidity sensors
- [ ] Update monitoring thresholds
- [ ] Document root cause

---

## ⚡ MEDIUM: Smoke Detector Activation

### Severity: P3 - Medium (unless confirmed fire)
### Response Time: < 5 minutes

#### Symptoms
- Smoke detector triggered
- No visible fire
- Possible dust, aerosol, or malfunction

#### Immediate Actions
1. **Acknowledge incident**
2. **Visual inspection**
   - Any visible smoke?
   - Any burning smell?
   - Any equipment showing distress?
3. **Check fire panel**
   - Single detector or multiple?
   - Fire alarm system status
   - Suppression system armed?

#### Investigation Steps
1. **Rule out false alarm**
   - Recent maintenance activity?
   - Dust from construction?
   - Aerosol spray used nearby?
   - Detector malfunction history?
2. **Check for actual smoke source**
   - Overheating equipment?
   - Electrical burning smell?
   - Dust accumulation?

#### Resolution Steps
1. **If false alarm:**
   - Document cause
   - Reset detector
   - Clean detector if dusty
   - Schedule replacement if faulty
2. **If actual smoke:**
   - Escalate to CRITICAL
   - Follow fire safety procedures
   - Evacuate if necessary
   - Call emergency services

#### Escalation
- **Immediate:** If smoke confirmed or fire suspected
- **Call 000:** If any doubt about fire risk

---

## ℹ️ LOW: Humidity Sensor Offline

### Severity: P4 - Low
### Response Time: < 1 hour

#### Actions
1. Check sensor power and connectivity
2. Verify BMS communication
3. Schedule sensor inspection/replacement
4. Use alternate sensors for monitoring
5. Update maintenance log

