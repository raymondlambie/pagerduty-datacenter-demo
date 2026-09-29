import tkinter as tk
from tkinter import ttk
import json
import random
import threading
import time
import urllib.request
import urllib.error
from datetime import datetime

# --- CORE DATA MODELS (Identical to Web Demo) ---

SERVICES = [
    {
        'id': 'power_electrical',
        'name': 'Power & Electrical',
        'color': '#eab308',  # Tailwind yellow-500
        'bg_color': '#fef9c3', # Tailwind yellow-100
        'icon': '⚡',
        'teams': ['Datacenter Ops', 'Management'],
        'sampleAlerts': [
            {'title': 'CRITICAL: UPS On Battery - Data Hall 1', 'severity': 'critical', 'details': 'UPS-HALL-1-PRIMARY: Battery runtime 45 minutes remaining, Load 85%, Mains status: Failed'},
            {'title': 'PDU Overload Warning - Rack 42', 'severity': 'warning', 'details': 'PDU-HALL-2-RACK-42-A: Current load 92%, Threshold 80%, Load balancing required'},
            {'title': 'CRITICAL: Generator Failure - Building Generator 1', 'severity': 'critical', 'details': 'GEN-BLDG-01: Failed to start, Fuel level 85%, Service required immediately'}
        ]
    },
    {
        'id': 'hvac_cooling',
        'name': 'HVAC & Cooling',
        'color': '#3b82f6',  # Tailwind blue-500
        'bg_color': '#dbeafe', # Tailwind blue-100
        'icon': '❄️',
        'teams': ['Environmental Team', 'Datacenter Ops'],
        'sampleAlerts': [
            {'title': 'CRITICAL: HVAC Unit Failure - Data Hall 1', 'severity': 'critical', 'details': 'HVAC-HALL-1-03: Compressor Failure, Temperature rising: 2°C per 10 minutes'},
            {'title': 'CRAC Unit Offline - Server Room A', 'severity': 'critical', 'details': 'CRAC-A-02: Unit Offline, Backup status: Active'},
            {'title': 'Chiller Low Efficiency - Building Chiller 1', 'severity': 'warning', 'details': 'Chiller-BLDG-01: Efficiency 72% (normal 85%), Schedule maintenance'}
        ]
    },
    {
        'id': 'environmental_monitoring',
        'name': 'Environmental Monitoring',
        'color': '#22c55e',  # Tailwind green-500
        'bg_color': '#dcfce7', # Tailwind green-100
        'icon': '🌡️',
        'teams': ['Environmental Team', 'Datacenter Ops'],
        'sampleAlerts': [
            {'title': 'Critical Temperature Alert - Server Room A', 'severity': 'critical', 'details': 'TEMP-SENSOR-ROOM-A-01: Current temp 32°C, Threshold 28°C'},
            {'title': 'Water Leak Detected - Data Hall 2', 'severity': 'error', 'details': 'WATER-SENSOR-HALL-2-03: Data Hall 2, Row 5 - Immediate response required'},
            {'title': 'High Humidity Alert - Server Room B', 'severity': 'warning', 'details': 'HUMIDITY-SENSOR-ROOM-B-02: Current 75% RH, Threshold 60%'}
        ]
    },
    {
        'id': 'physical_security',
        'name': 'Physical Security',
        'color': '#ef4444',  # Tailwind red-500
        'bg_color': '#fee2e2', # Tailwind red-100
        'icon': '🔒',
        'teams': ['Security Team', 'Management'],
        'sampleAlerts': [
            {'title': 'SECURITY: Unauthorized Door Access - Data Hall 1', 'severity': 'critical', 'details': 'DOOR-SENSOR-HALL-1-MAIN: Forced entry detected, Camera CAM-HALL-1-03'},
            {'title': 'Multiple Failed Badge Attempts - Server Room A', 'severity': 'error', 'details': 'BADGE-READER-ROOM-A-01: 5 failed attempts, Badge ID: Unknown'},
            {'title': 'Security Camera Offline - Data Hall 2', 'severity': 'warning', 'details': 'CAM-HALL-2-08: Camera offline for 15 minutes, Last frame captured at 14:23'}
        ]
    },
    {
        'id': 'fire_safety',
        'name': 'Fire Safety',
        'color': '#f97316',  # Tailwind orange-500
        'bg_color': '#ffedd5', # Tailwind orange-100
        'icon': '🔥',
        'teams': ['Environmental Team', 'Security Team'],
        'sampleAlerts': [
            {'title': 'CRITICAL: Smoke Detected - Data Hall 1', 'severity': 'critical', 'details': 'SMOKE-DETECTOR-HALL-1-05: Aspirating Smoke Detection, Alert Level 2'},
            {'title': 'CRITICAL: Fire Suppression System Activated', 'severity': 'critical', 'details': 'SUPPRESSION-SYSTEM-HALL-2: FM-200 Gas, Discharge status: Active'},
            {'title': '[TEST] Fire Alarm System Test', 'severity': 'info', 'details': 'FIRE-PANEL-MAIN: Monthly System Test, Scheduled by Facilities Team, Duration 15 minutes'}
        ]
    },
    {
        'id': 'network_infrastructure',
        'name': 'Network Infrastructure',
        'color': '#a855f7',  # Tailwind purple-500
        'bg_color': '#f3e8ff', # Tailwind purple-100
        'icon': '🌐',
        'teams': ['Datacenter Ops', 'Management'],
        'sampleAlerts': [
            {'title': 'CRITICAL: Core Switch Failure - Building Core', 'severity': 'critical', 'details': 'SWITCH-CORE-BLDG-01: Affected systems: All data halls, Redundancy: Failover active'},
            {'title': 'Network Switch Down - Data Hall 2 Row 3', 'severity': 'error', 'details': 'SWITCH-HALL-2-ROW-3-05: Affected racks 15-20, Customer impact: 6 customers'},
            {'title': 'Access Switch Port Errors - Hall 1', 'severity': 'warning', 'details': 'SWITCH-ACCESS-HALL-1-08: Port GigabitEthernet 1/0/24, High CRC errors'}
        ]
    }
]

SAMPLE_CHANGE_EVENTS = [
    {
        'id': 'hvac_maintenance',
        'summary': 'Scheduled HVAC Maintenance - Data Hall 1',
        'type': 'Scheduled Maintenance',
        'description': 'Routine maintenance on HVAC-HALL-1-03, expected duration 2 hours',
        'icon': '🔧',
        'color': '#2563eb', # Blue
        'bg_color': '#eff6ff',
        'serviceId': 'hvac_cooling'
    },
    {
        'id': 'ups_battery',
        'summary': 'UPS Battery Replacement - Data Hall 2',
        'type': 'Hardware Upgrade',
        'description': 'Replacing UPS batteries in Data Hall 2, backup power active',
        'icon': '🔋',
        'color': '#ca8a04', # Yellow
        'bg_color': '#fefcbf',
        'serviceId': 'power_electrical'
    },
    {
        'id': 'fire_test',
        'summary': 'Fire Suppression System Test',
        'type': 'System Test',
        'description': 'Quarterly fire suppression system test, all zones',
        'icon': '🔥',
        'color': '#db2777', # Pink/Red
        'bg_color': '#fdf2f8',
        'serviceId': 'fire_safety'
    },
    {
        'id': 'network_firmware',
        'summary': 'Network Switch Firmware Update - Core',
        'type': 'Software Update',
        'description': 'Firmware update for core network switches, redundancy active',
        'icon': '🌐',
        'color': '#9333ea', # Purple
        'bg_color': '#faf5ff',
        'serviceId': 'network_infrastructure'
    },
    {
        'id': 'generator_test',
        'summary': 'Generator Load Test - Building Gen 1',
        'type': 'System Test',
        'description': 'Monthly generator load test, 30 minute duration',
        'icon': '⚡',
        'color': '#16a34a', # Green
        'bg_color': '#f0fdf4',
        'serviceId': 'power_electrical'
    },
    {
        'id': 'security_upgrade',
        'summary': 'Security System Upgrade - All Halls',
        'type': 'System Upgrade',
        'description': 'Badge reader firmware upgrade across all data halls',
        'icon': '🔒',
        'color': '#dc2626', # Red
        'bg_color': '#fef2f2',
        'serviceId': 'physical_security'
    }
]

ESCALATION_POLICIES = {
    'Critical Infrastructure': ['Immediate: Primary On-Call (SMS + Phone)', '1 min: After Hours Team (SMS + Phone)', '5 min: Management Escalation (SMS + Phone)'],
    'Environmental Systems': ['Immediate: Environmental On-Call (SMS + Phone)', '1 min: Primary On-Call (SMS + Phone)', '5 min: Management Escalation (SMS + Phone)'],
    'Network Infrastructure': ['Immediate: Primary On-Call (SMS + Phone)', '5 min: After Hours Team (SMS + Phone)', '15 min: Management Escalation (SMS + Phone)'],
    'Power & Electrical': ['Immediate: Power Specialists (SMS + Phone)', '5 min: Primary On-Call (SMS + Phone)', '15 min: Management Escalation (SMS + Phone)'],
    'Security Response': ['Immediate: Security On-Call (SMS + Phone)', '1 min: Primary On-Call (SMS + Phone)', '5 min: Management Escalation (SMS + Phone)'],
    'Life Safety Critical': ['Immediate: Environmental + Security (Dual Notification)', '1 min: Primary On-Call (SMS + Phone)', '3 min: Management Escalation (SMS + Phone)']
}


class PagerDutyDemoApp:
    def __init__(self, root):
        self.root = root
        self.root.title("PagerDuty Datacenter Demo - Sydney")
        self.root.geometry("1280x850")
        self.root.configure(bg="#f3f4f6") # Modern neutral slate background

        # State Variables
        self.routing_keys = {
            'power_electrical': tk.StringVar(value='1dc05c3ad2524005c06f79eff03e87cf'),
            'hvac_cooling': tk.StringVar(value='63f81c7b1ca84007d0b0b0c6f49dcee4'),
            'environmental_monitoring': tk.StringVar(value='a0a2a03463144902d08920e53a47740c'),
            'physical_security': tk.StringVar(value='6b35bd392cf04709d0776ab82dd5b7dc'),
            'fire_safety': tk.StringVar(value='c5d00f9ea61a4b03c07ed62a21622790'),
            'network_infrastructure': tk.StringVar(value='637565ba0ed34a00c0bf48cf227956bb')
        }
        
        self.change_event_keys = {
            'power_electrical': tk.StringVar(value='5d5f29c319644906d0c83f0ef7fa6d43'),
            'hvac_cooling': tk.StringVar(value='7be6cd20a25a4d0fd05aa45e2b9c1976'),
            'environmental_monitoring': tk.StringVar(value='6f8130c7f85d430bd09453051330eb12'),
            'physical_security': tk.StringVar(value='8fe381a60d5e4e05d0008cc40904b786'),
            'fire_safety': tk.StringVar(value='0d3db60a993e430bc0b6fc25f7a7ef91'),
            'network_infrastructure': tk.StringVar(value='d82c8b3037354200c04e017c7b5040f9')
        }

        self.alert_multipliers = {s['id']: tk.IntVar(value=1) for s in SERVICES}
        self.selected_alerts = {} # Keyed by f"{service_id}_{alert_index}"
        self.sending_states = {}   # Track sending spinner states
        
        # Configure fonts and style definitions
        self.style = ttk.Style()
        self.style.theme_use('clam')
        self.style.configure('.', font=('Helvetica', 10), background="#f3f4f6")
        self.style.configure('Card.TFrame', background='#ffffff', relief='flat', borderwidth=1)
        self.style.configure('Title.TLabel', font=('Helvetica', 16, 'bold'), background='#ffffff', foreground='#1f2937')
        self.style.configure('Subtitle.TLabel', font=('Helvetica', 10), background='#ffffff', foreground='#4b5563')

        # Structure Layout
        self.setup_ui()

    def setup_ui(self):
        # Top Toast Notification banner
        self.toast_frame = tk.Frame(self.root, bg="#f3f4f6", height=1)
        self.toast_frame.pack(fill="x", side="top", padx=16, pady=(10, 0))

        # Main Scrollable canvas container
        self.container = tk.Frame(self.root, bg="#f3f4f6")
        self.container.pack(fill="both", expand=True, padx=16, pady=10)

        self.canvas = tk.Canvas(self.container, borderwidth=0, highlightthickness=0, bg="#f3f4f6")
        self.scrollbar = ttk.Scrollbar(self.container, orient="vertical", command=self.canvas.yview)
        
        self.scrollable_frame = tk.Frame(self.canvas, bg="#f3f4f6")
        self.scrollable_frame.bind(
            "<Configure>",
            lambda e: self.canvas.configure(scrollregion=self.canvas.bbox("all"))
        )

        self.canvas_window = self.canvas.create_window((0, 0), window=self.scrollable_frame, anchor="nw")
        self.canvas.configure(yscrollcommand=self.scrollbar.set)

        self.canvas.pack(side="left", fill="both", expand=True)
        self.scrollbar.pack(side="right", fill="y")

        # Allow canvas width updates to fit main viewport dynamically
        self.canvas.bind('<Configure>', self._configure_canvas)

        # Enable mousewheel scrolling across all components
        self.root.bind_all("<MouseWheel>", self._on_mousewheel)
        self.root.bind_all("<Button-4>", self._on_mousewheel)
        self.root.bind_all("<Button-5>", self._on_mousewheel)

        # Assemble individual panels
        self.render_header_card()
        self.render_flow_architecture_card()
        self.render_technical_services_grid()
        self.render_cmms_change_events()
        self.render_escalation_policies()
        self.render_key_features()

    def _configure_canvas(self, event):
        self.canvas.itemconfig(self.canvas_window, width=event.width)

    def _on_mousewheel(self, event):
        if event.num == 4:
            self.canvas.yview_scroll(-1, "units")
        elif event.num == 5:
            self.canvas.yview_scroll(1, "units")
        else:
            self.canvas.yview_scroll(int(-1 * (event.delta / 120)), "units")

    def show_toast(self, success, title, msg):
        # Clear any existing toast elements
        for child in self.toast_frame.winfo_children():
            child.destroy()

        bg = "#f0fdf4" if success else "#fef2f2"
        border_col = "#22c55e" if success else "#ef4444"
        text_col = "#15803d" if success else "#b91c1c"

        toast = tk.Frame(self.toast_frame, bg=bg, highlightbackground=border_col, highlightthickness=2, bd=0, padx=12, pady=10)
        toast.pack(fill="x", expand=True)

        lbl_title = tk.Label(toast, text=title, bg=bg, fg=text_col, font=('Helvetica', 11, 'bold'), anchor="w")
        lbl_title.pack(side="left", fill="x", expand=True)

        lbl_msg = tk.Label(toast, text=msg, bg=bg, fg=text_col, font=('Helvetica', 9), anchor="w")
        lbl_msg.pack(side="left", padx=(10, 0))

        btn_close = tk.Button(toast, text="×", bg=bg, fg=text_col, activebackground=bg, bd=0, font=('Helvetica', 14, 'bold'), command=toast.destroy, cursor="hand2")
        btn_close.pack(side="right", padx=(15, 0))

        # Auto-dismiss after 8 seconds
        self.root.after(8000, lambda: toast.destroy() if toast.winfo_exists() else None)

    # --- RENDER COMPONENT PANELS ---

    def render_header_card(self):
        card = tk.Frame(self.scrollable_frame, bg="#ffffff", bd=1, highlightbackground="#e5e7eb", highlightthickness=1)
        card.pack(fill="x", pady=(0, 10))

        title = tk.Label(card, text="PagerDuty Datacenter Service Architecture", font=('Helvetica', 18, 'bold'), bg="#ffffff", fg="#1f2937", anchor="w")
        title.pack(fill="x", padx=16, pady=(16, 4))

        subtitle = tk.Label(card, text="Niagara BMS Integration - Send Alerts to PagerDuty (Sydney/Australia Timezone)", font=('Helvetica', 10), bg="#ffffff", fg="#4b5563", anchor="w")
        subtitle.pack(fill="x", padx=16, pady=(0, 16))

    def render_flow_architecture_card(self):
        card = tk.Frame(self.scrollable_frame, bg="#ffffff", bd=1, highlightbackground="#e5e7eb", highlightthickness=1)
        card.pack(fill="x", pady=10)

        title = tk.Label(card, text="Alert Flow Architecture", font=('Helvetica', 14, 'bold'), bg="#ffffff", fg="#1f2937", anchor="w")
        title.pack(fill="x", padx=16, pady=(16, 12))

        # Horizontal flow container with flow elements
        flow_frame = tk.Frame(card, bg="#ffffff")
        flow_frame.pack(fill="x", padx=16, pady=(0, 16))

        # Define grid layout weightings for horizontal alignment
        for idx in range(7):
            flow_frame.columnconfigure(idx, weight=1 if idx % 2 == 0 else 0)

        # Node 1
        n1 = tk.Frame(flow_frame, bg="#374151", bd=0, padx=12, pady=16)
        n1.grid(row=0, column=0, sticky="nsew", padx=4)
        tk.Label(n1, text="🏢", font=('Helvetica', 22), bg="#374151", fg="white").pack()
        tk.Label(n1, text="Niagara BMS", font=('Helvetica', 11, 'bold'), bg="#374151", fg="white").pack(pady=2)
        tk.Label(n1, text="Building Mgmt System", font=('Helvetica', 8), bg="#374151", fg="#d1d5db").pack()

        # Arrow 1
        tk.Label(flow_frame, text=" ➔ ", font=('Helvetica', 20), bg="#ffffff", fg="#9ca3af").grid(row=0, column=1)

        # Node 2
        n2 = tk.Frame(flow_frame, bg="#16a34a", bd=0, padx=12, pady=16)
        n2.grid(row=0, column=2, sticky="nsew", padx=4)
        tk.Label(n2, text="🔄", font=('Helvetica', 22), bg="#16a34a", fg="white").pack()
        tk.Label(n2, text="Integration", font=('Helvetica', 11, 'bold'), bg="#16a34a", fg="white").pack(pady=2)
        tk.Label(n2, text="Mapping & Routing", font=('Helvetica', 8), bg="#16a34a", fg="#dcfce7").pack()

        # Arrow 2
        tk.Label(flow_frame, text=" ➔ ", font=('Helvetica', 20), bg="#ffffff", fg="#9ca3af").grid(row=0, column=3)

        # Node 3
        n3 = tk.Frame(flow_frame, bg="#15803d", bd=0, padx=12, pady=16)
        n3.grid(row=0, column=4, sticky="nsew", padx=4)
        tk.Label(n3, text="📟", font=('Helvetica', 22), bg="#15803d", fg="white").pack()
        tk.Label(n3, text="PagerDuty", font=('Helvetica', 11, 'bold'), bg="#15803d", fg="white").pack(pady=2)
        tk.Label(n3, text="Incident Engine", font=('Helvetica', 8), bg="#15803d", fg="#dcfce7").pack()

        # Arrow 3
        tk.Label(flow_frame, text=" ⇆ ", font=('Helvetica', 20), bg="#ffffff", fg="#9ca3af").grid(row=0, column=5)

        # Node 4
        n4 = tk.Frame(flow_frame, bg="#2563eb", bd=0, padx=12, pady=16)
        n4.grid(row=0, column=6, sticky="nsew", padx=4)
        tk.Label(n4, text="🔧", font=('Helvetica', 22), bg="#2563eb", fg="white").pack()
        tk.Label(n4, text="CMMS Portal", font=('Helvetica', 11, 'bold'), bg="#2563eb", fg="white").pack(pady=2)
        tk.Label(n4, text="Work Management", font=('Helvetica', 8), bg="#2563eb", fg="#dbeafe").pack()

    def render_technical_services_grid(self):
        section_frame = tk.Frame(self.scrollable_frame, bg="#f3f4f6")
        section_frame.pack(fill="x", pady=10)

        title = tk.Label(section_frame, text="Technical Services (Niagara Outlets)", font=('Helvetica', 14, 'bold'), bg="#f3f4f6", fg="#1f2937")
        title.pack(anchor="w", pady=(0, 6))

        # Service Card Layout: responsive grid behavior
        grid_frame = tk.Frame(section_frame, bg="#f3f4f6")
        grid_frame.pack(fill="x", expand=True)
        grid_frame.columnconfigure(0, weight=1)
        grid_frame.columnconfigure(1, weight=1)
        grid_frame.columnconfigure(2, weight=1)

        for idx, service in enumerate(SERVICES):
            row = idx // 3
            col = idx % 3

            card = tk.Frame(grid_frame, bg="#ffffff", bd=1, highlightbackground="#e5e7eb", highlightthickness=1)
            card.grid(row=row, column=col, padx=8, pady=8, sticky="nsew")

            # Header details
            hdr = tk.Frame(card, bg="#ffffff")
            hdr.pack(fill="x", padx=12, pady=(12, 6))

            icon_lbl = tk.Label(hdr, text=service['icon'], font=('Helvetica', 18), bg=service['bg_color'], width=2)
            icon_lbl.pack(side="left", padx=(0, 10))

            lbl_title = tk.Label(hdr, text=service['name'], font=('Helvetica', 12, 'bold'), bg="#ffffff", fg="#1f2937")
            lbl_title.pack(side="left")

            # Click handler to view Details modal
            def make_detail_handler(s):
                return lambda e: self.show_service_details_modal(s)
            lbl_title.bind("<Button-1>", make_detail_handler(service))
            lbl_title.config(cursor="hand2")

            # Inline sample alert picker
            lbl_alert_title = tk.Label(card, text="Sample Alerts (click to toggle multi-select):", font=('Helvetica', 8, 'bold'), fg="#4b5563", bg="#ffffff")
            lbl_alert_title.pack(anchor="w", padx=12, pady=(8, 2))

            alert_subframe = tk.Frame(card, bg="#ffffff")
            alert_subframe.pack(fill="x", padx=12, pady=2)

            for a_idx, alert in enumerate(service['sampleAlerts']):
                self.render_alert_item(alert_subframe, service, alert, a_idx)

            # Control panel multiplier selector (+ / -)
            ctrl_frame = tk.Frame(card, bg="#f9fafb", bd=1, highlightbackground="#e5e7eb", highlightthickness=1)
            ctrl_frame.pack(fill="x", padx=12, pady=10)

            tk.Label(ctrl_frame, text="🔢 Repeat times (1-10):", font=('Helvetica', 9, 'bold'), bg="#f9fafb", fg="#4b5563").pack(anchor="w", padx=8, pady=(6, 0))

            qty_picker = tk.Frame(ctrl_frame, bg="#f9fafb")
            qty_picker.pack(fill="x", padx=8, pady=(4, 6))

            # Helper for displaying precise multiplier labels
            lbl_count_summary = tk.Label(ctrl_frame, text="", font=('Helvetica', 8, 'italic'), bg="#f9fafb", fg="#6b7280")
            lbl_count_summary.pack(pady=(0, 6))

            def update_multiplier_summary(s_id=service['id'], lbl=lbl_count_summary):
                count = self.alert_multipliers[s_id].get()
                selected = self.get_selected_alerts_count(s_id)
                if selected > 0:
                    lbl.config(text=f"Will send {selected} alert{'s' if selected > 1 else ''} × {count} = {selected * count} total calls")
                else:
                    lbl.config(text=f"Will send 1 random alert × {count} = {count} total calls")

            btn_sub = tk.Button(qty_picker, text="-", font=('Helvetica', 10, 'bold'), width=3, bg="#e5e7eb", bd=0, activebackground="#d1d5db", cursor="hand2")
            btn_sub.pack(side="left")

            lbl_qty = tk.Label(qty_picker, textvariable=self.alert_multipliers[service['id']], font=('Helvetica', 12, 'bold'), bg="#f9fafb", width=6)
            lbl_qty.pack(side="left", padx=5)

            btn_add = tk.Button(qty_picker, text="+", font=('Helvetica', 10, 'bold'), width=3, bg="#e5e7eb", bd=0, activebackground="#d1d5db", cursor="hand2")
            btn_add.pack(side="left")

            def make_sub_handler(s_id, lbl):
                def h():
                    curr = self.alert_multipliers[s_id].get()
                    if curr > 1:
                        self.alert_multipliers[s_id].set(curr - 1)
                        update_multiplier_summary(s_id, lbl)
                return h

            def make_add_handler(s_id, lbl):
                def h():
                    curr = self.alert_multipliers[s_id].get()
                    if curr < 10:
                        self.alert_multipliers[s_id].set(curr + 1)
                        update_multiplier_summary(s_id, lbl)
                return h

            btn_sub.config(command=make_sub_handler(service['id'], lbl_count_summary))
            btn_add.config(command=make_add_handler(service['id'], lbl_count_summary))
            
            # Initial multiplier run state configuration
            update_multiplier_summary(service['id'], lbl_count_summary)
            service['multiplier_summary_callback'] = lambda s_id=service['id'], lbl=lbl_count_summary: update_multiplier_summary(s_id, lbl)

            # Integration API key input
            tk.Label(card, text="Alert Integration Key:", font=('Helvetica', 8, 'bold'), bg="#ffffff", fg="#4b5563").pack(anchor="w", padx=12)
            key_entry = ttk.Entry(card, textvariable=self.routing_keys[service['id']], font=('Consolas', 9))
            key_entry.pack(fill="x", padx=12, pady=(2, 8))

            # Trigger Actions Toolbar
            btn_box = tk.Frame(card, bg="#ffffff")
            btn_box.pack(fill="x", padx=12, pady=(0, 12))

            btn_send = tk.Button(btn_box, text="🚨 Send Alert", font=('Helvetica', 10, 'bold'), bg="#dc2626", fg="white", activebackground="#b91c1c", activeforeground="white", bd=0, padx=6, pady=6, cursor="hand2")
            btn_send.pack(fill="x", pady=(0, 4))
            
            self.sending_states[service['id']] = btn_send

            def make_send_handler(s=service):
                return lambda: self.on_trigger_alert(s)
            btn_send.config(command=make_send_handler(service))

            btn_payload = tk.Button(btn_box, text="📋 View Payload", font=('Helvetica', 9), bg="#4b5563", fg="white", activebackground="#374151", activeforeground="white", bd=0, padx=4, pady=4, cursor="hand2")
            btn_payload.pack(fill="x")

            def make_payload_handler(s=service):
                return lambda: self.show_alert_payload_modal(s)
            btn_payload.config(command=make_payload_handler(service))

    def render_alert_item(self, parent, service, alert, index):
        state_key = f"{service['id']}_{index}"
        self.selected_alerts[state_key] = False

        item_frame = tk.Frame(parent, bg="#ffffff", bd=1, highlightbackground="#e5e7eb", highlightthickness=1)
        item_frame.pack(fill="x", pady=2)

        lbl_check = tk.Label(item_frame, text="  ", font=('Helvetica', 9, 'bold'), bg="#ffffff", fg="#2563eb", width=3)
        lbl_check.pack(side="left")

        summary_text = alert['title'].split(':')[-1].strip()
        lbl_summary = tk.Label(item_frame, text=summary_text, font=('Helvetica', 9), bg="#ffffff", fg="#374151", anchor="w", wraplength=260, justify="left")
        lbl_summary.pack(side="left", fill="x", expand=True, padx=4, pady=4)

        # Toggle handler for interactive selections
        def toggle_select(e, sk=state_key, f=item_frame, chk=lbl_check, s=service):
            self.selected_alerts[sk] = not self.selected_alerts[sk]
            if self.selected_alerts[sk]:
                f.config(bg="#eff6ff", highlightbackground="#3b82f6", highlightthickness=1)
                chk.config(text="✓", bg="#eff6ff")
                lbl_summary.config(bg="#eff6ff", fg="#1e3a8a", font=('Helvetica', 9, 'bold'))
            else:
                f.config(bg="#ffffff", highlightbackground="#e5e7eb", highlightthickness=1)
                chk.config(text="  ", bg="#ffffff")
                lbl_summary.config(bg="#ffffff", fg="#374151", font=('Helvetica', 9))
            
            # Fire update state logic hook
            if 'multiplier_summary_callback' in s:
                s['multiplier_summary_callback']()

        item_frame.bind("<Button-1>", toggle_select)
        lbl_check.bind("<Button-1>", toggle_select)
        lbl_summary.bind("<Button-1>", toggle_select)

        # Ensure correct cursor hand indicator
        item_frame.config(cursor="hand2")
        lbl_check.config(cursor="hand2")
        lbl_summary.config(cursor="hand2")

    def render_cmms_change_events(self):
        section_frame = tk.Frame(self.scrollable_frame, bg="#f3f4f6")
        section_frame.pack(fill="x", pady=15)

        title = tk.Label(section_frame, text="CMMS Change Events (Maintenance Windows)", font=('Helvetica', 14, 'bold'), bg="#f3f4f6", fg="#1f2937")
        title.pack(anchor="w", pady=(0, 6))

        desc = tk.Label(section_frame, text="Send change events from CMMS to PagerDuty to track maintenance activities and automatically correlate with active alerts.", font=('Helvetica', 9, 'italic'), bg="#f3f4f6", fg="#4b5563")
        desc.pack(anchor="w", pady=(0, 10))

        # 3 Column change event panels
        grid_frame = tk.Frame(section_frame, bg="#f3f4f6")
        grid_frame.pack(fill="x", expand=True)
        grid_frame.columnconfigure(0, weight=1)
        grid_frame.columnconfigure(1, weight=1)
        grid_frame.columnconfigure(2, weight=1)

        for idx, change in enumerate(SAMPLE_CHANGE_EVENTS):
            row = idx // 3
            col = idx % 3

            card = tk.Frame(grid_frame, bg=change['bg_color'], bd=1, highlightbackground=change['color'], highlightthickness=1)
            card.grid(row=row, column=col, padx=8, pady=8, sticky="nsew")

            lbl_icon = tk.Label(card, text=change['icon'], font=('Helvetica', 18), bg=change['bg_color'])
            lbl_icon.pack(anchor="w", padx=12, pady=(12, 4))

            lbl_title = tk.Label(card, text=change['summary'].split(' - ')[0], font=('Helvetica', 11, 'bold'), fg="#1e293b", bg=change['bg_color'], wraplength=280, justify="left")
            lbl_title.pack(anchor="w", padx=12, pady=2)

            lbl_type = tk.Label(card, text=change['type'], font=('Helvetica', 8, 'bold'), fg=change['color'], bg=change['bg_color'])
            lbl_type.pack(anchor="w", padx=12, pady=(0, 8))

            # Integration change key configuration field
            tk.Label(card, text="Change Event Integration Key:", font=('Helvetica', 8, 'bold'), bg=change['bg_color'], fg="#4b5563").pack(anchor="w", padx=12)
            key_entry = ttk.Entry(card, textvariable=self.change_event_keys[change['serviceId']], font=('Consolas', 9))
            key_entry.pack(fill="x", padx=12, pady=(2, 8))

            # Trigger Actions Toolbar
            btn_box = tk.Frame(card, bg=change['bg_color'])
            btn_box.pack(fill="x", padx=12, pady=(0, 12))

            btn_send = tk.Button(btn_box, text="🔄 Send Change Event", font=('Helvetica', 9, 'bold'), bg=change['color'], fg="white", activebackground="#374151", activeforeground="white", bd=0, padx=5, pady=5, cursor="hand2")
            btn_send.pack(side="left", fill="x", expand=True, padx=(0, 4))

            self.sending_states[change['id']] = btn_send

            def make_change_handler(c=change):
                return lambda: self.on_trigger_change(c)
            btn_send.config(command=make_change_handler(change))

            btn_payload = tk.Button(btn_box, text=" 📋 ", font=('Helvetica', 9, 'bold'), bg="#475569", fg="white", activebackground="#1e293b", activeforeground="white", bd=0, padx=5, pady=5, cursor="hand2")
            btn_payload.pack(side="right")

            def make_change_payload_handler(c=change):
                return lambda: self.show_change_payload_modal(c)
            btn_payload.config(command=make_change_payload_handler(change))

    def render_escalation_policies(self):
        card = tk.Frame(self.scrollable_frame, bg="#ffffff", bd=1, highlightbackground="#e5e7eb", highlightthickness=1)
        card.pack(fill="x", pady=10)

        title = tk.Label(card, text="Escalation Policies by Severity", font=('Helvetica', 14, 'bold'), bg="#ffffff", fg="#1f2937", anchor="w")
        title.pack(fill="x", padx=16, pady=(16, 12))

        grid_frame = tk.Frame(card, bg="#ffffff")
        grid_frame.pack(fill="x", padx=16, pady=(0, 16))
        grid_frame.columnconfigure(0, weight=1)
        grid_frame.columnconfigure(1, weight=1)

        for idx, (policy, steps) in enumerate(ESCALATION_POLICIES.items()):
            row = idx // 2
            col = idx % 2

            p_frame = tk.Frame(grid_frame, bg="#ffffff", bd=1, highlightbackground="#f3f4f6", highlightthickness=1, padx=12, pady=12)
            p_frame.grid(row=row, column=col, padx=6, pady=6, sticky="nsew")

            tk.Label(p_frame, text=policy, font=('Helvetica', 11, 'bold'), bg="#ffffff", fg="#1f2937").pack(anchor="w", pady=(0, 8))

            for step_idx, step in enumerate(steps):
                step_row = tk.Frame(p_frame, bg="#ffffff")
                step_row.pack(fill="x", pady=2)

                num_badge = tk.Label(step_row, text=str(step_idx + 1), font=('Helvetica', 8, 'bold'), bg="#2563eb", fg="white", width=2, height=1)
                num_badge.pack(side="left", padx=(0, 8))

                step_lbl = tk.Label(step_row, text=step, font=('Helvetica', 9), bg="#ffffff", fg="#4b5563")
                step_lbl.pack(side="left")

    def render_key_features(self):
        card = tk.Frame(self.scrollable_frame, bg="#ffffff", bd=1, highlightbackground="#e5e7eb", highlightthickness=1)
        card.pack(fill="x", pady=(10, 20))

        title = tk.Label(card, text="Key App Features & Scenario Mapping", font=('Helvetica', 14, 'bold'), bg="#ffffff", fg="#1f2937", anchor="w")
        title.pack(fill="x", padx=16, pady=(16, 12))

        feats_frame = tk.Frame(card, bg="#ffffff")
        feats_frame.pack(fill="x", padx=16, pady=(0, 16))
        feats_frame.columnconfigure(0, weight=1)
        feats_frame.columnconfigure(1, weight=1)

        f1 = tk.Frame(feats_frame, bg="#ffffff")
        f1.grid(row=0, column=0, sticky="nsew", padx=10, pady=4)
        tk.Label(f1, text="✓ Multi-Alert Selection & Repeat", font=('Helvetica', 10, 'bold'), bg="#ffffff", fg="#15803d").pack(anchor="w")
        tk.Label(f1, text="Configure batch operations: select multiple simulated problems and replay them sequentially with specific repetition factors (1-10x) to test event cascades.", font=('Helvetica', 9), bg="#ffffff", fg="#4b5563", wraplength=500, justify="left").pack(anchor="w", padx=16)

        f2 = tk.Frame(feats_frame, bg="#ffffff")
        f2.grid(row=0, column=1, sticky="nsew", padx=10, pady=4)
        tk.Label(f2, text="✓ Contextual Integration Keys", font=('Helvetica', 10, 'bold'), bg="#ffffff", fg="#15803d").pack(anchor="w")
        tk.Label(f2, text="Dynamically configure independent event streams by customizing endpoints and tokens on a per-service level directly from the interface.", font=('Helvetica', 9), bg="#ffffff", fg="#4b5563", wraplength=500, justify="left").pack(anchor="w", padx=16)

    # --- GET STATE INFRASTRUCTURE ---

    def get_selected_alerts_count(self, service_id):
        return sum(1 for a_idx in range(3) if self.selected_alerts.get(f"{service_id}_{a_idx}", False))

    def get_selected_alert_indices(self, service_id):
        return [a_idx for a_idx in range(3) if self.selected_alerts.get(f"{service_id}_{a_idx}", False)]

    # --- PAYLOAD & ALERT CONSTRUCTORS ---

    def create_alert_payload(self, service, alert):
        return {
            "routing_key": self.routing_keys[service['id']].get() or "YOUR_INTEGRATION_KEY_HERE",
            "event_action": "trigger",
            "dedup_key": f"{service['id']}-{int(time.time())}-{random.randint(1000, 9999)}",
            "payload": {
                "summary": alert['title'],
                "source": alert['details'].split(':')[0] or service['name'],
                "severity": alert['severity'],
                "timestamp": datetime.utcnow().isoformat() + "Z",
                "component": service['name'],
                "group": "Datacenter BMS",
                "class": "Niagara Alert",
                "custom_details": {
                    "alert_details": alert['details'],
                    "location": "Sydney Datacenter",
                    "bms_system": "Niagara Framework",
                    "service_id": service['id']
                }
            },
            "links": [{
                "href": "https://bms.example.com/alerts",
                "text": "View in BMS"
            }]
        }

    def create_change_payload(self, change):
        return {
            "routing_key": self.change_event_keys[change['serviceId']].get() or "YOUR_INTEGRATION_KEY_HERE",
            "payload": {
                "summary": change['summary'],
                "timestamp": datetime.utcnow().isoformat() + "Z",
                "source": "CMMS",
                "custom_details": {
                    "change_id": change['id'],
                    "change_type": change['type'],
                    "description": change['description'],
                    "service_id": change['serviceId'],
                    "location": "Sydney Datacenter",
                    "system": "CMMS"
                }
            },
            "links": [{
                "href": "https://cmms.example.com/changes",
                "text": "View in CMMS"
            }]
        }

    # --- ASYNC DISPATCH NETWORK HANDLERS ---

    def on_trigger_alert(self, service):
        selected_indices = self.get_selected_alert_indices(service['id'])
        
        # If none selected, choose 1 randomly
        if not selected_indices:
            selected_indices = [random.randint(0, len(service['sampleAlerts']) - 1)]

        repeat_factor = self.alert_multipliers[service['id']].get()
        
        btn = self.sending_states.get(service['id'])
        if btn:
            btn.config(text="⏳ Sending...", state="disabled", bg="#9ca3af")

        # Offload HTTP queuing sequence to Background Thread
        thread = threading.Thread(
            target=self.dispatch_alerts_thread_queue, 
            args=(service, selected_indices, repeat_factor),
            daemon=True
        )
        thread.start()

    def dispatch_alerts_thread_queue(self, service, indices, multiplier):
        failures = 0
        successes = 0
        status_code = None
        response_body = ""

        total_runs = len(indices) * multiplier
        current_run = 0

        for alert_idx in indices:
            alert = service['sampleAlerts'][alert_idx]
            for _ in range(multiplier):
                current_run += 1
                payload = self.create_alert_payload(service, alert)
                
                # API Endpoint Dispatch
                ok, code, res = self.post_pd_endpoint("https://events.pagerduty.com/v2/enqueue", payload)
                
                if ok:
                    successes += 1
                    status_code = code
                    response_body = res
                else:
                    failures += 1
                    status_code = code
                    response_body = res

                # Introduce minimal pacing delay for multiple rapid fires
                if total_runs > 1 and current_run < total_runs:
                    time.sleep(0.4)

        # Reschedule UI updating on the TK Inter Main Loop Thread safely
        self.root.after(0, lambda: self.on_api_completed(
            service_name=service['name'],
            success=(failures == 0),
            success_count=successes,
            fail_count=failures,
            status_code=status_code,
            response_body=response_body,
            btn_key=service['id'],
            reset_text="🚨 Send Alert",
            active_color="#dc2626",
            hover_color="#b91c1c"
        ))

    def on_trigger_change(self, change):
        btn = self.sending_states.get(change['id'])
        if btn:
            btn.config(text="⏳ Sending...", state="disabled", bg="#9ca3af")

        thread = threading.Thread(
            target=self.dispatch_change_thread, 
            args=(change,),
            daemon=True
        )
        thread.start()

    def dispatch_change_thread(self, change):
        payload = self.create_change_payload(change)
        ok, code, res = self.post_pd_endpoint("https://events.pagerduty.com/v2/change/enqueue", payload)

        self.root.after(0, lambda: self.on_api_completed(
            service_name=f"CMMS: {change['summary'].split(' - ')[0]}",
            success=ok,
            success_count=1 if ok else 0,
            fail_count=0 if ok else 1,
            status_code=code,
            response_body=res,
            btn_key=change['id'],
            reset_text="🔄 Send Change Event",
            active_color=change['color'],
            hover_color="#374151"
        ))

    def post_pd_endpoint(self, url, payload):
        try:
            req_data = json.dumps(payload).encode('utf-8')
            req = urllib.request.Request(
                url,
                data=req_data,
                headers={'Content-Type': 'application/json'},
                method='POST'
            )
            with urllib.request.urlopen(req, timeout=10) as response:
                body = response.read().decode('utf-8')
                return True, response.status, body
        except urllib.error.HTTPError as e:
            try:
                err_body = e.read().decode('utf-8')
            except Exception:
                err_body = e.reason
            return False, e.code, err_body
        except Exception as e:
            return False, 500, str(e)

    def on_api_completed(self, service_name, success, success_count, fail_count, status_code, response_body, btn_key, reset_text, active_color, hover_color):
        # Restore native widget trigger button UI state
        btn = self.sending_states.get(btn_key)
        if btn:
            btn.config(text=reset_text, state="normal", bg=active_color)

        # Parse output fields
        dedup = "N/A"
        if response_body:
            try:
                res_json = json.loads(response_body)
                dedup = res_json.get('dedup_key', res_json.get('status', 'N/A'))
            except Exception:
                dedup = response_body[:60]

        # Toast status details formulation
        if success:
            title = f"✅ Enqueue Complete: {service_name}"
            msg = f"Requests successful: {success_count}. API Status: {status_code}. Key: {dedup}"
            self.show_toast(True, title, msg)
        else:
            title = f"❌ Event Failed: {service_name}"
            msg = f"Failed calls: {fail_count}. Status: {status_code}. Details: {dedup}"
            self.show_toast(False, title, msg)

    # --- MODAL FRAMEWORK WINDOWS (Top-Level Dialogs) ---

    def create_modal_scaffold(self, title_text, width=650, height=520):
        modal = tk.Toplevel(self.root)
        modal.title(title_text)
        modal.geometry(f"{width}x{height}")
        modal.configure(bg="#ffffff")
        modal.transient(self.root)
        modal.grab_set()

        # Center top level overlay safely on top of parent window geometry coordinates
        parent_x = self.root.winfo_rootx()
        parent_y = self.root.winfo_rooty()
        parent_w = self.root.winfo_width()
        parent_h = self.root.winfo_height()
        
        pos_x = parent_x + (parent_w - width) // 2
        pos_y = parent_y + (parent_h - height) // 2
        modal.geometry(f"+{pos_x}+{pos_y}")

        return modal

    def show_service_details_modal(self, service):
        modal = self.create_modal_scaffold(f"Technical Service: {service['name']}", 520, 420)

        hdr = tk.Frame(modal, bg=service['bg_color'], pady=16)
        hdr.pack(fill="x")
        tk.Label(hdr, text=f"{service['icon']}  {service['name']}", font=('Helvetica', 14, 'bold'), bg=service['bg_color'], fg="#111827").pack()

        body = tk.Frame(modal, bg="#ffffff", padx=18, pady=16)
        body.pack(fill="both", expand=True)

        tk.Label(body, text="Active BMS Outlets Configured:", font=('Helvetica', 10, 'bold'), bg="#ffffff", fg="#1f2937").pack(anchor="w", pady=(0, 4))
        for alert in service['sampleAlerts']:
            item = tk.Frame(body, bg="#f9fafb", bd=1, highlightbackground="#e5e7eb", highlightthickness=1, padx=8, pady=8)
            item.pack(fill="x", pady=3)
            tk.Label(item, text=alert['title'], font=('Helvetica', 9, 'bold'), bg="#f9fafb", fg="#ef4444" if alert['severity']=='critical' else "#ca8a04").pack(anchor="w")
            tk.Label(item, text=alert['details'], font=('Helvetica', 8), bg="#f9fafb", fg="#4b5563", wraplength=450, justify="left").pack(anchor="w")

        tk.Label(body, text="Escalation Teams Assigned:", font=('Helvetica', 10, 'bold'), bg="#ffffff", fg="#1f2937").pack(anchor="w", pady=(12, 4))
        teams_frame = tk.Frame(body, bg="#ffffff")
        teams_frame.pack(fill="x")
        for team in service['teams']:
            tk.Label(teams_frame, text=f"  {team}  ", font=('Helvetica', 8, 'bold'), bg="#eff6ff", fg="#1e40af", relief="solid", bd=1).pack(side="left", padx=3)

        tk.Button(modal, text="Close Details Window", font=('Helvetica', 10, 'bold'), bg="#1f2937", fg="white", activebackground="#374151", activeforeground="white", bd=0, padx=8, pady=8, command=modal.destroy, cursor="hand2").pack(fill="x", side="bottom", padx=18, pady=18)

    def show_alert_payload_modal(self, service):
        alert = service['sampleAlerts'][0]
        payload = self.create_alert_payload(service, alert)
        self.show_json_modal(
            title=f"Sample Alert Payload - {service['name']}",
            subtitle="POST https://events.pagerduty.com/v2/enqueue",
            badge_text="PagerDuty Events API v2",
            badge_color="#eff6ff",
            badge_text_color="#1e40af",
            payload=payload
        )

    def show_change_payload_modal(self, change):
        payload = self.create_change_payload(change)
        self.show_json_modal(
            title="CMMS Work Order Payload",
            subtitle="POST https://events.pagerduty.com/v2/change/enqueue",
            badge_text="PagerDuty Change Events API",
            badge_color="#faf5ff",
            badge_text_color="#6b21a8",
            payload=payload
        )

    def show_json_modal(self, title, subtitle, badge_text, badge_color, badge_text_color, payload):
        modal = self.create_modal_scaffold(title, 640, 560)

        # Header Title bar
        hdr = tk.Frame(modal, bg="#ffffff", padx=16, pady=12)
        hdr.pack(fill="x")

        tk.Label(hdr, text=title, font=('Helvetica', 14, 'bold'), bg="#ffffff", fg="#1f2937", anchor="w").pack(fill="x")
        tk.Label(hdr, text=subtitle, font=('Consolas', 9), bg="#ffffff", fg="#2563eb", anchor="w").pack(fill="x", pady=2)

        badge_box = tk.Frame(hdr, bg=badge_color, bd=1, relief="solid")
        badge_box.pack(anchor="w", pady=4)
        tk.Label(badge_box, text=f"  {badge_text}  ", font=('Helvetica', 8, 'bold'), bg=badge_color, fg=badge_text_color).pack()

        # Text Code Editor Container
        editor_frame = tk.Frame(modal, bg="#1e293b", padx=8, pady=8)
        editor_frame.pack(fill="both", expand=True, padx=16)

        text_area = tk.Text(editor_frame, font=('Consolas', 10), bg="#1e293b", fg="#34d399", insertbackground="white", selectbackground="#475569", bd=0)
        scroll = ttk.Scrollbar(editor_frame, orient="vertical", command=text_area.yview)
        text_area.configure(yscrollcommand=scroll.set)

        scroll.pack(side="right", fill="y")
        text_area.pack(side="left", fill="both", expand=True)

        # Write Pretty Formatted JSON to Screen
        json_str = json.dumps(payload, indent=2)
        text_area.insert("1.0", json_str)
        text_area.config(state="disabled")

        # Action bar Footer buttons
        footer = tk.Frame(modal, bg="#ffffff", padx=16, pady=16)
        footer.pack(fill="x", side="bottom")

        def copy_to_clipboard():
            self.root.clipboard_clear()
            self.root.clipboard_append(json_str)
            btn_copy.config(text="✓ Copied JSON Data", bg="#16a34a")
            self.root.after(2000, lambda: btn_copy.config(text="📋 Copy JSON Payload", bg="#2563eb") if btn_copy.winfo_exists() else None)

        btn_copy = tk.Button(footer, text="📋 Copy JSON Payload", font=('Helvetica', 10, 'bold'), bg="#2563eb", fg="white", activebackground="#1d4ed8", activeforeground="white", bd=0, padx=8, pady=8, command=copy_to_clipboard, cursor="hand2")
        btn_copy.pack(side="left", fill="x", expand=True, padx=(0, 6))

        btn_close = tk.Button(footer, text="Close View", font=('Helvetica', 10, 'bold'), bg="#4b5563", fg="white", activebackground="#374151", activeforeground="white", bd=0, padx=8, pady=8, command=modal.destroy, cursor="hand2")
        btn_close.pack(side="right", fill="x", expand=True, padx=(6, 0))


if __name__ == "__main__":
    root = tk.Tk()
    app = PagerDutyDemoApp(root)
    root.mainloop()