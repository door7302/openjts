# Start OpenJTS

## Start the Stack

To start OpenJTS, deploy the stack using Docker Compose.

```shell
# Start the stack (single Telegraf instance)
cd compose/
sudo docker compose up -d
```

## Verify Containers

You can verify that all containers are running with:

```shell
sudo docker compose ps
```

> Note: Telegraf containers are started only if at least one router is assigned to the corresponding instance.

## JTS Logs

JTS logs are written to:

```
/var/log/jtso.log
```

## Stop the Stack

To stop and remove the running containers:

```shell
cd compose/
sudo docker compose down
```

## Managing the Stack via JTSO

Once the stack is running, access the JTSO portal:

```
http(s)://<your-ip>:<your-port>/index.html
```

The main page provides:

- Stack status overview
- InfluxDB database full cleanup via the **Clear DB** button
- Change the InfluxDB database retention policy value via the **Change Retention** button
- Direct access to Chronograf (InfluxDB & Kapacitor management)
- Direct access to Grafana via the **Open** button

![jtso-main.png](./img/jtso-main.png)

A dark theme is available (top-right corner):

![jtso-dark.png](./img/jtso-dark.png)

### Telegraf Containers Overview

Each Telegraf container displays two indicators:

- **Left number** → Number of routers assigned to the container
- **Right "D" button** → Enables Debug mode

When Debug is enabled, the container restarts automatically in debug mode.  
The button turns **red** when active.

⚠️ Debug mode generates large log files. Use it only for troubleshooting.

![jtso-debug.png](./img/jtso-debug.png)

## Change Settings

Go to:

```
Admin > Settings
```

![jtso-settings-1.png](./img/jtso-settings-1.png)

### Change Credentials 

Here you must configure:

- NETCONF username/password
- gNMI username/password

> **Note**: Default credential for both protocols is lab/lab123

⚠️ **These credentials must be identical across all routers**

### Enabling/Disabling gNMI TLS

You can also configure:

- Enable/Disable TLS for gNMI (global setting)
- Skip certificate verification (enabled by default)
- Client-side TLS authentication (disabled by default)

⚠️ **TLS configuration is global: either all routers use TLS or none**

> **Note**: By default the tool uses clear-text mode for gNMI 

### Enable Kafka export

You could use Kafka export in parallel of the data injestion into InfluxDB. 

> **Note*: Kafka is not part of the stack

Make sure the OpenJTS VM will be able to connect to Kafka bus, otherwise the telegraf instances should continoustly reboot. 

![jtso-settings-2.png](./img/jtso-settings-2.png)

External Kafka export applies to all profiles including On-demand profile. As of now, several Kafka Brokers may be configured, but only one Topic is allowed today. You could configure:

- **Kafka Brokers**: a list of tuple (address:port) seperated with a comma
- **Kafka Topic**: the topic on which to produce
- **Kafka Version**: the version of the Kafka bus
- **Kafka Format**: the encoding format - today only **json** or **influx** format are supported 
- **Kafka Compression**: the supported codec are: **none**, **gzip**, **snappy**, **lz4** and **zstd**
- **Kafka Max Message Size**: Value in bytes - default value is **1MB**

## Configure Inventory

Go to:

```
Routers
```

For each router, configure:

- A unique short name (internal reference)
- IP address or hostname

JTSO will automatically establish a NETCONF session to retrieve device facts (model, version, etc.).

![jtso-rtrs.png](./img/jtso-rtrs.png)

You can also import a CSV file. The required format is shown by clicking the **Info** button or as below:

```csv
shortName;hostName
```

Alternatively, to refresh a router's facts, click the refresh **icon** next to the desired router. You may also remove a router by clicking on the delete **icon**. 


## Profiles Management

Go to:

```
Profiles > Management
```

This section provides:

- Sensors and counters used per profile
- Telegraf configuration details per-platform/version 
- Included Grafana dashboards
- Modification of the streaming **interval** rates. 

![jtso-docs-1.png](./img/jtso-docs-1.png)

You can click on the **Config** button of a given Platform/Version to inspect the JSON definition used by JTSO.

This JSON file will be dynamically rendered into a Telegraf TOML configuration file (See. Profiles Association section)

![jtso-docs-2.png](./img/jtso-docs-2.png)

By clicking the **Sensors** button, you can view:

- The sensors used by the profile
- The sensor origin: **native** or **openconfig**
- The default or modified interval rate
- Sensor aliases, if any
- A list of leaves (counters) collected and stored in the database

![jtso-docs-3.png](./img/jtso-docs-3.png)

You can change the default interval rate for each sensor (minimum 2 seconds) by clicking the **Modify Interval(s)** button.  

![jtso-docs-4.png](./img/jtso-docs-4.png)

⚠️ This change applies profile-wide, affecting all platforms and versions.  
You can revert to the default interval by clicking the **Reset to Default** button.

## Profiles Associations

Go to:

```
Profiles > Associations
```

From this page, you can assign or remove profiles for each router.  
Any modification automatically triggers a stack reconfiguration.

![jtso-profile-1.png](./img/jtso-profile-1.png)

You can also import a CSV file. The required format is displayed by clicking the **Info** button or as shown below:

```csv
shortName;profile1;profile2;profile3
```

Once profiles are assigned, they are combined to generate a Telegraf configuration.  
To view the full aggregated Telegraf TOML configuration, click the green **file** icon:

![jtso-profile-2.png](./img/jtso-profile-2.png)

## Browse a Sensor Path 

Go to:

```
Tools > Gnmi Browser
```

Steps:

1. Select a router
2. Enter a sensor path
3. Click Analyze

The **Merge** option replaces numeric keys with `X` for easier analysis.  
Uncheck Merge for full XPath expansion.

![jtso-browser-1.png](./img/jtso-browser-1.png)

Analysis takes approximately one minute. Number of extracted XPaths are displayed in real time:

![jtso-browser-2.png](./img/jtso-browser-2.png)

You can then export the full XPath list by clicking on the **export** button.

![jtso-browser-3.png](./img/jtso-browser-3.png)

Results are displayed in tree view format:

- Expand/Collapse tree
- Search within tree (matches highlighted in yellow)

![jtso-browser-4.png](./img/jtso-browser-4.png)

## Create On-Demand Graph

This feature is designed for troubleshooting purposes when existing profiles are not sufficient.

> At the time of writing, the On-Demand Graph supports **only one custom profile at a time**.

It also provides a simple way to share custom profiles created by end users with the OpenJTS maintainer. This helps speed up the integration of new profiles by supplying a JSON configuration file (see below).

```
Tools > On-Demand Graph
```

The main On-Demand Graph UI is shown below:

![jtso-ondemand-1.png](./img/jtso-ondemand-1.png)

### Adding Sensors

There are two ways to add sensors:

- **Manual** (more complex)
- **Assisted** (recommended when state data is available on devices)

For both approaches, you must first enter a sensor path in the corresponding input field:

![jtso-ondemand-2.png](./img/jtso-ondemand-2.png)

### Manual Configuration

Manual configuration is available using the **+ Field** and **+ Alias** buttons.

Clicking on **+ Field** opens the following dialog:

![jtso-ondemand-3.png](./img/jtso-ondemand-3.png)

You can enter either:
- A full field path, or
- A relative path from the previously entered sensor path

To use a relative path, prefix it with `./`.

You can apply two optional pre-processing operations on a field:

- **Convert to float** before ingesting into the database (useful if the original value is a string)
- **Compute rate** before ingestion (highly recommended for incremental counters such as `in-bytes`, `in-packets`, etc.)

You may also associate a list (sperated with comma) of tags (**full XPath keys is required**) with the field.

Aliases can be added using the **+ Alias** button. This is useful when legacy paths are redirected to other paths (often OpenConfig paths). Telegraf must be aware of these aliases to subscribe correctly.

![jtso-ondemand-4.png](./img/jtso-ondemand-4.png)

Once configured manually, you should see the selected fields, tags, and aliases:

![jtso-ondemand-5.png](./img/jtso-ondemand-5.png)

### Assisted Configuration (Recommended)

The assisted method is recommended when routers expose the desired state data and are reachable by OpenJTS.

After entering a sensor path, click on **Analyze path instead**. This opens a new window where you can:

1. Select a router with available state data
2. Click **Launch a gNMI collect**

![jtso-ondemand-6.png](./img/jtso-ondemand-6.png)

Wait approximately one minute while OpenJTS collects the initial state data. Once completed, a list of available fields (leaves), tags, and aliases is displayed:

![jtso-ondemand-7.png](./img/jtso-ondemand-7.png)

Tags are automatically inherited and do not require selection.

In most cases, aliases with the same prefix as the original sensor path do not need to be selected. If unsure, you may include them.

For each available field, select:
- The fields to monitor
- Whether to compute a **rate** (recommended for incremental counters)
- Whether to convert the value to **float**

Once your selection is complete, click **Monitor**. The selected fields, tags, and aliases will appear, similar to the manual method:

![jtso-ondemand-8.png](./img/jtso-ondemand-8.png)

### Finalizing the Sensor Path

Set the collection interval (in seconds), then click **Add Path**.  
The configured path will appear in the lower table:

![jtso-ondemand-9.png](./img/jtso-ondemand-9.png)

You can repeat the process to add additional paths.

### Profile Management

Save your profile once it is ready (you can save at any time).  
An unsaved profile is indicated by a **red floppy disk** icon:

![jtso-ondemand-10.png](./img/jtso-ondemand-10.png)

If the profile has never been saved, it will retain the default name `no-name`.

From left to right, the available profile actions are:

- **Load**: Load an existing on-demand profile from the OpenJTS server
- **Save**: Save the current on-demand profile to the OpenJTS server
- **Save As**: Save a copy of the on-demand profile under a new name
- **Export**: Export the on-demand profile as a JSON file to the local machine

> **Export** is useful for sharing troubleshooting details or requesting the creation of a native OpenJTS profile via a GitHub issue.

Once saved, the red floppy disk icon disappears:

![jtso-ondemand-11.png](./img/jtso-ondemand-11.png)

### Device Selection and Data Collection

Select the devices to which the on-demand profile should apply, then click **Update Devices**:

![jtso-ondemand-12.png](./img/jtso-ondemand-12.png)

Three controls are available for managing data collection:

![jtso-ondemand-13.png](./img/jtso-ondemand-13.png)

- **Start / Stop**: Start or stop data collection
- **Clear On-Demand DB**: Remove only data collected by on-demand profiles
- **Reset All**: Reset the On-Demand Graph tool to a blank state

When data collection is running, a blinking **red circle** indicates active collection:

![jtso-ondemand-14.png](./img/jtso-ondemand-14.png)

You may leave this page; data collection continues in the background.  
On the main page, the On-Demand Telegraf instance appears **UP**, showing the number of active routers (2 in this example):

![jtso-ondemand-15.png](./img/jtso-ondemand-15.png)

### Grafana Dashboard

A dedicated Grafana dashboard is automatically created:

![jtso-ondemand-16.png](./img/jtso-ondemand-16.png)

- One **row** is created per sensor path
- One **panel** is created per field
- All tags are converted into Grafana **variables** at the top of the dashboard

![jtso-ondemand-17.png](./img/jtso-ondemand-17.png)

## Monitor Stack Performance

Go to:

```
Admin > Stack Util. & Logs
```

Monitor:

- CPU usage
- Memory consumption
- Container status

![jtso-stats-1.png](./img/jtso-stats-1.png)

You can also view container logs directly:

![jtso-stats-2.png](./img/jtso-stats-2.png)

## Manage InfluxDB

Go to:

```
Admin > Manage InfluxDB
```

This opens the Chronograf interface for managing InfluxDB measurements.

![influx-mgt.png](./img/influx-mgt.png)

## Manage Kapacitor

Go to:

```
Admin > Manage Tick Scripts
```

This opens the Chronograf interface for managing Kapacitor Tick scripts.

![kapa-list.png](./img/kapa-list.png)

You can view or edit a specific script:

![kapa-code.png](./img/kapa-code.png)


# Access Grafana Dashboards

Go to:

```
Grafana
```

This provides direct access to the Grafana portal.

![grafana.png](./img/grafana.png)

---

Enjoy 🙂