#!/usr/bin/perl
use strict;
#use warnings;
use 5.010;
use IPC::Open2;
my $debug = 0; # toggle to 1 to enable debug
my $passedCases = 0;


sub compareOutputs{
(my $myOutput, my $summary,my $all)=(@_);
if($debug ==1 ){
    my $total_args = scalar(@_);
    print($total_args);
}
my $cmp = $myOutput eq $all;
if($cmp==1){
    print("OUTPUT MATCHES 1:1\n");
    $passedCases+=1;
}else{
if($myOutput=~/$summary/){
    print("only summary matches\n");
}else{
    print("you had a moment...\n");
}

my @compOut = split('\n', $all); # creates an @answer array
my @usrOut = split('\n', $myOutput); # creates an @answer array
my $lenSecond = scalar(@compOut);
my $lenFirst = scalar(@usrOut);

if($lenFirst ne $lenSecond){
print("CAUTION: unequal number of lines in outputs!\n");
}
# my $loopMax = $lenFirst>=$lenSecond ? $lenFirst : $lenSecond;

for (my $i = 0; $i < $lenSecond; $i += 1) {
    my $c = @compOut[$i];
    if($debug ==1 ){
        say("\"" . @compOut[$i] . "\"");
        say("\"" . @usrOut[$i] . "\"");
    }
    if($myOutput!~$c){
        say("YOURS: \"" . @usrOut[$i] . "\"");
        say("COMPS: \"" . @compOut[$i] . "\"");
    }

}

}
}

sub main {
my $argLen = $#ARGV + 1;



if($argLen lt 3 or $argLen gt 4){
print "error: invalid number of inputs\n";
exit 1;
}


my $inputFile = $ARGV[0]; # file with the test cases
my $outputFile = $ARGV[1]; # file where the output will be printed
open (my $LOG, '>', $outputFile);
select $LOG;
my $mainFile = $ARGV[2]; # file where the output will be printed
# print(split('_', $ARGV[3])."\n");
my @supportingJava = split('_', $ARGV[3]); # file where the output will be printed (seperated by ;)
if($debug ==1 ){
    print($inputFile."\n");
    print($outputFile."\n");
    print($mainFile."\n");

    foreach my $line (@supportingJava){
    print($line."\n");
    }
}

open(my $fh, '<:encoding(UTF-8)', $inputFile)
  or die "Could not open file '$inputFile' $!";

my $count = 0;
my $lastRow = 0;
my $input="";
my $output="";
my $allOutput="";
my $nextExecute;
my $endFindOutput;

if (-d "src/Testing") {
system("rm -rf src/Testing/*");
}else{
system("mkdir src/Testing");
}

system("cp src/$mainFile src/Testing/$mainFile");

foreach my $line (@supportingJava){
system("cp src/$line src/Testing/$line");
}


while (<$fh>) {

if($_ =~ /\[/){
    $_ =~ tr/\[\]//d;
    $input=$input . $_;
    $output=""

}else{
$output = $output . $_;
$allOutput = $allOutput . $_;
}
my $execute = $_ eq "\n"; # if reached the split character
 if ($execute == 1){ # found the end of the input/output example
        if($debug ==1 ){
             print"=========input=========\n";
             print($input);
             print"=========output=========\n";
             print($output);
             print"=========allOutput=========\n";
             print($allOutput);
        }
        select STDOUT;
        print("testing.....". $count . "\n");
        select $LOG;
        print("\nTEST CASE NUMBER ".$count.": ");

        $count++;
         system("javac -d \"classes\" src/Testing/*");

         my $pid = open2( \*getJava, \*giveJava, "java -cp \"classes\" src/Testing/$mainFile" )
                     or die "Could not open 2-way pipe: $!";

         print giveJava $input;  # Pass in data

         waitpid( $pid, 0 );

        my $myOutput = "";

         foreach my $line (<getJava>){
            $myOutput=$myOutput . $line;
         }

         compareOutputs($myOutput,$output,$allOutput);
         $input = "";
         $output = "";
         $allOutput = "";


 }



}
my $ful1="src/Testing/".$mainFile;
print($ful1."\n");
unlink($ful1);

foreach my $line (@supportingJava){
my $ful2 = "src/Testing/".$line;
print($ful1."\n");
unlink($ful2);
select STDOUT;
say("Tests passed: " . $passedCases);

}
}
main();
