if {$argc != 5} {
    puts stderr "ERROR: usage: synth.tcl <source> <top> <part> <constraints-or-NO_CONSTRAINTS> <netlist>"
    exit 2
}

set source_file [file normalize [lindex $argv 0]]
set top_module [lindex $argv 1]
set target_part [lindex $argv 2]
set constraints_file [lindex $argv 3]
set netlist_file [file normalize [lindex $argv 4]]

if {![file exists $source_file]} {
    puts stderr "ERROR: source file does not exist: $source_file"
    exit 2
}
if {[llength [get_parts -quiet $target_part]] == 0} {
    puts stderr "ERROR: unsupported part: $target_part"
    exit 3
}

read_verilog -sv $source_file
if {$constraints_file ne "NO_CONSTRAINTS"} {
    set normalized_xdc [file normalize $constraints_file]
    if {![file exists $normalized_xdc]} {
        puts stderr "ERROR: constraints file does not exist: $normalized_xdc"
        exit 2
    }
    read_xdc $normalized_xdc
}

synth_design -top $top_module -part $target_part
set netlist_dir [file dirname $netlist_file]
file mkdir $netlist_dir
write_verilog -force $netlist_file
puts "SYNTH_DESIGN_SUCCESS"
puts "SYNTH_NETLIST=$netlist_file"
exit 0
