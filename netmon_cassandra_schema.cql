========= NetMon Project - Time Series Data Modeling ========
https://academy.datastax.com/resources/getting-started-time-series-data-modeling

date; ping -c 5 google.ca

==================================================
== Time Series Pattern 1- Single Device per Row ==
==================================================

CREATE TABLE netmon_ping_history (
    host_id           text
   ,event_time        timestamp
   ,min_time_ms       text
   ,avg_time_ms       text
   ,max_time_ms       text
   ,packets_sent      text
   ,packets_lost      text
   ,packet_loss_pct   text
PRIMARY KEY (host_id,event_time)
);


INSERT INTO netmon_ping_history(host_id, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14 09:24:37', '4.424', '4.520', '4.736', '5', '0', '0');

INSERT INTO netmon_ping_history(host_id, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14 09:25:24', '4.703', '4.900', '5.231', '5', '0', '0');

INSERT INTO netmon_ping_history(host_id, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14 09:25:58', '4.587', '4.733', '4.930', '5', '0', '0');

INSERT INTO netmon_ping_history(host_id, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14 09:26:56', '4.527', '4.626', '4.860', '5', '0', '0');


SELECT event_time, avg_time_ms
  FROM netmon_ping_history
 WHERE host_id = 'google.ca'
   AND event_type > '2016-04-14 09:25:23'
   AND event_type < '2016-04-14 09:25:59';



============================================================
== Time Series Pattern 2 - Partitioning to Limit Row Size ==
============================================================

CREATE TABLE netmon_ping_by_day (
    host_id           text
   ,date              text
   ,event_time        timestamp
   ,min_time_ms       text
   ,avg_time_ms       text
   ,max_time_ms       text
   ,packets_sent      text
   ,packets_lost      text
   ,packet_loss_pct   text
PRIMARY KEY ((host_id,date),event_time)
);

-- This would group entries for a single day


INSERT INTO netmon_ping_by_day(host_id, date, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14', '2016-04-14 09:24:37', '4.424', '4.520', '4.736', '5', '0', '0');

INSERT INTO netmon_ping_by_day(host_id, date, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14', '2016-04-14 09:25:24', '4.703', '4.900', '5.231', '5', '0', '0');

INSERT INTO netmon_ping_by_day(host_id, date, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14', '2016-04-14 09:25:58', '4.587', '4.733', '4.930', '5', '0', '0');

INSERT INTO netmon_ping_by_day(host_id, date, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14', '2016-04-14 09:26:56', '4.527', '4.626', '4.860', '5', '0', '0');

SELECT *
  FROM netmon_ping_by_day
 WHERE host_id = 'google.ca'
   AND date > '2016-04-14';


============================================================================
== Time Series Pattern 3 - Reverse Order Timeseries with Expiring Columns ==
============================================================================

CREATE TABLE netmon_latest_pings (
    host_id           text
   ,event_time        timestamp
   ,min_time_ms       text
   ,avg_time_ms       text
   ,max_time_ms       text
   ,packets_sent      text
   ,packets_lost      text
   ,packet_loss_pct   text
PRIMARY KEY (host_id,event_time),
) WITH CLUSTERING ORDER BY (event_time DESC);


-- expire records after 5 minutes

INSERT INTO netmon_ping_history(host_id, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14 09:24:37', '4.424', '4.520', '4.736', '5', '0', '0') USING TTL 300;

INSERT INTO netmon_ping_history(host_id, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14 09:25:24', '4.703', '4.900', '5.231', '5', '0', '0') USING TTL 300;

INSERT INTO netmon_ping_history(host_id, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14 09:25:58', '4.587', '4.733', '4.930', '5', '0', '0') USING TTL 300;

INSERT INTO netmon_ping_history(host_id, event_time, avg_time_ms, max_time_ms, packets_sent, packets_lost, packet_loss_pct)
VALUES ('google.ca', '2016-04-14 09:26:56', '4.527', '4.626', '4.860', '5', '0', '0') USING TTL 300;





