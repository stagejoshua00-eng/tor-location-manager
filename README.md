# tor-location-manager

A robust Tor exit-location manager for authorized Kali Linux use. This project gives you a practical way to:

- scrape Tor exit relay metadata and save it locally
- review saved entries with country, region, city, timezone, and IP details
- select a saved Tor exit record and apply a Tor exit-node override
- rotate Tor identity every 2 minutes using the Tor control port
- validate the active Tor IP and log operational events

This tool is designed for systems you own or are explicitly authorized to test. It is not a guarantee of bypassing restrictions or forcing a specific IP address at all times. The actual exit capability is controlled by the Tor network and relay availability.

## Features

- Menu-driven workflow
- Safe backup of modified Tor files
- JSON persistence for scraped data
- Tor control port NEWNYM rotation
- Validation using `curl` and the Tor Project check endpoint
- Clear logging to `~/.tor-location-manager/tor_location_manager.log`

## Requirements

- Kali Linux 64-bit
- Python 3.10+
- Tor installed and running
- root privileges
- `curl` and `python3-pip`

## Installation

Run the installer as root:

```bash
sudo bash install.sh
```

The installer will:

- install Tor and required packages
- install Python dependencies from `requirements.txt`
- create the configuration directory
- add the Tor include directive if missing
- prepare the Tor config override file

## Running the app

Start the menu-driven app:

```bash
sudo ./run.sh
```

Or run directly:

```bash
sudo python3 tor_location_manager.py
```

## Menu options

1. Scrape Tor exit data and save
   - Contacts Onionoo for Tor relay metadata
   - Stores a JSON list of exit entries locally

2. Select a saved location and apply it
   - Shows the saved exit records
   - Lets you choose one by number
   - Writes a Tor override config using `ExitNodes {XX}` and `StrictNodes 1`
   - Restarts Tor and validates the resulting public IP

3. Rotate Tor identity every 2 minutes
   - Uses the Tor control port to issue `SIGNAL NEWNYM`
   - Keeps rotating every 120 seconds until interrupted
   - Validates the current Tor IP after each cycle

4. Exit
   - Ends the program cleanly

## Important behavior notes

- Tor network availability controls the actual exit nodes that are possible.
- `ExitNodes {XX}` is a strong hint that tells Tor to prefer the given country, but it is not a guarantee of successful exit-node selection.
- `StrictNodes 1` can make Tor fail to connect if the selected country is unavailable.
- For environment stability, the script keeps backups and logs all events.

## File overview

- `tor_location_manager.py` — main application logic
- `install.sh` — installs dependencies and prepares Tor
- `run.sh` — runs the tool as root
- `requirements.txt` — Python package requirements
- `torrc.d/tor_location_manager.conf` — initial Tor override config
- `README.md` — documentation

## Safety / authorized use

This utility is intended for legitimate educational, defensive, and authorized testing scenarios only. The operator must ensure they have explicit permission to test the network or environment involved. The developers and contributors are not responsible for unauthorized or harmful use.

## License

MIT
