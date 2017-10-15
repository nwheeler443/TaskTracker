#!/usr/bin/perl
use Data::Dumper;

$home = $ENV{"HOME"};

my @files;
foreach my $cal (`ls -d $home/Library/Calendars/*.caldav/*.calendar`) {
    chomp $cal;
    push @files, `ls $cal/Events/*.ics` or die "$!";
}

my %tasks;
open OUT, "> $home/Documents/tasktracker/tasks.txt" or die "$!";

foreach my $file (@files) {
    my @task;
    open IN, $file;
    my $id;
    while (<IN>) {
        chomp;
        if ($_ =~ /UID:(.+)\r$/) {
            $id = $1;
        }
        if ($_ =~ /SUMMARY:(.+)\r$/) {
            $task[0] = $1;
        }
        if ($_ =~ /DTSTART;\S+:(\d+)T(\d+)/) {
            @task[1..2] = ($1, $2);
        }
        if ($_ =~ /DTEND;\S+:(\d+)T(\d+)/) {
            @task[3..4] = ($1, $2);
        }
    }
    print OUT join("\t", @task), "\n";
}
