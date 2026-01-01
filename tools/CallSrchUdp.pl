#!/usr/bin/perl

####### This is an example program how to use callsign search from multiple logs using CqrlogAlpha #######
#######   version after 2025-12-01 that has NewQSO UDP XML info transmit option. (OH1KH/2025-12)   #######

# You may need to install some of modules below with cpan command to make perl run with this source
# Read the man page of cpan  (man cpan)
# NOTE: use of option "-T" speeds up install a lot (=without testing)
# cpan -T Term::ReadKey DBI IO::Socket::INET

use warnings;
use Term::ReadKey;
use DBI;
use IO::Socket::INET;

#-----------------list of log nicknames and Cqrlog log numbers ( 3digit zero padded) to search-----------------

# You should  modify the list (lines inside []) for your needs. 
# Add or remove log numbers you want to search and give names for those logs.

my @LogList = (
["Log 1","001"],
["Log 2","002"],
["Log 3","003"],
["TestLog","005"]
 );

# release below for debug
# print "@$_\n" for @LogList;


#-----------------Database access configs and connection-----------------
#Host is localhost unless you have a networked SQL server somewhere
my $sqlhost = "127.0.0.1";

# No need to select database here it will be done in sql query
my $database = "";

# user and pw when using "save log data to local machine"
# otherwise you should use username+pw you have granted to use cqrlog databases
# on external SQL server
my $user = "cqrlog";
my $pw = "cqrlog";

# When using "save log data to local machine" sql server port is 64000
# external SQL server often defaults to port 3306 
my $sqlport = "64000";

# database connect
my $dbh = DBI->connect("DBI:mysql:database=$database;host=$sqlhost;port=$sqlport",$user, $pw)
  or die "\nFix connect to MySQL server!\n\n";

#-----------------UDP listener configs   -----------------
# We call IO::Socket::INET->new() to create the UDP Socket and bound
# to specific port number mentioned in LocalPort 

my ($socket,$received_data);
# below is for later debug
my ($peeraddress,$peerport);

$socket = new IO::Socket::INET (
# use network address if you expect to listen UDPs from outside of local machine
LocalHost => '127.0.0.1',
# cqrlog UDP newqso default
LocalPort => '60073',
Proto => 'udp' ) or die "\nFix UDP socket creation error!\n\n";


my $continue = 1;
    $SIG{TERM} = sub {$continue = 0 };
print "\n\nCall search started. Waiting for UDP datagram\n Use Ctrl+C to exit\n\n";

#-----------------UDP listener loop     ----------------
while($continue) {

# read operation on the socket
$socket->recv($received_data,1024);

# get the peerhost and peerport at which the recent data received.
# release below 3 for debug
# $peer_address = $socket->peerhost();
# $peer_port = $socket->peerport();
# print "($peer_address , $peer_port) said :\n$received_data\n";

#-----------------We got datagram, grep the callsign from XML  ----------
my $call="";
if (defined $received_data){
my @x = split(/Callsign>/,$received_data);
my @xx = split(/</,$x[1]);
$call=$xx[0];
}
my $callen=length($call)+1;

#-----------------We got callsign, do the seek  ----------------
# create query from given log array
my $qbase="";
# separate queries for all listed logs combined with UNION
for my $r (@LogList) {
$qbase .= "SELECT '@$r[0]' AS log,qsodate,time_on,callsign,band,mode FROM cqrlog@$r[1].cqrlog_main WHERE callsign='$call' UNION ";
}
# replace last UNION with sort command. ASC or DESC affect to the sort order
$qbase = substr($qbase, 0, rindex($qbase,"UNION"))."ORDER BY qsodate ASC";
# release below for debug
# print "$qbase\n";

my $query = qq{ $qbase }; 
# release below for debug
# print "$query\n";
my $qry = $dbh->prepare($query);
$qry->execute();

# get max length from found columns
my $nicklen=0;
my $bandlen=0;
my $modelen=0;
while(my @row = $qry->fetchrow_array()){
      if (length($row[0])>$nicklen) { $nicklen = length($row[0]); }
      if (length($row[4])>$bandlen) { $bandlen = length($row[4]); }
      if (length($row[5])>$modelen) { $modelen = length($row[5]); }
}

#print out the seek results
print "$call:\n";
dashline($nicklen+10+5+$callen+$bandlen+$modelen+7);
$qry->execute();
while(my @row = $qry->fetchrow_array()){
     printf("|%".$nicklen."s|\%10s|\%5s|\%".$callen."s|\%".$bandlen."s|\%".$modelen."s|\n",$row[0],$row[1],$row[2],$row[3],$row[4],$row[5]);
  }
dashline($nicklen+10+5+$callen+$bandlen+$modelen+7);
print "\n";

# return for next callsign
} 
#-----------------UDP listener loop end ----------------

# exit from program
$socket->close();
$dbh->disconnect();
exit;

#-----------------subroutines  ----------------

sub dashline {
for (my $i = 0;$i < $_[0];$i++){
    print"-";
    }
    print "\n"
}