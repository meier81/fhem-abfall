# *** WARNING: DO NOT MODIFY *** This is a generated Perl source code! 
# 
# Generated by LF-ET 2.1.5 (170306b), http://www.lohrfink.de/lfet
# From decision table
# "/data/github/fhem/fhem-abfall/lfet/ABFALL_setUpdate.lfet"
# 04.09.2017 23:22
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
use ABFALL_getEvents;

sub ABFALL_setUpdate_Initialize($$)
{
  my ($hash) = @_;
}

sub ABFALL_setUpdate($) {
    
    my ($hash) = @_;
    my $name = $hash->{NAME};
    Log3 $name, 4, "ABFALL_setUpdate($name) - Start";

    # step counter
    my $step = 1;

    # array counter
    my $eventIndex = 0;    

    my $lastNow = ReadingsVal($name, "now", "");
    Log3 $name, 5, "ABFALL_setUpdate($name) - reading lastNow $lastNow";

    # array for events
    my @events = ();

    my $actualEvent = ();

    # readings
    my $nowAbfall_tage = -1;
    my $nowAbfall_text = "";
    my $nowAbfall_location = "";
    my $nowAbfall_description = "";
    my $nowAbfall_datum;
    my $nowAbfall_weekday;
    my $now_readingTermin = "";

    my $nextAbfall_tage = -1;
    my $nextAbfall_text = "";
    my $nextAbfall_location = "";
    my $nextAbfall_description = "";
    my $nextAbfall_datum;
    my $nextAbfall_weekday;
    my $next_readingTermin = "";

    # attribute values
    my $delimiter_text_reading = " " . AttrVal($name,"delimiter_text_reading","und") . " ";
    my $delimiter_reading = AttrVal($name,"delimiter_reading","|");

    while ($step != -1) {
    
    # Prolog Decision Table <----
    
    # Condition B01/01: step / 1 / cleanup step
    if (
    $step eq 1
    )
    {
        
        # Condition B02: counting pickups
        if (
        AttrVal($name, "enable_counting_pickups", "0")
        )
        {
            # Rule R01 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 1, 21";
            # Trace <----
            
            # Action A01: clean readings
            Log3 $name, 5, "ABFALL_GetUpdate ($name) - delete readings";
            fhem("deletereading $name next", 1);
            fhem("deletereading $name now", 1);
            fhem("deletereading $name .*_tage", 1);
            fhem("deletereading $name .*_days", 1);
            fhem("deletereading $name .*_wochentag", 1);
            fhem("deletereading $name .*_weekday", 1);
            fhem("deletereading $name .*_text", 1);
            fhem("deletereading $name .*_datum", 1);
            fhem("deletereading $name .*_date", 1);
            fhem("deletereading $name .*_location", 1);
            fhem("deletereading $name .*_description", 1);
            fhem("deletereading $name state", 1);
            
            # Action A03: getEvents
            @events = ABFALL_getEvents($hash);
            
            # Action A17: readingsBeginUpdate
            readingsBeginUpdate($hash);
            
            # Action A19/02: step / 2 / event step
            $step = 2;
            
            # Rule R01 <----
        }
        else
        {
            # Rule R02 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 2, 21";
            # Trace <----
            
            # Action A01: clean readings
            Log3 $name, 5, "ABFALL_GetUpdate ($name) - delete readings";
            fhem("deletereading $name next", 1);
            fhem("deletereading $name now", 1);
            fhem("deletereading $name .*_tage", 1);
            fhem("deletereading $name .*_days", 1);
            fhem("deletereading $name .*_wochentag", 1);
            fhem("deletereading $name .*_weekday", 1);
            fhem("deletereading $name .*_text", 1);
            fhem("deletereading $name .*_datum", 1);
            fhem("deletereading $name .*_date", 1);
            fhem("deletereading $name .*_location", 1);
            fhem("deletereading $name .*_description", 1);
            fhem("deletereading $name state", 1);
            
            # Action A02: clean pickup readings
            fhem("deletereading $name .*_pickups", 1);
            fhem("deletereading $name .*_pickups_used", 1);
            fhem("deletereading $name .*_abholungen", 1);
            fhem("deletereading $name .*_abholungen_genutzt", 1);
            
            # Action A03: getEvents
            @events = ABFALL_getEvents($hash);
            
            # Action A17: readingsBeginUpdate
            readingsBeginUpdate($hash);
            
            # Action A19/02: step / 2 / event step
            $step = 2;
            
            # Rule R02 <----
        }
    
    # Condition B01/02: step / 2 / next event step
    }
    elsif (
    $step eq 2
    )
    {
        
        # Condition B05: has events
        if (
        scalar(@events) > 0
        )
        {
            
            # Condition B06: has more events
            if (
            $eventIndex < scalar(@events)
            )
            {
                # Rule R03 ---->
                
                # Trace ---->
                Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 3, 21";
                # Trace <----
                
                # Action A04: next event
                $actualEvent = $events[$eventIndex];
                $eventIndex++;
                
                # Action A19/03: step / 3 / event step
                $step = 3
                
                # Rule R03 <----
            }
            else
            {
                # Rule R04 ---->
                
                # Trace ---->
                Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 4, 21";
                # Trace <----
                
                # Action A18: readingsEndUpdate
                readingsEndUpdate($hash,1); #end update
                
                # Action A19/01: step / E / end step
                $step = -1;
                
                # Rule R04 <----
            }
        }
        else
        {
            # Rule R05 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 5, 21";
            # Trace <----
            
            # Action A13: set state no pickups
            readingsBulkUpdate($hash, "state", "Keine Abholungen");
            
            # Action A18: readingsEndUpdate
            readingsEndUpdate($hash,1); #end update
            
            # Action A19/01: step / E / end step
            $step = -1;
            
            # Rule R05 <----
        }
    
    # Condition B01/03: step / 3 / event step
    }
    elsif (
    $step eq 3
    )
    {
        
        # Condition B07: event readingName is empty
        if (
        $actualEvent->{readingName} eq ""
        )
        {
            # Rule R06 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 6, 21";
            # Trace <----
            
            # Action A16: warn empty readingname
            Log3 $name, 2, "ABFALL_setUpdate($name) - readingName is empty for uid($actualEvent->{uid})";
            
            # Action A19/02: step / 2 / event step
            $step = 2;
            
            # Rule R06 <----
        }
        else
        {
            
            # Condition B08: event days equals 0
            if (
            $actualEvent->{days} eq 0
            )
            {
                # Rule R07 ---->
                
                # Trace ---->
                Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 7, 21";
                # Trace <----
                
                # Action A05: append as now
                if($nowAbfall_text eq "") {
                    $nowAbfall_text = $actualEvent->{summary};
                } else {
                    $nowAbfall_text .= $delimiter_text_reading . $actualEvent->{summary};
                }
                
                if($nowAbfall_location eq "") {
                    $nowAbfall_location = $actualEvent->{location};
                } elsif ($nowAbfall_location ne $actualEvent->{location}) {
                    # TODO change check to regex expression contains
                    $nowAbfall_location .= $delimiter_text_reading . $actualEvent->{location};
                }
                # check if description reading is the same
                if($nowAbfall_description eq "") {
                    $nowAbfall_description = $actualEvent->{description};
                } elsif ($nowAbfall_description ne $actualEvent->{description}) {
                    # TODO change check to regex expression contains
                    $nowAbfall_description .= $delimiter_text_reading . $actualEvent->{description};
                }
                $nowAbfall_tage = $actualEvent->{days};
                $nowAbfall_datum = $actualEvent->{dateFormatted};
                $nowAbfall_weekday = $actualEvent->{weekday};
                $now_readingTermin = $actualEvent->{readingName};
                
                # Action A08: set as reading
                my $enable_old_readingnames = AttrVal($name, "enable_old_readingnames", "0");
                my $readingTermin = $actualEvent->{readingName}; 
                
                readingsBulkUpdate($hash, $readingTermin ."_days", $actualEvent->{days});
                readingsBulkUpdate($hash, $readingTermin ."_text", $actualEvent->{summary});
                readingsBulkUpdate($hash, $readingTermin ."_date", $actualEvent->{dateFormatted});
                
                readingsBulkUpdate($hash, $readingTermin ."_weekday", $actualEvent->{weekday});
                readingsBulkUpdate($hash, $readingTermin ."_location", $actualEvent->{location});
                readingsBulkUpdate($hash, $readingTermin ."_description", $actualEvent->{description});
                readingsBulkUpdate($hash, $readingTermin ."_uid", $actualEvent->{uid});
                
                readingsBulkUpdate($hash, $readingTermin ."_tage", $actualEvent->{days}) if ($enable_old_readingnames);
                readingsBulkUpdate($hash, $readingTermin ."_wochentag", $actualEvent->{weekday}) if ($enable_old_readingnames);
                readingsBulkUpdate($hash, $readingTermin ."_datum", $actualEvent->{dateFormatted}) if ($enable_old_readingnames);
                
                # Action A19/04: step / 4 / counting pickup step
                $step = 4
                
                # Rule R07 <----
            }
            else
            {
                
                # Condition B09: next days initialized
                if (
                $nextAbfall_tage > -1
                )
                {
                    
                    # Condition B10: event days < next days
                    if (
                    $actualEvent->{days} < $nextAbfall_tage
                    )
                    {
                        # Rule R08 ---->
                        
                        # Trace ---->
                        Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 8, 21";
                        # Trace <----
                        
                        # Action A07: set next
                        $nextAbfall_text = $actualEvent->{summary};
                        $nextAbfall_location = $actualEvent->{location};
                        $nextAbfall_description = $actualEvent->{description};
                        $nextAbfall_tage = $actualEvent->{days};
                        $nextAbfall_datum = $actualEvent->{dateFormatted};
                        $nextAbfall_weekday = $actualEvent->{weekday};
                        $next_readingTermin = $actualEvent->{readingName};
                        
                        # Action A08: set as reading
                        my $enable_old_readingnames = AttrVal($name, "enable_old_readingnames", "0");
                        my $readingTermin = $actualEvent->{readingName}; 
                        
                        readingsBulkUpdate($hash, $readingTermin ."_days", $actualEvent->{days});
                        readingsBulkUpdate($hash, $readingTermin ."_text", $actualEvent->{summary});
                        readingsBulkUpdate($hash, $readingTermin ."_date", $actualEvent->{dateFormatted});
                        
                        readingsBulkUpdate($hash, $readingTermin ."_weekday", $actualEvent->{weekday});
                        readingsBulkUpdate($hash, $readingTermin ."_location", $actualEvent->{location});
                        readingsBulkUpdate($hash, $readingTermin ."_description", $actualEvent->{description});
                        readingsBulkUpdate($hash, $readingTermin ."_uid", $actualEvent->{uid});
                        
                        readingsBulkUpdate($hash, $readingTermin ."_tage", $actualEvent->{days}) if ($enable_old_readingnames);
                        readingsBulkUpdate($hash, $readingTermin ."_wochentag", $actualEvent->{weekday}) if ($enable_old_readingnames);
                        readingsBulkUpdate($hash, $readingTermin ."_datum", $actualEvent->{dateFormatted}) if ($enable_old_readingnames);
                        
                        # Action A19/04: step / 4 / counting pickup step
                        $step = 4
                        
                        # Rule R08 <----
                    }
                    else
                    {
                        
                        # Condition B11: event days = next days
                        if (
                        $actualEvent->{days} == $nextAbfall_tage
                        )
                        {
                            # Rule R09 ---->
                            
                            # Trace ---->
                            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 9, 21";
                            # Trace <----
                            
                            # Action A06: append next
                            if ($nextAbfall_text eq "") {
                                $nextAbfall_text = $actualEvent->{summary};
                            } else {
                                $nextAbfall_text .= $delimiter_text_reading . $actualEvent->{summary};
                            }
                            # check if location reading is the same
                            if ($nextAbfall_location eq "") {
                                $nextAbfall_location = $actualEvent->{location};
                            } else {
                                # TODO check if nextAbfall_location contains $actualEvent->{location}
                                $nextAbfall_location .= $delimiter_text_reading . $actualEvent->{location};
                            }
                            # check if description reading is the same
                            if ($nextAbfall_description eq "") {
                                $nextAbfall_description = $actualEvent->{description};
                            } else {
                                # TODO check if nextAbfall_location contains $actualEvent->{location}
                                $nextAbfall_description .= $delimiter_text_reading . $actualEvent->{description};
                            }
                            $nextAbfall_tage = $actualEvent->{days};
                            $nextAbfall_datum = $actualEvent->{dateFormatted};
                            $nextAbfall_weekday = $actualEvent->{weekday};
                            if ($next_readingTermin eq "") {
                                $next_readingTermin = $actualEvent->{readingName};
                            } else {
                                $next_readingTermin .= $delimiter_reading . $actualEvent->{readingName};
                            }
                            
                            # Action A08: set as reading
                            my $enable_old_readingnames = AttrVal($name, "enable_old_readingnames", "0");
                            my $readingTermin = $actualEvent->{readingName}; 
                            
                            readingsBulkUpdate($hash, $readingTermin ."_days", $actualEvent->{days});
                            readingsBulkUpdate($hash, $readingTermin ."_text", $actualEvent->{summary});
                            readingsBulkUpdate($hash, $readingTermin ."_date", $actualEvent->{dateFormatted});
                            
                            readingsBulkUpdate($hash, $readingTermin ."_weekday", $actualEvent->{weekday});
                            readingsBulkUpdate($hash, $readingTermin ."_location", $actualEvent->{location});
                            readingsBulkUpdate($hash, $readingTermin ."_description", $actualEvent->{description});
                            readingsBulkUpdate($hash, $readingTermin ."_uid", $actualEvent->{uid});
                            
                            readingsBulkUpdate($hash, $readingTermin ."_tage", $actualEvent->{days}) if ($enable_old_readingnames);
                            readingsBulkUpdate($hash, $readingTermin ."_wochentag", $actualEvent->{weekday}) if ($enable_old_readingnames);
                            readingsBulkUpdate($hash, $readingTermin ."_datum", $actualEvent->{dateFormatted}) if ($enable_old_readingnames);
                            
                            # Action A19/04: step / 4 / counting pickup step
                            $step = 4
                            
                            # Rule R09 <----
                        }
                        else
                        {
                            # Rule R10 ---->
                            
                            # Trace ---->
                            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 10, 21";
                            # Trace <----
                            
                            # Action A08: set as reading
                            my $enable_old_readingnames = AttrVal($name, "enable_old_readingnames", "0");
                            my $readingTermin = $actualEvent->{readingName}; 
                            
                            readingsBulkUpdate($hash, $readingTermin ."_days", $actualEvent->{days});
                            readingsBulkUpdate($hash, $readingTermin ."_text", $actualEvent->{summary});
                            readingsBulkUpdate($hash, $readingTermin ."_date", $actualEvent->{dateFormatted});
                            
                            readingsBulkUpdate($hash, $readingTermin ."_weekday", $actualEvent->{weekday});
                            readingsBulkUpdate($hash, $readingTermin ."_location", $actualEvent->{location});
                            readingsBulkUpdate($hash, $readingTermin ."_description", $actualEvent->{description});
                            readingsBulkUpdate($hash, $readingTermin ."_uid", $actualEvent->{uid});
                            
                            readingsBulkUpdate($hash, $readingTermin ."_tage", $actualEvent->{days}) if ($enable_old_readingnames);
                            readingsBulkUpdate($hash, $readingTermin ."_wochentag", $actualEvent->{weekday}) if ($enable_old_readingnames);
                            readingsBulkUpdate($hash, $readingTermin ."_datum", $actualEvent->{dateFormatted}) if ($enable_old_readingnames);
                            
                            # Action A19/04: step / 4 / counting pickup step
                            $step = 4
                            
                            # Rule R10 <----
                        }
                    }
                }
                else
                {
                    # Rule R11 ---->
                    
                    # Trace ---->
                    Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 11, 21";
                    # Trace <----
                    
                    # Action A07: set next
                    $nextAbfall_text = $actualEvent->{summary};
                    $nextAbfall_location = $actualEvent->{location};
                    $nextAbfall_description = $actualEvent->{description};
                    $nextAbfall_tage = $actualEvent->{days};
                    $nextAbfall_datum = $actualEvent->{dateFormatted};
                    $nextAbfall_weekday = $actualEvent->{weekday};
                    $next_readingTermin = $actualEvent->{readingName};
                    
                    # Action A08: set as reading
                    my $enable_old_readingnames = AttrVal($name, "enable_old_readingnames", "0");
                    my $readingTermin = $actualEvent->{readingName}; 
                    
                    readingsBulkUpdate($hash, $readingTermin ."_days", $actualEvent->{days});
                    readingsBulkUpdate($hash, $readingTermin ."_text", $actualEvent->{summary});
                    readingsBulkUpdate($hash, $readingTermin ."_date", $actualEvent->{dateFormatted});
                    
                    readingsBulkUpdate($hash, $readingTermin ."_weekday", $actualEvent->{weekday});
                    readingsBulkUpdate($hash, $readingTermin ."_location", $actualEvent->{location});
                    readingsBulkUpdate($hash, $readingTermin ."_description", $actualEvent->{description});
                    readingsBulkUpdate($hash, $readingTermin ."_uid", $actualEvent->{uid});
                    
                    readingsBulkUpdate($hash, $readingTermin ."_tage", $actualEvent->{days}) if ($enable_old_readingnames);
                    readingsBulkUpdate($hash, $readingTermin ."_wochentag", $actualEvent->{weekday}) if ($enable_old_readingnames);
                    readingsBulkUpdate($hash, $readingTermin ."_datum", $actualEvent->{dateFormatted}) if ($enable_old_readingnames);
                    
                    # Action A19/04: step / 4 / counting pickup step
                    $step = 4
                    
                    # Rule R11 <----
                }
            }
        }
    
    # Condition B01/04: step / 4 / counting pickup step
    }
    elsif (
    $step eq 4
    )
    {
        
        # Condition B02: counting pickups
        if (
        AttrVal($name, "enable_counting_pickups", "0")
        )
        {
            
            # Condition B03: reading pickups initialized
            if (
            ReadingsVal($name, $actualEvent->{readingName} . "_pickups", "-1") > -1
            )
            {
                
                # Condition B04: reading pickups used initialized
                if (
                ReadingsVal($name, $actualEvent->{readingName} . "_pickups_used", "-1") > -1
                )
                {
                    # Rule R12 ---->
                    
                    # Trace ---->
                    Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 12, 21";
                    # Trace <----
                    
                    # Action A19/05: step / 5 / now step
                    $step = 5
                    
                    # Rule R12 <----
                }
                else
                {
                    # Rule R13 ---->
                    
                    # Trace ---->
                    Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 13, 21";
                    # Trace <----
                    
                    # Action A15: initialize pickups used
                    readingsBulkUpdate($hash, $actualEvent->{readingName} ."_pickups_used", "0");
                    
                    # Action A19/05: step / 5 / now step
                    $step = 5
                    
                    # Rule R13 <----
                }
            }
            else
            {
                
                # Condition B04: reading pickups used initialized
                if (
                ReadingsVal($name, $actualEvent->{readingName} . "_pickups_used", "-1") > -1
                )
                {
                    # Rule R14 ---->
                    
                    # Trace ---->
                    Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 14, 21";
                    # Trace <----
                    
                    # Action A14: initialize pickups
                    readingsBulkUpdate($hash, $actualEvent->{readingName} ."_pickups", "0");
                    
                    # Action A19/05: step / 5 / now step
                    $step = 5
                    
                    # Rule R14 <----
                }
                else
                {
                    # Rule R15 ---->
                    
                    # Trace ---->
                    Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 15, 21";
                    # Trace <----
                    
                    # Action A14: initialize pickups
                    readingsBulkUpdate($hash, $actualEvent->{readingName} ."_pickups", "0");
                    
                    # Action A15: initialize pickups used
                    readingsBulkUpdate($hash, $actualEvent->{readingName} ."_pickups_used", "0");
                    
                    # Action A19/05: step / 5 / now step
                    $step = 5
                    
                    # Rule R15 <----
                }
            }
        }
        else
        {
            # Rule R16 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 16, 21";
            # Trace <----
            
            # Action A19/05: step / 5 / now step
            $step = 5
            
            # Rule R16 <----
        }
    
    # Condition B01/05: step / 5 / now step
    }
    elsif (
    $step eq 5
    )
    {
        
        # Condition B12: now days = 0
        if (
        $nowAbfall_tage == 0
        )
        {
            
            # Condition B13: last pickup <> actual pickup
            if (
            $lastNow ne $now_readingTermin
            )
            {
                # Rule R17 ---->
                
                # Trace ---->
                Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 17, 21";
                # Trace <----
                
                # Action A09: set now reading
                readingsBulkUpdate($hash, "now", $now_readingTermin);
                readingsBulkUpdate($hash, "now_text", $nowAbfall_text);
                readingsBulkUpdate($hash, "now_date", $nowAbfall_datum);
                readingsBulkUpdate($hash, "now_weekday", $nowAbfall_weekday);
                readingsBulkUpdate($hash, "now_location", $nowAbfall_location);
                readingsBulkUpdate($hash, "now_description", $nowAbfall_description);
                
                my $enable_old_readingnames = AttrVal($name, "enable_old_readingnames", "0");
                readingsBulkUpdate($hash, "now_datum", $nowAbfall_datum) if ($enable_old_readingnames);
                readingsBulkUpdate($hash, "now_wochentag", $nowAbfall_weekday) if ($enable_old_readingnames);
                
                # Action A10: increment last pickup
                Log3 $name, 4, "ABFALL_setUpdate($name) - inc count for pickups for $now_readingTermin";
                my $now_readingTermin_count =  ReadingsVal($hash, $now_readingTermin . "_pickups", "0");
                $now_readingTermin_count++;
                readingsBulkUpdate($hash, $now_readingTermin . "_pickups", $now_readingTermin_count);
                
                # Action A19/06: step / 6 / next step
                $step = 6;
                
                # Rule R17 <----
            }
            else
            {
                # Rule R18 ---->
                
                # Trace ---->
                Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 18, 21";
                # Trace <----
                
                # Action A09: set now reading
                readingsBulkUpdate($hash, "now", $now_readingTermin);
                readingsBulkUpdate($hash, "now_text", $nowAbfall_text);
                readingsBulkUpdate($hash, "now_date", $nowAbfall_datum);
                readingsBulkUpdate($hash, "now_weekday", $nowAbfall_weekday);
                readingsBulkUpdate($hash, "now_location", $nowAbfall_location);
                readingsBulkUpdate($hash, "now_description", $nowAbfall_description);
                
                my $enable_old_readingnames = AttrVal($name, "enable_old_readingnames", "0");
                readingsBulkUpdate($hash, "now_datum", $nowAbfall_datum) if ($enable_old_readingnames);
                readingsBulkUpdate($hash, "now_wochentag", $nowAbfall_weekday) if ($enable_old_readingnames);
                
                # Action A19/06: step / 6 / next step
                $step = 6;
                
                # Rule R18 <----
            }
        }
        else
        {
            # Rule R19 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 19, 21";
            # Trace <----
            
            # Action A19/06: step / 6 / next step
            $step = 6;
            
            # Rule R19 <----
        }
    }
    else
    {
        
        # Condition B14: next days > 0
        if (
        $nextAbfall_tage > 0
        )
        {
            # Rule R20 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 20, 21";
            # Trace <----
            
            # Action A11: set next reading
            readingsBulkUpdate($hash, "next", $next_readingTermin . "_" . $nextAbfall_tage);
            readingsBulkUpdate($hash, "next_days", $nextAbfall_tage);
            readingsBulkUpdate($hash, "next_text", $nextAbfall_text);
            readingsBulkUpdate($hash, "next_date", $nextAbfall_datum);
            readingsBulkUpdate($hash, "next_weekday", $nextAbfall_weekday);
            readingsBulkUpdate($hash, "next_location", $nextAbfall_location);
            readingsBulkUpdate($hash, "next_description", $nextAbfall_description);
            
            my $enable_old_readingnames = AttrVal($name, "enable_old_readingnames", "0");
            readingsBulkUpdate($hash, "next_tage", $nextAbfall_tage) if ($enable_old_readingnames);
            readingsBulkUpdate($hash, "next_datum", $nextAbfall_datum) if ($enable_old_readingnames);
            readingsBulkUpdate($hash, "next_wochentag", $nextAbfall_weekday) if ($enable_old_readingnames);
            
            # Action A12: set state next days
            readingsBulkUpdate($hash, "state", $nextAbfall_tage);
            
            # Action A19/02: step / 2 / event step
            $step = 2;
            
            # Rule R20 <----
        }
        else
        {
            # Rule R21 ---->
            
            # Trace ---->
            Log3 $name, 5, "ABFALL_setUpdate($name) - ABFALL_setUpdate, 20170904.232248, 21, 21";
            # Trace <----
            
            # Action A13: set state no pickups
            readingsBulkUpdate($hash, "state", "Keine Abholungen");
            
            # Action A19/02: step / 2 / event step
            $step = 2;
            
            # Rule R21 <----
        }
    }
    
    # Epilog Decision Table ---->
} # end while
}

1;
# Epilog Decision Table <----

# End of generated Perl source code
# Generated by LF-ET 2.1.5 (170306b), http://www.lohrfink.de/lfet

