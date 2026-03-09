#!/usr/bin/env python3
"""
PagerDuty Datacenter BMS Demo - Event Generator
Sends realistic Building Management System alerts to PagerDuty services
Updated: March 2026 - Aligned with current demo configuration
Includes random alert generation for correlation demo
"""
import requests
import json
import time
import os
import subprocess
import random
from datetime import datetime

# PagerDuty Events API v2 endpoint
EVENTS_API_URL = "https://events.pagerduty.com/v2/enqueue"

# Integration keys - Will be loaded from Terraform outputs
INTEGRATION_KEYS = {
    "environmental_monitoring": os.getenv("PD_ENV_KEY", ""),
    "fire_safety": os.getenv("PD_FIRE_KEY", ""),
    "hvac_cooling": os.getenv("PD_HVAC_KEY", ""),
    "network_infrastructure": os.getenv("PD_NETWORK_KEY", ""),
    "physical_security": os.getenv("PD_SECURITY_KEY", ""),
    "power_electrical": os.getenv("PD_POWER_KEY", "")
}

def load_integration_keys_from_terraform():
    """Load integration keys from Terraform outputs"""
    try:
        result = subprocess.run(
            ["terraform", "output", "-json", "service_integration_keys"],
            capture_output=True,
            text=True,
            check=True
        )
        keys = json.loads(result.stdout)

        # Update INTEGRATION_KEYS with Terraform values
        INTEGRATION_KEYS["environmental_monitoring"] = keys.get("environmental_monitoring", "")
        INTEGRATION_KEYS["fire_safety"] = keys.get("fire_safety", "")
        INTEGRATION_KEYS["hvac_cooling"] = keys.get("hvac_cooling", "")
        INTEGRATION_KEYS["network_infrastructure"] = keys.get("network_infrastructure", "")
        INTEGRATION_KEYS["physical_security"] = keys.get("physical_security", "")
        INTEGRATION_KEYS["power_electrical"] = keys.get("power_electrical", "")

        print("✅ Loaded integration keys from Terraform")
        return True
    except subprocess.CalledProcessError:
        print("⚠️  Could not load keys from Terraform. Using environment variables or manual config.")
        return False
    except Exception as e:
        print(f"⚠️  Error loading Terraform keys: {e}")
        return False

# Demo scenarios - Enhanced for workflow triggers
DEMO_SCENARIOS = {
    "environmental_critical_temp": {
        "service": "environmental_monitoring",
        "summary": "Critical Temperature Alert - Server Room A",
        "severity": "critical",
        "source": "TEMP-SENSOR-ROOM-A-01",
        "component": "Temperature Monitoring",
        "custom_details": {
            "component": "Temperature",
            "current_temp": "32°C",
            "threshold": "28°C",
            "location": "Server Room A - Zone 3",
            "sensor_id": "TEMP-A-01",
            "alert_type": "environmental_critical",
            "affected_zone": "Zone 3, Server Room A",
            "redundancy_status": "Partial - Backup HVAC active",
            "customer_impact": "Moderate - Temperature rising"
        }
    },

    "environmental_water_leak": {
        "service": "environmental_monitoring",
        "summary": "Water Leak Detected - Data Hall 2",
        "severity": "error",
        "source": "WATER-SENSOR-HALL-2-03",
        "component": "Water Detection",
        "custom_details": {
            "component": "Water Leak",
            "location": "Data Hall 2, Row 5",
            "sensor_id": "WATER-HALL-2-03",
            "alert_type": "environmental_critical",
            "leak_severity": "Active leak detected",
            "affected_equipment": "Racks 25-30"
        }
    },

    "environmental_humidity": {
        "service": "environmental_monitoring",
        "summary": "High Humidity Alert - Server Room B",
        "severity": "warning",
        "source": "HUMIDITY-SENSOR-ROOM-B-02",
        "component": "Humidity Monitoring",
        "custom_details": {
            "component": "Humidity",
            "current_humidity": "75%",
            "threshold": "60%",
            "location": "Server Room B",
            "sensor_id": "HUMIDITY-B-02"
        }
    },

    "fire_smoke_detected": {
        "service": "fire_safety",
        "summary": "🚨 CRITICAL: Smoke Detected - Data Hall 1",
        "severity": "critical",
        "source": "SMOKE-DETECTOR-HALL-1-05",
        "component": "Fire Detection",
        "custom_details": {
            "detector_id": "SMOKE-HALL-1-05",
            "location": "Data Hall 1, Row 8",
            "detector_type": "Aspirating Smoke Detection",
            "alarm_level": "Alert Level 2",
            "evacuation_status": "Standby",
            "fire_panel_status": "Active alarm"
        }
    },

    "fire_suppression_activated": {
        "service": "fire_safety",
        "summary": "🚨 CRITICAL: Fire Suppression System Activated",
        "severity": "critical",
        "source": "SUPPRESSION-SYSTEM-HALL-2",
        "component": "Fire Suppression",
        "custom_details": {
            "system_id": "SUPPRESSION-HALL-2",
            "location": "Data Hall 2",
            "suppression_type": "FM-200 Gas",
            "discharge_status": "Active",
            "evacuation_required": "YES - All personnel evacuate immediately"
        }
    },

    "fire_alarm_test": {
        "service": "fire_safety",
        "summary": "[TEST] Fire Alarm System Test",
        "severity": "info",
        "source": "FIRE-PANEL-MAIN",
        "component": "Fire Alarm",
        "custom_details": {
            "test_type": "Monthly System Test",
            "scheduled_by": "Facilities Team",
            "duration": "15 minutes",
            "status": "Scheduled maintenance"
        }
    },

    "hvac_critical_failure": {
        "service": "hvac_cooling",
        "summary": "CRITICAL: HVAC Unit Failure - Data Hall 1",
        "severity": "critical",
        "source": "HVAC-HALL-1-UNIT-03",
        "component": "HVAC System",
        "custom_details": {
            "unit_id": "HVAC-HALL-1-03",
            "location": "Data Hall 1",
            "failure_type": "Compressor Failure",
            "estimated_temp_rise": "2°C per 10 minutes",
            "affected_zone": "Data Hall 1 - All zones",
            "current_temp": "26°C",
            "target_temp": "22°C",
            "redundancy_status": "Failed - No backup available",
            "customer_impact": "High - Temperature rising rapidly"
        }
    },

    "hvac_crac_failure": {
        "service": "hvac_cooling",
        "summary": "CRAC Unit Offline - Server Room A",
        "severity": "critical",
        "source": "CRAC-ROOM-A-02",
        "component": "CRAC Unit",
        "custom_details": {
            "unit_id": "CRAC-A-02",
            "location": "Server Room A",
            "failure_type": "Unit Offline",
            "backup_status": "Active",
            "affected_zone": "Server Room A",
            "current_temp": "24°C",
            "target_temp": "21°C",
            "redundancy_status": "Active - Backup CRAC running"
        }
    },

    "hvac_chiller_alert": {
        "service": "hvac_cooling",
        "summary": "Chiller Low Efficiency - Building Chiller 1",
        "severity": "warning",
        "source": "Chiller-BLDG-01",
        "component": "Chiller System",
        "custom_details": {
            "unit_id": "Chiller-BLDG-01",
            "efficiency": "72%",
            "normal_efficiency": "85%",
            "action_required": "Schedule maintenance",
            "impact_level": "Low"
        }
    },

    "network_core_failure": {
        "service": "network_infrastructure",
        "summary": "CRITICAL: Core Switch Failure - Building Core",
        "severity": "critical",
        "source": "SWITCH-CORE-BLDG-01",
        "component": "Core Network",
        "custom_details": {
            "device_location": "SWITCH-CORE-BLDG-01",
            "impact_level": "Critical",
            "affected_systems": "All data halls",
            "redundancy_status": "Active",
            "failover_status": "Successful - Backup core active",
            "customer_impact": "None - Failover successful",
            "affected_segment": "Core Network - Primary"
        }
    },

    "network_switch_down": {
        "service": "network_infrastructure",
        "summary": "Network Switch Down - Data Hall 2 Row 3",
        "severity": "error",
        "source": "SWITCH-HALL-2-ROW-3-05",
        "component": "Access Switch",
        "custom_details": {
            "device_location": "SWITCH-HALL-2-ROW-3-05",
            "affected_racks": "Racks 15-20",
            "customer_impact": "Moderate - 6 customers affected",
            "affected_segment": "Access Layer - Data Hall 2",
            "failover_status": "In Progress"
        }
    },

    "network_access_switch": {
        "service": "network_infrastructure",
        "summary": "Access Switch Port Errors - Hall 1",
        "severity": "warning",
        "source": "SWITCH-ACCESS-HALL-1-08",
        "component": "Access Switch",
        "custom_details": {
            "device_location": "SWITCH-ACCESS-HALL-1-08",
            "port": "GigabitEthernet 1/0/24",
            "error_rate": "High CRC errors",
            "affected_segment": "Access Layer - Hall 1"
        }
    },

    "security_door_breach": {
        "service": "physical_security",
        "summary": "🔒 SECURITY: Unauthorized Door Access - Data Hall 1",
        "severity": "critical",
        "source": "DOOR-SENSOR-HALL-1-MAIN",
        "component": "Access Control",
        "custom_details": {
            "location": "Data Hall 1 - Main Entrance",
            "access_method": "Forced entry detected",
            "camera_id": "CAM-HALL-1-03",
            "video_footage": "Captured",
            "threat_level": "High",
            "incident_type": "Unauthorized Access"
        }
    },

    "security_badge_fail": {
        "service": "physical_security",
        "summary": "Multiple Failed Badge Attempts - Server Room A",
        "severity": "error",
        "source": "BADGE-READER-ROOM-A-01",
        "component": "Access Control",
        "custom_details": {
            "location": "Server Room A - Main Door",
            "attempts": "5 failed attempts",
            "badge_id": "Unknown",
            "video_footage": "Under Review",
            "threat_level": "Medium",
            "incident_type": "Failed Access Attempts"
        }
    },

    "power_ups_battery": {
        "service": "power_electrical",
        "summary": "⚡ CRITICAL: UPS On Battery - Data Hall 1",
        "severity": "critical",
        "source": "UPS-HALL-1-PRIMARY",
        "component": "UPS System",
        "custom_details": {
            "ups_id": "UPS-HALL-1-PRIMARY",
            "battery_runtime": "45 minutes remaining",
            "load": "85%",
            "mains_status": "Failed",
            "affected_system": "UPS - Primary",
            "power_load": "85%",
            "redundancy_status": "Failed - Mains power lost",
            "customer_impact": "Severe - On battery backup"
        }
    },

    "power_generator_start": {
        "service": "power_electrical",
        "summary": "⚡ Generator Auto-Start - Building Generator 1",
        "severity": "error",
        "source": "GENERATOR-BLDG-01",
        "component": "Generator",
        "custom_details": {
            "generator_id": "GENERATOR-BLDG-01",
            "status": "Running",
            "load": "60%",
            "fuel_level": "75%",
            "runtime_estimate": "12 hours",
            "affected_system": "Generator - Primary",
            "redundancy_status": "Active - Generator online"
        }
    },

    "power_pdu_overload": {
        "service": "power_electrical",
        "summary": "PDU Overload Warning - Rack 42",
        "severity": "warning",
        "source": "PDU-HALL-2-RACK-42-A",
        "component": "PDU",
        "custom_details": {
            "pdu_id": "PDU-HALL-2-RACK-42-A",
            "current_load": "92%",
            "threshold": "80%",
            "action": "Load balancing required",
            "affected_system": "PDU - Rack 42"
        }
    }
}

def send_event(scenario_name, scenario, show_output=True):
    """Send a PagerDuty event"""
    integration_key = INTEGRATION_KEYS.get(scenario["service"])

    if not integration_key:
        if show_output:
            print(f"❌ Integration key not configured for {scenario['service']}")
            print(f"   Set environment variable or run: terraform output -json service_integration_keys")
        return False

    # Add timestamp to custom_details
    scenario["custom_details"]["timestamp"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S AEDT")

    payload = {
        "routing_key": integration_key,
        "event_action": "trigger",
        "dedup_key": f"{scenario['source']}-{int(time.time())}-{random.randint(1000, 9999)}",
        "payload": {
            "summary": scenario["summary"],
            "severity": scenario["severity"],
            "source": scenario["source"],
            "component": scenario["component"],
            "custom_details": scenario["custom_details"]
        }
    }

    try:
        response = requests.post(EVENTS_API_URL, json=payload, timeout=10)

        if response.status_code == 202:
            if show_output:
                print(f"✅ {scenario_name}")
                print(f"   Service: {scenario['service']}")
                print(f"   Summary: {scenario['summary']}")
                print(f"   Severity: {scenario['severity']}")
            return True
        else:
            if show_output:
                print(f"❌ Failed: {scenario_name}")
                print(f"   Status: {response.status_code}")
                print(f"   Response: {response.text}")
            return False

    except Exception as e:
        if show_output:
            print(f"❌ Error sending {scenario_name}: {str(e)}")
        return False

def generate_random_alerts(num_alerts=50, duration_minutes=10):
    """
    Generate random alerts over a specified time period

    Args:
        num_alerts: Total number of alerts to generate (default: 50)
        duration_minutes: Time period to spread alerts over (default: 10 minutes)
    """
    print("\n" + "="*60)
    print(f"🎲 RANDOM ALERT GENERATOR")
    print("="*60)
    print(f"📊 Configuration:")
    print(f"   • Total alerts: {num_alerts}")
    print(f"   • Duration: {duration_minutes} minutes")
    print(f"   • Rate: ~{num_alerts/duration_minutes:.1f} alerts/minute")
    print(f"   • Delay between alerts: ~{(duration_minutes*60)/num_alerts:.1f} seconds")
    print("\n🎯 Purpose: Build incident history for correlation demo")
    print("="*60)

    confirm = input("\nStart generating random alerts? (y/n): ").strip().lower()
    if confirm != 'y':
        print("❌ Cancelled")
        return

    # Calculate delay between alerts
    delay_seconds = (duration_minutes * 60) / num_alerts

    # Get list of all scenario names
    scenario_names = list(DEMO_SCENARIOS.keys())

    print(f"\n🚀 Starting alert generation...")
    print(f"⏱️  Estimated completion: {duration_minutes} minutes\n")

    success_count = 0
    fail_count = 0

    start_time = time.time()

    for i in range(num_alerts):
        # Randomly select a scenario
        scenario_name = random.choice(scenario_names)
        scenario = DEMO_SCENARIOS[scenario_name].copy()

        # Send the event (suppress individual output)
        if send_event(scenario_name, scenario, show_output=False):
            success_count += 1
            status = "✅"
        else:
            fail_count += 1
            status = "❌"

        # Progress indicator
        progress = (i + 1) / num_alerts * 100
        elapsed = time.time() - start_time
        remaining = (elapsed / (i + 1)) * (num_alerts - i - 1)

        print(f"{status} [{i+1}/{num_alerts}] {progress:.0f}% | "
              f"Elapsed: {elapsed/60:.1f}m | Remaining: {remaining/60:.1f}m | "
              f"{scenario['service'][:15]:15s} | {scenario['severity']:8s}")

        # Wait before next alert (except for last one)
        if i < num_alerts - 1:
            time.sleep(delay_seconds)

    total_time = time.time() - start_time

    print("\n" + "="*60)
    print("✅ RANDOM ALERT GENERATION COMPLETE")
    print("="*60)
    print(f"📊 Results:")
    print(f"   • Total alerts sent: {num_alerts}")
    print(f"   • Successful: {success_count}")
    print(f"   • Failed: {fail_count}")
    print(f"   • Total time: {total_time/60:.1f} minutes")
    print(f"   • Actual rate: {num_alerts/(total_time/60):.1f} alerts/minute")
    print("\n🎯 Your PagerDuty account now has incident history for correlation!")
    print("="*60)

def demo_sequence_1():
    """Demo Sequence 1: HVAC Emergency with Structured Updates"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 1: HVAC Emergency (Triggers Structured Update Workflow)")
    print("="*60)
    print("This will trigger the HVAC Response Guide workflow with structured prompts")

    scenarios = [
        "hvac_critical_failure",
        "environmental_critical_temp"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(3)

def demo_sequence_2():
    """Demo Sequence 2: Power Emergency with MS Teams Chat"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 2: Power Emergency (Triggers Power Response Workflow)")
    print("="*60)
    print("This will trigger the Power Response Guide workflow")

    scenarios = [
        "power_ups_battery",
        "power_generator_start"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(3)

def demo_sequence_3():
    """Demo Sequence 3: Network Infrastructure Failure"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 3: Network Infrastructure Failure")
    print("="*60)
    print("This will trigger the Network Response Guide workflow")

    scenarios = [
        "network_core_failure",
        "network_switch_down"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(3)

def demo_sequence_4():
    """Demo Sequence 4: Security Incident"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 4: Security Incident (Triggers Security Response Workflow)")
    print("="*60)
    print("This will trigger the Security Response Guide workflow")

    scenarios = [
        "security_door_breach",
        "security_badge_fail"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(3)

def demo_sequence_5():
    """Demo Sequence 5: Fire Safety Emergency"""
    print("\n" + "="*60)
    print("DEMO SEQUENCE 5: Fire Safety Emergency (Life Safety Critical)")
    print("="*60)
    print("This will trigger the Fire & Life Safety Critical workflow")

    scenarios = [
        "fire_smoke_detected",
        "fire_suppression_activated"
    ]

    for scenario_name in scenarios:
        send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
        time.sleep(3)

def demo_full_scenario():
    """Demo Full Scenario: Complete datacenter incident"""
    print("\n" + "="*60)
    print("DEMO: Full Datacenter Incident Scenario")
    print("="*60)
    print("Simulating cascading failure: Power → HVAC → Environmental")

    print("\n1️⃣ Power failure detected...")
    send_event("power_ups_battery", DEMO_SCENARIOS["power_ups_battery"])
    time.sleep(5)

    print("\n2️⃣ Generator starting...")
    send_event("power_generator_start", DEMO_SCENARIOS["power_generator_start"])
    time.sleep(5)

    print("\n3️⃣ HVAC affected by power fluctuation...")
    send_event("hvac_critical_failure", DEMO_SCENARIOS["hvac_critical_failure"])
    time.sleep(5)

    print("\n4️⃣ Temperature rising...")
    send_event("environmental_critical_temp", DEMO_SCENARIOS["environmental_critical_temp"])
    time.sleep(3)

    print("\n✅ Full scenario complete - Check PagerDuty for incident workflows!")

def demo_all_scenarios():
    """Send all demo scenarios"""
    print("\n" + "="*60)
    print("DEMO: All Scenarios")
    print("="*60)

    for scenario_name, scenario in DEMO_SCENARIOS.items():
        send_event(scenario_name, scenario)
        time.sleep(2)

def test_integration_keys():
    """Test if integration keys are configured"""
    print("\n" + "="*60)
    print("Testing Integration Keys")
    print("="*60)

    all_configured = True

    for service, key in INTEGRATION_KEYS.items():
        if not key:
            print(f"❌ {service}: NOT CONFIGURED")
            all_configured = False
        else:
            print(f"✅ {service}: Configured ({key[:8]}...)")

    if all_configured:
        print("\n✅ All integration keys are configured!")
        print("   Ready to send demo events!")
    else:
        print("\n⚠️  Some integration keys are missing.")
        print("   Run: terraform output -json service_integration_keys")
        print("   Or set environment variables: PD_HVAC_KEY, PD_POWER_KEY, etc.")

    return all_configured

def interactive_menu():
    """Interactive demo menu"""
    while True:
        print("\n" + "="*60)
        print("PagerDuty Datacenter BMS Demo - Event Generator")
        print("="*60)
        print("\n🎯 RECOMMENDED DEMO SEQUENCES:")
        print("1. HVAC Emergency (Triggers Structured Update Workflow)")
        print("2. Power Emergency (Triggers Power Response Workflow)")
        print("3. Network Infrastructure Failure")
        print("4. Security Incident (Triggers Security Response Workflow)")
        print("5. Fire Safety Emergency (Life Safety Critical)")
        print("6. Full Datacenter Incident (Cascading Failure)")
        print("\n🎲 RANDOM ALERT GENERATION:")
        print("7. Generate Random Alerts (Custom)")
        print("8. Quick Generate (50 alerts over 10 minutes)")
        print("9. Large Generate (100 alerts over 20 minutes)")
        print("\n📋 OTHER OPTIONS:")
        print("10. Send All Scenarios")
        print("11. Send Single Scenario")
        print("12. Test Integration Keys")
        print("0. Exit")

        choice = input("\nSelect option: ").strip()

        if choice == "1":
            demo_sequence_1()
        elif choice == "2":
            demo_sequence_2()
        elif choice == "3":
            demo_sequence_3()
        elif choice == "4":
            demo_sequence_4()
        elif choice == "5":
            demo_sequence_5()
        elif choice == "6":
            demo_full_scenario()
        elif choice == "7":
            # Custom random generation
            try:
                num = int(input("Number of alerts to generate: ").strip())
                duration = int(input("Duration in minutes: ").strip())
                generate_random_alerts(num, duration)
            except ValueError:
                print("❌ Invalid input. Please enter numbers only.")
        elif choice == "8":
            generate_random_alerts(50, 10)
        elif choice == "9":
            generate_random_alerts(100, 20)
        elif choice == "10":
            demo_all_scenarios()
        elif choice == "11":
            print("\nAvailable scenarios:")
            for i, name in enumerate(DEMO_SCENARIOS.keys(), 1):
                print(f"{i}. {name}")

            scenario_choice = input("\nSelect scenario number: ").strip()
            try:
                scenario_name = list(DEMO_SCENARIOS.keys())[int(scenario_choice) - 1]
                send_event(scenario_name, DEMO_SCENARIOS[scenario_name])
            except (ValueError, IndexError):
                print("❌ Invalid selection")
        elif choice == "12":
            test_integration_keys()
        elif choice == "0":
            print("\n👋 Goodbye!")
            break
        else:
            print("❌ Invalid option")

if __name__ == "__main__":
    print("\n🚀 PagerDuty Datacenter BMS Demo - Event Generator")
    print("   Version: 2.1 (March 2026)")
    print("   Timezone: Australia/Sydney")
    print("   Events API: v2")
    print("   Services: 6 (Environmental, Fire Safety, HVAC, Network, Security, Power)")
    print("   Workflows: HVAC, Power, Network, Security Response Guides + CMMS Integration")
    print("   NEW: Random alert generation for correlation demo")

    # Try to load integration keys from Terraform
    if not load_integration_keys_from_terraform():
        print("\n⚠️  Using environment variables or manual configuration")

    # Test integration keys
    print()
    if test_integration_keys():
        # Start interactive menu
        interactive_menu()
    else:
        print("\n❌ Please configure integration keys before continuing.")
        print("   Option 1: Run 'terraform output -json service_integration_keys'")
        print("   Option 2: Set environment variables (PD_HVAC_KEY, PD_POWER_KEY, etc.)")
