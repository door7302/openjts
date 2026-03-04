# Native Profiles information

Each profile consists of a set of files packaged into a `.tgz` archive.  
These archives are stored in the `compose/jtso/profile` directory.

> This directory is continuously monitored by JTSO component. When a new version of a profile is added or updated, it automatically triggers a stack reconfiguration.

## Router Health Profile

Router health KPIs include CPU, memory, errors, drops, and more.

### Dashboard Screenshots

#### Router Health Details

![health1.png](./img/profiles/health/health1.png)

- (1) Select router  
- (2) Current real-time error status – monitored by the **ALARMING** Telegraf plugin  
- (3) Current chassis alarms  
- (4) Current RE master/backup CPU and memory usage  
- (5) Current CPU and memory usage for all MPCs/FPCs  
- (6) On-change based syslog events  

![health2.png](./img/profiles/health/health2.png)

- (1) Details of current chassis alarms  
- (2) All past and active MPC/FPC CMERROR events  
- (3) Current router alarms – monitored by the **ALARMING** Telegraf plugin  
- (4) Detailed view of current router alarms  

![health3.png](./img/profiles/health/health3.png)

- (1) CPU and memory usage history for master and backup REs  
- (2) CPU and memory usage history for all MPCs/FPCs  

![health4.png](./img/profiles/health/health4.png)

- (1) CPU consumption history of all RE master processes  
- (2) CPU usage history per RE master core  
- (3) Memory consumption history of all RE master processes  

![health5.png](./img/profiles/health/health5.png)

- (1) Fabric drops history per FPC/MPC  
- (2) Input fabric rate (pps) history per FPC/MPC  
- (3) Output fabric rate (pps) history per FPC/MPC  

#### NPU Statistics

![hw-mon1.png](./img/profiles/health/hw-mon1.png)

- (1) Select hardware component (depends on line card type)  
- (2) Select hardware property(ies)  

![hw-mon2.png](./img/profiles/health/hw-mon2.png)

- (1) Router information  
- (2) Current chassis alarms  
- (3) Hardware KPI trends over time  
- (4) Current hardware KPI values  

## BGP Profile

BGP KPIs include peer-groups, address families, and per-peer statistics.

### Dashboard Screenshots

![bgp1.png](./img/profiles/bgp/bgp1.png)

- (1) Filters by router, routing instance, peer-group, family, and neighbor  
- (2) Number of active paths per peer-group  
- (3) Received, installed, and sent prefixes per peer-group  
- (4) Number of active paths per family  
- (5) On-change BGP events  

![bgp2.png](./img/profiles/bgp/bgp2.png)

- (1) Per-neighbor detailed information  
- (2) Peer name, peer AS, session state, input/output queues  
- (3) Prefix-limit per family (if configured)  
- (4) Historical view of received, installed, rejected, and sent routes  
- (5) Per-family route details  

## Traffic / CoS Profile

Traffic KPIs include per-queue statistics, per-port statistics, queue depth, and drops per queue or port.

### Dashboard Screenshots

#### Physical Interfaces Traffic

![traffic1.png](./img/profiles/traffic/traffic1.png)

- (1) Filter by router and physical interface  
- (2) Real-time traffic alarms (RED, TAIL, CRC drops) – monitored by the **ALARMING** Telegraf plugin  
- (3) Overall traffic distribution per queue  
- (4) Details of real-time traffic alarms  

![traffic2.png](./img/profiles/traffic/traffic2.png)

- (1) Per-port statistics (in/out bps and pps)  
- (2) Per-port queue drops (RED and TAIL) over time  

![traffic3.png](./img/profiles/traffic/traffic3.png)

- (1) Real-time queue depth utilization (current)  
- (2) Real-time queue depth utilization (peak)  
- (3) Traffic distribution per queue  
- (4) Queued traffic per queue (bps)  
- (5) Forwarded traffic per queue (bps)  

![traffic4.png](./img/profiles/traffic/traffic4.png)

- (1) Queued traffic per queue (bps)  
- (2) Forwarded traffic per queue (bps)  
- (3) Queued traffic per queue (pps)  
- (4) Forwarded traffic per queue (pps)  

#### Logical Interfaces Traffic

![unit1.png](./img/profiles/traffic/unit1.png)

- (1) Select physical interface and unit(s)  
- (2) Port statistics  
- (3) Input traffic load sharing per unit  
- (4) Output traffic load sharing per unit  

![unit2.png](./img/profiles/traffic/unit2.png)

- (1) Per-unit traffic in bps and pps  

#### VoQ System (PTX Only)

Requires specific device configuration.

![voq1.png](./img/profiles/traffic/voq1.png)

- (1) Filter by router and physical interface  
- (2) Real-time traffic alarms  
- (3) Traffic distribution per queue  
- (4) Alarm details  
- (5) Per-port traffic statistics and traffic types  
- (6) Per-queue traffic distribution per port  

![voq2.png](./img/profiles/traffic/voq2.png)

- (1) Forwarded traffic per egress queue (bps and pps)  
- (2) Egress queue drops  

![voq3.png](./img/profiles/traffic/voq3.png)

- (1) Real-time VoQ depth (current, average, peak)  
- (2) VoQ depth history  

## Optic Profile

Optic KPIs include optic levels, physical errors, and per-optic details.

### Dashboard Screenshots

![optic1.png](./img/profiles/optic/optic1.png)

- (1) Filter by router and physical port  
- (2) Real-time CRC/BLOCK error alarms  
- (3) CRC/BLOCK error history  
- (4) Per-lane TX, RX, and BIAS values  

![optic2.png](./img/profiles/optic/optic2.png)

- (1) Per-port optic alarms  

![optic3.png](./img/profiles/optic/optic3.png)

- (1) Inventory information  
- (2) Per-lane RX values  
- (3) Per-lane TX values  
- (4) RX/TX history with warning thresholds  
- (5) BIAS and temperature history  
- (6) CRC and BLOCK error history  
- (7) Input frame size distribution history  

![optic4.png](./img/profiles/optic/optic4.png)

- (1) OTN-specific information  
- (2) Frequency and carrier frequency offset  
- (3) OSNR and ESNR history  
- (4) Pre-FEC engine history  
- (5) Chromatic dispersion history  
- (6) SOPDM history  
- (7) PDL history  

## Power Profile

Power KPIs include per-component consumption, total power usage, temperature, fan state, and efficiency metrics.

### Dashboard Screenshots

#### Per-Router Power Consumption

![power1.png](./img/profiles/power-ext/power1.png)

- (1) Chassis information  
- (2) Configured ambient temperature  
- (3) Overall chassis power metrics  
- (4) Per-zone power metrics (multi-zone chassis)  

![power2.png](./img/profiles/power-ext/power2.png)

- (1) Total input traffic (bps)  
- (2) Total input traffic (pps)  
- (3) Watts per Gbps ratio  

![power3.png](./img/profiles/power-ext/power3.png)

- (1) Total chassis power history  
- (2) Per-component power history  

![power4.png](./img/profiles/power-ext/power4.png)

- (1) Per-component temperature history  

![power5.png](./img/profiles/power-ext/power5.png)

- (1) Current MPC/FPC power consumption  
- (2) MPC/FPC power history  
- (3) Current fan power consumption  
- (4) Fan power history  

![power6.png](./img/profiles/power-ext/power6.png)

- (1) Current fan speed  
- (2) Fan speed history  

![power7.png](./img/profiles/power-ext/power7.png)

- (1) CB/Fabric/RE power consumption  
- (2) CB/Fabric/RE power history  
- (3) PEM/PSM power consumption  
- (4) PEM/PSM power history  

#### Power Aggregation Dashboard

![power8.png](./img/profiles/power-ext/power8.png)

- (1) Total power consumption  
- (2) Power consumption per model  
- (3) Total power consumption history  
- (4) Power consumption history per chassis model  

## Firewall Profile

Firewall KPIs include per-term counters and policer drop counters.

### Dashboard Screenshots

![filter1.png](./img/profiles/filter/filter1.png)

- (1) Filter by router, filter, counter, and policer history  
- (2) PPS view (counters shown as positive, policer drops as negative)  
- (3) BPS view (counters shown as positive, policer drops as negative)  

## DDOS Profile

DDOS KPIs include per-MPC protection statistics.  
Currently supported on **MX** and **PTX** platforms only.

### Dashboard Screenshots

![ddos1.png](./img/profiles/ddos/ddos1.png)

- (1) Filter by router, protocol, and sub-protocol  
- (2) Global dashboard showing routers under DDOS policer violation (last 15 minutes)  
- (3) Per-protocol details for the selected router  
- (4) Aggregated protocol statistics (received, dropped, punted to RE)  
- (5) Received PPS history per line card  
- (6) Dropped PPS history per line card  
- (7) Punted PPS history per line card  

## SR MPLS Profile

SR MPLS KPIs include traffic per interface, per SID, ingress, and egress.  
Requires specific device configuration.

### Dashboard Screenshots

#### Per-Interface SR MPLS Statistics

![srmpls1.png](./img/profiles/srmpls/srmpls1.png)

- (1) Filter by router and physical interface  
- (2) SR MPLS traffic in/out (bps and pps)  
- (3) Percentage of SR MPLS traffic relative to total interface traffic  

#### Per-Label (SID) SR MPLS Statistics

![srmpls2.png](./img/profiles/srmpls/srmpls2.png)

- (1) Filter by router and MPLS label (derived from SID)  
- (2) Traffic load per SID (label)  
- (3) Traffic in bps and pps per SID (label)  


## TWAMP Profile

TWAMP profile includes TWAMP Lite statistics. 

### Dashboard Screenshots

#### Global and 

![twamp1.png](./img/profiles/twamp/twamp1.png)

- (1) Filter by router and Test Owner, Test Name, Result Scope (Only Last Test supported today) and Probe Type. 
- (2) Overall current KPIs
- (3) RTT for All Probe Types
- (4) Min, Max, Avg. RTT trend for a specific Probe Type

![twamp2.png](./img/profiles/twamp/twamp2.png)

- (1) Per Test RTT/Jitter Snapshot for a given Probe Type
- (2) Injest cadence for a given Probe Type