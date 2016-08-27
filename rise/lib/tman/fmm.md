# File Modification Monitor

### methods

- monitor

#### using:
    use rise::lib::tman::fmm;

    my $fmon           = new rise::lib::tman::fmm;  
    my $result         = $fmon->monitor**( PATH [, TIME] )**; //returned list of modified files as ARRAYREF

**PATH** - is a string. Path or mask.  
**TIME** - is a number. When you scan only those files whose modification time is not greater than the specified value. The value is given in seconds. The default value is `2`.

	my $result         = $fmon->monitor("/mydir/fname.pm", 1)   // for a specific file  
	my $result         = $fmon->monitor("/mydir/\*.pm", 1)      // for all "*.pm" files in "/mydir"  
	my $result         = $fmon->monitor("/mydir/\*/\*.pm", 1)   // for all "*.pm" files in all subdirs from "/mydir"


#### examle:

	use rise::lib::tman::fmm;

	my $fmon           = new rise::lib::tman::fmm;
	my $result         = $fmon->scan("/mypath/*.pm", 1);
