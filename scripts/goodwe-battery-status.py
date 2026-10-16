#!/usr/bin/env python3
import asyncio
import json
import sys

import goodwe

async def main():
    host = sys.argv[1] if len(sys.argv) > 1 else "192.168.0.22"
    try:
        inverter = await goodwe.connect(host)
        data = await inverter.read_runtime_data()
        result = {
            "soc": data.get("battery_soc", -1),
            "power": data.get("battery_power", 0),
            "mode": data.get("battery_mode_label", "Unknown"),
            "voltage": data.get("battery_voltage", 0),
            "temperature": data.get("battery_temperature", 0),
        }
        # power > 0 means discharging, < 0 means charging (GoodWe convention)
        # but battery_mode_label is more reliable
        mode_label = str(result["mode"]).lower()
        if "charge" in mode_label and "discharge" not in mode_label:
            result["charging"] = True
        elif "discharge" in mode_label:
            result["charging"] = False
        else:
            result["charging"] = result["power"] < 0
        print(json.dumps(result))
    except Exception as e:
        print(json.dumps({"soc": -1, "error": str(e), "charging": False}))
        sys.exit(1)

asyncio.run(main())
