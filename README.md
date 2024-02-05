# Juniper Telemetry Stack - aka. JTS

## Getting Start

 **Table of content:**
 - [Home](README.md)
 - [Installation](INSTALL.md)
 - [Configuration](CONFIG.md)
 - [Update Stack](UPDATE.md)
 - [Utilization](USAGE.md)
 - [Profiles documentation](PROFILES.md)
 
## Presentation 

This is a repo to build from scratch a Telemetry stack to monitor any Juniper Routing Devices. 

This stack has the codename "JTS" which stands for Juniper Telemetry Stack 

This stack relies on OpenSource software solutions such as **Telegraf** for collecting gNMI Telemetry state data and pre-processing the data, **InfluxDB** as a Time Series Database to store data, **Kapacitor** to aggregate and perform Alarming and finally **Grafana** to display contents. A specific piece of software developed by Juniper and called **JTSO**, which stands for JTS Orchestrator, is also present in the stack (Dev. in **GOLANG**). This piece of software developed by TME AWAN Team has 2 main roles: the first one is to manage the Stack (provision routers IP, select the pre shipped profils) and on the other hands provide an Enricher tool to enrich on-the-fly telemetry data for better visualization and aggregation).  

JTS is pre-filled with templates of configuration and dashbords for typical use cases. Those profiles are tgz files store in **compose/jso/profiles directory** 

JTS relies on Docker Compose to deploy in one command this stack. Please be sure you have done all the prerequisites before.

JTS has only been validated for Ubuntu/Debian Host OS. 

{- Notice: Currently JTS uses a specific build of Telegraf which offers more functionalities (dev. by Juniper). Juniper will continue to push these enhancements to the official Telegraf project -}

![jts.png](./img/JTS.png)

