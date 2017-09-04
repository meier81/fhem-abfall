# *** WARNING: DO NOT MODIFY *** This is a generated Perl source code! 
# 
# Generated by LF-ET 2.1.5 (170306b), http://www.lohrfink.de/lfet
# From decision table
# "/data/github/fhem/fhem-abfall/lfet/ABFALL_getEvents.lfet"
# 05.09.2017 00:40
# 
# Changes to this code resulting from refactorings can be synchronised
# with LF-ET using the function "Scrapbook Import".
# 
# Prolog Decision Table ---->
package main;

use strict;
use warnings;
use POSIX;
use Time::Local;
use Time::Piece;

sub ABFALL_getEvents_Initialize($$)
{
  my ($hash) = @_;
}

sub ABFALL_getEvents_skipEvent($@) {
    my ($hash, @val) = @_;
    my $event = join(' ', @val);
    my $name = $hash->{NAME};
    my $skip = 0;
    my $filter = AttrVal($name,"filter","");

    if ($filter ne "") {
        # skip event of filter conditions - start
        my @filterArray=split( ',' ,$filter);
        foreach my $eachFilter (@filterArray) {
            # fix from fhem forum user justme1968 to support regex for filter
            Log3 $name, 5,  "skipEvent($name) - event($event) - filter($eachFilter)";
            if ($eachFilter =~ m'^/(.*)/$' && $event =~ m/$1/ ) {
                $skip = 1;
            } elsif (index($event, $eachFilter) != -1) {
                $skip = 1;
            }
        } # end foreach
    } # end if filter
    # skip event of filter conditions - end
    Log3 $name, 5, "skipEvent($name) - $event" if ($skip);
    return $skip;
} # end skipEvent

sub ABFALL_getEvents($) {
    my ($hash) = @_;
    my @terminliste ;
    my $name = $hash->{NAME};
    my @calendernamen = split( ",", $hash->{KALENDER});
    my $calendername = "";
    my $uid = "";

    my @termine;

    my @starts;
    my @summarys;
    my @locations;
    my @descriptions;

    my $cleanReadingRegex = AttrVal($name,"abfall_clear_reading_regex","");
    my $calendarNamePraefix = AttrVal($name,"calendarname_praefix","1");

    my %replacement = ("ä" => "ae", "Ä" => "Ae", "ü" => "ue", "Ü" => "Ue", "ö" => "oe", "Ö" => "Oe", "ß" => "ss" );
    my $replacementKeys= join ("|", keys(%replacement));

    my $wdMapping = AttrVal($name,"weekday_mapping","Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag");
    my $date_style = AttrVal($name, "date_style","date");
    my @days = split("\ ", $wdMapping);
    Log3 $name, 5,  "ABFALL_getEvents($name) - weekDayMapping ($wdMapping)" ;

    my $calIndex = 0;
    my $eventIndex = 0;
    my $startTimeIndex = 0;
    my $step = 1;

    # to search for a event with same summary
    my $foundItem = ();

    while ($step != -1) {
    
    # Prolog Decision Table <----
    
    # Condition B01/01: step / 1 / calendar step
    if (
    $step eq 1
    )
    {
        
        # Condition B02: has more calendars
        if (
        $calIndex < scalar(@calendernamen)
        )
        {
            # Rule R01 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 1, 19";
            # Trace <----
            
            # Action A01: next calendar
            $calendername = $calendernamen[$calIndex];
            $calIndex++;
            
            # Action A04: get next uids for events
            @termine = split(/\n/,CallFn($calendername, "GetFn", $defs{$calendername},(" ","uid", "next")));
            $eventIndex = 0;
            my $size = scalar(@termine);
            Log3 $name, 5, "ABFALL_getEvents($name) - size of events: $size";
            
            # Action A12/02: step / 2 / event step
            $step = 2;
            
            # Rule R01 <----
        }
        else
        {
            # Rule R02 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 2, 19";
            # Trace <----
            
            # Action A12/01: step / E / end step
            $step = -1;
            
            # Rule R02 <----
        }
    
    # Condition B01/02: step / 2 / event step
    }
    elsif (
    $step eq 2
    )
    {
        
        # Condition B03: has more events
        if (
        $eventIndex < scalar(@termine)
        )
        {
            # Rule R03 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 3, 19";
            # Trace <----
            
            # Action A02: next uid
            $uid = $termine[$eventIndex];
            $eventIndex++;
            Log3 $name,5,"ABFALL_getEvents - next uid : $uid";
            $startTimeIndex = 0; 
            
            # Action A05: get start times for uid
            @starts = split(/\n/,CallFn($calendername, "GetFn", $defs{$calendername},(" ","start", $uid)));
            
            # Action A06: get summaries for uid
            @summarys = split(/\n/,CallFn($calendername, "GetFn", $defs{$calendername},(" ","summary", $uid)));
            
            # Action A07: get locations for uid
            @locations = split(/\n/, CallFn($calendername, "GetFn", $defs{$calendername},(" ","location", $uid)));
            
            # Action A08: get descriptions for uid
            @descriptions = split(/\n/, CallFn($calendername, "GetFn", $defs{$calendername},(" ","description", $uid)));
            
            # Action A12/03: step / 3 / start time step
            $step =  3
            
            # Rule R03 <----
        }
        else
        {
            # Rule R04 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 4, 19";
            # Trace <----
            
            # Action A12/04: step / 1 / calendar step
            $step = 1
            
            # Rule R04 <----
        }
    
    # Condition B01/03: step / 3 / start time step
    }
    elsif (
    $step eq 3
    )
    {
        
        # Condition B04: has more start times
        if (
        $startTimeIndex < scalar(@starts)
        )
        {
            # Rule R05 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 5, 19";
            # Trace <----
            
            # Action A03: next start time
            $startTimeIndex++;
            
            # Action A12/05: step / 4 / check start time step
            $step = 4;
            
            # Rule R05 <----
        }
        else
        {
            # Rule R06 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 6, 19";
            # Trace <----
            
            # Action A12/02: step / 2 / event step
            $step = 2;
            
            # Rule R06 <----
        }
    
    # Condition B01/04: step / 4 / check start time step
    }
    elsif (
    $step eq 4
    )
    {
        
        # Condition B05: is actual start time valid
        if (
        defined($starts[$startTimeIndex - 1]) && !($starts[$startTimeIndex - 1] eq '') 
        )
        {
            
            # Prolog Condition B06 ---->
            my @SplitDt = split(/ /,$starts[$startTimeIndex - 1]);
            my @SplitDate = split(/\./,$SplitDt[0]);
            my @SplitTime = split(/\:/,$SplitDt[1]);
            my $eventDate = timelocal($SplitTime[2],$SplitTime[1],$SplitTime[0],$SplitDate[0],$SplitDate[1]-1,$SplitDate[2]);
            my $dayDiff = floor(($eventDate - time) / 60 / 60 / 24 + 1);
                            
            # Prolog Condition B06 <----
            
            # Condition B06: is start time in the past
            if (
            $dayDiff < 0
            )
            {
                # Rule R07 ---->
                
                # Trace ---->
                Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 7, 19";
                # Trace <----
                
                # Action A12/03: step / 3 / start time step
                $step =  3
                
                # Rule R07 <----
            }
            else
            {
                
                # Condition B07: is filter defined
                if (
                AttrVal($name, "filter", "") ne ""
                )
                {
                    
                    # Condition B08: filter type = include
                    if (
                    AttrVal($name,"filter_type","include") eq "include"
                    )
                    {
                        
                        # Condition B09: match filter
                        if (
                        ABFALL_getEvents_skipEvent($hash,$summarys[$startTimeIndex - 1])
                        )
                        {
                            
                            # Condition B10: clean summary with regex
                            if (
                            $cleanReadingRegex
                            )
                            {
                                # Rule R08 ---->
                                
                                # Trace ---->
                                Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 8, 19";
                                # Trace <----
                                
                                # Action A09: clean summary with regex
                                $summarys[$startTimeIndex] =~ s/$cleanReadingRegex//g;
                                
                                # Action A12/06: step / 5 / search for duplicate step
                                $step = 5;
                                
                                # Rule R08 <----
                            }
                            else
                            {
                                # Rule R09 ---->
                                
                                # Trace ---->
                                Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 9, 19";
                                # Trace <----
                                
                                # Action A12/06: step / 5 / search for duplicate step
                                $step = 5;
                                
                                # Rule R09 <----
                            }
                        }
                        else
                        {
                            # Rule R10 ---->
                            
                            # Trace ---->
                            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 10, 19";
                            # Trace <----
                            
                            # Action A12/03: step / 3 / start time step
                            $step =  3
                            
                            # Rule R10 <----
                        }
                    }
                    else
                    {
                        
                        # Condition B09: match filter
                        if (
                        ABFALL_getEvents_skipEvent($hash,$summarys[$startTimeIndex - 1])
                        )
                        {
                            # Rule R11 ---->
                            
                            # Trace ---->
                            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 11, 19";
                            # Trace <----
                            
                            # Action A12/03: step / 3 / start time step
                            $step =  3
                            
                            # Rule R11 <----
                        }
                        else
                        {
                            
                            # Condition B10: clean summary with regex
                            if (
                            $cleanReadingRegex
                            )
                            {
                                # Rule R12 ---->
                                
                                # Trace ---->
                                Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 12, 19";
                                # Trace <----
                                
                                # Action A09: clean summary with regex
                                $summarys[$startTimeIndex] =~ s/$cleanReadingRegex//g;
                                
                                # Action A12/06: step / 5 / search for duplicate step
                                $step = 5;
                                
                                # Rule R12 <----
                            }
                            else
                            {
                                # Rule R13 ---->
                                
                                # Trace ---->
                                Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 13, 19";
                                # Trace <----
                                
                                # Action A12/06: step / 5 / search for duplicate step
                                $step = 5;
                                
                                # Rule R13 <----
                            }
                        }
                    }
                }
                else
                {
                    
                    # Condition B10: clean summary with regex
                    if (
                    $cleanReadingRegex
                    )
                    {
                        # Rule R14 ---->
                        
                        # Trace ---->
                        Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 14, 19";
                        # Trace <----
                        
                        # Action A09: clean summary with regex
                        $summarys[$startTimeIndex] =~ s/$cleanReadingRegex//g;
                        
                        # Action A12/06: step / 5 / search for duplicate step
                        $step = 5;
                        
                        # Rule R14 <----
                    }
                    else
                    {
                        # Rule R15 ---->
                        
                        # Trace ---->
                        Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 15, 19";
                        # Trace <----
                        
                        # Action A12/06: step / 5 / search for duplicate step
                        $step = 5;
                        
                        # Rule R15 <----
                    }
                }
            }
        }
        else
        {
            # Rule R16 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 16, 19";
            # Trace <----
            
            # Action A12/03: step / 3 / start time step
            $step =  3
            
            # Rule R16 <----
        }
    }
    else
    {
        
        # Prolog Condition B11 ---->
        $foundItem = ();
        foreach my $item (@terminliste ){
            my $tempText= $item->{summary};
            my $tempCalName= $item->{calendar};
            if ($tempText eq $summarys[$startTimeIndex - 1] && $tempCalName eq $calendername) {
                $foundItem = $item;
            }
            last if ($foundItem);
        }
        # Prolog Condition B11 <----
        
        # Condition B11: is event with summary present
        if (
        $foundItem
        )
        {
            
            # Prolog Condition B12 ---->
            my @SplitDt = split(/ /,$starts[$startTimeIndex - 1]);
            my @SplitDate = split(/\./,$SplitDt[0]);
            my @SplitTime = split(/\:/,$SplitDt[1]);
            my $eventDate = timelocal($SplitTime[2],$SplitTime[1],$SplitTime[0],$SplitDate[0],$SplitDate[1]-1,$SplitDate[2]);
            my $dayDiff = floor(($eventDate - time) / 60 / 60 / 24 + 1);
            # Prolog Condition B12 <----
            
            # Condition B12: is event start newer than founded event
            if ($dayDiff < $foundItem->{days} && $eventDate > time)
            {
                # Rule R17 ---->
                
                # Trace ---->
                Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 17, 19";
                # Trace <----
                
                # Action A11: update existing event
                my $eventLocation = "";
                if (defined($locations[$startTimeIndex - 1])) {
                    $eventLocation = $locations[$startTimeIndex - 1];
                }
                my $eventDescription = "";
                if (defined($descriptions[$startTimeIndex - 1])) {
                    $eventDescription = $descriptions[$startTimeIndex - 1];
                }
                
                my @SplitDt = split(/ /,$starts[$startTimeIndex - 1]);
                my @SplitDate = split(/\./,$SplitDt[0]);
                my @SplitTime = split(/\:/,$SplitDt[1]);
                my $eventDate = timelocal($SplitTime[2],$SplitTime[1],$SplitTime[0],$SplitDate[0],$SplitDate[1]-1,$SplitDate[2]);
                my $eventDateFormatted = $SplitDt[0];
                
                if ($date_style eq "dateTime") {
                    $eventDateFormatted = $SplitDt[0] . " " . $SplitDt[1];
                }
                
                my $dayDiff = floor(($eventDate - time) / 60 / 60 / 24 + 1);
                
                my $weekday = (localtime($eventDate))[6];
                my $wdayname = $days[$weekday];
                
                $foundItem->{uid} = $uid;
                $foundItem->{start} = $starts[$startTimeIndex - 1];
                $foundItem->{weekday} = $wdayname;
                $foundItem->{location} = $eventLocation;
                $foundItem->{description} = $eventDescription;
                $foundItem->{date} = $eventDate;
                $foundItem->{dateFormatted} = $eventDateFormatted;
                $foundItem->{days} = $dayDiff;
                
                # Action A12/03: step / 3 / start time step
                $step =  3
                
                # Rule R17 <----
            }
            else
            {
                # Rule R18 ---->
                
                # Trace ---->
                Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 18, 19";
                # Trace <----
                
                # Action A12/03: step / 3 / start time step
                $step =  3
                
                # Rule R18 <----
            }
        }
        else
        {
            # Rule R19 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_getEvents($name) - ABFALL_getEvents, 20170905.004012, 19, 19";
            # Trace <----
            
            # Action A10: put new event
            my $cleanReadingName = $summarys[$startTimeIndex - 1];
            if ($calendarNamePraefix) {
                $cleanReadingName = $calendername . "_" . $cleanReadingName;
            }
            
            # prepare reading name from summary of event
            $cleanReadingName =~ s/($replacementKeys)/$replacement{$1}/eg;
            $cleanReadingName =~ tr/a-zA-Z0-9\-_//dc;
            
            $summarys[$startTimeIndex - 1] =~ s/\\,/,/g;
            $cleanReadingName =~ s/\\,/,/g;
            
            my $eventLocation = "";
            if (defined($locations[$startTimeIndex - 1])) {
                $eventLocation = $locations[$startTimeIndex - 1];
            }
            my $eventDescription = "";
            if (defined($descriptions[$startTimeIndex - 1])) {
                $eventDescription = $descriptions[$startTimeIndex - 1];
            }
            
            my @SplitDt = split(/ /,$starts[$startTimeIndex - 1]);
            my @SplitDate = split(/\./,$SplitDt[0]);
            my @SplitTime = split(/\:/,$SplitDt[1]);
            my $eventDate = timelocal($SplitTime[2],$SplitTime[1],$SplitTime[0],$SplitDate[0],$SplitDate[1]-1,$SplitDate[2]);
            my $eventDateFormatted = $SplitDt[0];
            
            if ($date_style eq "dateTime") {
                $eventDateFormatted = $SplitDt[0] . " " . $SplitDt[1];
            }
            
            my $dayDiff = floor(($eventDate - time) / 60 / 60 / 24 + 1);
            
            my $weekday = (localtime($eventDate))[6];
            my $wdayname = $days[$weekday];
            
            Log3 $name, 5,  "ABFALL_getEvents($name) - calendar($calendername) - uid($uid) - start($starts[$startTimeIndex - 1]) - days($dayDiff) - text($summarys[$startTimeIndex - 1]) - location($eventLocation) - description($eventDescription) - readingName($cleanReadingName)";
            
            push @terminliste, {
                uid => $uid,
                start => $starts[$startTimeIndex - 1],
                weekday => $wdayname,
                summary => $summarys[$startTimeIndex - 1],
                location => $eventLocation,
                description => $eventDescription,
                readingName => $cleanReadingName,
                date => $eventDate,
                days => $dayDiff,
                calendar => $calendername,
                dateFormatted => $eventDateFormatted
            };
            
            # Action A12/03: step / 3 / start time step
            $step =  3
            
            # Rule R19 <----
        }
    }
    
    # Epilog Decision Table ---->
} # end while
return @terminliste;
}

1;
# Epilog Decision Table <----

# End of generated Perl source code
# Generated by LF-ET 2.1.5 (170306b), http://www.lohrfink.de/lfet

