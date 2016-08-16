#!/usr/bin/perl

use strict;


my %words = ();

sub NumberOfSharedChars($$) {
    my ($wordA, $wordB) = @_;
    
    my $count = 0;
    my @charsA = split '', $wordA;
    my @charsB = split '', $wordB;
    for (my $i = 0; $i < @charsA; $i++) {
        if ($charsA[$i] eq $charsB[$i]) {
            $count++;
        }
    }
    
    return $count;
}


sub AnalyzeWords($$) {
    my ($guess, $numberOfRightChars) = @_;
    
    foreach my $word (keys %words) {
        if (NumberOfSharedChars($word,$guess) != $numberOfRightChars) {
            delete $words{$word}
        }
    }
}


sub SuggestGuess() {
    my ($bestCount, $bestWord) = (0, '');
    
    foreach my $guessWord (keys %words) {
        my $wordCount = 0;
        foreach my $targetWord (keys %words) {
            if ($guessWord ne $targetWord) {
                $wordCount += NumberOfSharedChars($guessWord, $targetWord);
            }
        }
        if ($wordCount > $bestCount) {
            $bestWord = $guessWord;
            $bestCount = $wordCount;
        }
    }
    
    return $bestWord;
}



my $doneReading = 0;
my $length = 0;
do {
    print "Enter candidate words, or [ENTER] to start hacking: ";
    my $word = uc <STDIN>;
    chomp $word;
    if ($word) {
        if ($length == 0) {
            $length = length $word;
        }
        elsif ($length == length $word) {
            $words{$word} = { };
        }
        else {
            print "Wrong number of characters.\n";
        }
    }
    else {
        $doneReading = 1;
    }
}
while (!$doneReading);





my $doneGuessing = 0;
do {
    print "Candidates:\n";
    print join "\n", map "  $_", sort keys %words;
    
    print "\nSuggested guess: " . SuggestGuess() . "\n";
    
    my $guess = '';
    while ($guess eq '') {
        print "Enter guess, or [ENTER] to quit: ";
        $guess = uc <STDIN>;
        chomp $guess;
        if ($guess eq '') {
            $doneGuessing = 1;
            $guess = "DONE";
        }
        elsif (not exists $words{$guess}) {
            print "****Invalid guess****\n";
            $guess = '';
        }
    }
    
    if (!$doneGuessing) {
        my $commonCharCount = 0;
        while (!$commonCharCount) {
            print "Enter number of common chars in guess, or [ENTER] to quit: ";
            $commonCharCount = <STDIN>;
            chomp $commonCharCount;
            if (not ($commonCharCount > 0)) {
                print "****Invalid count****\n";
                $commonCharCount = 0;
            }
        }
        
        AnalyzeWords($guess, $commonCharCount);
    }
}
while (!$doneGuessing);












