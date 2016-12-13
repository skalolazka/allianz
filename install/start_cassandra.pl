#!/usr/bin/env perl

use strict;

my ($cluster, $seeds, $listen, $datacenter, $rack) = ("cassandra-cluster", @ARGV);
my $conf_path = '/etc/cassandra';
my $conf = "$conf_path/cassandra.yaml";
my $dc_conf = "$conf_path/cassandra-rackdc.properties";

warn "Modifying config file:
    cluster $cluster,
    seeds $seeds,
    listen $listen,
    datacenter $datacenter,
    rack $rack\n";

# back up configs and fix them
`cp $conf $conf.bak`;
open(CONF, "<$conf.bak") || die "Can not open conf file $conf.bak: $!";
open(OUT, ">$conf") || die "Can not open conf file $conf: $!";
while (my $line = <CONF>) {
    $line =~ s/cluster_name: .*/cluster_name: \'$cluster\'/;
    $line =~ s/num_tokens: .*/num_tokens: 256/; # that's the recommended value
    $line =~ s/\- seeds\: .*$/\- seeds\: \"$seeds\"/; # list of all the seed nodes
    $line =~ s/[\# ]*listen_address: .*$/listen_address: $listen/;
    $line =~ s/[\# ]*broadcast_address: .*$/broadcast_address: $listen/;
    $line =~ s/[\# ]*rpc_address.*$/rpc_address: 0.0.0.0/; # for clients, listens on all configured interfaces
    $line =~ s/[\# ]*broadcast_rpc_address.*/broadcast_rpc_address: $listen/; # connected with the previous line
    $line =~ s/[\# ]*endpoint_snitch: .*$/endpoint_snitch: GossipingPropertyFileSnitch/;
    # this snitch automatically updates all nodes using gossip when adding new nodes and is recommended for production
    # for replication NetworkTopologyStrategy is planned, but it can be specified only when creating a keyspace
    print OUT $line;
}
print OUT "auto_bootstrap: false\n";
close(CONF);
close(OUT);

`cp $dc_conf $dc_conf.bak`;
open(CONF2, "<$dc_conf.bak") || die "Can not open conf file $dc_conf.bak: $!";
open(OUT2, ">$dc_conf") || die "Can not open conf file $dc_conf: $!";
while (my $line = <CONF2>) { # this configuration is needed for the specified snitch
    $line =~ s/^dc=.*/dc=$datacenter/;
    $line =~ s/^rack=.*/rack=$rack/;
    $line =~ s/^[\# ]*prefer_local=.*$/prefer_local=true/;
    # uses the local IP address when communication is not across different datacenters, saved bandwidth
    print OUT2 $line;
}
close(CONF2);
close(OUT2);

warn "Starting cassandra server...\n";
exec("cassandra -R -f");
