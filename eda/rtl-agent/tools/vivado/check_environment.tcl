set requested_part [lindex $argv 0]
puts "ENV_VIVADO_VERSION=[version -short]"
set matched_parts [get_parts -quiet $requested_part]
puts "ENV_REQUESTED_PART=$requested_part"
puts "ENV_PART_COUNT=[llength $matched_parts]"
if {[llength $matched_parts] == 0} {
    puts stderr "ENV_ERROR=unsupported_part"
    exit 3
}
puts "ENV_PART_MATCH=[lindex $matched_parts 0]"
puts "ENV_PART_SUPPORTED=1"
exit 0
